#!/bin/bash

# Check if the user provided any arguments
if [ $# -eq 0 ]; then
  echo "No directories provided."
  exit 1
fi

# Loop through the arguments
for dir in "$@"; do
  # Check if the directory exists
  if [ ! -d "$dir" ]; then
    echo "Directory $dir does not exist."
    continue
  fi

  # Print the name of the directory
  echo "Directory: $dir"

  # List the contents of the directory
  ls -a "$dir"
done


#This script first checks if the user provided any arguments. If not, it prints a message and exits.

#Next, the script loops through the arguments. For each argument, it checks if the directory exists. If not, it prints a message and continues to the next argument.

#If the directory exists, the script prints the name of the directory and then lists the contents of the directory using the ls command.
