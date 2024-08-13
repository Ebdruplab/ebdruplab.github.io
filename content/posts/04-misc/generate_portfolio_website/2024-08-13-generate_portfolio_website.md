---
title: "Generating free portfolio website from PDF file."
author: Kristian
date: 2024-08-13
weight: 56
description: "A help to convert pdf to html"
slug: "pdf_to_html"
tags: ["html", "website", "website"]
---

# Convert PDF to HTML

This post will explain how you can get a free website using GitHub, and github pages. This was generated because i needed a way to take a portfolio pdf file and turn it into a website. The following takes a pdf and just convert it to a index.html file that points to images taken of the pdf. SO it isn't really converting to html, but more converting pages to images and then refering those with a html index.html file.

## Prerequisites

- You need to have a [GitHub account](https://github.com/join).
- Install the required dependencies on your machine.

### How to Install Dependencies

1. Install the required Python packages:

    ```bash
    pip install pdf2image pillow
    ```

2. Install `poppler-utils` (required by `pdf2image`):

    ```bash
    sudo apt-get install poppler-utils
    ```

## Step 1: Prepare Your PDF File

- Place your PDF file in the same directory as the script.
- If your PDF is not named `portfolio.pdf`, either rename it to `portfolio.pdf` or edit the script to use your PDF file's name.

## Step 2: Run the Script

To generate the HTML files from your PDF, use the following script named `convert_pdf.py`:

```python
# How to use
# 1. Install the required dependencies:
#    - Install Python packages:
#      pip install pdf2image pillow
#    - Install poppler-utils (required by pdf2image):
#      sudo apt-get install poppler-utils
# 2. Run the script:
#    - To use default settings:
#      python3 convert_pdf.py
#    - To specify a PDF file and output folder:
#      python3 convert_pdf.py path/to/your_pdf_file.pdf path/to/output_folder

from pdf2image import convert_from_path
import os
import sys

# Default PDF file and output folder
pdf_file = "portfolio.pdf"  # Default PDF file name
output_folder = "webpage"  # Default folder where the HTML and images will be saved

# Check for command-line arguments to override defaults
if len(sys.argv) > 1:
    pdf_file = sys.argv[1]  # First command-line argument is the PDF file
    print(f"Using provided PDF file: {pdf_file}")
else:
    print(f"No PDF file provided. Using default: {pdf_file}")

if len(sys.argv) > 2:
    output_folder = sys.argv[2]  # Second command-line argument is the output folder
    print(f"Using provided output folder: {output_folder}")
else:
    print(f"No output folder provided. Using default: {output_folder}")

# Subfolder to store the images
src_folder = os.path.join(output_folder, "assets") 

# Start the conversion process
print("Starting PDF to HTML conversion...")
print(f"PDF file to convert: {pdf_file}")
print(f"Output folder: {output_folder}")

# Create the output and src folders if they don't exist
print("Creating necessary directories...")
if not os.path.exists(output_folder):
    os.makedirs(output_folder)  # Create the output directory
    print(f"Created directory: {output_folder}")
if not os.path.exists(src_folder):
    os.makedirs(src_folder)  # Create the subdirectory for images
    print(f"Created directory: {src_folder}")

# Convert PDF to images
print("Converting PDF to images...")
try:
    # Convert each page of the PDF into an image at 300 DPI resolution
    pages = convert_from_path(pdf_file, 300)
    print(f"Successfully converted {len(pages)} pages from PDF to images.")
except Exception as e:
    # If there is an error during conversion, print the error and exit
    print(f"Error during PDF to image conversion: {e}")
    exit()

# Initialize a list to store the paths of the saved images
image_files = []
for i, page in enumerate(pages):
    # Define the filename for each image (page_1.jpg, page_2.jpg, etc.)
    image_filename = os.path.join(src_folder, f'page_{i+1}.jpg')
    try:
        # Save each page as a JPEG image in the src folder
        page.save(image_filename, 'JPEG')
        image_files.append(image_filename)
        print(f"Saved image: {image_filename}")
    except Exception as e:
        # If there is an error saving an image, print the error
        print(f"Error saving image {image_filename}: {e}")

# Begin generating the HTML file
print("Generating HTML file...")
html_content = """
<html>
<head>
<style>
    body {
        margin: 0;
        padding: 0;
        background-color: #f0f0f0;  /* Set a light background color */
    }
    img {
        display: block;
        margin: 0 auto;  /* Center images horizontally */
    }
</style>
</head>
<body>
"""

# Add each image to the HTML content
print("Adding images to the HTML content...")
for i in range(len(image_files)):
    image_file = os.path.join("src", f'page_{i+1}.jpg')
    # Add a div for each image with 100% width and a max-width of 1200px
    html_content += f'<div><img src="{image_file}" style="width:100%; max-width:1200px;"/></div>\n'
    print(f"Added image {image_file} to HTML content.")

html_content += "</body></html>"

# Define the filename for the index HTML file
html_filename = os.path.join(output_folder, "index.html")
print(f"Saving HTML file to: {html_filename}")
try:
    # Write the generated HTML content to the output file
    with open(html_filename, "w") as f:
        f.write(html_content)
    print(f"HTML file created successfully: {html_filename}")
except Exception as e:
    # If there is an error writing the HTML file, print the error
    print(f"Error writing HTML file: {e}")
```

To run the script:

- **Using default settings** (PDF file named `portfolio.pdf` and output folder `webpage`):

    ```bash
    python3 convert_pdf.py
    ```

- **To specify a custom PDF file and output folder**:

    ```bash
    python3 convert_pdf.py path/to/your_pdf_file.pdf path/to/output_folder
    ```

## Step 3: Upload to GitHub Pages

1. **Create a Repository**: On GitHub, create a new repository named `<YOUR USERNAME>.github.io`.
2. **Upload Files**: Upload the contents of your output folder (including `index.html` and the `assets` folder) to the repository.
3. **Publish**: Once uploaded, your site will be live at `https://<YOUR USERNAME>.github.io`.

## Step 4: Visit Your Website

After uploading the files, visit your new website by navigating to `https://<YOUR USERNAME>.github.io` in your web browser.

