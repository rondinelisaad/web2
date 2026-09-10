#!/usr/bin/env python3
import html
import re
import subprocess
import sys
from pathlib import Path
from urllib.parse import quote


ROOT = Path(sys.argv[1] if len(sys.argv) > 1 else "htdocs")
REVISTAS = ROOT / "revistas"
CSS_VERSION = "about-20260614-6"

LANGUAGE_CONFIG = {
    "paboutj.htm": {"code": "pt", "title": "Sobre o periódico"},
    "eaboutj.htm": {"code": "es", "title": "Acerca del periódico"},
    "iaboutj.htm": {"code": "en", "title": "About the journal"},
}

STATIC_JOURNAL_HOME = {
    "1020-4989": "/revistas/rpsp/paboutj.htm",
}


def read_text(path):
    for enc in ("utf-8", "iso-8859-1", "cp1252"):
        try:
            return path.read_text(encoding=enc), enc
        except UnicodeDecodeError:
            continue
    return path.read_text(errors="ignore"), "utf-8"


def clean_pid(value):
    value = html.unescape(value or "")
    value = value.replace("%20", "").replace(" ", "").strip()
    if not value or "troca" in value.lower():
        return ""
    return value


def extract_pid(source):
    matches = re.findall(r"pid=([^&\"'<>\\s]+)", source, flags=re.I)
    for match in matches:
        pid = clean_pid(match)
        if re.match(r"^[0-9Xx-]{8,10}$", pid):
            return pid
    return ""


def extract_issn_pid(source):
    matches = re.findall(r"ISSN\s+([0-9Xx-]{8,10})", strip_tags(source), flags=re.I)
    for match in matches:
        pid = clean_pid(match)
        if re.match(r"^[0-9Xx-]{8,10}$", pid):
            return pid
    return ""


def extract_pid_from_sibling(path):
    for name in ("paboutj.htm", "pedboard.htm"):
        sibling = path.with_name(name)
        if not sibling.exists():
            continue
        sibling_source, _ = read_text(sibling)
        pid = extract_pid(sibling_source) or extract_issn_pid(sibling_source)
        if pid:
            return pid
    return ""


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


def strip_tags(value):
    value = re.sub(r"(?is)<script\\b.*?</script>", " ", value)
    value = re.sub(r"(?is)<style\\b.*?</style>", " ", value)
    value = re.sub(r"(?is)<[^>]+>", " ", value)
    value = html.unescape(value)
    return re.sub(r"\\s+", " ", value).strip()


def extract_title(source, path):
    match = re.search(r"(?is)<title>(.*?)</title>", source)
    if match:
        title = strip_tags(match.group(1))
        title = re.sub(r"\\s+-\\s+Sobre a revista.*$", "", title, flags=re.I)
        title = re.sub(r"\\s+-\\s+Sobre o periódico.*$", "", title, flags=re.I)
        if title:
            return title
    return path.parent.name


def extract_logo(source, path):
    match = re.search(r"(?is)<img\\b[^>]*src=[\"']([^\"']*?/img/revistas/[^\"']+/(?:g|p)logo\\.gif)[\"']", source)
    if match:
        return html.unescape(match.group(1))
    return f"/img/revistas/{path.parent.name}/glogo.gif"


def extract_email(source):
    match = re.search(r"mailto:([^\"'<>\\s]+)", source, flags=re.I)
    return html.unescape(match.group(1)) if match else "educ@fcc.org.br"


def extract_issn_lines(source):
    match = re.search(r"(?is)<p[^>]+class=[\"']?issn[\"']?[^>]*>(.*?)</p>", source)
    if not match:
        return []
    text = strip_tags(match.group(1))
    items = re.findall(r"ISSN\s+([0-9Xx-]{8,10})(.*?)(?=ISSN\s+[0-9Xx-]{8,10}|$)", text)
    lines = []
    for issn, label in items:
        label = label.strip()
        if "on-line" in label.lower() or "online" in label.lower():
            prefix = "Versão on-line ISSN:"
        elif "impressa" in label.lower() or "printed" in label.lower():
            prefix = "Versão impressa ISSN:"
        else:
            prefix = "ISSN:"
        lines.append((prefix, issn))
    return lines


def fallback_page(source, path, pid, content, page_title="Sobre o periódico"):
    title = extract_title(source, path)
    title_esc = html.escape(title)
    logo = html.escape(extract_logo(source, path), quote=True)
    email = html.escape(extract_email(source), quote=True)
    rel_dir = "/" + str(path.parent.relative_to(ROOT)).replace("\\\\", "/")
    about_url = f"{rel_dir}/paboutj.htm"
    edboard_url = f"{rel_dir}/pedboard.htm"
    instruc_url = f"{rel_dir}/pinstruc.htm"
    static_home = STATIC_JOURNAL_HOME.get(pid)
    serial_url = html.escape(static_home, quote=True) if static_home else f"/scielo.php?script=sci_serial&amp;pid={html.escape(pid)}&amp;lng=pt&amp;nrm=iso"
    issues_url = html.escape(static_home, quote=True) if static_home else f"/scielo.php?script=sci_issues&amp;pid={html.escape(pid)}&amp;lng=pt&amp;nrm=iso"
    issn_html = "".join(
        f'<div><span class="issnLabel">{html.escape(label)}</span> {html.escape(issn)}</div>'
        for label, issn in extract_issn_lines(source)
    )
    if not issn_html:
        issn_html = f'<div><span class="issnLabel">ISSN:</span> {html.escape(pid)}</div>'
    return f"""<!DOCTYPE html>
<html lang="pt">
<head>
  <title>{title_esc} - Sobre o periódico</title>
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="STYLESHEET" type="text/css" href="/css/scielo.css">
  <link rel="STYLESHEET" type="text/css" href="/css/include_layout.css">
  <link rel="STYLESHEET" type="text/css" href="/css/include_styles.css">
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css">
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css">
  <link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v={CSS_VERSION}">
  <script type="text/javascript" src="/applications/scielo-org/js/functions.js"></script>
  <script type="text/javascript" src="/article.js"></script>
  <script type="text/javascript" src="/js/jquery-1.9.1.min.js"></script>
</head>
<body class="serial-page">
  <a class="skip-link" href="#main-content">Pular para o conteúdo principal</a>
  <header class="serial-modern-header">
    <details class="home-main-menu serial-modern-menu"><summary class="serial-modern-menu-btn">☰ Menu</summary><ul class="home-main-dropdown"><li><a href="/search_mvp.php?lang=pt">Pesquisa</a></li><li><a href="/scielo.php?script=sci_alphabetic&amp;lng=pt&amp;nrm=iso">Lista de periódicos</a></li><li><a href="/about/?lang=pt">Sobre o Educ@</a></li><li><a href="/equipe/equipe_p.htm">Equipe Educ@</a></li></ul></details>
    <a class="serial-modern-brand" href="/scielo.php?lng=pt"><img alt="Educ@" src="/img/pt/scielobre.gif"></a>
    <div class="sci-nav-lang-menu serial-modern-lang"><button class="sci-nav-lang-btn" type="button" aria-haspopup="true" aria-expanded="false">🌐 Português ▾</button></div>
  </header>
  <div class="container"><main id="main-content" tabindex="-1"><h1 class="visually-hidden">{title_esc}</h1><div class="middle no-right-col">
    <section class="d-block journalInfo"><div class="container"><div class="row"><div class="col-12 col-lg-9 pt-4 pb-4"><a href="{serial_url}" class="journalInfo-logo-link"><img src="{logo}" alt="{title_esc}" border="0"></a><h1 class="h4"><img src="/design-system/1.0.0/img/logo-open-access.svg" alt="Open-access" class="logo-open-access">{title_esc}</h1><span class="publisher">Publicação de: <strong class="namePlublisher">{title_esc}</strong></span><br><span class="theme"><span class="area">Área:</span> HUMAN SCIENCES</span><span class="issn">{issn_html}</span><div class="mt-3"><a href="https://creativecommons.org/licenses/by/4.0/" target="_blank" rel="license"><img src="https://licensebuttons.net/l/by/4.0/80x15.png" alt="Creative Commons - by 4.0"></a></div></div><div class="col-12 col-lg-3 pt-lg-5 pb-4"><div class="list-group d-print-none mb-5"><a class="list-group-item" href="{about_url}"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="12" r="9"></circle><path d="M12 10v6"></path><path d="M12 7h.01"></path></svg> Sobre o periódico</a><a class="list-group-item" href="{about_url}"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M8 6h13"></path><path d="M8 12h13"></path><path d="M8 18h13"></path><path d="M3 6h.01"></path><path d="M3 12h.01"></path><path d="M3 18h.01"></path></svg> Política editorial</a><a class="list-group-item" href="{edboard_url}"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg> Corpo Editorial</a><a class="list-group-item" href="{instruc_url}"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="12" r="9"></circle><path d="M9.5 9a2.7 2.7 0 1 1 4.8 1.7c-.9.7-1.5 1.2-1.8 2.3"></path><path d="M12 17h.01"></path></svg> Instruções aos autores</a><a class="list-group-item" href="mailto:{email}"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><rect x="3" y="5" width="18" height="14" rx="2"></rect><path d="M3 7l9 6 9-6"></path></svg> Contato</a></div></div></div></div></section>
    <section class="levelMenu mb-3"><div class="container d-none d-xl-block"><div class="row"><div class="col-md-2 col-sm-2 serial-level-home"><a href="{serial_url}" class="btn scielo__btn-with-icon--left"><svg class="serial-home-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"></path></svg> Home do periódico</a></div><div class="col-md-8 col-sm-8 serial-level-issues"><div class="btn-group"><a href="{issues_url}" class="btn">Todos os números</a><a title="número anterior" href="#" class="btn disabled">« Número anterior</a><a title="número seguinte" href="#" class="btn disabled">Número seguinte »</a><a title="número atual" href="#" class="btn disabled">Número atual</a></div></div><div class="col-md-2 col-sm-2 text-end serial-level-tools"><div class="btn-group" role="group" aria-label="Ferramentas"><a href="/search_mvp.php?lang=pt&amp;journal={html.escape(pid)}" class="btn single">Buscar</a><a target="_blank" href="https://analytics.scielo.org/?journal={html.escape(pid)}&amp;collection=scl" class="btn scielo__btn-with-icon--left">Métricas</a></div></div></div></div></section>
    <section class="d-none d-md-flex breadcrumb mt-3 mb-5 serial-breadcrumb"><div class="container"><div class="serial-breadcrumb-inner"><ol class="breadcrumb mb-0 ps-0"><li class="breadcrumb-item"><a href="/scielo.php?lng=pt"><svg class="serial-home-icon serial-home-icon-breadcrumb" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M3 11.5L12 4l9 7.5"></path><path d="M5.5 10.5V20h5v-6h3v6h5v-9.5"></path></svg></a></li><li class="breadcrumb-item"><a href="/scielo.php?script=sci_alphabetic&amp;lng=pt&amp;nrm=iso">Periódicos</a></li><li class="breadcrumb-item">{title_esc}</li><li class="breadcrumb-item">Sobre o periódico</li></ol><a class="btn btn-sm btn-secondary scielo__btn-with-icon--only serial-share-btn" href="mailto:?subject={quote(title)}:%20Sobre%20o%20periódico&amp;body={about_url}" aria-label="Compartilhar"><svg class="serial-share-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="18" cy="5" r="2.4"></circle><circle cx="6" cy="12" r="2.4"></circle><circle cx="18" cy="19" r="2.4"></circle><path d="M8.2 11l7.6-4.4"></path><path d="M8.2 13l7.6 4.4"></path></svg><span class="serial-share-caret">▾</span></a></div></div></section>
{build_about_section(content, page_title)}
    <div class="serial-template-utils"><a href="mailto:educ@fcc.org.br?subject=Reportar%20erro" class="serial-template-report">Reportar erro</a><a href="#main-content" class="serial-template-accessibility">Acessibilidade</a></div><script type="text/javascript" src="/js/educa-accessibility.js?v=20260614-1"></script>
  </div></main><div class="license"><p><a rel="license" href="http://creativecommons.org/licenses/by/4.0/deed.pt"><img src="http://i.creativecommons.org/l/by/4.0/80x15.png" alt="Creative Commons License" style="border-width:0"></a> Todo o conteúdo deste periódico, exceto onde está identificado, está licenciado sob uma <a href="http://creativecommons.org/licenses/by/4.0/deed.pt">Licença Creative Commons</a></p></div><div class="footer"><img src="/img/pt/e-mailt.gif" alt="email" border="0"><br><a class="email" href="mailto:{email}">{email}</a></div></div>
</body>
</html>
"""


def extract_old_about(source):
    lower = source.lower()
    body_start = lower.find("<body")
    if body_start >= 0:
        body_start = lower.find(">", body_start)
        source = source[body_start + 1 :]
        lower = source.lower()
    body_end = lower.rfind("</body>")
    if body_end >= 0:
        source = source[:body_end]
        lower = source.lower()

    start = 0
    first_table_end = lower.find("</table>")
    if first_table_end >= 0:
        start = first_table_end + len("</table>")

    end_candidates = []
    for pattern in (
        r"<p[^>]+align=[\"']?center[\"']?[^>]*>\s*\[",
        r"<hr\b",
        r"<p[^>]+class=[\"']?rodape",
        r"<p[^>]+class=[\"']?rodapep",
    ):
        match = re.search(pattern, source[start:], flags=re.I)
        if match:
            end_candidates.append(start + match.start())
    end = min(end_candidates) if end_candidates else len(source)
    content = source[start:end]
    content = re.sub(r"(?is)<script\\b.*?</script>", "", content)
    content = re.sub(r"(?is)<style\\b.*?</style>", "", content)
    content = re.sub(r"(?is)<link\\b[^>]*>", "", content)
    content = re.sub(r"(?is)<p[^>]*>\\s*(?:&nbsp;|&#160;|\\s)*</p>", "", content)
    content = re.sub(r"(?is)<font\\b[^>]*>", "", content)
    content = re.sub(r"(?is)</font>", "", content)
    content = re.sub(r"(?is)\\s+width=[\"']?\\d+%?[\"']?", "", content)
    content = re.sub(r"(?is)\\s+border=[\"']?\\d+[\"']?", "", content)
    content = re.sub(r"(?is)\\s+cellpadding=[\"']?\\d+[\"']?", "", content)
    content = re.sub(r"(?is)\\s+cellspacing=[\"']?\\d+[\"']?", "", content)
    content = content.strip()
    if not content:
        content = "<p>Informações sobre o periódico indisponíveis.</p>"
    return content


def replace_title(prefix, page_title):
    return re.sub(
        r"(?is)<title>.*?</title>",
        f"<title>{page_title}</title>",
        prefix,
        count=1,
    )


def replace_css_version(prefix):
    return re.sub(
        r"/css/scielo-ds-bridge\.css\?v=[^\"']+",
        f"/css/scielo-ds-bridge.css?v={CSS_VERSION}",
        prefix,
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


def build_about_section(content, page_title):
    return f"""
        <section class="journalContent journal-about-section mb-5">
          <div class="container">
            <div class="row">
              <div class="col-12 col-lg-8">
                <h2 class="scielo__text-title--4" id="about">{page_title}</h2>
                <div class="journal-about-legacy">
{content}
                </div>
              </div>
            </div>
          </div>
        </section>
"""


def split_serial(serial_html):
    content_start = serial_html.find('<section class="journalContent')
    suffix_start = serial_html.find('<div class="serial-template-utils"')
    if content_start < 0 or suffix_start < 0:
        raise ValueError("serial page did not contain expected modern markers")
    prefix = serial_html[:content_start]
    suffix = serial_html[suffix_start:]
    return split_serial_for_language(serial_html, "Sobre o periódico")


def split_serial_for_language(serial_html, page_title):
    content_start = serial_html.find('<section class="journalContent')
    suffix_start = serial_html.find('<div class="serial-template-utils"')
    if content_start < 0 or suffix_start < 0:
        raise ValueError("serial page did not contain expected modern markers")
    prefix = serial_html[:content_start]
    suffix = serial_html[suffix_start:]
    prefix = replace_title(prefix, page_title)
    prefix = replace_css_version(prefix)
    prefix = extend_breadcrumb(prefix, page_title)
    return prefix, suffix


def modernize(path):
    source, _ = read_text(path)
    config = LANGUAGE_CONFIG[path.name]
    page_title = config["title"]
    if 'class="serial-modern-header"' in source and "journal-about-section" in source:
        refreshed = replace_css_version(source)
        if refreshed != source:
            path.write_text(refreshed, encoding="utf-8")
            return "refreshed-css", ""
        return "already-modern", ""
    pid = extract_pid(source)
    if not pid:
        if "MODELO" in str(path):
            return "skipped-template", ""
        pid = extract_pid_from_sibling(path) or extract_issn_pid(source)
    if not pid:
        return "skipped-no-pid", ""
    content = extract_old_about(source)
    try:
        serial_html = fetch_serial(pid, config["code"])
        prefix, suffix = split_serial_for_language(serial_html, page_title)
        new_html = prefix + build_about_section(content, page_title) + suffix
        status = "updated"
    except ValueError:
        new_html = fallback_page(source, path, pid, content, page_title)
        status = "updated-fallback"
    path.write_text(new_html, encoding="utf-8")
    return status, pid


def main():
    files = sorted(
        path
        for name in LANGUAGE_CONFIG
        for path in REVISTAS.rglob(name)
    )
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
