#!/usr/bin/env bash
set -euo pipefail

mkdir -p /run/php-fpm
chown apache:apache /run/php-fpm

HTTPD_PORT="${HTTPD_PORT:-80}"
sed -ri "s#^[[:space:]]*Listen[[:space:]].*#Listen ${HTTPD_PORT}#" /etc/httpd/conf/httpd.conf
sed -ri 's#^;?[[:space:]]*clear_env[[:space:]]*=.*#clear_env = no#' /etc/php-fpm.d/www.conf
if ! grep -q '^env\[SCIELO_ENABLE_DEBUG\]' /etc/php-fpm.d/www.conf; then
  printf '\nenv[SCIELO_ENABLE_DEBUG] = %s\n' "${SCIELO_ENABLE_DEBUG:-0}" >> /etc/php-fpm.d/www.conf
fi
if [[ -n "${SERVER_SCIELO:-}" ]]; then
  SCIELO_SERVER="${SERVER_SCIELO}"
elif [[ "${HTTPD_PORT}" == "80" ]]; then
  SCIELO_SERVER="127.0.0.1"
else
  SCIELO_SERVER="127.0.0.1:${HTTPD_PORT}"
fi

# Ensure required def files exist.
if [[ ! -f /var/www/html/htdocs/scielo.def.php && -f /var/www/html/htdocs/scielo.def.php.template ]]; then
  cp /var/www/html/htdocs/scielo.def.php.template /var/www/html/htdocs/scielo.def.php
fi
if [[ ! -f /var/www/html/htdocs/applications/scielo-org/scielo.def.php && -f /var/www/html/htdocs/applications/scielo-org/scielo.def.php.template ]]; then
  cp /var/www/html/htdocs/applications/scielo-org/scielo.def.php.template /var/www/html/htdocs/applications/scielo-org/scielo.def.php
fi
if [[ ! -f /var/www/html/htdocs/pressrelease/config.php && -f /var/www/html/htdocs/pressrelease/config.php.template ]]; then
  cp /var/www/html/htdocs/pressrelease/config.php.template /var/www/html/htdocs/pressrelease/config.php
fi

# Configure public SciELO server used to generate absolute links.
sed -ri "s#^SERVER_SCIELO=.*#SERVER_SCIELO=${SCIELO_SERVER}#" /var/www/html/htdocs/scielo.def.php || true
sed -ri 's#^ENABLED_CACHE=.*#ENABLED_CACHE=0#' /var/www/html/htdocs/scielo.def.php || true
sed -ri 's#^CACHE_STATUS\\s*=.*#CACHE_STATUS = off#' /var/www/html/htdocs/scielo.def.php || true

# Recreate legacy SciELO filesystem layout expected by old defs/scripts.
mkdir -p /home/scielo/www
ln -sfn /var/www/html/htdocs /home/scielo/www/htdocs
ln -sfn /var/www/html/cgi-bin /home/scielo/www/cgi-bin
ln -sfn /var/www/html/proc /home/scielo/www/proc
if [[ ! -e /var/www/html/cgi-bin/wxis.exe && -x /var/www/html/cgi-bin/temp/wxis ]]; then
  ln -sfn /var/www/html/cgi-bin/temp/wxis /var/www/html/cgi-bin/wxis.exe
fi
if [[ -d /var/www/html/htdocs/revistas ]]; then
  mkdir -p /var/www/html/htdocs/img/revistas
  for journal_dir in /var/www/html/htdocs/revistas/*; do
    if [[ -d "${journal_dir}" && ! -e "/var/www/html/htdocs/img/revistas/$(basename "${journal_dir}")" ]]; then
      ln -sfn "${journal_dir}" "/var/www/html/htdocs/img/revistas/$(basename "${journal_dir}")"
    fi
  done
fi

if [[ ! -e /var/www/html/bases && -d /var/www/html/bases_modelo ]]; then
  ln -sfn /var/www/html/bases_modelo /var/www/html/bases
fi
ln -sfn /var/www/html/bases /home/scielo/www/bases
rm -rf /home/scielo/www/bases/pages/* 2>/dev/null || true

# Compatibility fix for legacy CISIS index naming used by SERAREA in some dumps.
# Some datasets provide serarea.l01/l02 but WXIS expects serarea.ly1/ly2.
if [[ -d /var/www/html/bases/title ]]; then
  if [[ ! -e /var/www/html/bases/title/serarea.ly1 && -e /var/www/html/bases/title/serarea.l01 ]]; then
    ln -sfn /var/www/html/bases/title/serarea.l01 /var/www/html/bases/title/serarea.ly1
  fi
  if [[ ! -e /var/www/html/bases/title/serarea.ly2 && -e /var/www/html/bases/title/serarea.l02 ]]; then
    ln -sfn /var/www/html/bases/title/serarea.l02 /var/www/html/bases/title/serarea.ly2
  fi
  if [[ ! -e /var/www/html/bases/title/serarea.iyp && -e /var/www/html/bases/title/title.iyp ]]; then
    ln -sfn /var/www/html/bases/title/title.iyp /var/www/html/bases/title/serarea.iyp
  fi
fi

php-fpm -D
exec /usr/sbin/httpd -D FOREGROUND
