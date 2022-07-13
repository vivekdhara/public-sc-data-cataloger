# Public single cell data cataloger

Copyright (c) 2022 Aganitha. All rights reserved.

This repo contains code to catalog publicly available single cell omics data from 
[NCBI Gene Expression Omnibus (GEO)](https://www.ncbi.nlm.nih.gov/geo/) and [dbGaP](https://www.ncbi.nlm.nih.gov/gap/) databases
and organize the resulting catalog by disease area. 

Association of each GEO dataset to a disease area is done via [MeSH headings](https://meshb.nlm.nih.gov/treeView) 
in Pubmed of articles associated with each dataset. A processed version of MeSH unique identifiers to 
[tree numbers](https://www.nlm.nih.gov/mesh/intro_trees.html) map produced by a [custom script](disease-code-to-tree-number.sh) is 
[bundled](disease-code-to-tree-number-sorted.csv) with this repo.

Association of each dbGaP dataset to a disease area is directly obtained from diseases named along with the study.

Code here relies on [Entrez Direct](https://www.ncbi.nlm.nih.gov/books/NBK179288/) utilities which
can be used from a [docker image](dockerbuild/Dockerfile).

## Search criteria

We use the following search [query](https://www.ncbi.nlm.nih.gov/geo/info/qqtutorial.html) for GEO. Note that `mtx` files are cell-by-gene matrix files
produced in single cell RNA-seq experiments.

```
"human"[Organism] 
AND 
  (
    "expression profiling by high throughput sequencing"[DataSet Type] 
    OR 
    "high throughput sequencing"[Platform Technology Type]
  ) 
AND 
  "gse"[Entry Type] 
AND 
  "gds pubmed"[Filter] 
AND 
  "mtx"[Supplementary Files]
```

And, here's the query we use for searching dbGaP.

```
(
  ("rna"[Molecular Data Type]) 
  OR 
  "rna seq"[Molecular Data Type]
) 
OR 
"10x"[Genotype Platform]
```

## Pre-requisites

1. Docker
2. Linux

Haven't tested on Mac as of now; code here may not run as-is due to slight differences to be expected between utils like 
join, awk, and sed between Linux and Mac variants.
 
## Instructions to run 
1. `make image`
2. `make geo-search` or `make gap-search` depending on which database you want to search.
   `make all` will show you all options.

Key output files are:
1. `disease-to-geo-mtx-maj.csv`: Catalog of GEO studies, associated with diseases whose MeSH codes are declared as "Major" in associated Pubmed articles.
2. `disease-to-geo-mtx-all.csv`: Catalog of GEO studies, associated with all diseases associated via MeSH codes in associated Pubmed articles.
3. `disease-to-gap-q3.csv`: Catalog of dbGaP studies, by disease
