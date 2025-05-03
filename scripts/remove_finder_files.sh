#!/bin/bash

# Check if a directory is provided, else use the current directory
if [ -z "$1" ]; then
  target_dir="."
else
  target_dir="$1"
fi

# Confirm with the user before proceeding
echo "This will remove Finder-specific files in '$target_dir'."
read -p "Are you sure? (y/n): " confirmation
if [[ ! "$confirmation" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

# List of Finder-specific files to remove
files_to_remove=(
  ".DS_Store"
  "Thumbs.db"
  ".AppleDouble"
  ".LSOverride"
  "._*"  # Files with the "._" prefix
)

# Find and remove files recursively
for file in "${files_to_remove[@]}"; do
  echo "Removing '$file' files from '$target_dir' and its subdirectories..."
  find "$target_dir" -type f -name "$file" -exec rm -f {} \;
done

echo "Cleanup completed."

