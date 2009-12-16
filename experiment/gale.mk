#################################################################################
####                                                                         ####
####                  Experiment-specific variables                          ####
####                                                                         ####
#################################################################################

# Calculate the directory where this make file is stored
PATH.TO.THIS.MAKEFILE ?= $(realpath $(dir $(lastword ${MAKEFILE_LIST})))

# Define where experimental results should be stored
#
# The following line says to use the dir where this make file is located:
export EXPERIMENT_DIR:=${PATH.TO.THIS.MAKEFILE}

# Define where the Berkeley aligner jar files should go
export BERKELEY_ALIGNER_JAR:=${EXPERIMENT_DIR}/berkeleyaligner/berkeleyaligner.jar

# Define number of threads to be used during Berkeley alignment
export BERKELEY_NUM_THREADS:=20

# Define location of GALE tgz files from IBM
ORIGINAL_GALE_FILES:=/mnt/data/gale/OriginalFiles

# Define where other make files are stored
MAKE_DIR:=/home/lane/pipeline/stages

# Export this variable to make it visible to the make files called below.
export SCRIPTS_DIR:=/home/lane/pipeline/scripts


# Define Joshua pruning parameters
export MAX_N_ITEMS:=30

# Define MERT metric
export METRIC:=TER-BLEU nocase punc 20 50 ${EXPERIMENT_DIR}/tercom.7.25.jar 6 4 closest

# Define path to Joshua
export JOSHUA:=${EXPERIMENT_DIR}/joshua

# Define JVM flags for Joshua decoder
export JOSHUA_MEMORY_FLAGS:=-XX:MinHeapFreeRatio=10 -Xms50g -Xmx100g
export JOSHUA_THREADS:=20

# Define JVM flags for Joshua MBR
export MBR_MEMORY_FLAGS:=-XX:MinHeapFreeRatio=10 -Xms2g -Xmx2g
export MBR_THREADS:=20

# Define JVM flags for Joshua MERT
export MERT_JVM_FLAGS:=-Xms3g -Xmx3g

# Define the language model
export LM_FILE:=${EXPERIMENT_DIR}/lm/giga_v4+p4.kn5.gz
export LM_ORDER:=5

# Define where Hiero is installed
export HIERO_DIR:=/home/zli/work/hiero/copy_2008/sa_copy/sa-hiero_adapted

# Define the original training tgz archive
export ARCHIVE_FILE=Rosetta-P4-ae-training-data-FOUO-v1.0.tgz 

# Define the files to extract from the original tgz archive 
export FILES_TO_EXTRACT=arfiles/atb/*.filtered* enfiles/tok/*.filtered*

# Define the order of subsampling
export MANIFEST=xin ummah06.split-05 ummah06.split-04 ummah06.split-03 ummah06.split-02 ummah06.split-01 ummah06.split-00 Sakhr.EA.split-32 Sakhr.EA.split-31 Sakhr.EA.split-30 Sakhr.EA.split-29 Sakhr.EA.split-28 Sakhr.EA.split-27 Sakhr.EA.split-26 Sakhr.EA.split-25 Sakhr.EA.split-24 Sakhr.EA.split-23 Sakhr.EA.split-22 Sakhr.EA.split-21 Sakhr.EA.split-20 Sakhr.EA.split-19 Sakhr.EA.split-18 Sakhr.EA.split-17 Sakhr.EA.split-16 Sakhr.EA.split-15 Sakhr.EA.split-14 Sakhr.EA.split-13 Sakhr.EA.split-12 Sakhr.EA.split-11 Sakhr.EA.split-10 Sakhr.EA.split-09 Sakhr.EA.split-08 Sakhr.EA.split-07 Sakhr.EA.split-06 Sakhr.EA.split-05 Sakhr.EA.split-04 Sakhr.EA.split-03 Sakhr.EA.split-02 Sakhr.EA.split-01 Sakhr.EA.split-00 Sakhr.AE.split-57 Sakhr.AE.split-56 Sakhr.AE.split-55 Sakhr.AE.split-54 Sakhr.AE.split-53 Sakhr.AE.split-52 Sakhr.AE.split-51 Sakhr.AE.split-50 Sakhr.AE.split-49 Sakhr.AE.split-48 Sakhr.AE.split-47 Sakhr.AE.split-46 Sakhr.AE.split-45 Sakhr.AE.split-44 Sakhr.AE.split-43 Sakhr.AE.split-42 Sakhr.AE.split-41 Sakhr.AE.split-40 Sakhr.AE.split-39 Sakhr.AE.split-38 Sakhr.AE.split-37 Sakhr.AE.split-36 Sakhr.AE.split-35 Sakhr.AE.split-34 Sakhr.AE.split-33 Sakhr.AE.split-32 Sakhr.AE.split-31 Sakhr.AE.split-30 Sakhr.AE.split-29 Sakhr.AE.split-28 Sakhr.AE.split-27 Sakhr.AE.split-26 Sakhr.AE.split-25 Sakhr.AE.split-24 Sakhr.AE.split-23 Sakhr.AE.split-22 Sakhr.AE.split-21 Sakhr.AE.split-20 Sakhr.AE.split-19 Sakhr.AE.split-18 Sakhr.AE.split-17 Sakhr.AE.split-16 Sakhr.AE.split-15 Sakhr.AE.split-14 Sakhr.AE.split-13 Sakhr.AE.split-12 Sakhr.AE.split-11 Sakhr.AE.split-10 Sakhr.AE.split-09 Sakhr.AE.split-08 Sakhr.AE.split-07 Sakhr.AE.split-06 Sakhr.AE.split-05 Sakhr.AE.split-04 Sakhr.AE.split-03 Sakhr.AE.split-02 Sakhr.AE.split-01 Sakhr.AE.split-00 LDC2008G05.nw LDC2008E40-v2.bn LDC2008E40-v2.bc LDC2007E86-v2.bn LDC2007E86.nw LDC2007E86.ng LDC2007E46.wl LDC2007E46.nw LDC2007E46.ng LDC2007E103.nw.split-29 LDC2007E103.nw.split-28 LDC2007E103.nw.split-27 LDC2007E103.nw.split-26 LDC2007E103.nw.split-25 LDC2007E103.nw.split-24 LDC2007E103.nw.split-23 LDC2007E103.nw.split-22 LDC2007E103.nw.split-21 LDC2007E103.nw.split-20 LDC2007E103.nw.split-19 LDC2007E103.nw.split-18 LDC2007E103.nw.split-17 LDC2007E103.nw.split-16 LDC2007E103.nw.split-15 LDC2007E103.nw.split-14 LDC2007E103.nw.split-13 LDC2007E103.nw.split-12 LDC2007E103.nw.split-11 LDC2007E103.nw.split-10 LDC2007E103.nw.split-09 LDC2007E103.nw.split-08 LDC2007E103.nw.split-07 LDC2007E103.nw.split-06 LDC2007E103.nw.split-05 LDC2007E103.nw.split-04 LDC2007E103.nw.split-03 LDC2007E103.nw.split-02 LDC2007E103.nw.split-01 LDC2007E103.nw.split-00 LDC2007E101-v2.bn LDC2007E101-v2.bc LDC2007E101.nw LDC2007E06-v2.bc LDC2006E92.ng LDC2006E85.doc.ng LDC2006E34.wl LDC2006E34-v2.bc LDC2006E24.ng LDC2005E83-Test.wl LDC2005E83-BCAD05-v2.bc FOUO.LDC2006G05.GALE-Y1Q2-FBIS.split-01 FOUO.LDC2006G05.GALE-Y1Q2-FBIS.split-00 eTIRR asb ann.split-01 ann.split-00 afp LDC2007E07.ISI.split-56 LDC2007E07.ISI.split-55 LDC2007E07.ISI.split-54 LDC2007E07.ISI.split-53 LDC2007E07.ISI.split-52 LDC2007E07.ISI.split-51 LDC2007E07.ISI.split-50 LDC2007E07.ISI.split-49 LDC2007E07.ISI.split-48 LDC2007E07.ISI.split-47 LDC2007E07.ISI.split-46 LDC2007E07.ISI.split-45 LDC2007E07.ISI.split-44 LDC2007E07.ISI.split-43 LDC2007E07.ISI.split-42 LDC2007E07.ISI.split-41 LDC2007E07.ISI.split-40 LDC2007E07.ISI.split-39 LDC2007E07.ISI.split-38 LDC2007E07.ISI.split-37 LDC2007E07.ISI.split-36 LDC2007E07.ISI.split-35 LDC2007E07.ISI.split-34 LDC2007E07.ISI.split-33 LDC2007E07.ISI.split-32 LDC2007E07.ISI.split-31 LDC2007E07.ISI.split-30 LDC2007E07.ISI.split-29 LDC2007E07.ISI.split-28 LDC2007E07.ISI.split-27 LDC2007E07.ISI.split-26 LDC2007E07.ISI.split-25 LDC2007E07.ISI.split-24 LDC2007E07.ISI.split-23 LDC2007E07.ISI.split-22 LDC2007E07.ISI.split-21 LDC2007E07.ISI.split-20 LDC2007E07.ISI.split-19 LDC2007E07.ISI.split-18 LDC2007E07.ISI.split-17 LDC2007E07.ISI.split-16 LDC2007E07.ISI.split-15 LDC2007E07.ISI.split-14 LDC2007E07.ISI.split-13 LDC2007E07.ISI.split-12 LDC2007E07.ISI.split-11 LDC2007E07.ISI.split-10 LDC2007E07.ISI.split-09 LDC2007E07.ISI.split-08 LDC2007E07.ISI.split-07 LDC2007E07.ISI.split-06 LDC2007E07.ISI.split-05 LDC2007E07.ISI.split-04 LDC2007E07.ISI.split-03 LDC2007E07.ISI.split-02 LDC2007E07.ISI.split-01 LDC2007E07.ISI.split-00 UN_EA_2002.split-16 UN_EA_2002.split-15 UN_EA_2002.split-14 UN_EA_2002.split-13 UN_EA_2002.split-12 UN_EA_2002.split-11 UN_EA_2002.split-10 UN_EA_2002.split-09 UN_EA_2002.split-08 UN_EA_2002.split-07 UN_EA_2002.split-06 UN_EA_2002.split-05 UN_EA_2002.split-04 UN_EA_2002.split-03 UN_EA_2002.split-02 UN_EA_2002.split-01 UN_EA_2002.split-00 UN_EA_2001.split-27 UN_EA_2001.split-26 UN_EA_2001.split-25 UN_EA_2001.split-24 UN_EA_2001.split-23 UN_EA_2001.split-22 UN_EA_2001.split-21 UN_EA_2001.split-20 UN_EA_2001.split-19 UN_EA_2001.split-18 UN_EA_2001.split-17 UN_EA_2001.split-16 UN_EA_2001.split-15 UN_EA_2001.split-14 UN_EA_2001.split-13 UN_EA_2001.split-12 UN_EA_2001.split-11 UN_EA_2001.split-10 UN_EA_2001.split-09 UN_EA_2001.split-08 UN_EA_2001.split-07 UN_EA_2001.split-06 UN_EA_2001.split-05 UN_EA_2001.split-04 UN_EA_2001.split-03 UN_EA_2001.split-02 UN_EA_2001.split-01 UN_EA_2001.split-00 UN_EA_2000.split-23 UN_EA_2000.split-22 UN_EA_2000.split-21 UN_EA_2000.split-20 UN_EA_2000.split-19 UN_EA_2000.split-18 UN_EA_2000.split-17 UN_EA_2000.split-16 UN_EA_2000.split-15 UN_EA_2000.split-14 UN_EA_2000.split-13 UN_EA_2000.split-12 UN_EA_2000.split-11 UN_EA_2000.split-10 UN_EA_2000.split-09 UN_EA_2000.split-08 UN_EA_2000.split-07 UN_EA_2000.split-06 UN_EA_2000.split-05 UN_EA_2000.split-04 UN_EA_2000.split-03 UN_EA_2000.split-02 UN_EA_2000.split-01 UN_EA_2000.split-00 UN_EA_1999.split-23 UN_EA_1999.split-22 UN_EA_1999.split-21 UN_EA_1999.split-20 UN_EA_1999.split-19 UN_EA_1999.split-18 UN_EA_1999.split-17 UN_EA_1999.split-16 UN_EA_1999.split-15 UN_EA_1999.split-14 UN_EA_1999.split-13 UN_EA_1999.split-12 UN_EA_1999.split-11 UN_EA_1999.split-10 UN_EA_1999.split-09 UN_EA_1999.split-08 UN_EA_1999.split-07 UN_EA_1999.split-06 UN_EA_1999.split-05 UN_EA_1999.split-04 UN_EA_1999.split-03 UN_EA_1999.split-02 UN_EA_1999.split-01 UN_EA_1999.split-00 UN_EA_1998.split-25 UN_EA_1998.split-24 UN_EA_1998.split-23 UN_EA_1998.split-22 UN_EA_1998.split-21 UN_EA_1998.split-20 UN_EA_1998.split-19 UN_EA_1998.split-18 UN_EA_1998.split-17 UN_EA_1998.split-16 UN_EA_1998.split-15 UN_EA_1998.split-14 UN_EA_1998.split-13 UN_EA_1998.split-12 UN_EA_1998.split-11 UN_EA_1998.split-10 UN_EA_1998.split-09 UN_EA_1998.split-08 UN_EA_1998.split-07 UN_EA_1998.split-06 UN_EA_1998.split-05 UN_EA_1998.split-04 UN_EA_1998.split-03 UN_EA_1998.split-02 UN_EA_1998.split-01 UN_EA_1998.split-00 UN_EA_1997.split-23 UN_EA_1997.split-22 UN_EA_1997.split-21 UN_EA_1997.split-20 UN_EA_1997.split-19 UN_EA_1997.split-18 UN_EA_1997.split-17 UN_EA_1997.split-16 UN_EA_1997.split-15 UN_EA_1997.split-14 UN_EA_1997.split-13 UN_EA_1997.split-12 UN_EA_1997.split-11 UN_EA_1997.split-10 UN_EA_1997.split-09 UN_EA_1997.split-08 UN_EA_1997.split-07 UN_EA_1997.split-06 UN_EA_1997.split-05 UN_EA_1997.split-04 UN_EA_1997.split-03 UN_EA_1997.split-02 UN_EA_1997.split-01 UN_EA_1997.split-00 UN_EA_1996.split-15 UN_EA_1996.split-14 UN_EA_1996.split-13 UN_EA_1996.split-12 UN_EA_1996.split-11 UN_EA_1996.split-10 UN_EA_1996.split-09 UN_EA_1996.split-08 UN_EA_1996.split-07 UN_EA_1996.split-06 UN_EA_1996.split-05 UN_EA_1996.split-04 UN_EA_1996.split-03 UN_EA_1996.split-02 UN_EA_1996.split-01 UN_EA_1996.split-00 UN_EA_1995.split-12 UN_EA_1995.split-11 UN_EA_1995.split-10 UN_EA_1995.split-09 UN_EA_1995.split-08 UN_EA_1995.split-07 UN_EA_1995.split-06 UN_EA_1995.split-05 UN_EA_1995.split-04 UN_EA_1995.split-03 UN_EA_1995.split-02 UN_EA_1995.split-01 UN_EA_1995.split-00 UN_EA_1994.split-17 UN_EA_1994.split-16 UN_EA_1994.split-15 UN_EA_1994.split-14 UN_EA_1994.split-13 UN_EA_1994.split-12 UN_EA_1994.split-11 UN_EA_1994.split-10 UN_EA_1994.split-09 UN_EA_1994.split-08 UN_EA_1994.split-07 UN_EA_1994.split-06 UN_EA_1994.split-05 UN_EA_1994.split-04 UN_EA_1994.split-03 UN_EA_1994.split-02 UN_EA_1994.split-01 UN_EA_1994.split-00 UN_EA_1993.split-04 UN_EA_1993.split-03 UN_EA_1993.split-02 UN_EA_1993.split-01 UN_EA_1993.split-00

include ${PATH.TO.THIS.MAKEFILE}/Makefile