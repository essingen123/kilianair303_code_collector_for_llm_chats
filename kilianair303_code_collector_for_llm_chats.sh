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
      [[ $(grep -q "^${file##*/}$" .gitignore) || ${file##*/} == "."* || ${file##*/} =~ \.(wav|pdf|jpg|gif|mp3|ogg|wmv|API_KEY|PASSWORD)$ ]] || echo "${file##*/}" >> "$INCLUDE_FILE"
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
  grep -v '^#' "$INCLUDE_FILE" | grep -v "$COLLECTED_CODE_FILE" | while read file; do
    echo -e "\n### FILE_NAME: $(realpath --relative-to=. "$file")\n" >> "$COLLECTED_CODE_FILE"
    cat "$file" >> "$COLLECTED_CODE_FILE"
  done
}

# create_alias() {
#   if ! alias fox_alias &> /dev/null; then
#     wget https://raw.githubusercontent.com/essingen123/bashrc_alias_fox/master/alias_script.sh -O alias_script.sh && chmod +x alias_script.sh && ./alias_script.sh
#     if ! alias sc &> /dev/null; then
#       fox_alias sc 'kilianair303_collector.sh sh'
#       fox_alias pc 'kilianair303_collector.sh python'
#       fox_alias fc2 'kilianair303_collector.sh '
#       fox_alias f 'kilianair303_collector.sh '
#     fi
#   fi
# }

kilianair303_collector() {
  local file_type=$1
  local files_list=($(get_files_list "$file_type"))
  if [[ ! -f "$INCLUDE_FILE" ]]; then
    create_files_to_include_file
    update_files_to_include_file
    echo "File list created. Press Enter to continue..."
    read -p ""
    exit
  else
    update_files_to_include_file
    create_collected_code_file
    # create_alias
  fi
}

kilianair303_collector "$@"