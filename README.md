### Comparison of Smithella Genomes

- The Purpose of this repository is to record the direct comparison of protein coding genes found in Smithella strains in the SDB consortium and found in the literature
-  I'm using the KOBAS database for my Diamond searches

---

#### First, lets extract the KO numbers for all genes in each of the genomes

```sh
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q D17.faa -o D17.faa.dmd -e 1e-10 -k 1
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q F21.faa -o F21.faa.dmd -e 1e-10 -k 1
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q ME_1.faa -o ME_1.faa.dmd -e 1e-10 -k 1
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q SCADC.faa -o SCADC.faa.dmd -e 1e-10 -k 1
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q SDB_ONE.faa -o SDB_ONE.faa.dmd -e 1e-10 -k 1
```

#### I then run a perl script to parse the KO numbers into a tab delimited file 

```sh
perl /opt/local/scripts/get_record_grep.pl /data/static/sequence_data/KoGenes D17.faa.dmd D17.faa.dmd.KEGG_grep
perl /opt/local/scripts/get_record_grep.pl /data/static/sequence_data/KoGenes F21.faa.dmd F21.faa.dmd.KEGG_grep
perl /opt/local/scripts/get_record_grep.pl /data/static/sequence_data/KoGenes ME_1.faa.dmd ME_1.faa.dmd.KEGG_grep
perl /opt/local/scripts/get_record_grep.pl /data/static/sequence_data/KoGenes SCADC.faa.dmd SCADC.faa.dmd.KEGG_grep
perl /opt/local/scripts/get_record_grep.pl /data/static/sequence_data/KoGenes SDB_ONE.faa.dmd SDB_ONE.faa.dmd.KEGG_grep
```


