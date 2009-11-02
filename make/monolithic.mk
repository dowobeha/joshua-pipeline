# N=10; for i in `cd ~ccallison/GALE/P4/training/arfiles/atb/ && ls -1 *.ar.filtered`; do head -n $N ~ccallison/GALE/P4/training/arfiles/atb/$i > ./training/arfiles/atb/$i; done
# N=10; for i in `cd ~ccallison/GALE/P4/training/enfiles/tok/ && ls -1 *.en.filtered`; do head -n $N ~ccallison/GALE/P4/training/enfiles/tok/$i > ./training/enfiles/tok/$i; done


##############################
###    DERIVED VARIABLES   ###
##############################

# Gather a list of the original training file names, 
#    not including the paths to the files, and
#    not including the identifying suffix
TRAINING=$(patsubst $(ORIGINAL.SRC.PATH)/%.$(TRAINING.SRC.SUFFIX),%,$(wildcard $(ORIGINAL.SRC.PATH)/*.$(TRAINING.SRC.SUFFIX)))

# Gather a list of the original training file names, 
#    not including the paths to the files,
#    BUT including the identifying suffix
TRAINING.SRC:=$(foreach NAME,$(TRAINING),$(NAME).$(TRAINING.SRC.SUFFIX))
TRAINING.TGT:=$(foreach NAME,$(TRAINING),$(NAME).$(TRAINING.TGT.SUFFIX))

# Gather a list of the training file names in the working directory, 
#    including the paths to the files in the working directory, and
#    including the identifying suffix
TRAINING.SRC.PREPROCESSED:=$(foreach NAME,$(TRAINING.SRC),$(WORKING)/training/$(NAME))
TRAINING.TGT.PREPROCESSED:=$(foreach NAME,$(TRAINING.TGT),$(WORKING)/training/$(NAME))

# Gather a list of the training file names in the working directory,
#    with W removed, 
#    including the paths to the files in the working directory, and
#    including the identifying suffix
TRAINING.SRC.PREPROCESSED.NOW:=$(foreach NAME,$(TRAINING),$(WORKING)/training/$(NAME).$(NO.W.SUFFIX).$(TRAINING.SRC.SUFFIX))
TRAINING.TGT.PREPROCESSED.NOW:=$(foreach NAME,$(TRAINING),$(WORKING)/training/$(NAME).$(NO.W.SUFFIX).$(TRAINING.TGT.SUFFIX))

# Alignment file
SUBSAMPLED.ALIGNMENTS:=$(WORKING)/training/alignments/training.$(SUBSAMPLED.TGT.SUFFIX)-$(SUBSAMPLED.SRC.SUFFIX).align

SUBSAMPLED.BASE:=$(WORKING)/training/subsampled/subsampled

SUBSAMPLED.SRC:=$(SUBSAMPLED.BASE).$(SUBSAMPLED.SRC.SUFFIX)
SUBSAMPLED.TGT:=$(SUBSAMPLED.BASE).$(SUBSAMPLED.TGT.SUFFIX)
SUBSAMPLED.ALN:=$(SUBSAMPLED.BASE).aln

SUBSAMPLED.NOW.SRC:=$(SUBSAMPLED.BASE).$(NO.W.SUFFIX).$(SUBSAMPLED.SRC.SUFFIX)
SUBSAMPLED.NOW.TGT:=$(SUBSAMPLED.BASE).$(NO.W.SUFFIX).$(SUBSAMPLED.TGT.SUFFIX)

EMPTY.ALN.SUFFIX:=empty.aln
SUBSAMPLED.EMPTY.ALN:=$(SUBSAMPLED.BASE).$(EMPTY.ALN.SUFFIX)



##############################
###      MAKE TARGETS      ###
##############################

# Do everything
all: preprocess subsample align no-W

# Preprocess all source and target files
preprocess: $(TRAINING.SRC.PREPROCESSED) $(TRAINING.TGT.PREPROCESSED) $(WORKING)/training.preprocess.lines

# Define how to pre-process a source language training file
$(WORKING)/training/%.$(TRAINING.SRC.SUFFIX): $(ORIGINAL.SRC.PATH)/%.$(TRAINING.SRC.SUFFIX) | $(WORKING)/training $(SCRIPTS)/preprocess.pl
	$(SCRIPTS)/preprocess.pl $< $@

# Define how to pre-process a target language training file
$(WORKING)/training/%.$(TRAINING.TGT.SUFFIX): $(ORIGINAL.TGT.PATH)/%.$(TRAINING.TGT.SUFFIX) | $(WORKING)/training $(SCRIPTS)/preprocess.pl
	$(SCRIPTS)/preprocess.pl $< $@

# Verify that the preprocessed source and target language training files have equal number of lines
$(WORKING)/training.preprocess.lines: $(TRAINING.SRC.PREPROCESSED) $(TRAINING.TGT.PREPROCESSED)
	$(SCRIPTS)/compare-lengths.sh $(WORKING)/training .$(TRAINING.SRC.SUFFIX) .$(TRAINING.TGT.SUFFIX) > $@



# Perform subsampling
subsample: $(SUBSAMPLED.SRC) $(SUBSAMPLED.TGT) $(WORKING)/training.preprocess.subsampled.lines

# Define how to subsample
$(SUBSAMPLED.SRC) $(SUBSAMPLED.TGT) $(WORKING)/training.preprocess.subsampled.lines: $(SUBSAMPLE.TEST.FILE) $(SUBSAMPLE.MANIFEST.FILE) | $(WORKING)/training/subsampled
	@echo "Performing subsampling to make $@ using $(SUBSAMPLE.TEST.FILE) $(SUBSAMPLE.MANIFEST.FILE)"
	java -d64 -Dfile.encoding=utf8 -XX:MinHeapFreeRatio=10 -Xms4200M -Xmx4200M -cp $(JOSHUA)/bin:$(JOSHUA)/lib/commons-cli-2.0-SNAPSHOT.jar joshua.subsample.Subsampler -e $(TRAINING.TGT.SUFFIX) -f $(TRAINING.SRC.SUFFIX) -fpath $(WORKING)/training -epath $(WORKING)/training -output $(SUBSAMPLED.BASE) -ratio $(SUBSAMPLE.LENGTH.RATIO) -test $(SUBSAMPLE.TEST.FILE) -training $(SUBSAMPLE.MANIFEST.FILE)
	touch $(SUBSAMPLED.SRC)
	touch $(SUBSAMPLED.TGT)
	$(SCRIPTS)/compare-lengths.sh $(WORKING)/training/subsampled .$(TRAINING.SRC.SUFFIX) .$(TRAINING.TGT.SUFFIX) > $(WORKING)/training.preprocess.subsampled.lines



# Perform alignment
align: $(SUBSAMPLED.ALIGNMENTS)

# Define how to align
$(SUBSAMPLED.ALIGNMENTS): $(SUBSAMPLED.SRC) $(SUBSAMPLED.TGT) $(WORKING)/training/berkeley.aligner.config | $(WORKING)/training $(WORKING)/training/example/test
	@echo "Constructing $@"
	(cd $(WORKING)/training && java -d64 -Xmx10g -jar $(BERKELEY.ALIGNER) ++berkeley.aligner.config)


# Remove sentence-initial Arabic W-
no-W: $(SUBSAMPLED.NOW.SRC) $(SUBSAMPLED.NOW.TGT) $(SUBSAMPLED.ALN) $(WORKING)/training.preprocess.subsampled.noW.lines

$(SUBSAMPLED.ALN): $(SUBSAMPLED.ALIGNMENTS)
	cp $< $@

# Define how to remove W from a sentence-aligned parallel file
$(SUBSAMPLED.NOW.SRC): $(SUBSAMPLED.SRC) $(SUBSAMPLED.TGT) $(SUBSAMPLED.ALN)
	$(SCRIPTS)/reprocess_remove-W.pl --ar .$(TRAINING.SRC.SUFFIX) --en .$(TRAINING.TGT.SUFFIX) --align .aln --pp .$(NO.W.SUFFIX) $(SUBSAMPLED.BASE)

# Verify that the preprocessed source and target language training files have equal number of lines
$(WORKING)/training.preprocess.subsampled.noW.lines: $(SUBSAMPLED.NOW.SRC) $(SUBSAMPLED.NOW.TGT)
	$(SCRIPTS)/compare-lengths.sh $(WORKING)/training/subsampled .$(NO.W.SUFFIX).$(TRAINING.SRC.SUFFIX) .$(NO.W.SUFFIX).$(TRAINING.TGT.SUFFIX) > $@


filter-long: $(WORKING)/training/under100/short.$(SRC) $(WORKING)/training/under100/short.$(TGT) $(WORKING)/training/under100/short.aln

$(WORKING)/training/under100/long.source.lines: $(SUBSAMPLED.NOW.SRC) | $(WORKING)/training/under100
	cat $< | ruby -e "n=0; STDIN.each_line{|line| n+=1; size=line.split.size; puts n if size>=100}" > $@

$(WORKING)/training/under100/long.target.lines: $(SUBSAMPLED.NOW.TGT) | $(WORKING)/training/under100
	cat $< | ruby -e "n=0; STDIN.each_line{|line| n+=1; size=line.split.size; puts n if size>=100}" > $@

$(WORKING)/training/under100/long.lines: $(WORKING)/training/under100/long.source.lines $(WORKING)/training/under100/long.target.lines | $(WORKING)/training/under100
	cat $(WORKING)/training/under100/long.source.lines $(WORKING)/training/under100/long.target.lines | sort -n -u > $@

$(WORKING)/training/under100/short.$(SRC): $(WORKING)/training/under100/long.lines $(SUBSAMPLED.NOW.SRC) | $(WORKING)/training/under100
	cat $(SUBSAMPLED.NOW.SRC) | ruby -e "require 'set'; s=Set.new; File.open(ARGV[0]){|f| f.each_line{|l| s.add(l.to_i)}};  n=0; STDIN.each_line{|line| n+=1; puts line unless s.include?(n)}" $(WORKING)/training/under100/long.lines > $@

$(WORKING)/training/under100/short.$(TGT): $(WORKING)/training/under100/long.lines $(SUBSAMPLED.NOW.TGT) | $(WORKING)/training/under100
	cat $(SUBSAMPLED.NOW.TGT) | ruby -e "require 'set'; s=Set.new; File.open(ARGV[0]){|f| f.each_line{|l| s.add(l.to_i)}};  n=0; STDIN.each_line{|line| n+=1; puts line unless s.include?(n)}" $(WORKING)/training/under100/long.lines > $@

$(WORKING)/training/under100/short.aln: $(WORKING)/training/under100/long.lines $(SUBSAMPLED.ALN) | $(WORKING)/training/under100
	cat $(SUBSAMPLED.ALN) | ruby -e "require 'set'; s=Set.new; File.open(ARGV[0]){|f| f.each_line{|l| s.add(l.to_i)}};  n=0; STDIN.each_line{|line| n+=1; puts line unless s.include?(n)}" $(WORKING)/t\
raining/under100/long.lines > $@


compile-josh: 



##############################
### CONSTRUCT DIRECTORIES  ###
##############################

$(WORKING):
	mkdir -p $@

$(WORKING)/training: | $(WORKING)
	mkdir -p $@

$(WORKING)/training/subsampled: | $(WORKING)
	mkdir -p $@

$(WORKING)/training/under100: | $(WORKING)
	mkdir -p $@

$(WORKING)/training/example/test: | $(WORKING)/training
	mkdir -p $@


##############################
###       CLEAN UP         ###
##############################

# Remove all work
cleanest:
	rm -rf $(WORKING)

# Unlike most make target,
#    the following targets 
#    do NOT create files with that name
.PHONY: align all cleanest now preprocess subsample training.lines


##############################
### CREATE BERKELEY CONFIG ###
##############################

$(WORKING)/training/berkeley.aligner.config: | $(WORKING)
	@echo "## In this configuration the Berkeley aligner uses two HMM" > $@
	@echo "## alignment models trained jointly and then decoded" >> $@
	@echo "## using the competitive thresholding heuristic." >> $@
	@echo "" >> $@
	@echo "##########################################" >> $@
	@echo "# Training: Defines the training regimen" >> $@
	@echo "##########################################" >> $@
	@echo "" >> $@
	@echo "forwardModels	MODEL1 HMM" >> $@
	@echo "reverseModels	MODEL1 HMM" >> $@
	@echo "mode	JOINT JOINT" >> $@
	@echo "iters	5 5" >> $@
	@echo "" >> $@
	@echo "###############################################" >> $@
	@echo "# Execution: Controls output and program flow" >> $@
	@echo "###############################################" >> $@
	@echo "" >> $@
	@echo "execDir	alignments" >> $@
	@echo "create" >> $@
	@echo "saveParams	true" >> $@
	@echo "numThreads	1" >> $@
	@echo "msPerLine	10000" >> $@
	@echo "alignTraining" >> $@
	@echo "" >> $@
	@echo "#################" >> $@
	@echo "# Language/Data" >> $@
	@echo "#################" >> $@
	@echo "" >> $@
	@echo "foreignSuffix	$(TRAINING.SRC.SUFFIX)" >> $@
	@echo "englishSuffix	$(TRAINING.TGT.SUFFIX)" >> $@
	@echo "" >> $@
	@echo "# Choose the training sources, which can either be directories or files that list files/directories" >> $@
	@echo "trainSources	subsampled/" >> $@
	@echo "sentences	MAX" >> $@
	@echo "" >> $@
	@echo "#################" >> $@
	@echo "# 1-best output" >> $@
	@echo "#################" >> $@
	@echo "" >> $@
	@echo "competitiveThresholding" >> $@
