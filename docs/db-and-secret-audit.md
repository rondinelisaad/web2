# Auditoria de Banco e Segredos

Escopo: revisao de configuracoes reais locais, templates versionados e pontos de conexao de banco conforme NSI.04 secoes 3.2 e 3.3.

Data: 2026-05-24.

## Arquivos Revisados

- `htdocs/scielo.def.php`
- `htdocs/scielo.def.php.template`
- `htdocs/applications/scielo-org/scielo.def.php`
- `htdocs/applications/scielo-org/scielo.def.php.template`
- `htdocs/pressrelease/config.php.template`
- `htdocs/.user.ini`
- `.gitignore`
- `docker-compose.yml`
- `htdocs/applications/scielo-org/users/DBClass.php`
- `htdocs/applications/scielo-org/users/DBClassBlog.php`

## Resultado de Segredos e Configuracoes

- Os arquivos reais `scielo.def.php` estao cobertos por `.gitignore` e nao aparecem em `git ls-files`.
- Nao ha arquivos nao versionados pendentes em `git status --short` nem em `git ls-files --others --exclude-standard`.
- Os campos sensiveis locais revisados estao vazios nos arquivos reais ou sao placeholders nos templates:
  - `app_pass=`
  - `[MAIL_CREDENTIALS] sender=, username=, password=`
  - `JM_API_USER='anonymous'`
  - `JM_API_TOKEN='anonymous'`
- Nao foi identificado segredo real em arquivo versionado dentro do escopo revisado.
- `htdocs/.user.ini` esta versionado e contem caminho absoluto local para `compat.php`. Isto nao e segredo, mas e uma configuracao dependente de ambiente e deve ser ajustada antes de promocao para homologacao/producao.

## Resultado de Banco de Dados

- A aplicacao usa conexoes MySQL legadas via `mysql_pconnect`, com credenciais carregadas de `scielo.def.php`:
  - `DB_HOST_SCIELO`, `DB_USER_SCIELO`, `DB_USER_SCIELO_PASSWORD`, `DB_SCIELO`
  - `DB_HOST_BLOG`, `DB_USER_BLOG`, `DB_USER_BLOG_PASSWORD`, `DB_BLOG`
- O `scielo.def.php` local e os templates revisados nao contem essas chaves preenchidas.
- O `docker-compose.yml` local nao declara servico de banco de dados.
- O container possui extensoes PHP `mysqli`, `mysqlnd` e `pdo_mysql`, mas nao ha evidencia local de instancia ou credenciais de banco para executar `SHOW GRANTS`.
- Portanto, as permissoes reais de banco por ambiente nao puderam ser confirmadas neste workspace. A auditoria local cobre somente configuracao e codigo.

## Checklist Obrigatorio por Ambiente

Executar em desenvolvimento, homologacao e producao com usuario administrativo do banco:

```sql
SELECT CURRENT_USER();
SHOW GRANTS FOR 'scielo_app'@'%';
SHOW GRANTS FOR 'scielo_blog'@'%';
```

Validar:

- O usuario da aplicacao nao e `root`, `admin`, `dba` ou superusuario.
- Cada ambiente possui usuarios e senhas diferentes.
- O usuario de runtime possui apenas DML necessario: `SELECT`, `INSERT`, `UPDATE`, `DELETE`.
- O usuario de runtime nao possui `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `GRANT OPTION`, `SUPER`, `FILE`, `PROCESS` ou privilegios globais.
- Migrations, manutencao e rotinas administrativas usam usuario separado, temporario e auditado.
- A porta do banco nao fica exposta publicamente.
- Conexoes remotas usam TLS quando o banco nao esta no mesmo host/rede privada controlada.

Exemplo esperado para runtime:

```sql
CREATE USER 'scielo_app'@'10.%' IDENTIFIED BY '<gerenciado-fora-do-git>';
GRANT SELECT, INSERT, UPDATE, DELETE ON scielo.* TO 'scielo_app'@'10.%';

CREATE USER 'scielo_blog'@'10.%' IDENTIFIED BY '<gerenciado-fora-do-git>';
GRANT SELECT, INSERT, UPDATE, DELETE ON wordpress.* TO 'scielo_blog'@'10.%';
```

## Status de Compliance

- Segredos no workspace revisado: conforme, sem segredo real identificado.
- Arquivos reais de configuracao: conforme quanto a nao versionamento, pois `scielo.def.php` esta ignorado.
- Configuracao versionada: pendencia media em `htdocs/.user.ini` por caminho absoluto local.
- Permissoes reais de banco: pendente de evidencia externa por ambiente, pois nao ha acesso a instancia ou grants reais neste workspace.
