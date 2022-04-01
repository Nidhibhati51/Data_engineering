# Introduction
The Python project is a data analysis project to analyze a businesses' dataset of invoices. The company wants to understand its customers and organize targeted marketing campaigns. The result of the project included the segmentation of the customers in the dataset. It also included recommended marketing strategies for the three most populated segments. These results can provide the necessary data to develop targeted marketing campaigns for each of the three segments. The project was written in Python using a Jupyter Notebook. It used libraries such as Pandas, NumPy, and Matplotlib. A PSQL database stores the dataset, and the Jupyter Notebook accesses the data from the PSQL database. The testing process involved many trial and error tests throughout the project's development. The deployment of the application used two Docker containers to contain the Jupyter Notebook and PSQL database. A Docker network allows the containers to communicate.
## Architecture
![image](https://github.com/jarviscanada/jarvis_data_eng_NidhiBhati/blob/python_project/python_data_analytics/Python%20Project%20Architecture.png)

The overall architecture begins with the users visiting the company's web application, which consists of both the front-end and the back-end. After the users have made their transactions through the front-end, it gets recorded into the company's database using their back-end application. Then a script or CSV is constructed from this database so that the data gets imported into the company's data warehouse, which is running from a Docker container.

As for analysis, it is done using a Jupyter notebook that can connect to the data warehouse, and analyze the data so that I can help better the company's operations. The notebook runs from a Jupyter server.

## Data Analytics and wrangling
A Jupyter Notebook supplied the environment containing all data wrangling and analysis. The Notebook is available at the following link: ![retail_data_analytics_wrangling.ipynb](https://github.com/jarviscanada/jarvis_data_eng_NidhiBhati/blob/feature/data_analytics/python_data_wrangling/retail_data_analytics_wrangling.ipynb)

Aggregate data in the dataset provided RFM values for each customer. The segmentation process involved first grouping the customers by quantile in each of the three columns. Then they were assigned a number between and including one to five, corresponding to their quintile in each category. Various combinations of the first two digits (recency and frequency) produced ten different segments.

The three most populated segments are described below, ordered from most populous to least populous.

* Hibernating

1522 Customers, or 26% of the total
Customers in this segment have made few purchases (tied for worst average frequency) and have not purchased in a long time (worst average recency). Their purchases were for relatively small amounts (third-worst average monetary value). Although this is the largest segment in terms of population, it is not worth investing heavily in retaining these customers since they are unlikely to provide much customer value.

* Loyal Customers

1147 Customers, or 20% of the total
Customers in this segment have made frequent purchases (third-best average frequency) and are in the middle of the pack for recent purchases (fifth-best average recency). They've made purchases for relatively large amounts (third-best monetary value). Loyal customers are a large segment that makes frequent purchases for significant amounts. As a result, it is best to prioritize investing in this segment. These are likely satisfied customers. To maintain their satisfaction, don't overwhelm them with promotional material, but instead promote just a few products tailored to their tastes.

* Champions

852 Customers, or 14% of the total
Customers in this segment have made frequent purchases and have purchased recently. Their purchases are for large amounts. The champions segment is large and is the best in all three categories (recency, frequency, and monetary). Therefore, they deserve a lot of investment to maintain their satisfaction. For example, offer special-edition products or special discounts.

* Conclusion

Sixty percent of all customers in the database fall into one of the three segments described above. The three segments represent opposite extremes of investment priority. The customers in the hibernating segment represent customers that are among the least important from the businesses' perspective. They are not likely to generate much revenue in the future and are not worth investing a significant amount of resources. On the other end of the spectrum, loyal customers and champions are composed of loyal customers who are worth the investment. Both segments have made frequent purchases and are familiar with the business. Promoting products in which they are likely to be interested will encourage them to purchase a wide range of products. Asking them to share their positive experiences online is also a good idea, as they are likely to do so when asked. For the champions, it is best to reward them for their continued loyalty, such as offering special discounts or limited edition products.

## Improvements

Below are a few improvements to consider:

1. Explore the data by other columns, such as country and item purchased
2. Improve the visuals of the charts and graphs and create a dashboard using all charts
3. Create functions to make it easier to perform the same operations on an updated version of the dataset in the future
