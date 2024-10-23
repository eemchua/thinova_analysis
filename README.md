# THINOVA Sales and Performance Analysis

*Disclaimer: While this project is a real business analysis for an actual company, the brand name and information have been modified to protect the company’s identity.*

## Project Overview

The goal of this project is to analyze key sales metrics for **THINOVA** from January 2022 to September 2024, focusing on trends such as revenue, repeat purchase rates (RPR), average order value (AOV), customer lifetime value (CLTV), and conversion rates (CR).

Officially launched in January 2022, THINOVA offers premium fat-burning supplement capsules designed to support weight-loss goals. Packaged in convenient, easy-to-use bottles, the capsules are formulated to boost metabolism, increase energy levels, and promote fat burning through natural ingredients. The company operates on a direct-to-consumer e-commerce model, offering both one-time and subscription purchases, available in options of 1, 2, or 3 bottles.

This analysis explores performance insights for both one-time and subscription purchases, highlighting areas for improvement and opportunities for growth.

## Dataset

Sales history was obtained from the e-commerce platform that supports the online store, including information about order number, revenue, date of purchase, type of purchased item, and more (see dataset sample [here](https://github.com/eemchua/thinova_analysis/blob/bd3be3d74f045ef6b166506febbc0583b03bd4b1/thinova_sample_dataset.csv)). Google Excel was used to perform the initial data cleaning (see changelog [here](https://docs.google.com/spreadsheets/d/1v-fRLH4GvjFDNw6Q7OsAtCjtUmPPG4pTTXzGFgd3SFw/edit?usp=sharing)), and PostgreSQL was used to perform the remaining data cleaning and analysis (see SQL code [here](https://github.com/eemchua/thinova_analysis/blob/63471e360633b6a12438ae1eee663cf5bb9e1634/thinova_analysis.sql)).

## North Star Metrics

- **Revenue**: Total income generated from sales.
- **Average Order Value (AOV)**: The average amount of money spent by a customer in a single transaction.
- **Conversion Rate (CR)**: The percentage of website visitors who make a purchase.
- **Repeat Purchase Rate (RPR)**: The percentage of customers who make more than one purchase.
- **Customer Lifetime Value (CLTV)**: The total revenue a customer is expected to generate throughout their relationship with the business.

Revenue is analyzed both monthly and yearly to understand immediate trends and long-term business health. AOV and CR are analyzed monthly for quick action because these metrics can change frequently due to marketing efforts, customer behavior, and more. RPR and CLTV are analyzed yearly as they are indicators of customer loyalty and the value derived over a longer period.

## Monthly Metrics - Insights Summary

### Overview of Monthly Revenue, AOV, and CR

The peak revenue of **$7.3K in July 2022** aligns with possible successful campaigns, and the stable revenue of **$4.3K from October 2023 onward** shows consistent growth.

The AOV has remained within a relatively consistent range over time, with month-to-month fluctuations between **$40-$60**. While the AOV has not shown a significant increase, its steadiness suggests that customers are maintaining predictable purchase behaviors.

CR has seen significant spikes in **Q4 2022**, especially in the holiday season, with wide month-to-month fluctuations ranging from **1% to 13.5%**. This shows the impact of successful campaigns but also highlights volatility.

### Significant Observations of Monthly Revenue, AOV, and CR

- **Revenue spiked in July 2022**, driven by high sales volume of one-time single-bottle and 2-bottle purchases, but with lower AOV and CR.
- **AOV and CR peaked in December 2022**, but **Revenue was low**, with a minor portion of customers making high-value purchases (both one-time 3-bottle and subscription 3-bottle orders), which increased AOV and CR but didn’t drive overall revenue.
- **Cloud Chips has been performing well in 2024**, with consistent growth and relatively stable metrics.

## Yearly Metrics - Insights Summary

### Overview of Yearly Revenue, RPR, and CLTV

- The highest Revenue (**$38K**) was seen in 2024, driven by one-time (non-subscription) purchases.
- The highest RPR (**24%**) was also seen in 2024, with RPR of one-time purchases at **18%** and RPR of subscription purchases at **58%**.
- **CLTV is highest in 2022**, showing that customers acquired during this period were highly valuable.

### Significant Observations of Yearly Revenue, RPR, and CLTV

- **2024 has the highest revenue and RPR**. The **RPR of 2024 is 24%**, which is much closer to the **RPR of one-time purchases at 18%** rather than the **RPR of subscription purchases at 58%**. This explains that the large volume of one-time customers overshadows the higher repeat purchase rate of subscription customers. While the subscription RPR is high, the impact is diluted due to the relatively small number of subscription customers compared to one-time customers.
- The **highest CLTV is in 2022**, with revenue and RPR peaking in 2024. The high CLTV in 2022 suggests **effective customer retention efforts**, while **2024's peak in revenue and RPR** indicates a shift toward acquiring more customers and increasing repeat purchases. The **CLTV for 2024** could be **understated** since the final quarter of the year has not been included in the analysis. However, given current trends, **CLTV by the end of 2024 should surpass CLTV of 2023 easily**; **CLTV by the end of 2024 may surpass CLTV of 2022**, but this will require a very strong last quarter of 2024.
- While **2024 (up till September)** is performing best in revenue and RPR, it has not yet surpassed **2022** in CLTV. **2024 is performing well overall**, showing steady growth and consistency across key metrics.

## Recommendations Summary

- **Expand Marketing Campaigns**: Use insights from successful months in the past to replicate results.
  - Revenue spikes in **July 2022, September-November 2023, and March 2024**.
  - High CR in **December 2022, December 2023, and May 2024**.
  
- **Focus on Subscription Growth**: With one-time purchases significantly outnumbering subscription purchases, increase efforts to convert one-time buyers to subscriptions by offering bundled discounts and incentives.

- **Customer Retention**: Introduce personalized offers and upselling programs to improve **CLTV in 2024**, focusing on sustaining customer loyalty.

## Dashboard

The dashboard can be found in Tableau Public [here](https://public.tableau.com/app/profile/ee.ming.chua/viz/shared/9YXQ25DD5). This dashboard enables users to filter by month and year. Below is a screenshot of the dashboard:
![thinova_dashboard](https://github.com/user-attachments/assets/4fb13825-1b9c-4786-9c15-cd7ad0ece72e)

## Presentation

The presentation created for the stakeholder walks through the findings and recommendations above and can be found [here](https://docs.google.com/presentation/d/1UCnmFsELDBLGZAF8eKAR9QMCxa9NOK44VZ8UN03L6fk/edit?usp=sharing). Below are some extracts from the presentation:

![Screenshot 2024-10-23 at 3 50 29 PM](https://github.com/user-attachments/assets/08570051-c66e-4aba-b46f-593133d32f6b)
![Screenshot 2024-10-23 at 3 50 52 PM](https://github.com/user-attachments/assets/b3feb782-571e-4ab1-8fcf-ae7f34e53660)
![Screenshot 2024-10-23 at 3 51 15 PM](https://github.com/user-attachments/assets/50b8bd59-ea6a-48bb-9aaa-c62999bd7cf3)


