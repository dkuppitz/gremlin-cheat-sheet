#!/bin/bash

cd `dirname $0`

cat cheat-sheet.adoc | awk 'BEGIN {output = 1} /^[=]+ / {output = 1} /== Examples/ {output = 0} /^\[\[/ {output = 1} {if (output) print}' > cheat-sheet-no-examples.adoc

mkdir -p docs pdf
touch docs/.nojekyll

asciidoctor cheat-sheet.adoc && mv cheat-sheet.html docs/index.html
asciidoctor-pdf cheat-sheet*.adoc && mv *.pdf pdf/
