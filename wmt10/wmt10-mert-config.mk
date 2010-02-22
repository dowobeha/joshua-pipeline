
# Define file to translate during MERT
export MERT_FILE_TO_TRANSLATE=news-test2008-src.${SRC}

# Define file to use as reference during MERT
export MERT_REFERENCE_BASE=news-test2008-src.${TGT}

export MERT_METRIC_NAME=bleu

export MERT_NUM_REFERENCES=1
