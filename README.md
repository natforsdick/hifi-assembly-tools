# HiFi assembly tools

Scripts associated with genome assembly for kakī (black stilt; *Himantopus novaezelandiae*). Input data is PacBio HiFi, Hi-C, and Illumina HiSeq.

* [01-pacbio-processing](https://github.com/natforsdick/kaki-genome-assembly/tree/main/01-pacbio-processing) includes scripts that did not end up being used, but that could be used to convert raw PacBio data to HiFi, and other processes.

* [02-assembly](https://github.com/natforsdick/kaki-genome-assembly/tree/main/02-assembly) contains scripts used to produce draft assemblies from HiFi data.
These use the [hifiasm](https://github.com/chhylp123/hifiasm), [HiCanu](https://canu.readthedocs.io/en/latest/quick-start.html#assembling-pacbio-hifi-with-hicanu), [MaSuRCA](https://github.com/alekseyzimin/masurca), and [Flye](https://github.com/fenderglass/Flye) assemblers. We had most success with hifiasm and MaSuRCA.

* [03-purge-dups](https://github.com/natforsdick/kaki-genome-assembly/tree/main/03-purge-dups) implements the [purge_dups](https://github.com/dfguan/purge_dups) pipeline to remove haplotig and contig overlaps from the draft assembly prior to scaffolding. This pipeline is based on that implemented by Sarah Bailey (UoA) with modification.

* [04-scaffolding](https://github.com/natforsdick/kaki-genome-assembly/tree/main/04-scaffolding) uses the [ARIMA mapping pipeline](https://github.com/ArimaGenomics/mapping_pipeline) to prepare Hi-C data for use in scaffolding the purged assembly. The scaffolding is then implemented using [YAHS](https://github.com/c-zhou/yahs).

* [05-polishing](https://github.com/natforsdick/kaki-genome-assembly/tree/main/05-polishing) provides the option to polish the scaffolded assembly. This may not be necessary due to the use of high-quality PacBio HiFi data, but is yet to be determined. Meanwhile, manual curation of the draft assembly is in progress. 

* [QC](https://github.com/natforsdick/kaki-genome-assembly/tree/main/QC) provides scripts for assessing the quality of the draft assemblies, including through the use of short-read alignment, whole genome comparisons, and the [Merqury pipeline](https://github.com/marbl/merqury).  


