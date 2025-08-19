# Instructions for recreating figures 
The following sections show how to recreate the figures in Dallmann et al. (2025). 

Download the data from ... 

Store the data in the `data` folder of this repository.   

Optogenetic activation and silencing data from freely walking flies in the arena can be analyzed with the Jupyter notebook `arena_analysis.ipynb`.

Connectome figures can be recreated with the Jupyter notebooks `flywire_*.ipynb` and `manc_*.ipynb`.

Electrophysiology figures can be recretaed with the Matlab scripts `ephys_*.m`.

Chemogenetic activation data from tethered flies can be analyzed with the Jupyter notebook `p2x2_analysis.ipynb`.

Gap-crossing figures can be recreated with the Jupyter notebook `gap-crossing_analysis.ipynb`.

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

Figure 1f: Run `arena_analysis.ipynb`. Load `arena_rr_cschrimson_sinusoidal.csv` or `arena_empty_cschrimson_sinusoidal.csv`. Run cell `Plot mean time course for a specific intensity` with these settings:
```
parameter_name = "speed" 
animal_sex = ['female,'male']
stimulus_duration = 5 
pre_duration = 0 
post_duration = 5 
```

Figure 1g:

Figure 1i:

Figure 1j: 

Figure 1k: 

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

Figure 1m: 


## Figure 2
Figure 2a: Run `flywire_plot_synapses.ipynb`.

Figure 2b: Run `flywire_convergence.ipynb` with these settings:
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

Figure 2d: Run `flywire_convergence.ipynb` with these settings:
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

Figure 2e: 

Figure 2f: 

Figure 2g:

Figure 2h:

Figure 2i:


## Figure 3
Figure 3a: Run `ephys_plot_recording.m`. Load dataset `walking`. Set `recording = 13`. The figure shows 300 s to 335 s. 

Figure 3b: 

Figure 3c: Run `ephys_transition_analysis.m` with these settings:
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

Figure 3d: Run `ephys_cross_correlation.m` with these settings:
```
ephys_parameter_name = 'spike_rate'; 
treadmill_parameter_name = 'translational_speed'; 
correlation_window = 5; % s
```
Run script again with `treadmill_parameter_name = 'rotational_speed';` 

Figure 3e: Run `ephys_speed_analysis.m`. 

Figure 3f: 

Figure 3g: 

Figure 3h: 

Figure 3i: 


## Figure 4
Figure 4a: 

Figure 4b: In `p2x2_analysis.ipynb`, run cells `Plot mean time series` and `Plot means of mean time series` with `parameter_name = "forward_velocity"` or `parameter_name = "angular_velocity"`. 

Figure 4c. Run `arena_analysis.ipynb`. Load `arena_rr_sparc_cschrimson.csv`. Run `Plot mean time course for a specific intensity` with these settings:
```
parameter_name = "forward_velocity" 
sets = ["Left","Right"] 
intensity = 9
stimulus_duration = 10 
pre_duration = 5 
post_duration = 5 
```
Run script again with `sets = ["Bilateral"]`, `sets = ["Empty"]`, and `parameter_name = "angular_velocity"`. 


## Figure 5
Figure 5a: 

Figure 5b: 

Figure 5d: In `gap-crossing_analysis.ipynb`, run cell `Plot probability of behavior per phase` with datasets `gap_empty_cschrimson.csv`, `gap_rr_cschrimson.csv`, and `gap_mdn_cschrimson.csv`.

Figure 5e: In `gap-crossing_analysis.ipynb`, run cell `Plot cross duration`.

Figure 5f: In `gap-crossing_analysis.ipynb`, run cell `Plot latency to move`.



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