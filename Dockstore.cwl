#!/usr/bin/env cwl-runner

class: CommandLineTool
id: Seqware-Sanger-Somatic-Workflow
label: Seqware-Sanger-Somatic-Workflow
dct:creator:
  '@id': http://sanger.ac.uk/...
  foaf:name: Keiran Raine
  foaf:mbox: mailto:keiranmraine@gmail.com
dct:contributor:
  foaf:name: Brian O'Connor
  foaf:mbox: mailto:broconno@ucsc.edu

dct:contributor:
  foaf:name: Denis Yuen
  foaf:mbox: mailto:denis.yuen@oicr.on.ca

requirements:
- class: DockerRequirement
  dockerPull: quay.io/pancancer/pcawg-sanger-cgp-workflow:2.1.0

cwlVersion: v1.0

inputs:
  tumor:
    type: File
    inputBinding:
      position: 1
      prefix: --tumor
    secondaryFiles:
    - .bai
  refFrom:
    type: File
    inputBinding:
      position: 3
      prefix: --refFrom
  bbFrom:
    type: File
    inputBinding:
      position: 4
      prefix: --bbFrom
  normal:
    type: File
    inputBinding:
      position: 2
      prefix: --normal
    secondaryFiles:
    - .bai
  coreNum:
    type: int?
    inputBinding:
      position: 5
      prefix: --coreNum
  memGB:
    type: int?
    inputBinding:
      position: 6
      prefix: --memGB
  run-id:
    type: string?
    inputBinding:
      position: 7
      prefix: --run-id

outputs:
  somatic_cnv_vcf_gz:
    type: File
    outputBinding:
      glob: '*.somatic.cnv.vcf.gz'
    secondaryFiles:
    - .md5
    - .tbi
    - .tbi.md5
  somatic_cnv_tar_gz:
    type: File
    outputBinding:
      glob: '*.somatic.cnv.tar.gz'
    secondaryFiles:
    - .md5
  somatic_indel_vcf_gz:
    type: File
    outputBinding:
      glob: '*.somatic.indel.vcf.gz'
    secondaryFiles:
    - .md5
    - .tbi
    - .tbi.md5
  somatic_indel_tar_gz:
    type: File
    outputBinding:
      glob: '*.somatic.indel.tar.gz'
    secondaryFiles:
    - .md5
  somatic_sv_vcf_gz:
    type: File
    outputBinding:
      glob: '*.somatic.sv.vcf.gz'
    secondaryFiles:
    - .md5
    - .tbi
    - .tbi.md5
  somatic_sv_tar_gz:
    type: File
    outputBinding:
      glob: '*.somatic.sv.tar.gz'
    secondaryFiles:
    - .md5
  somatic_snv_mnv_vcf_gz:
    type: File
    outputBinding:
      glob: '*.somatic.snv_mnv.vcf.gz'
    secondaryFiles:
    - .md5
    - .tbi
    - .tbi.md5
  somatic_snv_mnv_tar_gz:
    type: File
    outputBinding:
      glob: '*.somatic.snv_mnv.tar.gz'
    secondaryFiles:
    - .md5
  somatic_genotype_tar_gz:
    type: File
    outputBinding:
      glob: '*.somatic.genotype.tar.gz'
    secondaryFiles:
    - .md5
  somatic_imputeCounts_tar_gz:
    type: File
    outputBinding:
      glob: '*.somatic.imputeCounts.tar.gz'
    secondaryFiles:
    - .md5
  somatic_verifyBamId_tar_gz:
    type: File
    outputBinding:
      glob: '*.somatic.verifyBamId.tar.gz'
    secondaryFiles:
    - .md5
  bas_tar_gz:
    type: File
    outputBinding:
      glob: '*.bas.tar.gz'
    secondaryFiles:
    - .md5
  qc_metrics:
    type: File
    outputBinding:
      glob: '*.qc_metrics.tar.gz'
    secondaryFiles:
    - .md5
  timing_metrics:
    type: File
    outputBinding:
      glob: '*.timing_metrics.tar.gz'
    secondaryFiles:
    - .md5


baseCommand: [/start.sh, python, /home/seqware/CGP-Somatic-Docker/scripts/run_seqware_workflow.py]
doc: |
    PCAWG Sanger variant calling workflow is developed by Wellcome Trust Sanger Institute
    (http://www.sanger.ac.uk/), it consists of software components calling somatic substitutions,
    indels and structural variants using uniformly aligned tumour / normal WGS sequences.
    The workflow has been dockerized and packaged using CWL workflow language, the source code
    is available on GitHub at: https://github.com/ICGC-TCGA-PanCancer/CGP-Somatic-Docker.

    ## Run the workflow with your own data

    ### Prepare compute environment and install software packages
    The workflow has been tested in Ubuntu 16.04 Linux environment with the following hardware and software settings.

    #### Hardware requirement (assuming X30 coverage whole genome sequence)
    - CPU core: 16
    - Memory: 64GB
    - Disk space: 1TB

    #### Software installation
    - Docker (1.12.6): follow instructions to install Docker https://docs.docker.com/engine/installation
    - CWL tool
    ```
    pip install cwltool==1.0.20180116213856
    ```

    ### Prepare input data
    #### Input aligned tumor / normal BAM files

    The workflow uses a pair of aligned BAM files as input, one BAM for tumor, the other for normal,
    both from the same donor. Here we assume file names are *tumor_sample.bam* and *normal_sample.bam*,
    and both files are under *bams* subfolder.

    #### Reference data files

    The workflow also uses two precompiled reference files (*GRCh37d5_CGP_refBundle.tar.gz*,
    *GRCh37d5_battenberg.tar.gz*) as input, they can be downloaded from the
    ICGC Data Portal under https://dcc.icgc.org/releases/PCAWG/reference_data/pcawg-sanger.
    We assume the two reference files are downloaded and put under *reference* subfolder.

    #### Job JSON file for CWL

    Finally, we need to prepare a JSON file with input, reference and output files specified. Please replace
    the *tumor* and *normal* parameters with your real BAM file names. Parameters for output are file name
    suffixes, usually don't need to be changed.

    Name the JSON file: *pcawg-sanger-variant-caller.job.json*
    ```
    {
      "tumor":
      {
        "path":"bams/tumor_sample.bam",
        "class":"File"
      },
      "normal":
      {
        "path":"bams/normal_sample.bam",
        "class":"File"
      },
      "refFrom":
      {
        "path":"reference/GRCh37d5_CGP_refBundle.tar.gz",
        "class":"File"
      },
      "bbFrom":
      {
        "path":"reference/GRCh37d5_battenberg.tar.gz",
        "class":"File"
      },
      "somatic_snv_mnv_tar_gz":
      {
        "path":"somatic_snv_mnv_tar_gz",
        "class":"File"
      },
      "somatic_cnv_tar_gz":
      {
        "path":"somatic_cnv_tar_gz",
        "class":"File"
      },
      "somatic_sv_tar_gz":
      {
        "path":"somatic_sv_tar_gz",
        "class":"File"
      },
      "somatic_indel_tar_gz":
      {
        "path":"somatic_indel_tar_gz",
        "class":"File"
      },
      "somatic_imputeCounts_tar_gz":
      {
        "path":"somatic_imputeCounts_tar_gz",
        "class":"File"
      },
      "somatic_genotype_tar_gz":
      {
        "path":"somatic_genotype_tar_gz",
        "class":"File"
      },
      "somatic_verifyBamId_tar_gz":
      {
        "path":"somatic_verifyBamId_tar_gz",
        "class":"File"
      }
    }
    ```

    ### Run the workflow
    #### Option 1: Run with CWL tool
    - Download CWL workflow definition file
    ```
    wget -O pcawg-sanger-variant-caller.cwl "https://raw.githubusercontent.com/ICGC-TCGA-PanCancer/CGP-Somatic-Docker/2.0.3/Dockstore.cwl"
    ```

    - Run `cwltool` to execute the workflow
    ```
    nohup cwltool --debug --non-strict pcawg-sanger-variant-caller.cwl pcawg-sanger-variant-caller.job.json > pcawg-sanger-variant-caller.log 2>&1 &
    ```

    #### Option 2: Run with the Dockstore CLI
    See the *Launch with* section below for details.
