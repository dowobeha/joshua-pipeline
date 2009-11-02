# Define the experiment-specific parameters:

##############################
### USER DEFINED VARIABLES ###
##############################

# Define the language codes for the source and target languages
SRC:=ur
TGT:=en

# Define what suffix the original training files will have
TRAINING.SRC.SUFFIX=$(SRC).tok.norm
TRAINING.TGT.SUFFIX=$(TGT).tok.norm

# Define the path to the original training files
ORIGINAL.SRC.PATH:=/home/hltcoe/lschwartz/GALE/experiments/2009-10_dry-run-URDU/data/training
ORIGINAL.TGT.PATH:=/home/hltcoe/lschwartz/GALE/experiments/2009-10_dry-run-URDU/data/training

# Define the suffix to add after stripping W
NO.W.SUFFIX:=noW

# Define the length ratio desired for subsampling
SUBSAMPLE.LENGTH.RATIO:=1.0

# Define the manifest file, required for subsampling
SUBSAMPLE.MANIFEST.FILE:=/home/hltcoe/lschwartz/GALE/experiments/2009-10_dry-run-URDU/manifest

# Define the test file
SUBSAMPLE.TEST.FILE:=/home/hltcoe/lschwartz/GALE/experiments/2009-10_dry-run-URDU/data/dev+devtest+nist09.tok.norm

# Define which files will be subsampled from
SUBSAMPLED.SRC.SUFFIX:=$(TRAINING.SRC.SUFFIX)
SUBSAMPLED.TGT.SUFFIX:=$(TRAINING.TGT.SUFFIX)

# Define the path to the Joshua directory
JOSHUA:=/home/hltcoe/lschwartz/GALE/experiments/2009-10_dry-run/joshua

# Define the path to the Berkeley aligner jar file
BERKELEY.ALIGNER:=/usr/local/berkeleyaligner/berkeleyaligner.jar

# Define the path to the local GALE scripts directory
SCRIPTS:=/home/hltcoe/lschwartz/GALE/scripts

# Define the working directory where results will live
WORKING:=/home/hltcoe/lschwartz/GALE/experiments/2009-10_dry-run-URDU/working



# Include the GALE pipeline makefile
include /home/hltcoe/lschwartz/GALE/scripts/GALE-pipeline.mk
