# ngsFormatTools

## vcf2fasta.bash
This tool will help to extract a multi-sample alignment from a vcf file.
This is for unphased genotypes.
For heterozygote snp an IUPAC Ambiguity Code is used.
 
An alignment file  for each chromosome or contigs and a snp coordinates file are produced.

To use with a gziped vcf : 
 ```zcat fic.vcf.gz | vcf2fasta.bash``` 

To extract only some chr/contigs : 
```bcftools view -t groupI,groupII,groupIII fic.vcf | vcf2fasta.bash ```

To extract only a subset of samples, it's better to use : 
``` bcftools view -s sample1,sample2 fic.vcf | vcf2fasta.bash ```
