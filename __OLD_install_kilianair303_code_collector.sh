#!/bin/bash


# Function to check if the script is already installed in .bashrc
check_installed() {
    if grep -q "kilianair303_code_collector" ~/.bashrc; then
        echo "It looks like kilianair303_code_collector is already installed in your .bashrc file."
        echo "If you want to reinstall, please remove the previous installation first."
        exit 1
    fi
}

# Function to check if .bashrc file exists
check_bashrc() {
    if [ ! -f ~/.bashrc ]; then
        echo "It looks like you don't have a .bashrc file in your home directory."
        echo "This script will create one for you, but please be aware that this might"
        echo "overwrite any existing configuration you have."
        read -p "Are you sure you want to continue? (y/n) " -n 1 -r
        echo
        if [ "$REPLY" != "y" ]; then
            exit 1
        fi
    fi
}

# Function to append the code to the .bashrc file
append_to_bashrc() {
    echo "Appending kilianair303_code_collector to your .bashrc file..."
    cat kilianair303_code_collector_for_llm_chats.sh >> ~/.bashrc
    echo "Done! Please restart your terminal or run 'source ~/.bashrc' to apply the changes."
}

# Function to print a warning message
print_warning() {
    echo "WARNING: This script will collect all files in your current directory and subdirectories."
    echo "Please make sure you have reviewed the code and understand what it does before running it."
}

# Main script execution
check_installed
check_bashrc
append_to_bashrc
print_warning
