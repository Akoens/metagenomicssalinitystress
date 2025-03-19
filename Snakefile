"""
"""

configfile: "config/config.yaml"


# rule concat_data
# rule decompress_data
# rule kaiju
# rule kraken
# rule cleanup
# 



rule all:
    input:
        expand("outputs/kaiju/{sample}.out", sample=config["samples"])
    

rule run_kaiju:
    input:
        nodes =config["kaiju_index_nodes"]
        fmi = config["kaiju_index_fmi"]
        threads = config["threads"]


        expand("data/{sample}.fastq", sample=config["samples"])
    output:
        "outputs/kaiju/{sample}.out"
    shell:
        "kaiju-multi -z {threads} -t {input.nodes} -f {input.fmi} -i $(ls --format=commas) -o {output}"
    conda:
    
