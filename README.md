# RLC_fibersim_project
### Instructions

+ Pull latest version of [FiberSim](https://campbell-muscle-lab.github.io/FiberSim/)

+ Install FiberSim as described at [https://campbell-muscle-lab.github.io/FiberSim/pages/installation/installation.html](https://campbell-muscle-lab.github.io/FiberSim/pages/installation/installation.html)

+ Pull latest version of [project_greenberg_fibersim](https://github.com/Campbell-Muscle-Lab/project_greenberg_fibersim)

+ Open Anaconda prompt

+ Activate FiberSim environment
  + `conda activate fibersim`

+ Change directory to Fiberpy
  + `cd <FiberSim_Repo>/code/fiberpy/fiberpy`

+ Find the setup file in the project repo
  + `<project_repo>/base/setup.json`

+ Change the `FiberCpp_exe` path to match your FiberSim installation and resave

````
 "FiberSim_setup": {
        "FiberCpp_exe": {
            "relative_to": "False",
            "exe_file": "d:/ken/github/campbellmusclelab/models/FiberSim/bin/FiberCpp.exe"
        },
````

+ Type `python fiberpy.py chararacterize <project_repo>/base/setup.json`

+ Stuff should run

### Output

The setup file runs simulations for different myosin schemes for:
+ force-pCa and k_tr
+ force-velocity at pCa 4.5
  

There are 4 conditions:
+ 1 = base model
+ 2 = base model with faster SRX recrutment 
+ 3 = base model with faster myosin attachment in pre-power stroke.
+ 4 = base model with faster myosin detachement 

All the figures are in a folder structure under `<project_repo>/sim_data`

The rate diagram is
![rates](https://github.com/Campbell-Muscle-Lab/RLC_fibersim_project/assets/145811350/68934158-7bda-4a84-bfcc-c9c78fbf2536)


Summary files are as follows

![force_pCa](https://github.com/Campbell-Muscle-Lab/RLC_fibersim_project/assets/145811350/2cf210bd-bff3-4737-afac-33f02f62d5a0)
![k_tr_analysis](https://github.com/Campbell-Muscle-Lab/RLC_fibersim_project/assets/145811350/5869633d-c6d5-4288-af32-59c1720d4a97)
![superposed_traces](https://github.com/Campbell-Muscle-Lab/RLC_fibersim_project/assets/145811350/b32967eb-6118-4182-bad5-75cbffa74cdc)

![fv_and_power](https://github.com/Campbell-Muscle-Lab/RLC_fibersim_project/assets/145811350/4dac15ee-3f8d-46eb-8fc2-01794fd6f1a4)
![superposed_traces](https://github.com/Campbell-Muscle-Lab/RLC_fibersim_project/assets/145811350/3d76a29d-1cca-4f27-a783-1bd83ccbd4d1)
![fv_traces_1](https://github.com/Campbell-Muscle-Lab/RLC_fibersim_project/assets/145811350/61e3754e-62a0-477d-a207-36026879f8f7)



### Setup file

The setup file uses features described in the [FiberSim demos](https://campbell-muscle-lab.github.io/FiberSim/pages/demos/demos.html) to run the different simulation conditions.

The cross-bridge scheme is adjusted using the [parameter adjustment mode](https://campbell-muscle-lab.github.io/FiberSim/pages/demos/model_comparison/parameter_adjustments/parameter_adjustments.html)

You can check this works by looking at the rate figure.

````
