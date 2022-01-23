INPUT_ADOC=design.adoc
asciidoctor -r asciidoctor-diagram --backend html --out-file - $INPUT_ADOC | \
pandoc --from html --to docx --output $INPUT_ADOC.docx
