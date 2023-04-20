#!/bin/bash

# Enable nullglob shell option to check whether or not *.extension files exist in a directory and built-in Bash shell which enables or disables current shell session options 
shopt -s nullglob

# Initialize directory and file counters
dir_count=0
file_count=0

# Read the type of display to use and the maximum depth to go
read -p "Chosir quelles types d'affichage '1' pour un affichage simple \"simple\"  et '2' pour un affichage \"avancé\" : " type_affichage
read -p "Saisissez le nombre de niveaux à visualiser : " max_profondeur

# Define showtree function
showtree() {
  # Set local variables to function arguments
  local directory=$1
  local prefix=$2
  local profondeur=$3

  # If the current depth is greater than the maximum depth, return
  if [ $profondeur -gt $max_profondeur ]; then
    return
  fi
  
  # Increment directory counter
  dir_count=$(($dir_count + 1))

  # Read in a list of threads in the current directory
  local children=("$directory"/*)
  # the children array is an array that contains the names of files and directories in a given directory
  # we set the child_count variable to the number of elements in the children array
  local child_count=${#children[@]}

  # Iterate over threads
  for idx in "${!children[@]}"; do
   # Set child to current list item
    local child=${children[$idx]}

    # Set child prefix and pointer variables based on position of child in list
    local child_prefix="\e[1;37m│   "
    local pointer="\e[1;37m├── "

    if [ $idx -eq $((child_count - 1)) ]; then
      pointer="\e[1;37m└── "
      child_prefix="    "
    fi

   # Show son based on selected display type
    if [ $type_affichage = "1" ]; then
      echo -e "${prefix}${pointer}${child##*/}"
      
    elif [ $type_affichage = "2" ]; then
    # Set color and icon variables according to the type of the thread (file or directory)
      if [[ -f "$child" ]]; then
        color="\e[1;36m"
        icone=📄
      fi
      if [[ -d "$child" ]]; then
        icone=📁
        color="\e[1;33m"
      fi
      # Check if the file is an image file type
      if [[ "$child" == *.jpg ]] || [[ "$child" == *.png ]] || [[ "$child" == *.jpeg ]] || [[ "$child" == *.gif ]]; then
	    color="\e[1;35m"
	    icone=🖼️" "
	fi
      # extracts the file or directory name from the full path specified in the child string
      echo -e "${prefix}${pointer}${color}${icone} ${child##*/}"
    fi

    # If the child is a directory, recursively call the showtree function
    if [ -d "$child" ]; then
      showtree "$child" "${prefix}$child_prefix" $((profondeur + 1))
    else
    # If the child is a file, increment the file counter
      file_count=$((file_count + 1))
    fi
  done
}

# Set the root directory to the current directory unless a command line argument is provided
racine="."
# checks if the number of arguments passed to the script is non-zero
[ "$#" -ne 0 ] && racine="$1"
echo $racine

# Call the show tree function to list the files and directories in the specified directory tree with a maximum depth of 1.
showtree $racine "" 1
echo
# Display the total number of directories and files encountered during the traversal
echo -e "\e[1;33m$(($dir_count - 1)) directories \e[1;37m| \e[1;36m$file_count files "
shopt -u nullglob
