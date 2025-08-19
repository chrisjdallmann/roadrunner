# Overview of datasets
## Optogenetic activation and silencing data 
`arena_rr_cschrimson.csv`: Square-wave optogenetic activation of Roadrunner>CsChrimson flies at different light intensities.  
`arena_empty_cschrimson.csv`: Square-wave optogenetic activation of empty>CsChrimson flies at different light intensities.  
`arena_rr_gtacr.csv`: Square-wave optogenetic silencing of Roadrunner>CsChrimson flies at different light intensities. 
`arena_empty_gtacr.csv`: Square-wave optogenetic silencing of empty>CsChrimson flies at different light intensities. 
`arena_rr_sparc_cschrimson.csv`: Square-wave optogenetic activation of RR>SPARC2-CsChrimson flies. 

## Electrophysiology data  
`treadmill_rr_gfp_walking`: Patch-clamp recordings of tethered walking Roadrunner>GFP flies.  
`treadmill_rr_gfp_flight`: Patch-clamp recordings of tethered flying Roadrunner>GFP flies. 
`treadmill_rr_gfp_pushing`: Patch-clamp recordings of tethered pushing Roadrunner>GFP flies.  

## Chemogenetic activation data 
`treadmill_rr_p2x2`: Chemogenetic activation of tethered Roadrunner>P2X2 flies.
`treadmill_rr_p2x2_control`: ATP application in tethered Roadrunner>GFP control flies.

## Gap-crossing data
`gap_rr_cschrimson.csv`: Optogenetic activation of Roadrunner>CsChrimson flies in the gap-crossing paradigm. 
`gap_mdn_cschrimson.csv`: Optogenetic activation of MDN>CsChrimson flies in the gap-crossing paradigm. 
`gap_empty_cschrimson.csv`: Optogenetic activation of empty>CsChrimson flies in the gap-crossing paradigm. 

## Connectome data
FAFB/FlyWire connectome data (`flywire_v783_*.csv`) were analyzed from version 783, which was downloaded from https://codex.flywire.ai/api/download/ in June 2025. We used tables `Classification`, `Neurons`, and `Connections Princeton No Threshold`. 

MANC connectome data (`manc_v121_*.csv`) were analyzed from version 1.2.1, which was downloaded from https://neuprint.janelia.org/ in June 2025 using the neuPrint Python package.

`neurons_onf_interest.csv`: Metadata for neurons of interest in the connectomes. 