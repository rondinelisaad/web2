#!/usr/bin/env python3
import html
import re
import sys
import subprocess
from pathlib import Path
from urllib.parse import quote

import modernize_about_pages as common


ROOT = Path(sys.argv[1] if len(sys.argv) > 1 else "htdocs")
REVISTAS = ROOT / "revistas"
CONTENT_CLASS = "journal-author-instructions-section"

PAGE_CONFIG = {
    "pinstruc.htm": {"lang": "pt", "title": "Instruções aos autores"},
    "einstruc.htm": {"lang": "es", "title": "Instrucciones para los autores"},
    "iinstruc.htm": {"lang": "en", "title": "Instructions to authors"},
}


def fetch_serial(pid, lang):
    url = f"http://127.0.0.1:8090/scielo.php?script=sci_serial&pid={quote(pid)}&lng={lang}&nrm=iso"
    result = subprocess.run(
        ["curl", "-sS", url],
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=30,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or f"curl failed for {pid}")
    return result.stdout


def replace_title(prefix, page_title):
    return re.sub(
        r"(?is)<title>.*?</title>",
        f"<title>{page_title}</title>",
        prefix,
        count=1,
    )


def extend_breadcrumb(prefix, page_title):
    marker = '<section class="d-none d-md-flex breadcrumb'
    section_pos = prefix.rfind(marker)
    if section_pos < 0:
        return prefix
    ol_end = prefix.find("</ol>", section_pos)
    if ol_end < 0:
        return prefix
    if page_title in prefix[section_pos:ol_end]:
        return prefix
    return prefix[:ol_end] + f'<li class="breadcrumb-item">{page_title}</li>' + prefix[ol_end:]


def build_section(content, page_title):
    return f"""
        <section class="journalContent journal-about-section {CONTENT_CLASS} mb-5">
          <div class="container">
            <div class="row">
              <div class="col-12 col-lg-8">
                <h2 class="scielo__text-title--4" id="author-instructions">{page_title}</h2>
                <div class="journal-about-legacy">
{content}
                </div>
              </div>
            </div>
          </div>
        </section>
"""


def split_serial(serial_html, page_title):
    content_start = serial_html.find('<section class="journalContent')
    suffix_start = serial_html.find('<div class="serial-template-utils"')
    if content_start < 0 or suffix_start < 0:
        raise ValueError("serial page did not contain expected modern markers")
    prefix = serial_html[:content_start]
    suffix = serial_html[suffix_start:]
    prefix = replace_title(prefix, page_title)
    prefix = common.replace_css_version(prefix)
    prefix = common.restore_journal_menu(prefix, serial_html)
    prefix = extend_breadcrumb(prefix, page_title)
    return prefix, suffix


def extract_old_content(source):
    content = common.extract_old_about(source)
    content = re.sub(r"(?is)<p[^>]+class=[\"']?titulo[\"']?[^>]*>.*?</p>", "", content)
    content = re.sub(r"(?is)<p[^>]*>\s*(?:&nbsp;|&#160;|\s)*</p>", "", content)
    return content.strip() or "<p>Instruções aos autores indisponíveis.</p>"


def fallback_page(source, path, pid, content, page_title):
    page = common.fallback_page(source, path, pid, content)
    title = common.extract_title(source, path)
    about_subject = quote(title) + ":%20Sobre%20o%20periódico"
    instructions_subject = quote(title) + ":%20" + quote(page_title)
    page = page.replace(
        "<title>" + html.escape(title) + " - Sobre o periódico</title>",
        f"<title>{html.escape(title)} - {page_title}</title>",
    )
    page = page.replace('<li class="breadcrumb-item">Sobre o periódico</li>', f'<li class="breadcrumb-item">{page_title}</li>')
    page = page.replace("Sobre o periódico</h2>", f"{page_title}</h2>")
    page = page.replace('id="about"', 'id="author-instructions"')
    page = page.replace("journal-about-section mb-5", f"journal-about-section {CONTENT_CLASS} mb-5")
    page = page.replace(about_subject, instructions_subject)
    return common.restrict_editorial_menu(page)


def extract_pid_from_sibling(path):
    for name in ("paboutj.htm", "pedboard.htm"):
        sibling = path.with_name(name)
        if not sibling.exists():
            continue
        sibling_source, _ = common.read_text(sibling)
        pid = common.extract_pid(sibling_source) or common.extract_issn_pid(sibling_source)
        if not pid and 'class="serial-modern-header"' in sibling_source:
            match = re.search(r"var\s+pid\s*=\s*['\"]([^'\"]+)['\"]", sibling_source)
            if match:
                pid = common.clean_pid(match.group(1))
        if not pid:
            match = re.search(r"script=sci_serial&amp;pid=([^&\"'<>]+)", sibling_source)
            if match:
                pid = common.clean_pid(match.group(1))
        if pid:
            return pid
    return ""


def modernize(path):
    source, _ = common.read_text(path)
    config = PAGE_CONFIG[path.name]
    page_title = config["title"]
    if 'class="serial-modern-header"' in source and CONTENT_CLASS in source:
        refreshed = common.replace_css_version(source)
        pid = common.extract_pid(source) or extract_pid_from_sibling(path)
        if pid:
            try:
                refreshed = common.restore_journal_menu(refreshed, fetch_serial(pid, config["lang"]))
            except (OSError, RuntimeError, subprocess.SubprocessError):
                pass
        if refreshed != source:
            path.write_text(refreshed, encoding="utf-8")
            return "refreshed-css", ""
        return "already-modern", ""

    pid = common.extract_pid(source)
    if not pid:
        if "MODELO" in str(path):
            return "skipped-template", ""
        pid = extract_pid_from_sibling(path)
    if not pid:
        pid = common.extract_issn_pid(source)
    if not pid:
        return "skipped-no-pid", ""

    content = extract_old_content(source)
    try:
        serial_html = fetch_serial(pid, config["lang"])
        prefix, suffix = split_serial(serial_html, page_title)
        new_html = prefix + build_section(content, page_title) + suffix
        status = "updated"
    except ValueError:
        new_html = fallback_page(source, path, pid, content, page_title)
        status = "updated-fallback"
    path.write_text(new_html, encoding="utf-8")
    return status, pid


def main():
    files = sorted(path for name in PAGE_CONFIG for path in REVISTAS.rglob(name))
    counts = {}
    failures = []
    for path in files:
        try:
            status, info = modernize(path)
        except Exception as exc:
            status, info = "failed", str(exc)
            failures.append((path, info))
        counts[status] = counts.get(status, 0) + 1
        print(f"{status}\t{path}\t{info}")
    print("SUMMARY", counts)
    if failures:
        sys.exit(1)


if __name__ == "__main__":
    main()
