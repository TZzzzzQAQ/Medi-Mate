import csv
import os
import requests
from urllib.parse import urlparse

def download_image(url, folder):
    response = requests.get(url)
    if response.status_code == 200:
        filename = os.path.basename(urlparse(url).path)
        filepath = os.path.join(folder, filename)
        with open(filepath, 'wb') as f:
            f.write(response.content)
        return filepath
    return None

# Set the input CSV file name and output CSV file name
input_csv = 'dataConvert.csv'
output_csv = 'output.csv'

# Set the folder where images will be saved
image_folder = 'downloaded_images'

# Create the image folder if it doesn't exist
os.makedirs(image_folder, exist_ok=True)

# Read the input CSV and write to the output CSV
with open(input_csv, 'r') as infile, open(output_csv, 'w', newline='') as outfile:
    reader = csv.DictReader(infile)
    fieldnames = reader.fieldnames + ['local_image_path']
    writer = csv.DictWriter(outfile, fieldnames=fieldnames)
    
    writer.writeheader()
    
    for row in reader:
        image_url = row['Image Src']  
        local_path = download_image(image_url, image_folder)
        row['local_image_path'] = local_path
        writer.writerow(row)

print(f"Images downloaded and CSV updated. Output saved to {output_csv}")
