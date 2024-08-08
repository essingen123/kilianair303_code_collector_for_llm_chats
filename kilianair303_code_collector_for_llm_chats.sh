#!/bin/bash

# Constants
SKIP_GIT_FOLDER=true
IGNORE_GITIGNORE=true
INCLUDE_FILE="__a__kilian___INCLUDE_FILE_LIST.txt"
COLLECTED_CODE_FILE="__a__kilian___COLLECTED_CODE___${file_type:-txt}"

# Functions
create_files_to_include_file() {
  [[ ! -f "$INCLUDE_FILE" ]] && {
    > "$INCLUDE_FILE"
    find . -type f -o -type d | grep -v '/\.git/' | while read file; do
      [[ $(grep -q "^${file##*/}$" .gitignore) || ${file##*/} =~ ^# || ${file##*/} == "."* || ${file##*/} =~ \.(wav|pdf|jpg|gif|mp3|ogg|wmv|API_KEY|PASSWORD)$ ]] || echo "$(realpath --relative-to=. "$file")" >> "$INCLUDE_FILE"
    done
  }
}

get_files_list() {
  local files_list=()
  case $1 in
    python) files_list+=($(find . -type f -name "*.py" -print));;
    sh) files_list+=($(find . -type f -name "*.sh" -print));;
    *) files_list+=($(find . -type f -not -name "*.gif" -not -name "*.jpg" -not -name "*.pdf" -not -name "*.wav" -not -name "*.mp3" -not -name "*.ogg" -not -name "*.wmv" -print));;
  esac
  find . -type d | grep -v '\.git/' | while read dir; do
    case $1 in
      python) files_list+=($(find "$dir" -type f -name "*.py" -print));;
      sh) files_list+=($(find "$dir" -type f -name "*.sh" -print));;
      *) files_list+=($(find "$dir" -type f -not -name "*.gif" -not -name "*.jpg" -not -name "*.pdf" -not -name "*.wav" -not -name "*.mp3" -not -name "*.ogg" -not -name "*.wmv" -print));;
    esac
  done
  echo "${files_list[@]}"
}

update_files_to_include_file() {
  touch "$INCLUDE_FILE"
}

create_collected_code_file() {
  rm -f "$COLLECTED_CODE_FILE"
  echo "###### This is a collection of content of files that could be relevant: " >> "$COLLECTED_CODE_FILE"
  echo "Edit this script with 'code $(realpath --relative-to=. "$0")'" >> "$COLLECTED_CODE_FILE"
  echo "Files collected from: $(find . -type f -name "__a__kilian___code_collector___*")" >> "$COLLECTED_CODE_FILE"
  grep -v '^#' "$INCLUDE_FILE" | grep -v "$COLLECTED_CODE_FILE" | while read file; do
    echo -e "\n### FILE_NAME: $file\n" >> "$COLLECTED_CODE_FILE"
    cat "$file" >> "$COLLECTED_CODE_FILE"
  done
}

kilianair303_collector() {
  local file_type=$1
  local files_list=($(get_files_list "$file_type"))
  if [[ ! -f "$INCLUDE_FILE" ]]; then
    create_files_to_include_file
    update_files_to_include_file
    echo "This is the file: $INCLUDE_FILE"
    echo "File list created. "
    echo "Pick the files you wish to include"
    echo "Run this again after your check please! Press Enter to continue..."
    read -p ""
    exit
  else
    update_files_to_include_file
    create_collected_code_file
    echo "File created: $COLLECTED_CODE_FILE"
    echo "File size: $(stat -c%s "$COLLECTED_CODE_FILE") bytes"
    echo "File location: $(realpath --relative-to=. "$COLLECTED_CODE_FILE")"
  fi
}

kilianair303_collector "$@"
