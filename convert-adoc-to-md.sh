INPUT_ADOC=OCTA-0.adoc
asciidoctor -r asciidoctor-diagram --backend html --out-file - $INPUT_ADOC | \
pandoc --from html --to markdown_strict --output $INPUT_ADOC.md
