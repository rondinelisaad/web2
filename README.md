# Web

SciELO Web.

## Como Subir o Projeto Localmente

O ambiente local recomendado usa Docker Compose com Apache/PHP em Rocky Linux 9.

### Pre-requisitos

- Docker instalado e em execucao.
- Docker Compose v2, disponivel pelo comando `docker compose`.
- Porta `8090` livre na maquina local.

### Configuracao Inicial

O container monta o diretorio do projeto em `/var/www/html` e, na primeira execucao, cria automaticamente os arquivos locais de configuracao quando eles ainda nao existem:

- `htdocs/scielo.def.php`, a partir de `htdocs/scielo.def.php.template`.
- `htdocs/applications/scielo-org/scielo.def.php`, a partir de `htdocs/applications/scielo-org/scielo.def.php.template`.

Esses arquivos reais nao devem ser versionados. Ajuste neles apenas valores do seu ambiente local, homologacao ou producao.

### Subir a Aplicacao

Na raiz do projeto, execute:

```bash
docker compose build scielo-web
docker compose up -d scielo-web
```

A aplicacao ficara disponivel em:

```text
http://localhost:8090/
```

Para acompanhar os logs:

```bash
docker compose logs -f scielo-web
```

Para parar o ambiente:

```bash
docker compose stop scielo-web
```

### Validacoes Rapidas

Depois de subir o container, valide o Apache e alguns endpoints:

```bash
docker compose exec -T scielo-web httpd -t
curl -I http://localhost:8090/
curl -I http://localhost:8090/phpinfo.php
curl -I http://localhost:8090/info.php
```

Resultado esperado:

- `httpd -t` retorna `Syntax OK`.
- A home responde HTTP 200 ou redirecionamento esperado conforme a base/configuracao local.
- `phpinfo.php` e `info.php` retornam 404.

### Bases Gizmo

A partir da versao **5.45.2**, copie os arquivos `gizmo.*`, disponiveis em `bases_modelo/gizmo`, para o diretorio `bases/gizmo` da aplicacao implantada.

Caso a pagina do site nao carregue conforme esperado, execute tambem:

```bash
proc/cisis/id2i bases/gizmo/gizmo.id create=bases/gizmo/gizmo
```

### Observacoes de Seguranca

- Nao commite `scielo.def.php` real nem arquivos com senhas, tokens ou credenciais.
- Configure credenciais de banco e servicos externos apenas nos arquivos reais de ambiente ou em mecanismo seguro de secrets.
- Antes de deploy em homologacao/producao, revise o checklist em `docs/security-release-checklist.md`.
- A auditoria de banco e segredos esta documentada em `docs/db-and-secret-audit.md`.
