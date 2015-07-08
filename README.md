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

#### Lets find the genes that are shared among all the Smithella's

- The Smithella SDB assembly has the largest number of predicted Proteins.  
- Run a blastP of all Smithella SDB proteins against the other four genomes
- The put all hits in a spread sheet and find the ones that are in all five; four out of five; in all but F21 (no assA)

```sh
diamond blastp -d SDB_ONE -q D17.faa -o D17_vs_SDB.faa.dmd -e 1e-10 -k 1
diamond blastp -d SDB_ONE -q ME_1.faa -o ME_1_vs_SDB.faa.dmd -e 1e-10 -k 1
diamond blastp -d SDB_ONE -q SCADC.faa -o SCADC_vs_SDB.faa.dmd -e 1e-10 -k 1
diamond blastp -d SDB_ONE -q F21.faa -o F21_vs_SDB.faa.dmd -e 1e-10 -k 1
```
- I then added all of these table into an SQLite Database using the Firefox addon (Genome_comparison.sqlite)
- the query to find the identifiers of SDB_ONE ORFS that have a homolg in all other smithellas is:

```sh
SELECT DISTINCT col_2
FROM D17
WHERE col_2 IN 
(SELECT DISTINCT col_2 FROM F21)
AND
col_2 IN 
(SELECT DISTINCT col_2 FROM ME1)
AND
col_2 IN 
(SELECT DISTINCT col_2 FROM SCADC)
```

- If I exclude F21, which does not have an ASS gene:
 
```sh
SELECT DISTINCT col_2
FROM D17
WHERE col_2 IN 
(SELECT DISTINCT col_2 FROM ME1)
AND
col_2 IN 
(SELECT DISTINCT col_2 FROM SCADC)
```

- I then added the results of these two searches as tables. This is needed to find the entries that are absent from the comparison wiht F21

```sh
SELECT DISTINCT col_1
FROM SDB_VS_SCADCD17ME1
WHERE col_1 NOT IN 
(SELECT DISTINCT col_1 FROM SDB_VS_SCADCD17ME1F21)
```
- This produces two files, which conttain the identifiers to the genes which
- are shared between SDB and SCADC, ME1, D17, and F21 (SDB_VS_SCADCD17ME1F21.txt)
- are shared between SDB and SCADC, ME1, and D17 but not in F21 (SDB_VS_SCADCD17ME1_not_F21.txt)


- Now lets extract the AA sequences that correspond to these hits

```sh
read_fasta -i SDB_ONE.faa | grab -E SDB_VS_SCADCD17ME1F21.txt | write_fasta -o SDB_VS_SCADCD17ME1F21.faa
read_fasta -i SDB_ONE.faa | grab -E SDB_VS_SCADCD17ME1_not_F21.txt | write_fasta -o SDB_VS_SCADCD17ME1_not_F21.faa
```

- We now need a basic annotation of these gene, which we will do by using the KOBAS database

```sh
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q SDB_VS_SCADCD17ME1F21.faa -o SDB_VS_SCADCD17ME1F21.faa.dmd -e 1e-10 -k 1
diamond blastp -d /data/DATABASES/KOBAS/seq_pep/ko -q SDB_VS_SCADCD17ME1_not_F21.faa -o SDB_VS_SCADCD17ME1_not_F21.faa.dmd -e 1e-10 -k 1
```

- Extract the columns containing the database hit identifiers
```sh
cut -f 2 SDB_VS_SCADCD17ME1_not_F21.faa.dmd > N1.txt
cut -f 2 SDB_VS_SCADCD17ME1F21.faa.dmd > N2.txt
```

- make a databasee to analyze the results in (needs KoGenes.txt file; too large to upload to github)

```sh
sqlite3 KO.sqlite
```

- Import the KOgenes table

```sh
.separator " "
create table KoGenes (KO, gene);
.import KoGenes KoGenes
create table F1(hit);
create table F2(hit);
.import N1.txt F1;
.import N2.txt F2;
```
- now do your database search

... ok, never mind this database shit --- just do it with remote blast

- blast results using remote ncbi against swissprot
 

```sh
lastp -db swissprot -query SDB_VS_SCADCD17ME1_not_F21.faa -remote -outfmt 6 -num_alignments 1 -evalue 1e-10 > SDB_VS_SCADCD17ME1_not_F21.faa.blast
```
