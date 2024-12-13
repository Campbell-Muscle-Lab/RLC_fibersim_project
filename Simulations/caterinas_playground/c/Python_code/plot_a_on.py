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

def plot_a_on():
    """ Code plots a_on for simulation """

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
    
    # Create an empty dict
    plot_data = {}
    
    # Loop through the simulations    
    for i in range(no_of_conditions):
        condition_folder = os.path.join(top_data_folder,
                                        ('%i' % (i+1)))
        
        # Get the results files
        results_files = []
        for file in os.listdir(condition_folder):
            test_f = os.path.join(condition_folder, file)
            if ('rates.json' in test_f):
                continue
            elif (os.path.isdir(test_f)):
                continue
            else:
                results_files.append(test_f)
                
        # Sort them
        results_files = natsorted(results_files)
        
        # Now loop through them

        # Set up to store data
        no_of_trials = len(results_files)

        pCa = np.NaN * np.ones(no_of_trials)        
        y = np.NaN * np.ones(no_of_trials)
        
        # Loop through the trials
        for (fi, file) in enumerate(results_files):

            # Load the file            
            d = pd.read_csv(file, sep='\t')
            
            # Pull off data
            pCa[fi] = d['hs_1_pCa'].iloc[-1]
            y[fi] = d['hs_1_a_pop_2'].iloc[-1]
            
        # Make a dict
        d = {'pCa': pCa, 'y': y}
        
        # Make a data-frame
        data = pd.DataFrame(data=d)
        
        # Add to plot_data
        plot_data[i] = data

    # Now plot
    anal.plot_y_pCa_data(plot_data,'d:/temp/a_on.png')        
    
if __name__ == "__main__":
    plot_a_on()
