from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import csv
import time


def fetch_page(driver, url):
    driver.get(url)
    return driver.page_source


def parse_product_list(driver):
    product_links = []
    driver.implicitly_wait(10)
    a_tags = driver.find_elements(By.CLASS_NAME, 'sc-pyfCe.goggFx.product__container')
    for a_tag in a_tags:
        link = a_tag.get_attribute('href')
        product_links.append(link)
    return product_links


def parse_product_details(driver, url):
    # 定义默认值
    product_name = product_price = manufacturer_name = general_information = product_id = common_uses = 'N/A'
    warnings = directions = image_src = ingredients = 'N/A'

    try:
        product_name = driver.find_element(By.CLASS_NAME, 'product-name').text.strip()
    except Exception as e:
        print(f"Error finding product name: {e}")

    try:
        product_price = driver.find_element(By.CLASS_NAME, 'product__price').text.strip()
    except Exception as e:
        print(f"Error finding product price: {e}")

    try:
        manufacturer_name = driver.find_element(By.CLASS_NAME, 'manufacturer-name.product-information').text.strip()
    except Exception as e:
        print(f"Error finding manufacturer name: {e}")

    try:
        common_uses = driver.find_element(By.CLASS_NAME, 'product-info-section.commonuses').text.strip()
    except Exception as e:
        print(f"Error finding common uses: {e}")

    try:
        product_id = driver.find_element(By.CLASS_NAME, 'product-id.product-information').text.strip()
        print(f"Product ID: {product_id}")
    except Exception as e:
        print(f"Error finding product ID: {e}")

    try:
        general_information = driver.find_element(By.CLASS_NAME, 'product-info-section.general-info').text.strip()
    except Exception as e:
        print(f"Error finding general information: {e}")

    try:
        warnings = driver.find_element(By.CLASS_NAME, 'product-info-section.warnings').text.strip()
    except Exception as e:
        print(f"Error finding warnings: {e}")

    try:
        ingredients = driver.find_element(By.CLASS_NAME, 'product-info-section.ingredients').text.strip()
    except Exception as e:
        print(f"Error finding ingredients: {e}")

    try:
        directions = driver.find_element(By.CLASS_NAME, 'product-info-section.directions').text.strip()
    except Exception as e:
        print(f"Error finding directions: {e}")

    # 增加重试机制
    max_retries = 5
    for attempt in range(max_retries):
        try:
            WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, '.hero_image.zoomer_harvey.product-thumbnail'))
            )
            image_element = driver.find_element(By.CSS_SELECTOR, '.hero_image.zoomer_harvey.product-thumbnail')
            image_src = image_element.get_attribute('src')

            if image_src:  # 如果成功获取到图片链接，跳出循环
                print(f"Image source: {image_src}")
                break
            else:
                raise Exception("Image src is empty")  # 如果图片链接为空，抛出异常
        except Exception as e:
            print(f"Attempt {attempt + 1} failed: Error finding image src: {e}")
            if attempt < max_retries - 1:
                print(f"Reloading page and retrying... (Attempt {attempt + 2})")
                fetch_page(driver, url)  # 重新加载页面
            time.sleep(10)  # 等待10秒后重试
            image_src = 'N/A'  # 如果最终还是失败，就设置为默认值

    return [product_name, product_price, manufacturer_name, product_id, general_information, warnings,
            common_uses, ingredients, directions, image_src]


def save_to_csv(data, filename):
    with open(filename, mode='a', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(
            ['Product Name', 'Product Price', 'Manufacturer Name', 'Product ID', 'General Information',
             'Warnings', 'Common Use', 'Ingredients', 'Directions', 'Image Src'])
        writer.writerows(data)


def main():
    base_urls = [
        "https://www.chemistwarehouse.co.nz/shop-online/81/vitamins-supplements",
        "https://www.chemistwarehouse.co.nz/shop-online/1255/sports-nutrition",
        "https://www.chemistwarehouse.co.nz/shop-online/258/medicines",
        "https://www.chemistwarehouse.co.nz/shop-online/517/weight-management",
        "https://www.chemistwarehouse.co.nz/shop-online/20/baby-care",
        "https://www.chemistwarehouse.co.nz/shop-online/1093/cold-flu",
        "https://www.chemistwarehouse.co.nz/shop-online/159/oral-hygiene-and-dental-care",
        "https://www.chemistwarehouse.co.nz/shop-online/3240/clearance"
    ]

    options = Options()
    options.headless = True
    options.add_argument("--disable-notifications")
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

    # CSV文件路径
    csv_filename = 'C:\\Users\\TZQ\\OneDrive\\桌面\\UOA\\778\\FriedChicken\\products_info.csv'

    # 首次运行时创建CSV文件并写入标题行
    save_to_csv([], csv_filename)  # 确保CSV文件存在

    for base_url in base_urls:
        all_product_links = []
        html = fetch_page(driver, base_url)

        while True:
            if html:
                product_links = parse_product_list(driver)
                all_product_links.extend(product_links)

            try:
                next_button = driver.find_element(By.CLASS_NAME, 'pager__button.pager__button--next')
                next_button.click()
                time.sleep(1)
                html = driver.page_source
            except Exception as e:
                print(f"No more pages or error finding next page button: {e}")
                break

        print(f"Collected {len(all_product_links)} links from {base_url}")

        for link in all_product_links:
            fetch_page(driver, link)
            product_info = parse_product_details(driver, link)

            # 立即保存每个产品的信息
            save_to_csv([product_info], csv_filename)
            time.sleep(1)

    driver.quit()


if __name__ == "__main__":
    main()
