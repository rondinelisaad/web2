# Checklist de Release/Deploy Seguro

Escopo: hardening de segurança do Web SciELO conforme NSI.04, com foco nos controles de Testes (4.5) e Implantacao (4.6).

## Fase 5 - Testes (NSI.04 4.5)

- [x] Usar dados ficticios ou anonimizados no ambiente de teste
  - Por que: dados reais em teste violam LGPD e expõem usuarios.
  - Como: os smokes foram executados no container local `scielo-web` com base local `127.0.0.1`.
  - Referencia NSI.04: 4.5

- [x] Realizar testes manuais de seguranca antes do release
  - Por que: testes automatizados nao cobrem toda a logica de negocio.
  - Como: smoke HTTP validou bloqueio de `phpinfo`, samples/testes, `debug=xml` externo e entradas invalidas.
  - Referencia NSI.04: 3.7

- [ ] Executar testes automatizados de seguranca no CI
  - Por que: regressões de seguranca passam sem automacao.
  - Como: incluir SAST/DAST/dependency check no pipeline; pendente por falta de pipeline identificado neste repositorio.
  - Referencia NSI.04: 3.7, 4.5

- [ ] Submeter sistema a ferramenta de pentest quando houver mudanca de superficie
  - Por que: mudancas em endpoints/debug/config podem criar superficie nova.
  - Como: rodar OWASP ZAP/Burp contra homologacao antes do deploy.
  - Referencia NSI.04: 3.5

- [x] Manter testes em ambiente separado de producao
  - Por que: testes em producao podem expor dados reais ou derrubar o servico.
  - Como: validacao executada em container Docker local.
  - Referencia NSI.04: 4.5

## Fase 6 - Implantacao / Deploy (NSI.04 4.6)

- [ ] Documentar plano de implantacao com rollback
  - Por que: deploy sem rollback aumenta o tempo de indisponibilidade.
  - Como: registrar passos de deploy, responsaveis, criterios de sucesso e reversao para estes commits.
  - Referencia NSI.04: 4.6

- [ ] Realizar backup antes do deploy
  - Por que: problema pos-deploy pode exigir restauracao imediata.
  - Como: snapshot do ambiente e backup do banco antes da aplicacao.
  - Referencia NSI.04: 4.6, 3.7

- [ ] Aplicar patches de seguranca de app e infraestrutura
  - Por que: infraestrutura desatualizada anula parte do hardening.
  - Como: validar imagem base, PHP/Apache e dependencias antes da promocao.
  - Referencia NSI.04: 4.6

- [ ] Validar permissoes reais de banco por ambiente
  - Por que: o codigo pode estar endurecido, mas um usuario com privilegios excessivos ainda permite impacto maior em incidente.
  - Como: executar `SHOW GRANTS` em dev, homologacao e producao conforme `docs/db-and-secret-audit.md`.
  - Referencia NSI.04: 3.2, 4.6

- [x] Revisar segredos e configuracoes fora do diff
  - Por que: arquivos reais ignorados pelo Git podem conter credenciais ou configuracoes inseguras.
  - Como: revisados `scielo.def.php`, templates, `.user.ini`, `.gitignore` e arquivos nao versionados; sem segredo real identificado no workspace local.
  - Referencia NSI.04: 3.3, 4.6

- [ ] Ativar monitoramento e deteccao
  - Por que: incidentes sem monitoramento sao descobertos tarde.
  - Como: alertas para 4xx/5xx, falha de integracoes WXIS, tentativas de `debug`, acesso a samples/testes e erro PHP.
  - Referencia NSI.04: 4.6

- [x] Executar testes de validacao pos-deploy
  - Por que: comportamento pode diferir entre build e runtime.
  - Como: rebuild da imagem Docker, `httpd -t`, reload/recreate do container e smoke HTTP local.
  - Referencia NSI.04: 4.6

- [ ] Registrar mudanca conforme GMUD
  - Por que: rastreabilidade e reversibilidade sao requisitos de controle.
  - Como: abrir registro com commits, impacto, janela, aprovador, plano de rollback e evidencias de teste.
  - Referencia NSI.04: 5

## Evidencias Locais

- `php -l` executado nos arquivos PHP alterados: aprovado.
- `httpd -t`: `Syntax OK`.
- `docker compose build scielo-web`: aprovado.
- `docker compose up -d scielo-web`: aprovado.
- `docs/db-and-secret-audit.md`: auditoria local de configuracoes, segredos e checklist de grants por ambiente.
- Smoke HTTP local:
  - `/phpinfo.php`: 404.
  - `/info.php`: 404.
  - samples/testes de `nusoap`, `phpmailer` e `jpgraph`: 403.
  - `scielo.php?...&debug=xml` externo: 200 sem XML bruto.
  - entradas invalidas em `statjournal` e `scielologArticle`: 400.
