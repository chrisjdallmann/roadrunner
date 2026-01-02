# roadrunner
This repository contains code for recreating figures in:

Dallmann CJ, Iqbal FM, Liebscher S, Erginkaya M, Liessem s, Sauer EL, Soyka H, Cascino-Milani F, Goldammer J, Ito K, Ache JM: A dedicated brain circuit controls forward walking in _Drosophila_. bioRxiv.

Data will be available for download on Dryad. 

## Usage
Instructions on how to recreate individual figure panels are given in `code/README.md`.

## Requirements 
This repository contains Python 3 code and MATLAB code. 

The Python code was tested on Windows 10 with the packages listed in `requirements.txt`. Some scripts access the *Drosophila* connectomes via CAVEclient (FlyWire, BANC) or neuprint (MANC), which require an authentication token. Tokens for FlyWire and BANC can be obtained by joining the [FlyWire community](https://flywire.ai/brain_access) or the [BANC community](https://flywire.ai/banc_access). A token for MANC can be obtained from [neuprint.janelia.org](https://neuprint.janelia.org/account).  

The MATLAB code was tested on Windows 10 with MATLAB R2023a. To run the code, add the `code` folder and its subfolders to the Matlab path. 

## Installation
The code can be run on a standard computer. Installation of the Python packages should take 10 minutes. 