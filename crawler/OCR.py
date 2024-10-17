import pytesseract
from PIL import Image
import time

# Path to tesseract executable
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

# Open an image file
image = Image.open('C:\\Users\\TZQ\\Downloads\\2DF_800.jpg')
start_time = time.time()
# Use Tesseract to do OCR on the image
text = pytesseract.image_to_string(image)

# Print the text
end_time = time.time()

elapsed_time = end_time - start_time
print(text)
print(f"OCR running time：{elapsed_time:.2f} seconds")
