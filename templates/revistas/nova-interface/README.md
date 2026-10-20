# Modelo de paginas informativas

Os arquivos deste diretorio sao fragmentos de conteudo editorial. Eles nao devem
ser publicados diretamente: o script `scripts/create_journal_info_pages.py`
combina cada fragmento com o cabecalho, menu, breadcrumb, rodape e idioma da
pagina do periodico.

Arquivos:

- `paboutj.html`, `eaboutj.html`, `iaboutj.html`: sobre o periodico;
- `pedboard.html`, `eedboard.html`, `iedboard.html`: corpo editorial;
- `pinstruc.html`, `einstruc.html`, `iinstruc.html`: instrucoes aos autores.

Os comentarios `EDITOR:` indicam o que deve ser substituido pelo operador. Os
IDs e os titulos das secoes podem ser alterados, mas os IDs devem continuar
unicos dentro da pagina para manter o sumario e os links de ancora.
