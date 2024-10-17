import pandas as pd
import requests
from bs4 import BeautifulSoup

# 爬取网页内容函数
def scrape_website(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    # 获取需要的信息
    product_name = soup.find('h1', {'class': 'productName'}).text.strip() if soup.find('h1', {'class': 'productName'}) else 'Product Name Not Found'
    manufacturer_name = 'Barker’s'  # 这个网页没有直接的制造商名称，假设它是Barker’s
    general_information = soup.find('div', {'class': 'product-description'}).text.strip() if soup.find('div', {'class': 'product-description'}) else 'General Information Not Found'
    warnings = 'No specific warnings provided.'  # 如果网页没有提供警告信息
    common_use = 'Common use not specified on the webpage.'  # 如果网页没有提供Common Use信息
    directions = soup.find('div', {'class': 'directions'}).text.strip() if soup.find('div', {'class': 'directions'}) else 'Directions not specified on the webpage.'
    ingredients = soup.find('div', {'class': 'product-ingredients'}).text.strip() if soup.find('div', {'class': 'product-ingredients'}) else 'Ingredients not found.'

    return {
        'Product Name': product_name,
        'Manufacturer Name': manufacturer_name,
        'General Information': general_information,
        'Warnings': warnings,
        'Common Use': common_use,
        'Directions': directions,
        'Ingredients': ingredients
    }

# 指定要爬取的网页
url = 'https://www.chemistwarehouse.co.nz/buy/114721/barker-s-immunity-fruit-syrup-lemon-honey-ginger-turmeric-710ml'
scraped_data = scrape_website(url)

# 读取CSV文件
df = pd.read_csv('Cleaned_New_Data - Final Cleaned_New_Data.csv')

# 替换列内容
df['Product Name'] = df['Product Name'].apply(lambda x: scraped_data['Product Name'] if pd.isnull(x) else x)
df['Manufacturer Name'] = df['Manufacturer Name'].apply(lambda x: scraped_data['Manufacturer Name'] if pd.isnull(x) else x)
df['General Information'] = df['General Information'].apply(lambda x: scraped_data['General Information'] if pd.isnull(x) else x)
df['Warnings'] = df['Warnings'].apply(lambda x: scraped_data['Warnings'] if pd.isnull(x) else x)
df['Common Use'] = df['Common Use'].apply(lambda x: scraped_data['Common Use'] if pd.isnull(x) else x)
df['Directions'] = df['Directions'].apply(lambda x: scraped_data['Directions'] if pd.isnull(x) else x)
df['Ingredients'] = df['Ingredients'].apply(lambda x: scraped_data['Ingredients'] if pd.isnull(x) else x)

# 保存修改后的CSV文件
df.to_csv('Modified_Cleaned_New_Data.csv', index=False)

print("文件处理完成并保存为 'Modified_Cleaned_New_Data.csv'")
