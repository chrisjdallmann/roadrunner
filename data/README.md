# Description of the data and file structure
This dataset contains behavioral and electrophysiology data generated for Dallmann et al. (2025). All data are from adult _Drosophila melanogaster_.  

Code to recreate all figures is provided on GitHub (https://github.com/chrisjdallmann/roadrunner).


## Optogenetic activation and silencing data 
### Files
`arena_rr_cschrimson.csv`: Square-wave optogenetic activation of RR>CsChrimson flies at different light intensities.  
`arena_empty_cschrimson.csv`: Square-wave optogenetic activation of empty>CsChrimson flies at different light intensities.

`arena_rr_cschrimson_sinusoidal.csv`: Sinusoidal optogenetic activation of RR>CsChrimson flies. 
`arena_empty_cschrimson_sinusoidal.csv`: Sinusoidal optogenetic activation of empty>CsChrimson flies. 

`arena_rr_gtacr.csv`: Square-wave optogenetic silencing of RR>GtACR flies at different light intensities. 
`arena_empty_gtacr.csv`: Square-wave optogenetic silencing of empty>GtACR flies at different light intensities. 

`arena_rr_sparc_cschrimson.csv`: Square-wave optogenetic activation of RR>SPARC2-CsChrimson flies. 

`treadmill_rr_cschrimson_walking_initiation.csv`: Optogenetic activation of tethered resting RR>CsChrimson flies. 
`treadmill_rr_cschrimson_walking_initiation_control.csv`: Spontaneous walking initiation by tethered RR>CsChrimson flies.
`treadmill_rr_cschrimson_transitions.csv`: Optogenetic activation of tethered resting, walking, grooming, and flying RR>CsChrimson flies.                             

### Variables
The csv files contain a combination of the following columns:
`experiment`: Indicates the experimental group in which animals have been recorded (1 or 2) or how many RR neurons were targeted (bilateral, unilteral, or none).  
`intensity`: Optogenetic activation intensity in Volt. 
`animal_id`: Animal identifier.
`animal_sex`: Animal sex. 
`trial`: Trial number.
`frame`: Number of video frame. 
`time`: Time in seconds. 
`n_stimulus`: Number of stimulus repetition. 
`n_inter_stimulus_interval`: Number of stimulus interval. 
`x`, `y`: 2D coordinates of the body center of mass.  
`forward_velocity`: Forward velocity in millimeters per second.
`lateral_velocity`: Lateral or side-stepping velocity in millimeters per second.
`angular_velocity`: Angular velocity in degrees per second.
`speed`: Translational speed of the body center of mass in mm/s.  
`resting`: Binary variable indicating whether animal was resting. 
`walking`: Binary variable indicating whether animal was walking.  
`grooming`: Binary variable indicating whether animal was grooming.  
`flying`: Binary variable indicating whether animal was flying. 
`other`: Binary variable indicating whether animal was performing movements other than walking, grooming, or flying.  
`swing_L1`, `swing_L2`, `swing_L3`, `swing_R1`, `swing_R2`, `swing_R3`: Binary variable indicating whether left (L) or right (R) front (1), middle (2), or hind (3) leg was in swing.  


## Chemogenetic activation data 
### Files
`treadmill_rr_p2x2.csv`: Chemogenetic activation (ATP application) of tethered RR>P2X2 flies.
`treadmill_rr_p2x2_control.csv`: ATP application in tethered RR>GFP control flies.

### Variables
The csv files contain the following columns:
`animal_id`: Animal identifier.
`hemisphere`: Hemisphere in which cell body was stimulated (left or right). 
`trial`: Trial number.
`forward_velocity`: Forward velocity in millimeters per second.
`lateral_velocity`: Lateral or side-stepping velocity in millimeters per second.
`angular_velocity`: Angular velocity in degrees per second.
`stimulus`: Binary variable indicating whether ATP was applied. 

## Electrophysiology data  
### Files
`treadmill_ephys_rr_gfp_walking.mat`: Patch-clamp recordings of tethered walking RR>GFP flies.  
`treadmill_ephys_rr_gfp_pushing.mat`: Patch-clamp recordings of tethered pushing RR>GFP flies. 
`treadmill_ephys_rr_gfp_flying.mat`: Patch-clamp recordings of tethered flying RR>GFP flies.  

### Variables
The csv files contain a combination of the following columns:
`experiment`: Name of recording.
`animal_id`: Animal identifier.
`trial`: Trial number.
`membrane_potential`: Membrane potential in millivolt. 
`spike_events`: Detected spike times. 
`Spike_rate`: Spike rate in Hz. 
`time_ephys`: Time vector for electrophysiology data in seconds. Sampling rate is 20000 Hz. 
`movement`: Binary variable indicating whether animal was moving (walking, pushing, or flying).
`forward_velocity`: Forward velocity in millimeters per second.
`lateral_velocity`: Lateral or side-stepping velocity in millimeters per second.
`angular_velocity`: Angular velocity in degrees per second.
`translational_speed`: Translational speed in millimeters per second.
`angular_speed`: Angular speed in degrees per second.
`time_treadmill`: Time vector for treadmill data in seconds. Sampling rate is 50 Hz. 
`tachometer`: Wing beat tachometer signal. 


## Gap-crossing data
### Files
`gap_rr_cschrimson.csv`: Optogenetic activation of RR>CsChrimson flies in the gap-crossing paradigm. 
`gap_empty_cschrimson.csv`: Optogenetic activation of empty>CsChrimson flies in the gap-crossing paradigm. 
`gap_mdn_cschrimson.csv`: Optogenetic activation of MDN>CsChrimson flies in the gap-crossing paradigm. 

### Variables
The csv files contain a combination of the following columns:
`phase`: Phase of gap crossing. Either 0 (flies ready to cross), 1 (early crossing), 2 (mid crossing), or 3 (late crossing). 
`animal_id`: Animal identifier.
`body_length`: Distance between neck and end of abdomen in millimeters.
`trial`: Trial number.
`behavior`: Behavior after the onset of the optogenetic light stimulus. Either none (rest), cross (climb), abort, fall, backward, or jump.
`stimulus_onset`: Frame at which stimulus started.
`movement_onset`: Frame at which movement started.
`cross_start`: Frame at which cross started.
`cross_end`: Frame at which cross ended.


## Connectome data
### Files
`neurons_of_interest.csv`: Metadata for neurons of interest in the connectomes. 

### Variables
The csv files contains the following columns:
`connectome`: Name of connectome dataset.
`root_id`: Neuron identifier. 
`community_name`: Community name of neuron.
`super_class`: Super class of neuron.
`motor_program`: Motor program that neuron has been implicated in. 
`motor_function`: Specific function within motor program that neuron has been implicated in. 
`motor_function_reference`: Paper reference for motor function.
`connectome_id_reference`: Paper reference for connectome identification. 