import requests
from bs4 import BeautifulSoup
import time
import re
from urllib.parse import urljoin

# Configuration
BASE_URL = "https://portableapps.com"
CATEGORIES = {
    "Internet": "/apps/internet",
    "Office": "/apps/office",
    "Security": "/apps/security",
    "Utilities": "/apps/utilities",
    "Games": "/games",
    "Development": "/apps/development",
    "Music": "/apps/music",
    "Education": "/apps/education"
}
OUTPUT_FILE = "portableapps_categorized.txt"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0"
}

def get_soup(url):
    """Fetch and parse a webpage with error handling."""
    try:
        response = requests.get(url, headers=HEADERS, timeout=15)
        response.raise_for_status()
        return BeautifulSoup(response.text, 'html.parser')
    except Exception as e:
        print(f"⚠️ Error fetching {url}: {e}")
        return None

def extract_app_info(category_url):
    """Extract app names and their page links from a category."""
    soup = get_soup(category_url)
    if not soup:
        return []
    
    apps = []
    for item in soup.select(".app_list > li"):
        name = item.select_one(".app_list_name").get_text(strip=True)
        link = item.select_one("a")['href']
        if link and not link.endswith('/download'):
            full_url = urljoin(BASE_URL, link)
            apps.append((name, full_url))
    return apps

def get_direct_download_url(app_page_url):
    """Get the final .paf.exe download URL."""
    soup = get_soup(app_page_url)
    if not soup:
        return None
    
    # Try to find direct download link
    dl_link = soup.find("a", href=re.compile(r'\.paf\.exe$'))
    if dl_link:
        return urljoin(BASE_URL, dl_link['href'])
    
    # Try download page as fallback
    download_page = app_page_url + '/download'
    soup_dl = get_soup(download_page)
    if soup_dl:
        dl_link = soup_dl.find("a", href=re.compile(r'\.paf\.exe$'))
        if dl_link:
            return urljoin(BASE_URL, dl_link['href'])
    
    return None

def verify_download_url(url):
    """Check if the download URL actually exists."""
    try:
        r = requests.head(url, headers=HEADERS, allow_redirects=True, timeout=10)
        return r.status_code == 200
    except:
        return False

def main():
    """Main scraping function."""
    categorized_apps = {category: [] for category in CATEGORIES.keys()}
    
    for category_name, category_path in CATEGORIES.items():
        category_url = urljoin(BASE_URL, category_path)
        print(f"\n🔍 Scanning {category_name} category...")
        
        apps = extract_app_info(category_url)
        for app_name, app_url in apps:
            print(f"  Checking: {app_name}")
            download_url = get_direct_download_url(app_url)
            
            if download_url and verify_download_url(download_url):
                categorized_apps[category_name].append((app_name, download_url))
                print(f"    ✅ Found: {download_url}")
            else:
                print(f"    ❌ No valid download for {app_name}")
            
            time.sleep(1)  # Be polite
    
    # Save results
    with open(OUTPUT_FILE, 'w') as f:
        for category, apps in categorized_apps.items():
            f.write(f"[{category}]\n")
            for app_name, download_url in apps:
                f.write(f'"{app_name}" = "{download_url}"\n')
            f.write("\n")
    
    print(f"\n🎉 Done! Categorized list saved to {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
