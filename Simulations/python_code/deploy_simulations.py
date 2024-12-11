import sys
import json
import os
import copy
import shutil

import multiprocessing
import threading
import subprocess

from pathlib import Path


def generate_command_strings(master_file_string):
    """ Parses the master file string to create a sequence of setup files
        that run the defined simulations plus the command strings
        that will launch them """
    
    # Open up master json file and load entire file as a dict
    with open(master_file_string, 'r') as f:
        master = json.load(f)
        
    # Pull off the location for the setup files
    base_dir = return_base_dir(master['setup_files'], master_file_string)
    setup_folder = os.path.join(base_dir, master['setup_files']['setup_folder'])
    
    # Clean the folder and remake it
    try:
        print('Trying to remove: %s' % setup_folder)
        shutil.rmtree(setup_folder, ignore_errors = True)
    except OSError as e:
        print('Error: %s : %s' % (setup_folder, e.strerror))
        
    if not os.path.isdir(setup_folder):
        os.makedirs(setup_folder)

    # Pull off the shared components
    shared_elements = master['shared_elements']

    # Pull off the shared models
    shared_models = shared_elements['model_types']

    # Create a list holding the model types
    model_type_list = []
    for sm in shared_models:
        model_type_list.append(sm['type'])

    unique_sims = master['simulations']

    # Loop through the unique simulations

    for (sim_counter, sim) in enumerate(unique_sims):

        # Create a new dict for the setup file
        d = dict()
        d['FiberSim_setup']= dict()
        
        # Add in the FiberSim_Cpp element
        # We need to convert to absolute paths
        Cpp_exe = shared_elements['FiberSim_Cpp']['FiberCpp_exe']
        base_dir = return_base_dir(Cpp_exe, master_file_string)
        d['FiberSim_setup']['FiberCpp_exe'] = dict()
        d['FiberSim_setup']['FiberCpp_exe']['relative_to'] = 'False'
        d['FiberSim_setup']['FiberCpp_exe']['exe_file'] = \
            str(Path(os.path.join(base_dir, Cpp_exe['exe_file'])).absolute().resolve())
            
        # Add in the model element
        # Again, start by copying the master
        new_model = copy.deepcopy(shared_elements['model'])
        
        # We need to convert to absolute paths
        base_dir = return_base_dir(new_model, master_file_string)
        new_model['relative_to'] = 'False'
        new_model['options_file'] = str(Path(os.path.join(base_dir,
                                                          new_model['options_file'])).absolute().resolve())
        new_model['manipulations']['generated_folder'] = \
            str(Path(os.path.join(base_dir,
                                  new_model['manipulations']['generated_folder'])).absolute().resolve())

        # Now tweak that to add the right base model and
        # Find the right model_element to add
        model_ind = model_type_list.index(sim['model_type'])
        
        # Pull off the model type and adjust for absolute path
        mt = shared_elements['model_types'][model_ind]
        base_dir = return_base_dir(mt, master_file_string)
        
        new_model['manipulations']['base_model'] = \
            os.path.join(base_dir,
                         shared_elements['model_types'][model_ind]['model'])

        # Add an index to the generated folder
        new_model['manipulations']['generated_folder'] = \
            os.path.join(new_model['manipulations']['generated_folder'],
                         '%i' % (sim_counter+1))
            
        # Now find the adjustments in the sim and add them to the model
        if ('adjustments' in sim):
            new_model['manipulations']['adjustments'] = \
                copy.deepcopy(sim['adjustments'])

        # Add the model to the setup
        d['FiberSim_setup']['model'] = new_model

        # Now add the characterization
        new_characterization = \
            copy.deepcopy(shared_elements['characterization'])
            
        # Adjust the sim_folder with the tag
        new_characterization['sim_folder'] = \
            os.path.join(new_characterization['sim_folder'],
                         sim['tag'])
            
        # Now the extra fields
        if ('characterization' in sim):
            for key in sim['characterization']:
                new_characterization[key] = \
                    sim['characterization'][key]
                    
        # Adjust the sim_data paths
        base_dir = return_base_dir(new_characterization,
                                   master_file_string)
        new_characterization['relative_to'] = 'False'
        new_characterization['sim_folder'] = \
            os.path.join(base_dir, new_characterization['sim_folder'])

        # Add in to the setup
        d['FiberSim_setup']['characterization'] = []
        d['FiberSim_setup']['characterization'].append(new_characterization)
            
        # Now generate a setup file name
        setup_file_string = os.path.join(setup_folder,
                                         ('setup_%s.json' % sim['tag']))
        
        print(setup_file_string)
        
        # Write it
        with open(setup_file_string, 'w') as f:
            json.dump(d, f, indent=4)
            
    # Now deduce the FiberPy path from the shared elements
    base_dir = return_base_dir(master['setup_files'], master_file_string)
    FiberCpp_dir = os.path.join(base_dir,
                                shared_elements['FiberSim_Cpp']['FiberCpp_exe']['exe_file'])
    FiberCpp_dir = str(Path(FiberCpp_dir).parent.absolute().resolve())
    FiberPy_dir = os.path.join(FiberCpp_dir, '../code/FiberPy/FiberPy')
    FiberPy_dir = str(Path(FiberPy_dir).absolute().resolve())
    
    # Now generate a list of command strings
    command_strings = []
    
    # Get the setup files
    for file in os.listdir(setup_folder):
        if (file.endswith('.json')):
            full_file = os.path.join(setup_folder, file)
            cs = 'pushd \"%s\" & python FiberPy.py characterize \"%s\" & popd' % \
                    (FiberPy_dir, full_file)
            command_strings.append(cs)
            
    # Return the command strings
    return command_strings
        
def return_base_dir(struct, file_string):
    base_dir = ''
    if ('relative_to' in struct):
        if (struct['relative_to'] == 'this_file'):
            base_dir = str(Path(file_string).parent.absolute().resolve())
        elif not (struct['relative_to'] == 'False'):
            base_dir = struct['relative_to']
    return base_dir

def worker(cmd):
    """ Launches a command string """
    print('command_string: %s' % cmd)
    subprocess.call(cmd)
    
if __name__ == "__main__":
    """ Code parses the master setup file string,
        generates a list of command files, and then
        runs them """
        
    master_file_string = sys.argv[1]

    command_strings = generate_command_strings(master_file_string)

    for cs in command_strings:
        os.system(cs)
