Project Title: showTree - A Shell Script for Displaying Directory Trees

Overview: The showTree script is a shell script that displays the directory tree of a given directory. It offers various display options, including simple indentation and advanced display modes, and allows you to specify the number of levels to display. Additionally, it can color-code files based on their type, making it easy to distinguish between directories, files, and other types of files.

Usage: To use the showTree script, simply call it from the command line and provide the path to the directory you want to display. By default, it will display the directory tree using the simple indentation mode. However, you can also use the "-a" option to enable the advanced display mode, or the "-l" option to specify the number of levels to display. The "-c" option can be used to enable color-coding of files.

Examples: To display the directory tree of the current directory using the simple indentation mode:

./showTree .

To display the directory tree of the /home/user directory using the advanced display mode:

./showTree /home/user -a

To display only the first two levels of the directory tree of the /var/log directory with color-coding:

./showTree /var/log -l 2 -c

Requirements:

  - Bash shell
  - GNU Core Utilities
  - awk

Contributing: If you find any issues or have suggestions for improvement, please feel free to open an issue or pull request on the project's GitHub repository.

License: This project is licensed under the MIT License. See the LICENSE file for more information.
