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


configfile: "config.yaml"

rule all:
    input:
        get_kaiju_inputs


rule decompress:
    input:
        "{seq_dir}{sample_group}{sample}.fastq.gz"
    output:
        "outputs/kaiju/{seq_dir}{sample_group}{sample}.fastq"
    shell:
        "gzip -c {sample} > outputs/kaiju/decompressed_samples/{seq-dir}{sample_group}{sample}.fastq"
    

rule run_kaiju:
    input:
        "outputs/kaiju/decompressed_samples/{seq_dir}{sample_group}{sample}.fastq"
    output:
        "outputs/kaiju/{seq_dir}{sample_group}{sample}.out"
    shell:
        "kaiju -t {config[kaiju_index_nodes]} -f {config[kaiju_index_fmi]} -i {input} -o {output}"
