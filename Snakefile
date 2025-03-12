# STEPS:
# Get all fastq files in directory
# push fastq through kaiju-multi? 


configfile: "config.yaml"

rule all:
    input:
        expand("test.{sample_dir}.txt", sample_dir=config["sample_dirs"])


rule kraken:
# One rule to handle all the samples in a singel directory.
# Another rule will need to be added that can then handle multiple directories
# Lastly a function that can scan a directory for fastq files that can be passed to the super > kaiju rules.
    input:
        expand()

    output:
        # would the output be per sample or per directory?
    shell:
        "kaiju -t {Kaiju_nodes} -f {kaiju_fmi} -i {sample_file}"


rule list_samples:
    shell:
        "for dir in {config[sample_dirs]}ls {data_dir}{sample_dir}"