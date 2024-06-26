#!/bin/bash

# Define the root content directory
CONTENT_DIR="/home/kristian/git/ebdruplab/ebdruplab.github.io/content/posts"
OUTPUT_FILE="./blog_posts.md"

# Start the markdown file
echo "## Blog Posts" > $OUTPUT_FILE

# Function to extract title from markdown file
extract_title() {
  grep "^title:" "$1" | sed 's/title: "\(.*\)"/\1/' | sed 's/title: //'
}

# Loop through all subdirectories
for dir in $(find "$CONTENT_DIR" -mindepth 1 -maxdepth 1 -type d | sort); do
  # Get the base directory name and remove any leading numbers
  dir_name=$(basename "$dir")
  display_name=$(echo "$dir_name" | sed 's/^[0-9]*-//')

  echo "### $display_name" >> $OUTPUT_FILE

  # Loop through all markdown files in the subdirectory excluding _index.md files
  for file in $(find "$dir" -name "*.md" ! -name "_index.md" | sort); do
    # Extract the title from the markdown file
    title=$(extract_title "$file")
    # Get the relative URL for the markdown file
    url=$(echo "$file" | sed 's|^/home/kristian/git/ebdruplab/ebdruplab.github.io/content||' | sed 's|.md$||')

    # Write the markdown link to the output file
    echo "  - [$title]($url/)" >> $OUTPUT_FILE
  done
done

echo "Markdown list generated in $OUTPUT_FILE"
