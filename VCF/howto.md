Here we will use the Picard LiftoverVcf tool developed by the broad institute

https://github.com/broadinstitute/picard

Afer installing the above we will need a a fasta file of the build we are lifting over to 

https://www.gencodegenes.org/human/

At the time of writing I used 

ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_32/GRCh38.p13.genome.fa.gz

From this we then need to build a dictionary file using the picard tool

```
java -jar picard.jar CreateSequenceDictionary R=/home/ryan/Data/liftover/GRCh38.p13.genome.fa.gz
```
Note: The syntax of this code may change as Picard updates (instead of using R=<file>, picard will update to just -R <file>)

Next you need to check that your chromosome names in your vcf file are formatted as `chrNUM` and not just `NUM`. If they are not update their names using bcftools.

```
for i in {1..22}
do
  echo "${i} chr${i}" >> chr.map
done

for i in {1..22}
do
  bcftools annotate --rename-chrs chr.map <input.vcf.gz> -o <output.vcf.gz> -O z
done
```
Finally use the picard tool to perform liftover

```
for i in {1..22}
do
  java -jar picard.jar LiftoverVcf I=<Input.vcf> O=<Output.vcf> CHAIN=<Chain> R=<Reference.fa> REJECT=<Output.reject.vcf.gz>
done
```
