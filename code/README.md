# Datasets
Overview of datasets in Dallmann et al. (2025).

## Arena data
`arena_empty_cschrimson.csv`: Square-wave optogenetic activation of empty control flies at different light intensities.  
`arena_empty_cschrimson_sinusoidal.csv`: Sinusoidal optogenetic activation of empty control flies. 
`arena_empty_gtacr.csv`: Square-wave optogenetic silencing of empty control flies at different light intensities. 
`arena_rr_cschrimson.csv`: Square-wave optogenetic activation of Roadrunner flies at different light intensities.  
`arena_rr_cschrimson_sinusoidal.csv`: Sinusoidal optogenetic activation of Roadrunner flies. 
`arena_rr_gtacr.csv`: Square-wave optogenetic silencing of Roadrunner flies at different light intensities. 
`arena_rr_sparc_cschrimson.csv`: Square-wave optogenetic activation of Roadrunner SPARC flies. 

## Electrophysiology data
`ephys_walking`: Patch-clamp recordings of Roadrunner neurons in tethered walking flies. 
`ephys_flight`: Patch-clamp recordings of Roadrunner neurons in tethered flying flies. 
`ephys_flailing`: Patch-clamp recordings of Roadrunner neurons in flailing flies. 
`ephys_pushing`: Patch-clamp recordings of Roadrunner neurons in pushing flies. 

In the datasets, `*_velocity` are the smoothed velocities in mm/s (forward and lateral velocity) or deg/s (rotational velocity). `translational_speed` is the sum of the absolute smoothed forward and lateral velocity in mm/s. `rotational_speed` is the absolute smoothed rotational velocity in deg/s. `movement` is a binary vector indicating whether the animal was moving. `time_ephys` and `time_treadmill` are time vector for electrophysiology and treadmill data, respectively. 

## P2X2 data


## Connectome data
FAFB/FlyWire connectome data (`flywire_v783_*.csv`) were analyzed from version 783, which was downloaded from https://codex.flywire.ai/api/download/ in June 2025. Specifically, we used tables Classification, Neurons, and Connections Princeton No Threshold. 

MANC connectome data (`manc_v121_*.csv`) were analyzed from version 1.2.1, which was downloaded from https://neuprint.janelia.org/ in June 2025 using the neuPrint Python package.

`neurons_onf_interest.csv`: Metadata for neurons of interest in the connectomes. 

## Gap-crossing data
`gap_empty_cschrimson.csv`: Optogenetic activation of empty control flies. 
`gap_rr_cschrimson.csv`: Optogenetic activation of Roadrunner flies. 
`gap_mdn_cschrimson.csv`: Optogenetic activation of Moonwalker Descending Neuron flies. 

# Instructions for recreating figures 
The following sections show how to recreate figures in Dallmann et al. (2025) from the datasets above.

## Figure 1
Figure 1b: Run `flywire_plot_synapses.ipynb`.

Figure 1c: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson.csv` or `arena_empty_cschrimson.csv`. Run cell `Plot mean time course for a specific intensity` with these settings: 
```
parameter_name = "speed" 
sets = [1,2] 
intensity = 9
stimulus_duration = 10 
pre_duration = 5 
post_duration = 5 
```

Figure 1d: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson.csv` or `arena_empty_cschrimson.csv`. Run cell `Plot trajectories for a specific intensity` with these settings: 
```
intensity = 9
sets = [1] 
subtract_origin = False
stimulus_duration = 10 
``` 
Because data from different sets can have different absolute x-y-coordinates, run the cell separately for each set, using `sets = [1]` or `sets = [2]`.  


Figure 1e: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson.csv` or `arena_empty_cschrimson.csv`. Run cell `Plot mean speed per animal and intensity` with these settings:
```
parameter_name = "speed"
sets = [1,2]
```
Run cell `Statistics` to perform a one-way ANOVA and Tukey's HSD test.

Figure 1f: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson_sinusoidal.csv` or `arena_empty_cschrimson_sinusoidal.csv`. Run cell `Plot mean time course for a specific intensity` with these settings:
```
parameter_name = "speed" 
animal_sex = ['female,'male']
stimulus_duration = 5 
pre_duration = 0 
post_duration = 5 
```

Figure 1g:

Figure 1h: 

Figure 1i:

Figure 1j: 

Figure 1k: Run `arena_analysis.ipynb`. Load `arena_roadrunner_gtacr.csv` or `arena_empty_gtacr.csv`. For the left graph, run cell `Plot mean speed per animal and intensity` with these settings:
```
parameter_name = "speed"
sets = [1,2]
```

For the right graph, run cell `Plot mean speed per animal and repetition for a specific intensity` with these settings:
```
parameter_name = "speed"
sets = [1,2]
```


## Figure 2
Figure 2a: Run `ephys_plot_recording.m`. Set `recording = 13`. The figure shows 300 s to 335 s. 

Figure 2b: Run `ephys_transitions.m` with these settings:
```
transition_type = 'onset';
parameter_name = 'spike_rate'; 
parameter_source = 'ephys'; 
pre_window = 1; 
post_window = 1; 
plot_type = 'mean';
subtract_baseline = false;
```
Run script again with `transition_type = 'offset';`.  

Figure 2c: Run `ephys_transitions.m` with these settings:
```
transition_type = 'onset';
parameter_name = 'spike_rate'; 
parameter_source = 'ephys';
pre_window = 1; 
post_window = 1; 
plot_type = 'time_series'; 
subtract_baseline = true;
baseline_win = 0.5; 
```
To plot the speeds, run script again with:
```
transition_type = 'onset';
parameter_source = 'treadmill';
pre_window = 1; 
post_window = 1; 
plot_type = 'time_series'; 
subtract_baseline = false;
```
Set `parameter_name = 'translational_speed';` or `parameter_name = 'rotational_speed';`.  

Figure 2d: Run `ephys_transitions.m` with these settings:
```
transition_type = 'onset';
parameter_name = 'spike_rate'; 
parameter_source = 'ephys';
pre_window = 1; 
post_window = 1; 
plot_type = 'time_series'; 
subtract_baseline = true;
baseline_win = 0.5; 
```
Plot `time_to_transition`.

Figure 2e: Run `ephys_cross_correlation.m` with these settings:
```
ephys_parameter_name = 'spike_rate'; 
treadmill_parameter_name = 'translational_speed'; 
correlation_window = 5; % s
```
Run script again with `treadmill_parameter_name = 'rotational_speed';` 

Figure 2f: Run `ephys_plot_distribution.m`.



## Figure 3


## Figure 4
Figure 4a: Run `flywire_convergence.ipynb` with these settings:
```
syn_prediction = 'princeton' 
syn_thresh = 5
nt_type_score_thresh = 0.62
nt_inhibitory_effect = ['GABA','GLUT']
shuffle = False 
n_iterations = 1 
source_neurons = 'RR' 
```
To get the relative output of one group of neurons onto another, specify the respective groups in pre_index and post_index (cell `Calculate output of neurons in specific group `). For example, `pre_index = groups.index("source_1")`and `post_index = groups.index("intermediary_12")`. 


Figure 4c: Run `flywire_convergence.ipynb` with these settings:
```
syn_prediction = 'princeton' 
syn_thresh = 5
nt_type_score_thresh = 0.62
nt_inhibitory_effect = ['GABA','GLUT']
shuffle = False 
n_iterations = 1 
source_neurons = 'RR_BPN' 
```
To get the relative output of one group of neurons onto another, specify the respective groups in pre_index and post_index (cell ...). For example, `pre_index = groups.index("source_1")`and `post_index = groups.index("intermediary_12")`. 


Figure 4I: To display descending neurons in the MANC connectome, open https://tinyurl.com/NeckConnective (Neuroglancer scene from Stürner et al. 2025, https://doi.org/10.1038/s41586-025-08925-z). Body IDs in cluster 1 are `20978, 21696, 22586, 26296, 13238, 12898, 11856, 12025, 10279, 11120`. Body IDs in cluster 2 are `15016, 14999, 14585, 15134, 12613, 13548`. Body IDs in cluster 3 are `21069, 190167, 14904, 13184, 13291, 16333, 154401, 16264, 17366`.


## Figure 5
Figure 5b: In `gap-crossing_analysis.ipynb`, run cell `Plot probability of behavior per phase` with datasets `gap_empty_cschrimson.csv`, `gap_rr_cschrimson.csv`, and `gap_mdn_cschrimson.csv`.

Figure 5c: In `gap-crossing_analysis.ipynb`, run cell `Plot cross duration`.

Figure 5d: In `gap-crossing_analysis.ipynb`, run cell `Plot latency to move`.



## Extended Data Figure 1  
Extended Data Figure 1a:

Extended Data Figure 1b: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson_sinusoidal.csv`. Run cell `Plot mean time course for a specific intensity` with these settings:
```
parameter_name = "speed" 
animal_sex = ['female']
stimulus_duration = 5 
pre_duration = 0 
post_duration = 5 
```
Run script again with `animal_sex = ['male']` 

## Extended Data Figure 2

## Extended Data Figure 3

## Extended Data Figure 4  


## Extended Data Figure 5
In `gap-crossing_analysis.ipynb`, run cell `Plot body lengths`.