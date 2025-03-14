"""
"""

import os
import glob



def find_fastq_files(sample_dirs):
    fastq_files = []
    for sample_dir in sample_dirs:
        files = glob.glob(os.path.join(sample_dir, "*.fastq.gz"))
        fastq_files.extend(files)
    return fastq_files


def get_kaiju_inputs(wildcards):
    sample_dirs = expand("{seq_dir}{sample_group}", seq_dir=config["seq_dirs"], sample_group=config["sample_groups"]) 
    return find_fastq_files(sample_dirs)


configfile: "config/config.yaml"


# rule concat_data
# rule decompress_data
# rule kaiju
# rule kraken
# rule cleanup
# 



rule all:
    input:
        get_kaiju_inputs

    

rule run_kaiju:
    input:
        "outputs/kaiju/decompressed_samples/{seq_dir}{sample_group}{sample}.fastq"
    output:
        "outputs/kaiju/{seq_dir}{sample_group}{sample}.out"
    shell:
        "kaiju-multi -t {config[kaiju_index_nodes]} -f {config[kaiju_index_fmi]} -i $(ls --format=commas) -o {output}"
