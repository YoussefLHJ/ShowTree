#!/bin/bash

# Enable nullglob shell option
shopt -s nullglob

# Initialize variables
dir_count=0
file_count=0
show_icons=true
max_depth=-1
help=false

# Function to display help
show_help() {
    echo "Usage: showtree [OPTIONS] [DIRECTORY]"
    echo "Options:"
    echo "  -d NUM   Limit recursion depth to NUM (default: unlimited)"
    echo "  -i       Disable icons in output"
    echo "  -h       Display this help message"
    exit 0
}

# Get command-line options
while getopts "d:ih" opt; do
    case $opt in
        d) max_depth=$OPTARG ;;
        i) show_icons=false ;;
        h) help=true ;;
        *) show_help ;;
    esac
done

# Shift off options and arguments so that $1 is the directory
shift $((OPTIND-1))

# If help was requested, display it and exit
if [ "$help" = true ]; then
    show_help
fi

# Define showtree function
showtree() {
  local directory=$1
  local prefix=$2
  local current_depth=$3

  # Stop recursion if current depth exceeds the maximum depth
  if [ "$max_depth" -ge 0 ] && [ "$current_depth" -gt "$max_depth" ]; then
    return
  fi

  dir_count=$((dir_count + 1))

  # Get all children (files and directories)
  local children=("$directory"/*)
  local child_count=${#children[@]}

  for idx in "${!children[@]}"; do
    local child=${children[$idx]}
    local child_prefix="\e[1;37m│   "
    local pointer="\e[1;37m├── "

    # Adjust pointers for the last child
    if [ $idx -eq $((child_count - 1)) ]; then
      pointer="\e[1;37m└── "
      child_prefix="    "
    fi

    # Set color and icons based on file extension
    local color="\e[1;37m"
    local icone="📄"

    if [[ -d "$child" ]]; then
      color="\e[1;33m"
      icone="📦"
    elif [[ "$child" == *.jpg || "$child" == *.png ]]; then
      color="\e[1;92m"
      icone="🖼️ "
    elif [[ "$child" == *.pdf ]]; then
      color="\e[1;91m"
      icone="📕"
    elif [[ "$child" == *.java ]]; then
      color="\e[38;2;139;69;19m"
      icone="☕"
    elif [[ "$child" == *.c ]]; then
      color="\e[1;37m"
      icone="🖥️ "
    elif [[ "$child" == *.cpp || "$child" == *.hpp ]]; then
      color="\e[1;37m"
      icone="➕"
    elif [[ "$child" == *.py ]]; then
      color="\e[1;33m"  # Yellow color for Python files
      icone="🐍"
    # Add more file types here as necessary
    fi

    # Display file name with or without icon based on -i option
    if [ "$show_icons" = true ]; then
      echo -e "${prefix}${pointer}${color}${icone} ${child##*/}"
    else
      echo -e "${prefix}${pointer}${color}${child##*/}"
    fi

    # Recursively call showtree if it's a directory
    if [ -d "$child" ]; then
      showtree "$child" "${prefix}$child_prefix" $((current_depth + 1))
    else
      file_count=$((file_count + 1))
    fi
  done
}

# Set root directory (use current directory by default)
racine="."
[ "$#" -ne 0 ] && racine="$1"

# Call showtree with depth starting at 0
showtree "$racine" "" 0
echo

# Display total number of directories and files
echo -e "\e[1;33m$(($dir_count - 1)) Package \e[1;90m| \e[1;37m$file_count File "

# Disable nullglob shell option
shopt -u nullglob
