docker run --rm -v $PWD:/work -w /work -it ncbi/edirect \
	xsltproc -o disease-code-to-tree-number.csv disease-code-to-tree-number.xsl desc2022 
