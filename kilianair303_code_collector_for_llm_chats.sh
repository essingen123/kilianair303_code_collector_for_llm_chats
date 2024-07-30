#!/bin/bash

kilianair303_code_collector() {
  local file_type=$1
  local files_to_include_file="__a__kilian___INCLUDE_FILE_LIST.txt"
  local collected_code_file="__a__kilian___COLLECTED_CODE___.${file_type:-txt}"
  local ignore_gitignore=${2:-false}

  __create_files_to_include_file() {
    if [ ! -f "$files_to_include_file" ]; then
      > "$files_to_include_file"
      find . -type f -o -type d | while read file; do
        [[ "$file" == *.git* ]] && echo "# $file" >> "$files_to_include_file" || \
        [[ -d "$file" || "${file##*/}" == "."* || "${file##*/}" =~ \.(wav|pdf|jpg|gif|mp3|ogg|wmv|API_KEY|PASSWORD)$ ]] && echo "# ${file##*/}" >> "$files_to_include_file" || echo "${file##*/}" >> "$files_to_include_file"
      done
    fi
  }

  __get_files_list() {
    case $file_type in
      python) files_list+=($(find . -type f -name "*.py" -print));;
      sh) files_list+=($(find . -type f -name "*.sh" -print));;
      *) files_list+=($(find . -type f -not -name "*.gif" -not -name "*.jpg" -not -name "*.pdf" -not -name "*.wav" -not -name "*.mp3" -not -name "*.ogg" -not -name "*.wmv" -print));;
    esac
    find . -type d | while read dir; do
      case $file_type in
        python) files_list+=($(find "$dir" -type f -name "*.py" -print));;
        sh) files_list+=($(find "$dir" -type f -name "*.sh" -print));;
        *) files_list+=($(find "$dir" -type f -not -name "*.gif" -not -name "*.jpg" -not -name "*.pdf" -not -name "*.wav" -not -name "*.mp3" -not -name "*.ogg" -not -name "*.wmv" -print));;
      esac
    done
    echo "${files_list[@]}"
  }

  __update_files_to_include_file() {
    if [ -f "$files_to_include_file" ]; then
      for file in "${files_list[@]}"; do
        filename="${file##*/}"
        if ! grep -q "^${filename}$" "$files_to_include_file" && ! grep -q "^#${filename}$" "$files_to_include_file"; then
          for existing_file in $(grep -v '^#' "$files_to_include_file"); do
            if [[ "$existing_file" == *"${filename%_*}"* ]]; then
              continue 2
            fi
          done
          [[ "$file" == *.git* ]] && echo "# $file" >> "$files_to_include_file" || \
          [[ -d "$file" || "${file##*/}" == "."* || "${file##*/}" =~ \.(wav|pdf|jpg|gif|mp3|ogg|wmv|API_KEY|PASSWORD)$ ]] && echo "# ${file##*/}" >> "$files_to_include_file" || echo "${file##*/}" >> "$files_to_include_file"
        fi
      done
    fi
  }

  __create_collected_code_file() {
    rm -f "$collected_code_file"
    echo "# This is a collection of all the files that should be relevant for the project..." >> "$collected_code_file"
    grep -v '^#' "$files_to_include_file" | while read file; do
      echo -e "\n# $(realpath --relative-to=. "$file")\n" >> "$collected_code_file"
      cat "$file" >> "$collected_code_file"
    done
  }

  __create_alias() {
    if ! alias fox_alias &> /dev/null; then
      wget https://raw.githubusercontent.com/essingen123/bashrc_alias_fox/master/alias_script.sh -O alias_script.sh && chmod +x alias_script.sh && ./alias_script.sh
      if ! alias sc &> /dev/null; then
        fox_alias sc 'kilianair303_code_collector sh'
        fox_alias pc 'kilianair303_code_collector python'
        fox_alias fc2 'kilianair303_code_collector'
      fi
    fi
  }

  local files_list=($(__get_files_list))
  if [ ! -f "$files_to_include_file" ]; then
    __create_files_to_include_file
    __update_files_to_include_file
    echo "File list created. Press Enter to continue..."
    read -p ""
    exit
  else
    __update_files_to_include_file
    if [ "$(grep -v '^#' "$files_to_include_file" | wc -l)" -eq "${#files_list[@]}" ]; then
      __create_collected_code_file
      __create_alias
    else
      echo "Not all files are listed. Press Enter to continue..."
      read -p ""
      exit
    fi
  fi
}

kilianair303_code_collector "$@"