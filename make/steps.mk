###############################################################################
##                                                                           ##
##                         GALE MT PIPELINE                                  ##
##                                                                           ##
###############################################################################

# Steps to run pipeline:
#
#    A1- Preprocess training source data
#    A2- Preprocess training target data
#    A3- Remove W- from training source data (depends on A1)
#
#    B4- Preprocess each test source data file
#    B6- Remove W- from each training source data file (depends on B4)
#
#    C7- Preprocess each tuning source data file
#    C8- Preprocess each tuning target data file
#    C9- Remove W- from each tuning source data file (depends on C7)
#
#    D1- Preprocess devtest source data
#    D2- Preprocess devtest target data
#    D3- Remove W- from devtest source data (depends on D1)
#
#    E4- Merge tuning, devtest, and test source data (depends on B6,C9,D3)
#    E5- Construct manifest file for subsampling
#    E6- Perform subsampling (depends on A2,A3,E4,E5)
#
#    F7- Align subsampled parallel corpus (depends on E6)
#
#    G1- Extract rules for tuning data (depends on F7)
#    G2- Extract rules for devtest data (depends on F7)
#    G3- Extract rules for each test data set (depends on F7)
#
#    H4- Tune parameters with MERT on tuning data (depends on G1,C8,C9)
#
#    I5- Translate devtest data (depends on D3,G2,H4)
#    I6- Extract 1-best translation (depends on I5)
#    I7- Wrap devtest translation in XML (depends on I6)
#    I8- Score wrapped devtest translation (depends on I7)
#
#    J1- Translate test data (depends on B6,G3,H4)
#    J2- Extract 1-best translation (depends on J1)
#    J3- Wrap test translation in XML (depends on J2)
#
