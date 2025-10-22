# Instructions for recreating figures 
The following sections show how to recreate the figures in Dallmann et al. (2025). 

Download the data from ... 

Store the data in the `data` folder of this repository.   


## Figure 1
Figure 1d: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson.csv` or `arena_empty_cschrimson.csv`. Run cell `Plot mean time course for a specific intensity` with these settings: 
```
parameter_name = "speed" 
sets = [1,2] 
intensity = 9
stimulus_duration = 10 
pre_duration = 5 
post_duration = 5 
```

Figure 1e: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson.csv` or `arena_empty_cschrimson.csv`. Run cell `Plot trajectories for a specific intensity` with these settings: 
```
intensity = 9
sets = [1] 
subtract_origin = False
stimulus_duration = 10 
``` 
Because data from different sets can have different absolute x-y-coordinates, run the cell separately for each set, using `sets = [1]` or `sets = [2]`.  

Figure 1f: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson.csv` or `arena_empty_cschrimson.csv`. Run cell `Plot mean speed per animal and intensity` with these settings:
```
parameter_name = "speed"
sets = [1,2]
```
Run cell `Statistics` to perform a one-way ANOVA and Tukey's HSD test.

Figure 1g: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson_sinusoidal.csv` or `arena_empty_cschrimson_sinusoidal.csv`. Run cell `Plot mean time course for a specific intensity` with these settings:
```
parameter_name = "speed" 
animal_sex = ['female,'male']
stimulus_duration = 5 
pre_duration = 0 
post_duration = 5 
```

Figure 1j,k: Run `walking_initiation_analysis.ipynb`. Load `treadmill_rr_cschrimson_walking_initiation.csv` or `treadmill_rr_cschrimson_walking_initiation_control.csv`.

Figure 1l: Run `arena_analysis.ipynb`. Load `arena_roadrunner_gtacr.csv` or `arena_empty_gtacr.csv`. For the left graph, run cell `Plot mean speed per animal and intensity` with these settings:
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
Figure 2a: Run `flywire_plot_neurons.ipynb`. Set `root_id = [720575940639781027]`.

Figure 2b: Run `flywire_convergence.ipynb` with these settings:
```
syn_thresh = 5
nt_type_score_thresh = 0.62
nt_inhibitory_effect = ['GABA','GLUT']
shuffle = False 
n_iterations = 1 
source_neurons = 'RR' 
```
To get the relative output of one group of neurons onto another, specify the respective groups in `pre_index` and `post_index` (cell `Calculate output of neurons in specific group `). For example, `pre_index = groups.index("source")`and `post_index = groups.index("intermediary_12")`. 

Figure 2c: Run `flywire_plot_neurons.ipynb`. Set `root_id = [720575940633362145, 720575940639781027]`.

Figure 2d: Run `flywire_convergence.ipynb` with these settings:
```
syn_thresh = 5
nt_type_score_thresh = 0.62
nt_inhibitory_effect = ['GABA','GLUT']
shuffle = False 
n_iterations = 1 
source_neurons = 'RR_BPN' 
```
To get the relative output of one group of neurons onto another, specify the respective groups in `pre_index` and `post_index` (cell `Calculate output of neurons in specific group `). For example, `pre_index = groups.index("source_1")`and `post_index = groups.index("intermediary_12")`. 

Figure 2e: Run `flywire_convergence.ipynb` with these settings:
```
syn_thresh = 5
nt_type_score_thresh = 0.62
nt_inhibitory_effect = ['GABA','GLUT']
shuffle = True 
n_iterations = 10000 
source_neurons = 'RR_BPN' 
```
Run cell `Plot distribution of shared output`. For RR, set `data_to_plot = shared_source_1_output`. For BPN, set `data_to_plot = shared_source_2_output`.

Figure 2f: Same as Figure 2d. Run cell `Plot connectivity matrix`. 

Figure 2g: Same as Figure 2d. Run cell `Plot net excitation onto target nodes`. 

Figure 2h: Same as Figure 2d. Run cell `Plot net excitation onto target nodes per source`.  

Figure 2i: Run `manc_neuropil_analysis.ipynb` and `manc_neuron_analysis.iypnb`.


## Figure 3
Figure 3a: Run `flywire_plot_synapses.ipynb`.

Figure 3c: In `p2x2_analysis.ipynb`, run cells `Plot mean time series` and `Plot means of mean time series` with `parameter_name = "forward_velocity"` or `parameter_name = "angular_velocity"`. 


## Figure 4
Figure 4a: Run `ephys_plot_recording.m`. Load dataset `treadmill_ephys_rr_gfp_walking.mat`. Set `recording = 13`. The figure shows 300 s to 335 s. 

Figure 4b: Run `ephys_movement_analysis.m`. Load dataset `treadmill_ephys_rr_gfp_walking.mat`. Set `parameter_name = 'spike_rate';`.

Figure 4c: Run `ephys_transition_analysis.m` with these settings:
```
transition_type = 'onset';
parameter_name = 'membrane_potential_smoothed'; 
parameter_source = 'ephys';
pre_window = 1; 
post_window = 1; 
plot_type = 'time_series'; 
subtract_baseline = true;
baseline_win = 0.5; 
```
To plot the spike rate, run script with `parameter_name = 'spike_rate';` 
To plot the speeds, run script with `parameter_source = 'treadmill'` and `subtract_baseline = false;`. Set `parameter_name = 'translational_speed';` or `parameter_name = 'rotational_speed';`.  

Figure 4d: Run `ephys_cross_correlation.m` with these settings:
```
ephys_parameter_name = 'spike_rate'; 
treadmill_parameter_name = 'translational_speed'; 
correlation_window = 3; 
```
Run script again with `treadmill_parameter_name = 'angular_speed';` 

Figure 4e: Run `ephys_speed_analysis.m`. Load dataset `treadmill_ephys_rr_gfp_walking.mat`.

Figure 4f, left: Run `ephys_transition_analysis.m`. Load dataset `treadmill_ephys_rr_gfp_pushing.mat`. Use these settings:
```
transition_type = 'onset';
parameter_name = 'membrane_potential_smoothed'; 
parameter_source = 'ephys';
pre_window = 1; 
post_window = 5; 
plot_type = 'time_series'; 
subtract_baseline = true;
baseline_win = 0.5; 
```
To plot the spike rate, run script with `parameter_name = 'spike_rate';` and `subtract_baseline = false;`. 

Figure 4f, right: Same as Figure 4f left, but with dataset `treadmill_ephys_rr_gfp_flight.mat`.

Figure 4g, left: Run `ephys_movement_analysis.m`. Load dataset `treadmill_ephys_rr_gfp_pushing.mat`. Set `parameter_name = 'spike_rate';`.

Figure 4g, right: Same as Figure 4g left, but with dataset `treadmill_ephys_rr_gfp_flight.mat`.


## Figure 5
Figure 5a: Run `behavior_transition_analysis.ipynb`. Set `behavior_before = 'resting'`, `behavior_before = 'grooming'`, or `behavior_before = 'flight'`. 

Figure 5c: In `gap-crossing_analysis.ipynb`, run cell `Plot probability of behavior per phase` with datasets `gap_empty_cschrimson.csv`, `gap_rr_cschrimson.csv`, and `gap_mdn_cschrimson.csv`.

Figure 5d: In `gap-crossing_analysis.ipynb`, run cell `Plot cross duration`.


## Extended Data Figure 1 
Extended Data Figure 1b: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson.csv`. Run cell `Plot mean speed per animal and intensity` with these settings:
```
parameter_name = "speed"
sets = [1]
```
Run script again with `sets = [2]`.

Figure 1c: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson_sinusoidal.csv`. Run cell `Plot mean time course for a specific intensity` with these settings:
```
parameter_name = "speed" 
animal_sex = ['female']
stimulus_duration = 5 
pre_duration = 0 
post_duration = 5 
```
Run script again with `animal_sex = ['male']`.


## Extended Data Figure 2
Extended Data Figure 2a: Run `flywire_convergence.ipynb` with these settings:
```
syn_thresh = 5
nt_type_score_thresh = 0.62
nt_inhibitory_effect = ['GABA','GLUT']
shuffle = False 
n_iterations = 1 
source_neurons = 'RR_BPN' 
```
Run cell `Plot super class and neurotransmitter profile of specific group of neurons`. Set `group` to `"intermediary_1_shared"` (Inter RR), `"intermediary_12"` (Inter RR+BPN), or `"intermediary_2_shared"` (Inter BPN). 

Extended Data Figure 2b: Same as Figure 2g. 

Extended Data Figure 2c: Same as Figure 2h. 

Extended Data Figure 2e,f: Run `flywire_presynaptic_connectivity.ipynb`.


## Extended Data Figure 3
Extended Data Figure 4b: Run `arena_analysis.ipynb`. Load `arena_rr_sparc_cschrimson.csv`. Run `Plot mean time course for a specific intensity` with these settings:
```
parameter_name = "forward_velocity" 
sets = ["Left","Right"] 
intensity = 9
stimulus_duration = 10 
pre_duration = 5 
post_duration = 5 
```
Run script again with `sets = ["Bilateral"]`, `sets = ["Empty"]`, and `parameter_name = "angular_velocity"`. 


## Extended Data Figure 4  
Extended Data Figure 4a: Run `ephys_plot_recording.m`. Load dataset `pushing`. Set `recording = 1`. The figure shows 1 to 27.5 s. 

Extended Data Figure 4b: Run `ephys_plot_recording.m`. Load dataset `flight`. Set `recording = 5`. The figure shows 36 to 122 s. 


## Extended Data Figure 5
Extended Data Figure 5a: In `gap-crossing_analysis.ipynb`, run cell `Plot body lengths`.

Extended Data Figure 5b: In `gap-crossing_analysis.ipynb`, run cell `Plot latency to move`.