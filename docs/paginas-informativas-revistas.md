# Paginas informativas de revistas

## O que mudou

Na interface atual, o operador nao precisa mais copiar o cabecalho, ISSN,
logo, menu lateral, breadcrumb ou rodape. Esses elementos sao obtidos da
pagina do periodico e montados pelo template.

O operador deve manter apenas o conteudo editorial de:

| Pagina | Portugues | Espanhol | Ingles |
| --- | --- | --- | --- |
| Sobre o periodico | `paboutj.htm` | `eaboutj.htm` | `iaboutj.htm` |
| Corpo editorial | `pedboard.htm` | `eedboard.htm` | `iedboard.htm` |
| Instrucoes aos autores | `pinstruc.htm` | `einstruc.htm` | `iinstruc.htm` |

`Politica editorial` usa a mesma pagina de Sobre o periodico. Nao e necessario
criar um quarto arquivo. `Contato` vem do e-mail configurado no rodape e no
menu do periodico.

## Criar uma revista nova

1. Confirme que a pagina do periodico responde para o ISSN nos tres idiomas.
2. Crie os logos `glogo.gif` e `plogo.gif` em
   `htdocs/img/revistas/<acronimo>/`.
3. Execute o gerador a partir da raiz do projeto:

   ```bash
   python3 scripts/create_journal_info_pages.py \
     --acronym novarevista \
     --issn 2675-519X \
     --base-url http://127.0.0.1:8090
   ```

   Em homologacao, `--base-url` deve apontar para o endereco de homologacao.
   A variavel `SERVER_SCIELO` tambem pode ser usada como valor padrao.

4. O comando cria os nove arquivos dentro de
   `htdocs/revistas/novarevista/`.
5. Abra os arquivos, substitua os comentarios `EDITOR:` e remova secoes que
   nao se aplicarem. O conteudo deve ser escrito em seu respectivo idioma.
6. Mantenha os `name`/IDs das secoes unicos. Eles sao usados pelas ancoras e
   pelo sumario da pagina.
7. Valide as URLs em portugues, espanhol e ingles antes de publicar.

O gerador recusa sobrescrever uma pasta que ja tenha paginas. Para regenerar
uma pasta existente, faca backup e use `--force` conscientemente.

## O que nao deve ser editado

Nao altere manualmente, dentro das paginas geradas:

- `serial-modern-header` e os controles de idioma;
- bloco `journalInfo`, logo, ISSN e publicador;
- menu lateral de acoes;
- barra de navegacao, breadcrumb e ferramentas;
- `serial-template-utils`, acessibilidade e rodape.

Esses trechos pertencem ao template. Alteracoes locais neles serao perdidas na
proxima regeneracao e podem deixar o cabeçalho diferente entre revistas.

## Conteudo permitido

O modelo aceita HTML simples e sem scripts:

- paragrafos, listas ordenadas e nao ordenadas;
- links externos com `https://`;
- negrito, italico e subtitulos;
- tabelas pequenas, quando forem indispensaveis;
- imagens institucionais publicadas em `/img/revistas/<acronimo>/`.

Nao inserir JavaScript, CSS inline, `iframe`, formularios ou tabelas usadas como
estrutura de layout. Para ORCID, use o link completo e o padrao de icone já
adotado no corpo editorial existente.

## Logos

- `glogo.gif`: logo usada no cabeçalho e nas paginas informativas;
- `plogo.gif`: logo usada em componentes legados e compatibilidade;
- manter os nomes exatamente em minusculas;
- conferir transparencia, proporcao e legibilidade em desktop e mobile;
- nao incorporar logo ou ISSN no corpo de `paboutj`, `pedboard` ou `pinstruc`.

## Homologacao e publicacao

O fluxo recomendado e:

1. gerar a pasta no ambiente local;
2. editar os nove arquivos;
3. publicar a pasta e os logos em homologacao;
4. conferir as nove URLs, links de ancora, ORCID, e-mail e menu lateral;
5. revisar em desktop e celular;
6. versionar os arquivos em um commit separado por revista;
7. promover o mesmo commit para producao.

Para a revista sem paginas informativas, como o exemplo do ISSN `2675-519X`,
o menu lateral nao deve exibir links quebrados. Depois que `paboutj.htm`,
`pedboard.htm` e `pinstruc.htm` forem publicados, o roteamento da pagina do
periodico passa a encontrar esses destinos automaticamente.

## Como facilitar ainda mais para o operador

O gerador resolve a etapa repetitiva e reduz o trabalho para preenchimento de
conteudo. O proximo passo recomendado e um painel editorial com este fluxo:

1. cadastro da revista por ISSN, com preenchimento automatico do cabeçalho;
2. abas `Sobre`, `Corpo editorial` e `Instrucoes`, cada uma com os idiomas;
3. editor visual restrito a paragrafos, listas, links, tabelas e imagens;
4. campos estruturados para nome, instituicao, ORCID e e-mail dos editores;
5. preview responsivo que reutiliza o mesmo shell do site;
6. indicador de traducao pendente por idioma;
7. historico de versoes, rascunho, revisao e publicacao;
8. validacao automatica de links, IDs duplicados, ORCID e imagens ausentes;
9. publicacao atomica com possibilidade de rollback.

O painel deve salvar o conteudo como HTML sanitizado ou como blocos estruturados
e deixar a montagem do cabecalho e rodape exclusivamente para o template. Assim
o operador edita apenas o que muda entre revistas, sem precisar conhecer a
estrutura HTML da interface.
