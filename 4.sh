#!/bin/bash

rename_file() {
  local old_name="$1"
  local new_name="$2"
  if [ -e "$new_name" ]; then
    echo "Ошибка: файл \"$new_name\" уже существует"
  else
    mv "$old_name" "$new_name"
    echo "Файл \"$old_name\" переименован в \"$new_name\""
  fi
}

delete_file() {
  local file="$1"
  rm "$file"
  echo "Файл \"$file\" удалён"
}

for subdir in */; do
  echo "Обрабатываем подкаталог \"$subdir\""
  
  base_file=""
  additional_files=()
  
  for file in "$subdir"*; do
    if [ -f "$file" ]; then
      file_name=$(basename "$file")
      extension="${file_name##*.}"
      if [ "$extension" = "$file_name" ]; then
        if [ -z "$base_file" ]; then
          base_file="$file"
        else
          echo "Ошибка: найдено два основных файла в подкаталоге \"$subdir\""
        fi
      else
        additional_files+=("$file")
      fi
    fi
  done
  
  if [ "${#additional_files[@]}" -gt 0 ]; then
    if [ -z "$base_file" ]; then
      if [ "${#additional_files[@]}" -eq 1 ]; then
        new_base_file="${additional_files[0]%.*}"
        rename_file "${additional_files[0]}" "$new_base_file"
        base_file="$new_base_file"
      else
        echo "Ошибка: найдено несколько дополнительных файлов в подкаталоге \"$subdir\", но основной файл отсутствует"
      fi
    else
    
      largest_additional_file=""
      largest_additional_file_size=0
      for file in "${additional_files[@]}"; do
        size=$(stat -c%s "$file")
        if [ "$size" -gt "$largest_additional_file_size" ]; then
          largest_additional_file="$file"
          largest_additional_file_size="$size"
        fi
      done
      if [ "$largest_additional_file_size" -gt "$(stat -c%s "$base_file")" ]; then
        new_base_file="${largest_additional_file%.*}"
        rename_file "$largest_additional_file" "$new_base_file"
        base_file="$new_base_file"
        for file in "${additional_files[@]}"; do
          if [ "$file" != "$largest_additional_file" ]; then
            delete_file "$file"
          fi
        done
      else
        for file in "${additional_files[@]}"; do
          delete_file "$file"
        done
      fi
    fi
  fi
done