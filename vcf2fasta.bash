# This tool will help to extract a multi-sample alignment from a vcf file
# This is for unphased genotypes
# for heterozygote snp an IUPAC Ambiguity Code is used
#An alignment file  for each chromosome or contigs and a snp coordinates file are produced.

#To use with a gziped vcf : 
# zcat fic.vcf.gz | vcf2fasta.bash 

#To extract only some chr/contigs : 
# bcftools view -t groupI,groupII,groupIII fic.vcf | vcf2fasta.bash 

#To extract only a subset of samples, it's better to use : 
# bcftools view -s sample1,sample2 fic.vcf | vcf2fasta.bash 

# one can also change these two variable to set a range of samples to extract
#first=10 #the column of the first sample
#last=0 #the column of the last sample to extract 0 = till the last one
awk -v first=$first -v last=$last  ' BEGIN{first=10 ;last=0; FS="\t"; OFS="\t"; snp=0;oldChr="-1"; IUB["AC"]= "M";IUB["AG"]= "R";	IUB["AT"]= "W";	IUB["CG"]= "S";	IUB["CT"]= "Y";	IUB["GT"]= "K";	IUB["ACG"]= "V";	IUB["ACT"]= "H";	IUB["AGT"]= "D";	IUB["CGT"]= "B";	IUB["ACGT"]= "N";}
      $1!~"##" {
      
      if (snp == 0)
      {
        if (last==0) last = NF  
        for (i=first; i <= last; i++) {ident[i]=$i;seqind[$i]=""}
      }
      else
      {
        
        chr = $1  
        print snp, $1, $2 > "snpscoord_chr"chr".txt"
        if (chr != oldChr) 
        {
          if (oldChr != "-1")  for (i in ident) { print ">"ident[i]"\n"seqind[ident[i]]"\n" > "test"oldChr".fasta"; seqind[ident[i]]=""; }  
          oldChr=chr
        } 
        REF=$4
        split($5,ALT,",");
        
        for (i=10; i <=NF; i++)
        {
          
          split($i,info,":" )  ;
          split(info[1],alleles,"/");
          
          for (j=1; j <=2; j++)
          {
            if (alleles[j] == "." ) geno[j] = "N"
            else
            { 
              if (alleles[j] == 0) geno[j] = REF
              else geno[j] = ALT[alleles[j]]
             }
          }
          if (geno[1] == geno[2]) site = geno[1]
          else
          {
            if (geno[1] > geno[2]) het = geno[2] geno[1]
            else het = geno[1] geno[2]
            site = IUB[het]
          }
          ind = ident[i]
          seqind[ind]=seqind[ind] site
          #print info[1], site
        }
      }  
      
      snp++;
      }
      END {for (i in seqind) print ">"i"\n" seqind[i] > "test"chr".fasta"}'
      
