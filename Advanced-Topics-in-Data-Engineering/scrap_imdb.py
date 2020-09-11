import time as t
import csv
import os
import pandas as pd
import concurrent.futures
from bs4 import BeautifulSoup
import shutil
import requests
import base64

# Read the tsv file downloaded from https://datasets.imdbws.com/
df = pd.read_csv("C:/Users/manta/Desktop/title-basics/data.tsv", sep="\t")

# define max number of threads for scrapping
MAX_THREADS = 100
DIRECTORY = "C:/IMDB_scrap/"

# change startYear to numeric
asd = df['startYear'].astype(str).str[:4]
df['startYear'] = pd.to_numeric(asd, errors='coerce')

# select movies between 2000 and 2010
rslt_df = df.loc[df['startYear'] > 1960]
rsltdf = rslt_df.loc[rslt_df['startYear'] < 1962]
rsltdf = rsltdf.reset_index(drop=True)

# drop some records with certain movie type category
rsltdf = rsltdf[~rsltdf.titleType.str.contains("tvSeries")]
rsltdf = rsltdf[~rsltdf.titleType.str.contains("tvSpecial")]
rsltdf = rsltdf[~rsltdf.titleType.str.contains("tvEpisode")]
rsltdf = rsltdf[~rsltdf.titleType.str.contains("videoGame")]
rsltdf = rsltdf[~rsltdf.titleType.str.contains("video")]
rsltdf = rsltdf.reset_index(drop=True)

# create descriptions dataset
d_columns = ['tconst', 'desc']
df_ = pd.DataFrame(columns=d_columns)

result = []
descs = []

# create list of urls to loop through
for value in rsltdf["tconst"]:
    result.append('https://www.imdb.com/title/' + value)
# add column 'urls'
rsltdf["urls"] = result


def download_url(url):
    header = {'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) Gecko/20100101 Firefox/32.0', }
    content = requests.get(url, headers=header)
    soup = BeautifulSoup(content.text, 'html.parser')
    titlenamepart = url.split(sep='/')
    urlname = titlenamepart[4]
    try:
        the_url = soup.find("link", {"rel": "image_src"})['href']
        # the records with this png on their listing, did not have an image.
        if the_url == "https://m.media-amazon.com/images/G/01/imdb/images-ANDW73HA/imdb_fb_logo._CB1542065250_.png":
            pass
        else:
            desc = soup.find('meta', {'name': 'description'}).get('content')
            descs.insert(0, {'tconst': urlname, 'desc': desc})
            the_url = the_url.split('_V1_', 1)[0]
            response = requests.get(the_url + '_V1_.jpg', stream=True)
            # save image
            with open(DIRECTORY + urlname + '.jpg', 'wb') as out_file:
                shutil.copyfileobj(response.raw, out_file)
            del response
            t.sleep(0.5)
    except Exception as e:
        print(e + " " + urlname)
        with open(r'exceptions', 'ab') as f:
            writer = csv.writer(f)
            writer.writerow(urlname)
        pass


def download_img(img_urls):
    threads = min(MAX_THREADS, len(img_urls))

    with concurrent.futures.ThreadPoolExecutor(max_workers=threads) as executor:
        executor.map(download_url, img_urls)


def make_dataset(descr):
    nameslist = []
    b64imgs = []
    dfImg = pd.DataFrame(columns=['tconst', 'imageb64'])

    for file in os.listdir(DIRECTORY):
        filename = os.fsdecode(file)
        names = filename.split(sep='.')
        with open(DIRECTORY + filename, "rb") as imageFile:
            b64str = base64.b64encode(imageFile.read())
            b64str = b64str.decode("utf-8")
            b64imgs.append(b64str)
            dfImg = dfImg.append({'tconst': names[0], 'imageb64': b64str}, ignore_index=True)

        nameslist.append(names[0])

    dfnew = rsltdf[rsltdf['tconst'].isin(nameslist)]
    # drop rows which have no genre, in our case they had the '\N' value
    dfnew = dfnew[~dfnew.genres.str.contains(r'\\N')]

    # merge dataset with descriptions dataset on tittle id
    df_merge_col = pd.merge(dfnew, descr, on='tconst')
    df_merge_final = pd.merge(df_merge_col, dfImg, on='tconst')
    df_merge_final.to_csv('dataset.csv', index=False)
    shutil.rmtree(DIRECTORY, ignore_errors=True)


def main(img_urls):
    download_img(img_urls)
    # covert descriptions list to dataframe
    desc_df = pd.DataFrame(descs, columns=['tconst', 'desc'])
    # create csv of dataset
    make_dataset(desc_df)


main(result)
