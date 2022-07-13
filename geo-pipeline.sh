#!/bin/bash
QUERY_ID=mtx

# Step 1: Search GEO for scRNA-seq datasets
if [ ! -f geo-$QUERY_ID-matches.xml ]
then
  esearch -db gds -query '("human"[Organism] AND ("expression profiling by high throughput sequencing"[DataSet Type] OR "high throughput sequencing"[Platform Technology Type]) AND "gse"[Entry Type] AND "gds pubmed"[Filter] AND "mtx"[Supplementary Files])' | esummary > geo-$QUERY_ID-matches.xml
fi

# Step 1.post: Separate out each DocumentSummarySet xml element esearch produces 
# as xml tools do not like more than one root element in a file
awk -v id=$QUERY_ID '
  BEGIN{ 
    fmt="geo-%s-matches-part%02d.xml"               # 2 digits for suffix, zero padded
  }
  /<DocumentSummarySet/, /<\/DocumentSummarySet/ {
    if ($0 ~ /<DocumentSummarySet/){ # for every start element...
      fname=sprintf(fmt, id, fcnt++)    # update output filename
    }
    print $0 > fname                # print line, redirect output to fname
  }
' geo-$QUERY_ID-matches.xml

# Step 2a: Extract pubmed ID of each study GEO search returned
for i in geo-$QUERY_ID-matches-part*.xml
do
  xmllint --shell $i <<< 'cat  /DocumentSummarySet/DocumentSummary/PubMedIds/int/text()' | grep '[0-9]'
done > geo-$QUERY_ID-matches-pubmed-ids.txt

# Step 2b: Fetch metadata for extracted pubmed IDs
if [ ! -f geo-$QUERY_ID-pubmed-matches.xml ]
then
  sort geo-$QUERY_ID-matches-pubmed-ids.txt | uniq | efetch -db pubmed -format medline -mode xml > geo-$QUERY_ID-pubmed-matches.xml 
fi

# Step 2c: Produce pubmed-id to mesh-disease-codes map
# but first we need to separate each PubmedArticleSet into its own file
awk -v id=$QUERY_ID '
  BEGIN{
      fmt="geo-%s-pubmed-matches-part%02d.xml"               # 2 digits for suffix, zero padded
  }
  /<PubmedArticleSet/, /<\/PubmedArticleSet/ {
      if ($0 ~ /<PubmedArticleSet/){ # for every start element...
        fname=sprintf(fmt, id, fcnt++)    # update output filename
      }
      print $0 > fname                # print line, redirect output to fname
   }
' geo-$QUERY_ID-pubmed-matches.xml

for i in geo-$QUERY_ID-pubmed-matches-part*.xml
do
  xsltproc majmesh2pm.xsl $i 
done | sort > geo-$QUERY_ID-pubmed-maj-mesh.csv

join -t, -o '1.2,2.2' geo-$QUERY_ID-pubmed-maj-mesh.csv disease-code-to-tree-number-sorted.csv | sort > geo-$QUERY_ID-pubmed-maj-disease.csv

for i in geo-$QUERY_ID-pubmed-matches-part*.xml
do
  xsltproc allmesh2pm.xsl $i
done | sort > geo-$QUERY_ID-pubmed-all-mesh.csv

join -t, -o '1.2,2.2' geo-$QUERY_ID-pubmed-all-mesh.csv disease-code-to-tree-number-sorted.csv | sort > geo-$QUERY_ID-pubmed-all-disease.csv

for i in geo-$QUERY_ID-matches-part*.xml
do
  xsltproc pm2geo.xsl $i
done | sort > geo-$QUERY_ID-to-pubmed.csv

join -t, -o '1.2,2.2' geo-$QUERY_ID-pubmed-maj-disease.csv geo-$QUERY_ID-to-pubmed.csv | sort > disease-to-geo-$QUERY_ID-maj.csv 
join -t, -o '1.2,2.2' geo-$QUERY_ID-pubmed-all-disease.csv geo-$QUERY_ID-to-pubmed.csv | sort > disease-to-geo-$QUERY_ID-all.csv 
