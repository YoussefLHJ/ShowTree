#!/bin/bash

# Enable nullglob shell option to check whether or not *.extension files exist in a directory and built-in Bash shell which enables or disables current shell session options 
shopt -s nullglob

# Initialize directory and file counters
dir_count=0
file_count=0

# Define showtree function
showtree() {
  # Set local variables to function arguments
  local directory=$1
  local prefix=$2

  # Increment directory counter
  dir_count=$(($dir_count + 1))

  # Read in a list of threads in the current directory
  local children=("$directory"/*)
  local child_count=${#children[@]}

  # Iterate over threads
  for idx in "${!children[@]}"; do
    local child=${children[$idx]}

    # Set child prefix and pointer variables based on position of child in list
    local child_prefix="\e[1;37m│   "
    local pointer="\e[1;37m├── "

    if [ $idx -eq $((child_count - 1)) ]; then
      pointer="\e[1;37m└── "
      child_prefix="    "
    fi

    if [[ -f "$child" ]]; then
      color="\e[1;97m"
      icone=📄
    fi
    if [[ -d "$child" ]]; then
      icone=📦
      color="\e[1;33m"
    fi
    if [[ "$child" == *.jpg ]] || [[ "$child" == *.svg ]] || [[ "$child" == *.png ]] || [[ "$child" == *.jpeg ]] || [[ "$child" == *.gif ]]; then
      color="\e[1;92m"
      icone="🖼️ "
    fi
    if [[ "$child" == *.class ]] || [[ "$child" == *.java ]]; then
	  color="\e[38;2;139;69;19m" 
	  icone="☕"
	fi
    if [[ "$child" == *.jar ]]; then
      color="\e[38;5;208m"
      icone="🗂️ "
    fi
    if [[ "$child" == *.xml ]]; then
      color="\e[1;94m"
      icone="🔧"
    fi
    if [[ "$child" == *.xhtml ]]; then
      color="\e[1;34m"
      icone="🌐"
    fi
    if [[ "$child" == *.html ]]; then
      color="\e[1;94m"
      icone="🌐"
    fi	
    if [[ "$child" == *.pdf ]]; then 
		color="\e[1;91m"
		icone="📕"
    fi
    if [[ "$child" == *.css ]]; then 
		color="\e[1;36m"
		icone="🎨"
    fi
    if [[ "$child" == *.js ]]; then 
		color="\e[1;93m"
		icone="🚀"
    fi
    if [[ "$child" == *.jrxml ]] || [[ "$child" == *.jasper ]]; then 
		color="\e[1;96m"
		icone="📊"
    fi
    if [[ "$child" == *.scss ]]; then 
		color="\e[1;95m"
		icone="🎨"
    fi
    if [[ "$child" == *.mp3 ]] || [[ "$child" == *.wav ]] || [[ "$child" == *.flac ]] || [[ "$child" == *.ogg ]]; then
		color="\e[1;90m"  
		icone="🎵"
    fi
    if [[ "$child" == *.txt ]] || [[ "$child" == *.md ]] || [[ "$child" == *.log ]] || [[ "$child" == *.cfg ]] || [[ "$child" == *.yaml ]]; then
    	color="\e[1;37m" 
    	icone="📝"           
    fi
	if [[ "$child" == *.properties ]]; then 
		color="\e[1;35m"
		icone="🛠️ "
    fi
	if [[ "$child" == *.wsdl ]]; then 
		color="\e[1;32m"
		icone="🛰️ "
    fi
    if [[ "$child" == *.war ]]; then 
		color="\e[1;31m"
		icone="🌍 "
    fi

    # extracts the file or directory name from the full path specified in the child string
    echo -e "${prefix}${pointer}${color}${icone} ${child##*/}"

    # If the child is a directory, recursively call the showtree function
    if [ -d "$child" ]; then
      showtree "$child" "${prefix}$child_prefix"
    else
      # If the child is a file, increment the file counter
      file_count=$((file_count + 1))
    fi
  done
}

# Set the root directory to the current directory unless a command line argument is provided
racine="."
[ "$#" -ne 0 ] && racine="$1"

# Call the show tree function to list the files and directories in the specified directory tree with no maximum depth limit.
showtree "$racine" ""
echo

# Display the total number of directories and files encountered during the traversal
echo -e "\e[1;33m$(($dir_count - 1)) Package \e[1;90m| \e[1;37m$file_count File "

# Disable nullglob shell option
shopt -u nullglob

