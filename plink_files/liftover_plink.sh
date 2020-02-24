#!/bin/bash
PlinkPath=/usr/local/bin
repoPath=~/Liftover_tools/plink_files/
LiftOverPath=/usr/local/bin
UpdateIds=False


while :
do
    case "$1" in
      -b | --bfile) #same as normal plink - Path to all files and the shared prefix
	        Bfile=True
	        shift 1
	        ;;
      --bim) #/path/to/file.bim
        	  BimFile="$2"
	        shift 2
	        ;;
      --bed) #/path/to/file.bed
      	  	BedFile="$2"
	        shift 2
	        ;;
      -c | --chain) #chain file used by liftover tool
          	ChainFile="$2"
	        shift 2
	        ;;
      --fam) #/path/to/file.fam
      	 	FamFile="$2"
	        shift 2
	        ;;
      -o | --output) #directory where you'd like to send all your QC folders - will be folder hierarchy
          	OutputDir="$2"
	        shift 2
	        ;;
      --updateids) #update IDs to c:pos, otherwise keep original IDs
          UpdateIds=TRUE
	        shift 2
	        ;;
      -*) #unknown 
      		echo "Error: Unknown option: $1" >&2
	        exit 1
	        ;;
      *)  # No more options
         	shift
	        break
	        ;;
     esac
done

echo "Using bim file ${BimFile:=${BFile:=$BfileDefault}.bim}"
echo "Using bed file ${BedFile:=${BFile:=$BfileDefault}.bed}"
echo "Using fam file ${FamFile:=${BFile:=$BfileDefault}.fam}"

if [ ! -e "${BimFile}" ] || [ ! -e "${FamFile}" ] || [ ! -e "${BedFile}" ]
then
  echo "Warning: One or more bfiles does not exist. Exiting."
  exit 1
fi

if [ ! -e  ]
then
  echo "Warning: One or more bfiles does not exist. Exiting."
  exit 1
fi

awk '{print "chr" $1 FS $3 FS $3 + 1 FS $2}' ${BimFile} > ${OutputDir}/prelift.txt 

${LiftOverPath}/liftOver ${OutputDir}/prelift.txt ${ChainFile} ${OutputDir}/lifted.txt ${OutputDir}/unmapped.txt

awk '{print $0 FS $1 ":" $2 }' ${OutputDir}/lifted.txt | grep -F -v "alt" | grep -F -v "random" > ${OutputDir}/lifted_cpos.txt
awk '{print $4}' ${OutputDir}/lifted_cpos.txt > ${OutputDir}/extract_ids.txt

"${PlinkPath}"/plink --bed "${BedFile}" \
--bim "${BimFile}" \
--fam "${FamFile}" \
--extract ${OutputDir}/extract_ids.txt \
--update-chr ${OutputDir}/lifted_cpos.txt 1 4 \
--update-map ${OutputDir}/lifted_cpos.txt 2 4 \
--make-bed \
--out ${OutputDir}/lifted_update_chr_bp

if [ ${UpdateIds} == TRUE ]
then
  plink --bfile ${OutputDir}/lifted_update_chr_bp \
  --update-name ${OutputDir}/lifted_cpos.txt 5 4 \
  --make-bed \
  --out ${OutputDir}/lifted_update_chr_bp_name
fi
