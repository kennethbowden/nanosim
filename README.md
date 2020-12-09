# NanoSim

This utilizes a Dockerized version of NanoSim v3.0 to perform metagenomics data simulation

NanoSim Reference:
Chen Yang, Justin Chu, René L Warren, and Inanç Birol; NanoSim: nanopore sequence read simulator based on statistical characterization. GigaScience, Volume 6, Issue 4, April 2017, gix010, https://doi.org/10.1093/gigascience/gix010

# Read Analysis 

metagenome mode If you are interested in simulating ONT metagenome reads, you need to run the characterization stage in "metagenome" mode with following options. It takes a metagenome list with paths pointing to each genome and a training read set in FASTA or FASTQ format as input and aligns these reads to the reference using minimap2. User can also provide their own alignment file in SAM formats. If the SAM file is provided, make sure that is MD flag in the SAM file. The output of this is a bunch of profiles which you should use in simulation stage.

metagenome mode usage:

usage: read_analysis.py metagenome [-h] -i READ -gl GENOME_LIST [-ga G_ALNM]
                                   [-o OUTPUT] [-c] [-q] [--no_model_fit]
                                   [-t NUM_THREADS]

optional arguments:
  -h, --help            show this help message and exit
  -i READ, --read READ  Input read for training
  -gl GENOME_LIST, --genome_list GENOME_LIST
                        Reference metagenome list, tsv file, the first column
                        is species/strain name, the second column is the
                        reference genome fasta/fastq file directory, the third
                        column is optional, if provided, it contains the
                        expected abundance (sum up to 100)
  -ga G_ALNM, --g_alnm G_ALNM
                        Genome alignment file in sam format, the header of
                        each species should match the metagenome list provided
                        above (optional)
  -o OUTPUT, --output OUTPUT
                        The location and prefix of outputting profiles
                        (Default = training)
  -c, --chimeric        Detect chimeric and split reads (Default = False)
  -q, --quantification  Perform Salmon quantification and compute the
                        variation in abundance when compared to expected
                        values (Default = False)
  --no_model_fit        Disable model fitting step
  -t NUM_THREADS, --num_threads NUM_THREADS
                        Number of threads for alignment and model fitting
                        (Default = 1)

# Simulation

metagenome mode
If you are interested in simulating ONT metagenome reads, you need to run the simulation stage in "metagenome" mode with following options. We have provided sample config files for users to construct their own -gl, -a, and -dl config files correctly.

metagenome mode usage:

usage: simulator.py metagenome [-h] -gl GENOME_LIST -a ABUN -dl DNA_TYPE_LIST
                               [-c MODEL_PREFIX] [-o OUTPUT] [-max MAX_LEN]
                               [-min MIN_LEN] [-med MEDIAN_LEN] [-sd SD_LEN]
                               [--seed SEED] [-k KMERBIAS]
                               [-b {albacore,guppy,guppy-flipflop}]
                               [-s STRANDNESS] [--perfect]
                               [--abun_var ABUN_VAR [ABUN_VAR ...]] [--fastq]
                               [--chimeric] [-t NUM_THREADS]

optional arguments:
  -h, --help            show this help message and exit
  -gl GENOME_LIST, --genome_list GENOME_LIST
                        Reference metagenome list, tsv file, the first column
                        is species/strain name, the second column is the
                        reference genome fasta/fastq file directory
  -a ABUN, --abun ABUN  Abundance list, tsv file with header, the abundance of all species in
                        each sample need to sum up to 100. See example in README and provided
                        config files
  -dl DNA_TYPE_LIST, --dna_type_list DNA_TYPE_LIST
                        DNA type list, tsv file, the first column is
                        species/strain, the second column is the chromosome
                        name, the third column is the DNA type: circular OR
                        linear
  -c MODEL_PREFIX, --model_prefix MODEL_PREFIX
                        Location and prefix of error profiles generated from
                        characterization step (Default = training)
  -o OUTPUT, --output OUTPUT
                        Output location and prefix for simulated reads
                        (Default = simulated)
  -max MAX_LEN, --max_len MAX_LEN
                        The maximum length for simulated reads (Default =
                        Infinity)
  -min MIN_LEN, --min_len MIN_LEN
                        The minimum length for simulated reads (Default = 50)
  -med MEDIAN_LEN, --median_len MEDIAN_LEN
                        The median read length (Default = None), Note: this
                        simulationis not compatible with chimeric reads
                        simulation
  -sd SD_LEN, --sd_len SD_LEN
                        The standard deviation of read length in log scale
                        (Default = None), Note: this simulation is not
                        compatible with chimeric reads simulation
  --seed SEED           Manually seeds the pseudo-random number generator
  -k KMERBIAS, --KmerBias KMERBIAS
                        Minimum homopolymer length to simulate homopolymer
                        contraction andexpansion events in, a typical k is 6
  -b {albacore,guppy,guppy-flipflop}, --basecaller {albacore,guppy,guppy-flipflop}
                        Simulate homopolymers and/or base qualities with
                        respect to chosen basecaller: albacore, guppy, or
                        guppy-flipflop
  -s STRANDNESS, --strandness STRANDNESS
                        Percentage of antisense sequences. Overrides the value
                        profiled in characterization stage. Should be between
                        0 and 1
  --perfect             Ignore error profiles and simulate perfect reads
  --abun_var ABUN_VAR [ABUN_VAR ...]
                        Simulate random variation in abundance values, takes
                        in two values, format: relative_var_low,
                        relative_var_high, Example: -0.5 0.5)
  --fastq               Output fastq files instead of fasta files
  --chimeric            Simulate chimeric reads
  -t NUM_THREADS, --num_threads NUM_THREADS
                        Number of threads for simulation (Default = 1)
sample abundance file for metagenome_simulation

The abundance file is a tsv file, with rows representing the abundance of each sample and columns representing each sample. Each column (except for the first row) needs to sum up to 100, because the total abundance of each sample needs to be 100.

The first row is header row to specify the number of reads in each sample. The format of the first row is:
Size total_reads_in_sample1 total_reads_in_sample2 ...
The following rows are in the format as:
Species abundance_in_sample1 abundance_in_sample2 ...

Size	200000	100
Bacillus subtilis	12	0.89
Cryptococcus neoformans	2	0.00089
Enterococcus faecalis	12	0.00089
Escherichia coli	12	0.089
Lactobacillus fermentum	12	0.0089
Listeria monocytogenes	12	89.1
Pseudomonas aeruginosa	12	8.9
Saccharomyces cerevisiae	2	0.89
Salmonella enterica	12	0.089
Staphylococcus aureus	12	0.000089
In the above example, there are two samples. The first sample will contain 20,0000 reads, while the second sample will contain 100 reads. The abundances in sample 1 and 2 are as shown in th table, and both of them add up to 100.

* Notice: the use of max_len and min_len in genome mode will affect the read length distributions. If the range between max_len and min_len is too small, the program will run slowlier accordingly.

* Notice: the transcript name in the expression tsv file and the ones in th polyadenylated transcript list has to be consistent with the ones in the reference transcripts, otherwise the tool won't recognize them and don't know where to find them to extract reads for simulation.

* Notice: the species name in the genome list file, dna type file, and abundance file has to be consistent. The chromosome names in the dna type file has to match the ones in the reference genomes.
