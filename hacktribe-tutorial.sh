#!/bin/bash

# Hacktribe Firmware Patching Tutorial
#
# See https://github.com/bangcorrupt/hacktribe for details.
#
# This tutorial will help you learn how to run a few bash commands and a python script.
#
# If you are running this in a default Github codespace, 
# you should find everything is already installed.
# If you are running this on your own machine,
# you will need to install git, wget, python and pip.
# 
# The rest of this tutorial assumes you are in a Github codespace.
#
# This pane is a text editor, we can use it to edit text files.
# You don't need to edit this file for this tutorial.
#
# The pane on the left is a file browser.  
# We can right-click for a context menu to upload and download files.
# 
# The pane below is a bash shell, where we can run commands and see the results.
#
# Anything starting with a '#' character is a comment and ignored by the shell 
# (you don't need to type these).  
#
# Any line not starting with '#' is a command that will be run.
# We can run commands by typing them at the prompt in the shell below, then pressing 'Enter'.
# We can also put multiple commands into a single file (a script) and run them all at once.
# This file is a script, its name is 'hacktribe-tutorial.sh'.
#
# For best results, read everything, 
# run each command separately and pay attention to the output.
#
# If you just want to see the result, run './hacktribe-tutorial.sh' in the bash shell below.  
# This will run all the commands in this file.
# Note the './' prefix to the file name.  
# This tells the shell to look for the file in the current working directory.
#
#
# Happy hacking!


# First we need to download some files.  

# Clone the repo, including all submodules:
git clone --recursive https://github.com/bangcorrupt/hacktribe.git

# This will get a copy of all the Hacktribe project files.

# Then change directory to the 'hacktribe' directory we just downloaded:
cd hacktribe

# Next we need to download the factory firmware.  
# This is proprietary and copyrighted.  
# Please only download it for yourself and do not distribute it.  
# 
# 'wget' command can be used to download files if we know the URL:
wget https://cdn.korg.com/us/support/download/files/0b87bcd3112fbb8c0ad7b0f55e618837.zip

# Use the 'ls' command to list files in the current directory:
ls

# Unzip the zip archive we just downloaded to access the files inside:
unzip 0b87bcd3112fbb8c0ad7b0f55e618837.zip

# Use 'ls directory' to list files in a directory named 'directory':
ls electribe_sampler_system_v202

# Move the firmware update file 'SYSTEM.VSB' to our current directory '.' :
mv electribe_sampler_system_v202/SYSTEM.VSB .

# Now we have all the files in the right places.

# Next, make sure the required python packages are installed:
pip install argparse bsdiff4

# Now we are ready to run the firmware patching script.
# This will apply the Hacktribe patch to the factory firmware,
# then check the sha256 hash of the patched file.
# If the hashes match, you have the same file I tested.
# If not, you will get a scary error message saying 'patch failed' or something.
#
# Run the firmware patching script for sampler:
python scripts/e2-firmware-patch.py

# This should produce a file called hacked-SYSTEM.VSB, 
# which can be used to install Hacktribe on Electribe 2 Sampler.

# We can rename a file by moving it to a file with a different name:
mv hacked-SYSTEM.VSB sampler-hacked-SYSTEM.VSB

# If you're installing Hacktribe to a factory synth (grey or blue) 
# for the first time, we need to modify the update file header as well.
# This will change some bytes in the file that tell the device what type of file it is.
# (If you already have a previous version of Hacktribe installed, this is not necessary).
#
# Run the firmware patching script for synth, using '-e' flag to edit the header:
python scripts/e2-firmware-patch.py -e

# Again, we can rename the file to something more descriptive:
mv hacked-SYSTEM.VSB synth-hacked-SYSTEM.VSB


# If the patching was successful, 
# you should see 'Firmware patched successfully' in the output from the script.  

# Reverting to the factory firmware has minor differences depending on original firmware type.
# For Sampler, just install factory sampler firmware version 2.02, no editing necessary.
# For Synth, we need to edit the file header to look like sampler firmware.

# First we need to download the factory synth firmware.  
# This is proprietary and copyrighted.  
# Please only download it for yourself and do not distribute it.  
#
wget https://cdn.korg.com/us/support/download/files/89f5b5eb14071e3456ceedd534618d8a.zip

# Use the 'ls' command to list files in the current directory:
ls

# Unzip the zip archive we just downloaded to access the files inside:
unzip 89f5b5eb14071e3456ceedd534618d8a.zip

# Use 'ls directory' to list files in a directory named 'directory':
ls electribe_system_v202

# Move the firmware update file 'SYSTEM.VSB' to our current directory '.' :
mv electribe_system_v202/SYSTEM.VSB .

# Run another python script to edit the file header:
python scripts/e2-header.py SYSTEM.VSB sampler

# Rename the file to something more descriptive:
mv SYSTEM.VSB synth-revert-SYSTEM.VSB


# The patching is complete now, the rest is just tidying up.


# We can match multiple file names using the wildcard '*' operator.
# Move all files with names ending '-SYSTEM.VSB' to the parent directory:
mv *-SYSTEM.VSB ..

# Change directory to parent directory:
cd ..

# Delete all the files we downloaded:
rm -rf hacktribe

# List files in our current working directory, showing some extra details:
ls -lah

# Continue with 'Install patched firmware' in the Hacktribe Wiki: 
# https://github.com/bangcorrupt/hacktribe/wiki/How-To#install-patched-firmware

# Copy the relevant '*-hacked-SYSTEM.VSB' to the 'System' directory on the SD card, 
# rename it to 'SYSTEM.VSB' and run the firmware update function on the device.

# If you currently have Electribe 2 Sampler firmware installed, put 'sampler-hacked-SYSTEM.VSB' at:
# 'KORG/electribe sampler/System/SYSTEM.VSB'

# If you currently have Electribe 2 Synth firmware installed, put 'synth-hacked-SYSTEM.VSB' file at:
# 'KORG/electribe/System/SYSTEM.VSB'

# If you currently have a very old version of Hacktribe firmware installed, put 'sampler-hacked-SYSTEM.VSB' file at:
# 'KORG/electribe sampler/System/SYSTEM.VSB'

# If you currently have a more recent version of Hacktribe firmware installed, put 'sampler-hacked-SYSTEM.VSB' file at:
# 'KORG/hacktribe/System/SYSTEM.VSB'

# If you want to revert from Hacktribe to the factory firmware, put the relevant *SYSTEM.VSB file at:
# 'KORG/hacktribe/System/SYSTEM.VSB'

# See https://github.com/bangcorrupt/hacktribe/discussions/41 if you are having difficulties
