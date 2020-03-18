## Introduction
GTEx V8 is built using hg38 coordinates, so to run a version of PrediXcan using the GTEx V8 data, we need to have the coordinates of each SNP in the correct position.  To do this, we are going to try to use a process similar to that of the [hg18 to hg19 liftover](https://github.com/WheelerLab/Neuropsychiatric-Phenotypes/blob/master/SCZ-BD_Px/1_hg18tohg19liftover.md). 

## Prepping LiftOver Files
First, I downloaded the appropriate [chain file](http://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz) from UCSC Genome Browser.  I also returned to the [LiftMap.py](https://github.com/WheelerLab/Neuropsychiatric-Phenotypes/blob/master/SCZ-BD_Px/Complimentary_Scripts/LiftMap.py) script that was edited from the liftover to hg19.  The [UCSC Genome Browser](https://genome.ucsc.edu/cgi-bin/hgGateway) is always a great resource to confirm and check builds.  When searching SNPs in the browswer, try to chose a SNP from somewhere towards the middle of the chromosome rather than one of the ends.  


Make the following changes to the script:
```
  ##['LIFTOVERBIN']='/usr/local/bin/liftOver
  ##['CHAIN']='/home/peter/prostate_cancer/liftover/hg19ToHg38.over.chain.gz'
```


## Execute LiftOver Script
The liftover should ideally be done from .ped/.map files, but you can easily go from bed/bim/fam to this file type in plink.

``` 
python LiftMap.py -m /home/peter/prostate_cancer/aa_genotypes/prostate_cancer_genotypes.map -p /home/peter/prostate_cancer/aa_genotypes/prostate_cancer_genotypes.ped -o new

plink --file new --make-bed --allow-extra-chr --out hg38_imputed_aa_procan
```
