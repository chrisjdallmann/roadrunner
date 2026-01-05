# Instructions for recreating figures 
The following sections show how to recreate the figures in Dallmann et al. (2026). 

The data generated for this study will be available for download from Zenodo. The FlyWire connectome data can be downloaded from [flywire.ai](https://codex.flywire.ai/api/download?dataset=fafb). Download the csv-files `Connections (Unfiltered)` as `flywire_v783_connections.csv`, `Classification` as `flywire_v783_classifications.csv`,  and `Neurotransmitter Type Predictions` as `flywire_v783_neurotransmitters.csv`.

Store all data in the `data` folder of this repository.   


## Figure 1
Figure 1d: In `arena_analysis.ipynb`, run cell `Plot mean time course for a specific intensity` with the these settings: 
```
dataset = "arena_rrn_cschrimson.csv"
parameter_name = "speed" 
experiments = [1,2] 
intensity = 9
stimulus_duration = 10 
pre_duration = 5 
post_duration = 5 
```
Run cell again with `dataset = "arena_empty_cschrimson.csv"`.


Figure 1e: In `arena_analysis.ipynb`, run cell `Plot trajectories for a specific intensity` with these settings: 
```
dataset = "arena_rrn_cschrimson.csv"
intensity = 9
experiments = [1] 
subtract_origin = False
stimulus_duration = 10 
``` 
Run cell again with `experiments = [2]`. The cell should be run separately for each experiment because different experiments can have different absolute x-y coordinates. Run cell again with `dataset = "arena_empty_cschrimson.csv"`.  


Figure 1f: In `arena_analysis.ipynb`, run cell `Plot mean of activation per animal and intensity` with these settings:
```
dataset = "arena_rrn_cschrimson.csv"
parameter_name = "speed"
experiments = [1,2]
```

Figure 1g: In `arena_analysis.ipynb`, run cell `Plot mean time course for a specific intensity` with these settings:
```
dataset = "arena_rrn_cschrimson_sinusoidal.csv"
parameter_name = "speed" 
animal_sex = ["female","male"]
stimulus_duration = 5 
pre_duration = 0 
post_duration = 5 
```
Run cell again with `dataset = "arena_empty_cschrimson_sinusoidal.csv"`.


Figure 1h: In `walking_initiation_analysis.ipynb`, run cell `Plot swing phases of a specific trial` with these settings:
```
dataset = "treadmill_rrn_cschrimson_walking_initiation.csv"
animal_id = 3
trial = 4
```


Figure 1i-j: In `walking_initiation_analysis.ipynb`,  first run cell `Compute latency and probability of swing phases` with these settings:
```
dataset = "treadmill_rrn_cschrimson_walking_initiation.csv"
```
Then run cell `Plot latencies` (Fig. 1i) and cell `Plot probability of legs to swing first` (Fig. 1j).
Run cells again with `dataset = "treadmill_rrn_cschrimson_walking_initiation_control.csv"`.


Figure 1k: In `arena_analysis.ipynb`, run cell `Plot mean of activation per animal and intensity` with these settings:
```
dataset = "arena_rrn_gtacr.csv"
parameter_name = "speed"
experiments = [1,2]
```
Run cell again with `dataset = "arena_empty_gtacr.csv"`.


Figure 1l: In `arena_analysis.ipynb`, run cell `Plot mean of activation per animal and repetition` with these settings:
```
dataset = "arena_rrn_gtacr.csv"
intensity = 1
parameter_name = "speed"
experiments = [1,2]
stimulus_duration = 10 
```


Figure 1m: In `arena_analysis.ipynb`, run cell `Compare means of activations across datasets` with these settings:
```
dataset_1 = "arena_rrn_gtacr.csv"
dataset_2 = "arena_empty_gtacr.csv"
parameter_name = "speed"
```


## Supplementary Figure 1
Supplementary Figure 1b: In `arena_analysis.ipynb`, run cell `Plot mean of activation per animal and intensity` with these settings:
```
dataset = "arena_rrn_chchrimson.csv"
parameter_name = "speed"
experiments = [1]
```
Run cell again with `experiments = [2]`. In experiment 1, activation intensities were presented in decreasing order. In experiment 2, activation intensities were presented in increasing order. 


Supplementary Figure 1c: In `arena_analysis.ipynb`, run cell `Plot mean time course for a specific intensity`
```
dataset = "arena_rrn_cschrimson_sinusoidal.csv"
parameter_name = "speed" 
stimulus_duration = 5 
pre_duration = 0 
post_duration = 5
animal_sex = ["female"]
```
Run cell again with `animal_sex = ["male"]`. 


## Figure 2
Figure 2a: Run `flywire_plot_neurons.ipynb` with these settings:
```
neurons_to_plot = "RRN"  
```


Figure 2b: Run `flywire_downstream_connectivity.ipynb` with these settings:
```
syn_thresh = 5
nt_type_score_thresh = 0.62
nt_inhibitory_effect = ['GABA','GLUT']
shuffle = False 
n_iterations = 1 
source_neurons = 'RRN'
```
For the number of source, intermediate, and target neurons, see cell `Display number of neurons per group`.
For the relative output of one group of neurons onto another, see cell `Calculate output of one group of neurons onto another`. Specify the groups in `pre_index` and `post_index`. Use combinations of:
- `"source"`: RRN
- `"intermediate"`: Intermediate neurons postsynaptic to RRN
- `"target"`: Descending neurons downstream of RRN  


Figure 2c: Run `flywire_plot_neurons.ipynb` with these settings:
```
neurons_to_plot = 'RRN_BPN'  
```


Figure 2d: Run `flywire_downstream_connectivity.ipynb` with these settings:
```
syn_thresh = 5
nt_type_score_thresh = 0.62
nt_inhibitory_effect = ['GABA','GLUT']
shuffle = False 
n_iterations = 1 
source_neurons = 'RRN_BPN'
```
For the number of source, intermediate, and target neurons, see cell `Display number of neurons per group`.
For the relative output of one group of neurons onto another, see cell `Calculate output of one group of neurons onto another`. Specify the groups in `pre_index` and `post_index`. Use combinations of:
- `"source_1"`: RRN
- `"source_2"`: BPN
- `"intermediate_1_shared"`: Intermediate neurons postsynaptic to RRN projecting to shared DNs
- `"intermediate_2_shared"`: Intermediate neurons postsynaptic to BPN projecting to shared DNs
- `"intermediate_12"`: Intermediate neurons postsynaptic to both RRN and BPN
- `"target_12"`: Descending neurons downstream of RRN and BPN


Figure 2e: Run `flywire_downstream_connectivity.ipynb` with these settings:
```
syn_thresh = 5
nt_type_score_thresh = 0.62
nt_inhibitory_effect = ['GABA','GLUT']
shuffle = True 
n_iterations = 10000 
source_neurons = 'RRN_BPN' 
```
See output of cell `Plot distribution of shared output`. For RRN, set `data_to_plot = shared_source_1_output`. For BPN, set `data_to_plot = shared_source_2_output`.


Figure 2f: Same as Figure 2d. See output of cell `Plot all-to-all connectivity matrix`. 


Figure 2g: Same as Figure 2d. See output of cell `Plot net excitation onto target nodes per source`.  


Figure 2h, left: Run `manc_neuropil_analysis.ipynb` 

Figure 2h, right: Run `manc_neuron_analysis.iypnb`.

Figure 2i, top: Run `flywire_plot_neurons.ipynb` with these settings:
```
neurons_to_plot = 'DN_leg_cluster'  
```
Run again with `neurons_to_plot = 'DN_LTct_cluster'`.

Figure 2i, bottom: DNs in MANC were plotted using the Neuroglancer environment from [Stuerner et al. (2025)]: https://tinyurl.com/NeckConnective.



## Supplementary Figure 2
Supplementary Figure 2a: Same as Figure 2d. See output of cells `Plot synapse counts of intermediate neurons`, `Plot super classes of intermediate neurons`, and `Plot neurotransmitter type of intermediate neurons`.


Supplementary Figure 2b: Same as Figure 2d. See output of cell `Plot combined net excitation onto target nodes`.


Supplementary Figure 2c: Same as Figure 2g. 


Supplementary Figure 2d: Run `manc_neuron_analysis.iypnb`. See output of cell `Plot sorted connectivity with neurons of interest`.


Supplementary Figure 2e: Run `flywire_upstream_connectivity.ipynb`.


Supplementary Figure 2f: Run `flywire_shortest_path.ipynb`.



## Figure 3
Figure 3a: Run `flywire_plot_synapses.ipynb`.


Figure 3c: Run `p2x2_analysis.ipynb`. In cells `Plot mean time series` and `Plot means of mean time series`, use either `parameter_name = "forward_velocity"` or `parameter_name = "angular_velocity"`. 



## Supplementary Figure 3
Supplementary Figure 3b, left: In `arena_analysis.ipynb`, run cell `Plot mean time course for a specific intensity` with these settings:
```
dataset = "arena_rrn_sparc_cschrimson.csv"
parameter_name = "forward_velocity" 
experiments = ["left","right"] 
intensity = 9
stimulus_duration = 10 
pre_duration = 5 
post_duration = 5 
```
Run cell again with `parameter_name = "angular_velocity"` and `experiments = ["bilateral"]` or `experiments = ["empty"]`.


Supplementary Figure 3b, right: In `arena_analysis.ipynb`, run cell `Plot mean of activation per animal and intensity for SPARC data` with these settings:
```
dataset = "arena_rrn_cschrimson.csv"
parameter_name = "forward_velocity"
```
Run cell again with `parameter_name = "angular_velocity"`. 


## Figure 4
Figure 4a: Run `ephys_plot_recording.m` with these settings:
```
dataset = `treadmill_ephys_rrn_gfp_walking.mat`;
recording = 13;
```
The figure shows 300 s to 335 s. 


Figure 4b: Run `ephys_movement_analysis.m` with these settings:
```
dataset = `treadmill_ephys_rrn_gfp_walking.mat`;
parameter_name = 'spike_rate';

```


Figure 4c: Run `ephys_transition_analysis.m` with these settings:
```
dataset = `treadmill_ephys_rrn_gfp_walking.mat`;
n_transitions_min = 3;
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
dataset = 'treadmill_ephys_rrn_gfp_walking.mat';
ephys_parameter_name = 'spike_rate'; 
treadmill_parameter_name = 'translational_speed'; 
correlation_window = 3; 
```
Run script again with `treadmill_parameter_name = 'angular_speed';` 


Figure 4e: Run `ephys_speed_analysis.m` with these settings:
```
dataset = 'treadmill_ephys_rrn_gfp_walking.mat';
```


Figure 4f: Run `ephys_transition_analysis.m` with these settings: 
```
dataset = `treadmill_ephys_rrn_gfp_flight.mat`;
n_transitions_min = 3;
transition_type = 'onset';
parameter_name = 'membrane_potential_smoothed'; 
parameter_source = 'ephys';
pre_window = 1; 
post_window = 5; 
plot_type = 'time_series'; 
subtract_baseline = true;
baseline_win = 0.5; 
```
To plot the spike rate, run script with `parameter_name = 'spike_rate';` and `subtract_baseline = false`. 


Figure 4g: Same as Figure 4f, but with `dataset = treadmill_ephys_rrn_gfp_pushing.mat`.


Figure 4h, left: Run `ephys_movement_analysis.m` with these settings:
```
dataset = 'treadmill_ephys_rrn_gfp_flight.mat';
parameter_name = 'spike_rate';
```

Figure 4h, right: Same as Figure 4g left, but with `dataset = treadmill_ephys_rrn_gfp_pushing.mat`.


## Supplementary Figure 4  
Supplementary Figure 4a: Run `ephys_plot_recording.m` with these settings:
```
dataset = 'treadmill_ephys_rrn_gfp_flight.mat';
recording = 5;
```
The figure shows 35 to 105 s. 


Supplementary Figure 4b: Run `ephys_plot_recording.m` with these settings: 
```
dataset = 'treadmill_ephys_rrn_gfp_pushing.mat';
recording = 1;
```
The figure shows 1 to 27.5 s. 


## Figure 5
Figure 5a: Run `behavior_transition_analysis.ipynb`. In cell `Plot mean probility`, set `behavior_before = 'resting'`, `behavior_before = 'grooming'`, or `behavior_before = 'flight'`. 


Figure 5c: Run `gap-crossing_analysis.ipynb`. In cell `Plot probability of behavior per phase`, set `dataset = gap_empty_cschrimson.csv`, `dataset = gap_rrn_cschrimson.csv`, or `gap_mdn_cschrimson.csv`.


Figure 5d: Same as Figure 5c. Probability is shown in cell `Compute mean probability to cross during phases 1-3`.


Figure 5e: In `gap-crossing_analysis.ipynb`, run cell `Plot cross duration`.


## Supplementary Figure 5
Supplementary Figure 5a: Same as Figure 5c.


Supplementary Figure 5b: In `gap-crossing_analysis.ipynb`, run cell `Plot body lengths`.


Supplementary Figure 5c: In `gap-crossing_analysis.ipynb`, run cell `Plot latency to move`.