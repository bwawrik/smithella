### Comparison of Smithella Genomes

- The Purpose of this repository is to record the direct comparison of protein coding genes found in Smithella strains in the SDB consortium and found in the literature
-  I'm using the KOBAS database for my Diamond searches

---

#### First, lets extract the KO numbers for all genes in each of the genomes
(Link to Diamond documentation: http://ab.inf.uni-tuebingen.de/software/diamond/)

```sh
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q D17.faa -o D17.faa.dmd -e 1e-10 -k 1
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q F21.faa -o F21.faa.dmd -e 1e-10 -k 1
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q ME_1.faa -o ME_1.faa.dmd -e 1e-10 -k 1
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q SCADC.faa -o SCADC.faa.dmd -e 1e-10 -k 1
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q SDB_ONE.faa -o SDB_ONE.faa.dmd -e 1e-10 -k 1
gunzip *
```

#### I then run a perl script to parse the KO numbers into a tab delimited file 

```sh
perl /opt/local/scripts/get_record_grep.pl /data/static/sequence_data/KoGenes D17.faa.dmd D17.faa.dmd.KEGG_grep
perl /opt/local/scripts/get_record_grep.pl /data/static/sequence_data/KoGenes F21.faa.dmd F21.faa.dmd.KEGG_grep
perl /opt/local/scripts/get_record_grep.pl /data/static/sequence_data/KoGenes ME_1.faa.dmd ME_1.faa.dmd.KEGG_grep
perl /opt/local/scripts/get_record_grep.pl /data/static/sequence_data/KoGenes SCADC.faa.dmd SCADC.faa.dmd.KEGG_grep
perl /opt/local/scripts/get_record_grep.pl /data/static/sequence_data/KoGenes SDB_ONE.faa.dmd SDB_ONE.faa.dmd.KEGG_grep
```

#### Make Diamond Databases of all five .faa files

```sh
diamond makedb --in D17.faa -d D17
diamond makedb --in F21.faa -d F21
diamond makedb --in ME_1.faa -d ME_1
diamond makedb --in SCADC.faa -d SCADC
diamond makedb --in SDB_ONE.faa -d SDB_ONE
```

#### Search for Membrane Complexes

- I went to the AK-01 genome paper and downloaded the supplement. 
- I then generated a fasta file of the protein sequences that encode the membrane complex proteins as outlined in supplement S20 (AK01_membrane_complexes.faa)
- I then use Diamond to search for homologs of these proteins in each of the Smithella genome

```sh
diamond blastp -d D17 -q AK01_membrane_complexes.faa -o AK01_MK_in_D17.faa.dmd -e 1e-10 -k 1
diamond blastp -d F21 -q AK01_membrane_complexes.faa -o AK01_MK_in_F21.faa.dmd -e 1e-10 -k 1
diamond blastp -d ME_1 -q AK01_membrane_complexes.faa -o AK01_MK_in_ME_1.faa.dmd -e 1e-10 -k 1
diamond blastp -d SCADC -q AK01_membrane_complexes.faa -o AK01_MK_in_SCADC.faa.dmd -e 1e-10 -k 1
diamond blastp -d SDB_ONE -q AK01_membrane_complexes.faa -o AK01_MK_in_SDB_ONE.faa.dmd -e 1e-10 -k 1
```
- this makes the follwoing results files

```sh
-rw-rw-r--. 1 bwawrik bwawrik      387 Jul  6 15:35 AK01_MK_in_D17.faa.dmd
-rw-rw-r--. 1 bwawrik bwawrik      858 Jul  6 15:36 AK01_MK_in_F21.faa.dmd
-rw-rw-r--. 1 bwawrik bwawrik      711 Jul  6 15:36 AK01_MK_in_ME_1.faa.dmd
-rw-rw-r--. 1 bwawrik bwawrik     1176 Jul  6 15:36 AK01_MK_in_SCADC.faa.dmd
-rw-rw-r--. 1 bwawrik bwawrik     1176 Jul  6 15:36 AK01_MK_in_SDB_ONE.faa.dmd
```


