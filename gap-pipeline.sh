#!/bin/bash -x
QUERY_ID=q3

# Step 1: Search GEO for scRNA-seq datasets
if [ ! -f gap-$QUERY_ID-matches.xml ]
then
  esearch -db gap -query '(("rna"[Molecular Data Type]) OR "rna seq"[Molecular Data Type]) OR "10x"[Genotype Platform]' | esummary > gap-$QUERY_ID-matches.xml
fi

# Step 1.post: Separate out each DocumentSummarySet xml element esearch produces 
# as xml tools do not like more than one root element in a file
awk -v id=$QUERY_ID '
  BEGIN{ 
    fmt="gap-%s-matches-part%02d.xml"               # 2 digits for suffix, zero padded
  }
  /<DocumentSummarySet/, /<\/DocumentSummarySet/ {
    if ($0 ~ /<DocumentSummarySet/){ # for every start element...
      fname=sprintf(fmt, id, fcnt++)    # update output filename
    }
    print $0 > fname                # print line, redirect output to fname
  }
' gap-$QUERY_ID-matches.xml

for i in gap-$QUERY_ID-matches-part*.xml
do
  xsltproc disease2gap.xsl $i
  # xmllint --shell $i <<< 'cat  /DocumentSummarySet/DocumentSummary/d_study_results/d_study_disease_list/d_disease_info[d_disease_importance="primary"]/d_disease_name/text()' | grep -v -- "---" | grep -v ">" 
done | sort > disease-to-gap-$QUERY_ID.csv

