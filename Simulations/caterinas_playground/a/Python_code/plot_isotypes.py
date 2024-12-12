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
sys.path.append('../../../code/fiberpy/fiberpy/package/modules/analysis')
import dump_file_analysis as dump_analysis

def plot_myosin_isotypes():
    """ Code plots myosin isotypes from dump file """

    # Work out where the data are    
    top_data_folder = '../sim_data/sim_output'
    
    m_no_of_isotypes = 2
    m_no_of_states = 4
    
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
  
    # Now we can make a figure with one column per condition
    no_of_rows = m_no_of_isotypes * m_no_of_states + 1
    no_of_cols = no_of_conditions
        
    fig = plt.figure(constrained_layout = False)
    spec = gridspec.GridSpec(nrows = no_of_rows,
                             ncols = no_of_cols,
                             figure = fig,
                             wspace = 1,
                             hspace = 1)
    fig.set_size_inches([no_of_conditions * 4, 20])
    
    ax = []
    for i in range(no_of_rows):
        for j in range(no_of_cols):
            ax.append(fig.add_subplot(spec[i,j]))
    
    # Get the default colors
    color_map = [p['color'] for p in plt.rcParams['axes.prop_cycle']]
    
    # Set some holders
    min_force = np.inf
    max_force = -np.inf        
            
    # Loop through the simulations
    for i in range(no_of_conditions):
        condition_folder = os.path.join(top_data_folder,
                                        ('%i' % (i+1)))
        
        # Get the status folders for the condition
        status_folders = []
        for file in os.listdir(condition_folder):
            test = os.path.join(condition_folder, file)
            if (os.path.isdir(test)):
                status_folders.append(test)
                    
        # Sort them
        status_folders = natsorted(status_folders)
        
        # Now loop through the status folders, picking up the status file
        # There should only be 1 in each folder
        dump_files = []
        
        for sf in status_folders:
            for file in os.listdir(sf):
                dump_files.append(os.path.join(sf, file))
        
        # Sort them
        dump_files = natsorted(dump_files)

        # Set up to store data
        no_of_trials = len(dump_files)

        pCa = np.NaN * np.ones(no_of_trials)        
        force = np.NaN * np.ones(no_of_trials)
        hs_length = np.NaN * np.ones(no_of_trials)
        m_iso_state_pop = np.NaN * np.ones((no_of_trials,
                                            m_no_of_isotypes,
                                            m_no_of_states))
        
        # Loop through the trials
        for (fi, file) in enumerate(dump_files):
            
            (hs, thick) = dump_analysis.extract_dump_data(file)
            
            pCa[fi] = hs['pCa']
            force[fi] = hs['hs_force']
            hs_length[fi] = hs['hs_length']
            
            for s in range(thick['m_no_of_states']):
                for iso in range(thick['m_no_of_isotypes']):
                    m_iso_state_pop[fi][iso][s] = thick['states'][s][iso]
                    
        
        # Now plot the data
        plot_index = i
        ax[plot_index].plot(pCa, force, 'o-', color=color_map[i])
        
        # Note the min and max force
        if (np.amin(force) < min_force):
            min_force = np.amin(force)
        if (np.amax(force) > max_force):
            max_force = np.amax(force)
        
        # Cycle through the isotypes and states
        for s in range(thick['m_no_of_states']):
            for iso in range(thick['m_no_of_isotypes']):
                
                plot_index = i + \
                    ((iso * thick['m_no_of_states']) + s + 1) * \
                        no_of_conditions
                
                y = m_iso_state_pop[:, iso, s]
                ax[plot_index].plot(pCa, y, 'o-',
                                    color=color_map[i])
    
    # Tidy up the formatting
    for i in range(no_of_conditions):
        plot_index = i
        y_ticks = [min_force, max_force]
        ax[plot_index].set_ylim(y_ticks)
        ax[plot_index].set_yticks(y_ticks)
        ax[plot_index].set_ylabel('Force')
        ax[plot_index].invert_xaxis()
        
        for s in range(m_no_of_states):
            for iso in range(m_no_of_isotypes):
                
                plot_index = i + \
                    ((iso * thick['m_no_of_states']) + s + 1) * \
                        no_of_conditions
                        
                ax[plot_index].set_ylim([0, 1])
                ax[plot_index].set_ylabel('m_iso_%i\nstate_%i' % (iso+1, s+1),
                                          rotation=0)
                ax[plot_index].invert_xaxis()
    
    # Save fig
    output_file_string = os.path.join(top_data_folder, 'isotypes.png')
    fig.savefig(output_file_string, bbox_inches='tight')
    
if __name__ == "__main__":
    plot_myosin_isotypes()
