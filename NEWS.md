# epigraHMM 0.99.0

* First release of epigraHMM.

* It is now possible to add normalizing offsets via `addOffsets`.

* epigraHMM now uses hdf5 files to store all intermediate data during computation
of the EM algorithm. Intermediate data include window-based HMM and mixture model 
posterior probabiltiies, and forward-backward probabilities. This change leads to
a better memory utilization upon convergece.
