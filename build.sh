#!/bin/bash

cd `dirname $0`

mkdir -p docs pdf && rm -rf {docs,pdf}/*
touch docs/.nojekyll

cp index.html docs/

for adoc in 1*.adoc
do
  name=`basename ${adoc} .adoc`
  cat ${adoc} | awk 'BEGIN {output = 1} /^[=]+ / {output = 1} /== Examples/ {output = 0} /^\[\[/ {output = 1} {if (output) print}' > ${name}-no-examples.adoc
  asciidoctor ${adoc} && mv ${name}.html docs/
  # remove links from pdf files
  for _adoc in ${name}*.adoc
  do
    _name=`basename ${_adoc} .adoc`
    cat ${_adoc} | grep -v '^link:' > ${_name}-pdf.adoc
    asciidoctor-pdf ${_name}-pdf.adoc && mv ${_name}-pdf.pdf pdf/${_name}.pdf
    rm ${_name}-pdf.adoc
  done
  rm ${name}-no-examples.adoc
done

ls pdf/ | xargs -n1 -I {} pdfcrop --margins 50 pdf/{} pdf/{}
