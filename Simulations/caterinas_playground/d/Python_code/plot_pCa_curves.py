# -*- coding: utf-8 -*-
"""
Created on Thu Jan 18 17:48:35 2024

@author: Campbell
"""

"""
Created on Sat Sep 16 15:16:23 2023

@author: Campbell
"""
import os
import sys

import numpy as np
import pandas as pd

import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

from natsort import natsorted

from pathlib import Path

# Add FiberSim code to path
sys.path.append('../../../code/fiberpy/fiberpy/package/modules/display')
import analyses as anal

def plot_pCa_curves_isotypes():
    """ Code plots pCa_curves """

    # Work out where the data are    
    top_data_folder = '../sim_data/sim_output'
    
    
    # Adapt because it is relative to this file
    parent_dir = Path(__file__).parent.absolute()
    top_data_folder = Path(os.path.join(parent_dir, top_data_folder)).resolve()
    
    # Display
    print('Top data folder')
    print(top_data_folder)
    
    # Find out how many simulations there are
    no_of_conditions = 1
    keep_going = True

    while (keep_going):
        condition_folder = os.path.join(top_data_folder,
                                        ('%i' % (no_of_conditions)))

        if os.path.isdir(condition_folder):
            no_of_conditions = no_of_conditions + 1
        else:
            keep_going = False
            
    no_of_conditions = no_of_conditions - 1
   
    # Set some holders
    min_force = np.inf
    max_force = -np.inf        
            
    # Loop through the simulations, filling up an array of plot_data dataframes
    abs_data = {}
    norm_data = {}
    
    for i in range(no_of_conditions):
        condition_folder = os.path.join(top_data_folder,
                                        ('%i' % (i+1)))
        
        # Get the results files
        results_files = []
        for file in os.listdir(condition_folder):
            test_file = os.path.join(condition_folder, file)
            if ('rates.json' in test_file):
                continue
            elif (os.path.isdir(test_file)):
                continue
            else:
                results_files.append(test_file)
                    
        # Sort them
        results_files = natsorted(results_files)

        # Set up to store data
        no_of_trials = len(results_files)

        pCa = np.NaN * np.ones(no_of_trials)        
        y = np.NaN * np.ones(no_of_trials)
        
        # Loop through the trials, filling up a dictionary of dataframes
        for (fi, file) in enumerate(results_files):
            d = pd.read_csv(file, sep='\t')
            pCa[fi] = d['hs_1_pCa'].iloc[-1]
            y[fi] = d['hs_1_force'].iloc[-1]
           
        # Normalize y
        norm_y = (y - np.amin(y)) / (np.amax(y) - np.amin(y))
           
        # Set the data frames
        abs_data[i] = pd.DataFrame(data = {'pCa': pCa, 'y': y})
        norm_data[i] = pd.DataFrame(data = {'pCa': pCa, 'y': norm_y})
        
        # Normalize
        min_force = min(min_force, np.amin(y))
        max_force = max(max_force, np.amax(y))
        
    # Now we can make a figure with one column per condition
    no_of_rows = 1
    no_of_cols = no_of_conditions
        
    fig = plt.figure(constrained_layout = False)
    spec = gridspec.GridSpec(nrows = no_of_rows,
                             ncols = no_of_cols,
                             figure = fig,
                             wspace = 1,
                             hspace = 1)
    fig.set_size_inches([no_of_conditions * 4, 6])
    
    ax = []
    for i in range(no_of_rows):
        for j in range(no_of_cols):
            ax.append(fig.add_subplot(spec[i,j]))
    
    # Get the default colors
    color_map = [p['color'] for p in plt.rcParams['axes.prop_cycle']]

    for i in range(no_of_conditions):        
        anal.plot_y_pCa_data(abs_data[i], ax = ax[i], y_ticks=[0, max_force])
        
    # Save fig
    output_file_string = os.path.join(top_data_folder, 'abs_forces.png')
    fig.savefig(output_file_string, bbox_inches='tight')
    
    # Now make a new figure with comparisons
    
    # Work out how many comparisons there are
    no_of_comparisons = 1 + int((no_of_conditions - 2) / 2)
    
    # And what they are
    compar = []
    vi= [0, 1]
    compar.append(vi)
    for i in range(no_of_comparisons):
        vi = [0, 1, (2*(i+1)), (2*(i+1))+1]
        compar.append(vi)

    # Now make the figure    
    no_of_rows = 2
    no_of_cols = no_of_comparisons
        
    fig = plt.figure(constrained_layout = False)
    spec = gridspec.GridSpec(nrows = no_of_rows,
                             ncols = no_of_cols,
                             figure = fig,
                             wspace = 0.5,
                             hspace = 0.5)
    fig.set_size_inches([no_of_comparisons * 4, 6])
    
    ax = []
    for i in range(no_of_rows):
        for j in range(no_of_cols):
            ax.append(fig.add_subplot(spec[i,j]))
    
    # Get the default colors
    color_map = [p['color'] for p in plt.rcParams['axes.prop_cycle']]
    
    # Set the formatting
    formatting = {'marker_symbols': ['o','s','o', 's'],
                  'color_set': [color_map[1], color_map[1],
                                color_map[2], color_map[2]]}
    
    for i in range(no_of_comparisons):
        test_abs_pd = []
        test_norm_pd = []
        for j in compar[i]:
            test_abs_pd.append(abs_data[j])
            test_norm_pd.append(norm_data[j])
        
        anal.plot_y_pCa_data(test_abs_pd, ax=ax[i],
                             formatting_overrides=formatting)
        anal.plot_y_pCa_data(test_norm_pd, ax = ax[i+no_of_comparisons],
                             y_ticks=[0, 1], formatting_overrides=formatting)
        
    # Save fig
    output_file_string = os.path.join(top_data_folder, 'curve_comparison.png')
    fig.savefig(output_file_string, bbox_inches='tight')
    
if __name__ == "__main__":
    plot_pCa_curves_isotypes()
