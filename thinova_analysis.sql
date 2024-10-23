CREATE TABLE all_orders (
    order_id VARCHAR(20),
    email VARCHAR(255),
    financial_status VARCHAR(50),
    paid_at DATE,
    accepts_marketing VARCHAR(5),
    subtotal NUMERIC(10, 2),
    shipping NUMERIC(10, 2),
    taxes NUMERIC(10, 2),
    total NUMERIC(10, 2),
    discount_code VARCHAR(50),
    discount_amount NUMERIC(10, 2),
    shipping_method VARCHAR(50),
    lineitem_quantity INTEGER,
    lineitem_name VARCHAR(255),
    billing_name VARCHAR(255),
    billing_city VARCHAR(255),
    billing_zip VARCHAR(20),
    billing_province VARCHAR(100),
    billing_country VARCHAR(100),
    shipping_name VARCHAR(255),
    shipping_city VARCHAR(255),
    shipping_zip VARCHAR(20),
    shipping_province VARCHAR(100),
    shipping_country VARCHAR(100),
    payment_method VARCHAR(100),
    refunded_amount NUMERIC(10, 2),
    risk_level VARCHAR(50)
);

SELECT *
FROM all_orders;

-- Monthly Revenue by Type
SELECT
    TO_CHAR(paid_at, 'YYYY-MM') AS month,
    SUM(CASE 
            WHEN lineitem_name LIKE 'Subscription%' THEN total
            ELSE 0
        END) AS revenue_subscription,
    SUM(CASE 
            WHEN lineitem_name NOT LIKE 'Subscription%' THEN total
            ELSE 0
        END) AS revenue_onetime,
    SUM(total) AS total_revenue,
    COUNT(order_id) AS total_orders
FROM
    all_orders
WHERE
    paid_at >= '2021-01-01' AND paid_at <= '2024-09-30'  -- Adjust the date range as necessary
GROUP BY
    TO_CHAR(paid_at, 'YYYY-MM')
ORDER BY
    month;

-- Monthly Revenue by Line Item
SELECT
    TO_CHAR(paid_at, 'YYYY-MM') AS month,
    SUM(CASE 
            WHEN lineitem_name = '1 Bottle' THEN total
            ELSE 0
        END) AS "1 Bottle",
    SUM(CASE 
            WHEN lineitem_name = '2 Bottles' THEN total
            ELSE 0
        END) AS "2 Bottles",
    SUM(CASE 
            WHEN lineitem_name = '3 Bottles' THEN total
            ELSE 0
        END) AS "3 Bottles",
    SUM(CASE 
            WHEN lineitem_name = 'Subscription - 1 Bottle' THEN total
            ELSE 0
        END) AS "Subscription - 1 Bottle",
    SUM(CASE 
            WHEN lineitem_name = 'Subscription - 2 Bottles' THEN total
            ELSE 0
        END) AS "Subscription - 2 Bottles",
    SUM(CASE 
            WHEN lineitem_name = 'Subscription - 3 Bottles' THEN total
            ELSE 0
        END) AS "Subscription - 3 Bottles"
FROM
    all_orders
WHERE
    paid_at >= '2021-01-01' AND paid_at <= '2024-09-30'  -- Adjust the date range as necessary
GROUP BY
    TO_CHAR(paid_at, 'YYYY-MM')
ORDER BY
    month;


-- Total Revenue
SELECT
    EXTRACT(YEAR FROM paid_at) AS year,
    EXTRACT(MONTH FROM paid_at) AS month,
    lineitem_name,
    SUM(total) AS total_revenue
FROM
    all_orders
WHERE
    paid_at >= '2021-01-01'
    AND paid_at <= '2024-09-30'
GROUP BY
    EXTRACT(YEAR FROM paid_at),
    EXTRACT(MONTH FROM paid_at),
    lineitem_name
ORDER BY
    year, month;

-- Overall RPR
WITH customer_orders AS (
    SELECT
        email,
        COUNT(order_id) AS order_count
    FROM
        all_orders
    WHERE
        paid_at >= '2021-01-01' 
		AND paid_at <= '2024-09-30' 
		AND email IS NOT NULL
    GROUP BY
        email
),
repeat_customers AS (
    SELECT
        COUNT(email) AS repeat_customers
    FROM
        customer_orders
    WHERE
        order_count > 1 
),
total_customers AS (
    SELECT
        COUNT(DISTINCT email) AS total_customers
    FROM
       all_orders
    WHERE
        paid_at >= '2021-01-01' AND paid_at <= '2024-09-30' AND email IS NOT NULL
)
SELECT
    total_customers,
    repeat_customers,
    ROUND((repeat_customers::NUMERIC / total_customers * 100),2) AS repeat_purchase_rate
FROM
    total_customers,
    repeat_customers;

-- RPR by year
WITH customer_orders AS (
    SELECT
        email,
        EXTRACT(YEAR FROM paid_at) AS year,
        COUNT(order_id) AS order_count
    FROM
        all_orders
    WHERE
        paid_at >= '2021-01-01' 
        AND paid_at <= '2024-09-30'
        AND email IS NOT NULL
    GROUP BY
        email, EXTRACT(YEAR FROM paid_at)
),
repeat_customers AS (
    SELECT
        year,
        COUNT(email) AS repeat_customers
    FROM
        customer_orders
    WHERE
        order_count > 1
    GROUP BY
        year
),
total_customers AS (
    SELECT
        EXTRACT(YEAR FROM paid_at) AS year,
        COUNT(DISTINCT email) AS total_customers
    FROM
        all_orders
    WHERE
        paid_at >= '2021-01-01' AND paid_at <= '2024-09-30' AND email IS NOT NULL
    GROUP BY
        EXTRACT(YEAR FROM paid_at)
)
SELECT
    t.year,
    t.total_customers,
    COALESCE(r.repeat_customers, 0) AS repeat_customers,
    ROUND((COALESCE(r.repeat_customers, 0)::NUMERIC / t.total_customers * 100), 2) AS repeat_purchase_rate
FROM
    total_customers t
LEFT JOIN
    repeat_customers r
ON
    t.year = r.year
ORDER BY
    t.year;

-- Overall RPR of one-time vs subcription customer
WITH customer_orders AS (
    SELECT
        email,
        COUNT(order_id) AS order_count
    FROM
        all_orders
    WHERE
        paid_at >= '2021-01-01' AND paid_at <= '2024-09-30' AND email IS NOT NULL
    GROUP BY
        email
),
repeat_customers AS (
    SELECT
        COUNT(email) AS repeat_customers
    FROM
        customer_orders
    WHERE
        order_count > 1  -- Only count customers who have made more than 1 purchase
),
total_customers AS (
    SELECT
        COUNT(DISTINCT email) AS total_customers
    FROM
       all_orders
    WHERE
        paid_at >= '2021-01-01' AND paid_at <= '2024-09-30' AND email IS NOT NULL
)
SELECT
    total_customers,
    repeat_customers,
    ROUND((repeat_customers::NUMERIC / total_customers * 100),2) AS repeat_purchase_rate
FROM
    total_customers,
    repeat_customers;

-- Overall RPR by type
WITH customer_orders AS (
    SELECT
        email,
        CASE
            WHEN lineitem_name = 'Subscription - 1 Bottle' OR lineitem_name = 'Subscription - 2 Bottles' OR lineitem_name = 'Subscription - 3 Bottles' THEN 'subscription'
        END AS purchase_type,
        COUNT(order_id) AS order_count
    FROM
        all_orders
    WHERE
        paid_at >= '2021-01-01' AND paid_at <= '2024-09-30'
    GROUP BY
        email, purchase_type
),
repeat_customers AS (
    SELECT
        purchase_type,
        COUNT(DISTINCT email) AS repeat_customers
    FROM
        customer_orders
    WHERE
        order_count > 1
    GROUP BY
        purchase_type
),
total_customers AS (
    SELECT
        CASE
            WHEN lineitem_name = 'Subscription - 1 Bottle' OR lineitem_name = 'Subscription - 2 Bottles' OR lineitem_name = 'Subscription - 3 Bottles' THEN 'subscription'
            ELSE 'one-time'
        END AS purchase_type,
        COUNT(DISTINCT email) AS total_customers
    FROM
        all_orders
    WHERE
        paid_at >= '2021-01-01' AND paid_at <= '2024-09-30'
    GROUP BY
        purchase_type
)
SELECT
    t.purchase_type,
    t.total_customers,
    COALESCE(r.repeat_customers, 0) AS repeat_customers,
    ROUND((COALESCE(r.repeat_customers, 0)::NUMERIC / t.total_customers * 100), 2) AS repeat_purchase_rate
FROM
    total_customers t
LEFT JOIN
    repeat_customers r
ON
    t.purchase_type = r.purchase_type
ORDER BY
    t.purchase_type;

--Yearly RPR by One-Time vs Subscription Customers
WITH customer_orders AS (
    SELECT
        email,
        EXTRACT(YEAR FROM paid_at) AS year,
        CASE
            WHEN lineitem_name = 'Subscription - 1 Bottle' 
                OR lineitem_name = 'Subscription - 2 Bottles' 
                OR lineitem_name = 'Subscription - 3 Bottles' 
            THEN 'subscription'
            ELSE 'one-time'
        END AS purchase_type,
        COUNT(order_id) AS order_count
    FROM
        all_orders
    WHERE
        paid_at >= '2021-01-01' AND paid_at <= '2024-09-30' AND email IS NOT NULL
    GROUP BY
        email, year, purchase_type
),
repeat_customers AS (
    SELECT
        year,
        purchase_type,
        COUNT(DISTINCT email) AS repeat_customers
    FROM
        customer_orders
    WHERE
        order_count > 1  -- Only count customers who have made more than 1 purchase
    GROUP BY
        year, purchase_type
),
total_customers AS (
    SELECT
        EXTRACT(YEAR FROM paid_at) AS year,
        CASE
            WHEN lineitem_name = 'Subscription - 1 Bottle' 
                OR lineitem_name = 'Subscription - 2 Bottles' 
                OR lineitem_name = 'Subscription - 3 Bottles' 
            THEN 'subscription'
            ELSE 'one-time'
        END AS purchase_type,
        COUNT(DISTINCT email) AS total_customers
    FROM
        all_orders
    WHERE
        paid_at >= '2021-01-01' AND paid_at <= '2024-09-30' AND email IS NOT NULL
    GROUP BY
        year, purchase_type
)
SELECT
    t.year,
    t.purchase_type,
    t.total_customers,
    COALESCE(r.repeat_customers, 0) AS repeat_customers,
    ROUND((COALESCE(r.repeat_customers, 0)::NUMERIC / t.total_customers * 100), 2) AS repeat_purchase_rate
FROM
    total_customers t
LEFT JOIN
    repeat_customers r
ON
    t.year = r.year AND t.purchase_type = r.purchase_type
ORDER BY
    t.year, t.purchase_type;

-- Overall Monthly AOV
SELECT
    EXTRACT(YEAR FROM paid_at) AS year,
    EXTRACT(MONTH FROM paid_at) AS month,
    ROUND(SUM(total) / COUNT(order_id), 2) AS monthly_aov
FROM
    all_orders
WHERE
    paid_at >= '2022-01-01' 
    AND paid_at <= '2024-09-30'
GROUP BY
    EXTRACT(YEAR FROM paid_at),
    EXTRACT(MONTH FROM paid_at)
ORDER BY
    year, month;

-- Monthly AOV by type
SELECT
    EXTRACT(YEAR FROM paid_at) AS year,
    EXTRACT(MONTH FROM paid_at) AS month,
    CASE
        WHEN lineitem_name = 'Subscription - 1 Bottle' 
            OR lineitem_name = 'Subscription - 2 Bottles' 
            OR lineitem_name = 'Subscription - 3 Bottles' 
        THEN 'subscription'
        ELSE 'one-time'
    END AS purchase_type,
    ROUND(SUM(total) / COUNT(order_id), 2) AS monthly_aov
FROM
    all_orders
WHERE
    paid_at >= '2022-01-01' 
    AND paid_at <= '2024-09-30'
GROUP BY
    EXTRACT(YEAR FROM paid_at),
    EXTRACT(MONTH FROM paid_at),
    purchase_type
ORDER BY
    year, month, purchase_type;

-- CREATE WEB VISIT SESSION COUNT TABLE
CREATE TABLE monthly_sessions (
    session_month VARCHAR(7) PRIMARY KEY,
	total_sessions INT
);

SELECT *
FROM monthly_sessions;

-- Overall Monthly CR
WITH orders_data AS (
    SELECT
        TO_CHAR(paid_at, 'YYYY-MM') AS order_month,
        COUNT(order_id) AS total_orders
    FROM
        all_orders
    WHERE
        paid_at >= '2022-01-01' AND paid_at <= '2024-09-30'
    GROUP BY
        TO_CHAR(paid_at, 'YYYY-MM')
)
SELECT
    s.session_month,
    s.total_sessions,
    o.total_orders,
    ROUND((o.total_orders::NUMERIC / s.total_sessions) * 100, 2) AS conversion_rate_combined
FROM
    monthly_sessions s
LEFT JOIN
    orders_data o
ON
    s.session_month = o.order_month
WHERE
    s.session_month >= '2022-01' AND s.session_month <= '2024-09'
ORDER BY
    s.session_month;

-- Monthly CR for one-time purchase
WITH one_time_orders AS (
    SELECT
        TO_CHAR(paid_at, 'YYYY-MM') AS order_month,
        COUNT(order_id) AS total_orders
    FROM
        all_orders
    WHERE
        paid_at >= '2022-01-01'
        AND paid_at <= '2024-09-30'
        AND (lineitem_name NOT LIKE 'Subscription%' OR lineitem_name IS NULL)
    GROUP BY
        TO_CHAR(paid_at, 'YYYY-MM')
)
SELECT
    s.session_month,
    s.total_sessions,
    o.total_orders,
    ROUND((o.total_orders::NUMERIC / s.total_sessions) * 100, 2) AS conversion_rate_onetime
FROM
    monthly_sessions s
LEFT JOIN
    one_time_orders o
ON
    s.session_month = o.order_month
WHERE
    s.session_month >= '2022-01' AND s.session_month <= '2024-09'
ORDER BY
    s.session_month;

-- Monthly CR for subscription purchase
WITH subscription_orders AS (
    SELECT
        TO_CHAR(paid_at, 'YYYY-MM') AS order_month,
        COUNT(order_id) AS total_orders
    FROM
        all_orders
    WHERE
        paid_at >= '2022-01-01'
        AND paid_at <= '2024-09-30'
        AND lineitem_name LIKE 'Subscription%' 
    GROUP BY
        TO_CHAR(paid_at, 'YYYY-MM')
)
SELECT
    s.session_month,
    s.total_sessions,
    o.total_orders,
    ROUND((o.total_orders::NUMERIC / s.total_sessions) * 100, 2) AS conversion_rate_subscription
FROM
    monthly_sessions s
LEFT JOIN
    subscription_orders o
ON
    s.session_month = o.order_month
WHERE
    s.session_month >= '2022-01' AND s.session_month <= '2024-09'
ORDER BY
    s.session_month;

-- Determine Average Customer Lifespan
WITH customer_lifespan AS (
    SELECT
        email,
        MIN(paid_at) AS first_purchase_date,
        MAX(paid_at) AS last_purchase_date,
        (MAX(paid_at) - MIN(paid_at)) AS customer_lifespan_in_days
    FROM
        all_orders
    GROUP BY
        email
)
SELECT
    ROUND(AVG(customer_lifespan_in_days), 2) AS average_customer_lifespan_in_days
FROM
    customer_lifespan;

-- Overall CLTV
WITH customer_metrics AS (
    SELECT
        email,
        COUNT(order_id) AS total_orders,
        SUM(total) AS total_revenue,
        MIN(paid_at) AS first_purchase_date,
        MAX(paid_at) AS last_purchase_date,
        (MAX(paid_at) - MIN(paid_at)) AS customer_lifespan_in_days
    FROM
        all_orders
    GROUP BY
        email
),
overall_metrics AS (
    SELECT
        ROUND(SUM(total_revenue)::NUMERIC / SUM(total_orders), 2) AS aov,
        ROUND(SUM(total_orders)::NUMERIC / COUNT(email), 2) AS purchase_frequency,
        45.28 AS customer_lifespan_in_days
    FROM
        customer_metrics
)
SELECT
    aov,
    purchase_frequency,
    customer_lifespan_in_days,
    ROUND((aov * purchase_frequency * customer_lifespan_in_days / 30.44), 2) AS cltv
FROM
    overall_metrics;

-- Yearly CLTV
WITH customer_metrics AS (
    SELECT
        email,
        EXTRACT(YEAR FROM paid_at) AS year,
        COUNT(order_id) AS total_orders,
        SUM(total) AS total_revenue,
        MIN(paid_at) AS first_purchase_date,
        MAX(paid_at) AS last_purchase_date,
        (MAX(paid_at) - MIN(paid_at)) AS customer_lifespan_in_days
    FROM
        all_orders
    GROUP BY
        email, year
),
yearly_metrics AS (
    SELECT
        year,
        ROUND(SUM(total_revenue)::NUMERIC / SUM(total_orders), 2) AS aov,
        ROUND(SUM(total_orders)::NUMERIC / COUNT(email), 2) AS purchase_frequency,
        45.28 AS customer_lifespan_in_days
    FROM
        customer_metrics
    GROUP BY
        year
)
SELECT
    year,
    aov,
    purchase_frequency,
    customer_lifespan_in_days,
    ROUND((aov * purchase_frequency * customer_lifespan_in_days / 30.44), 2) AS cltv
FROM
    yearly_metrics
ORDER BY
    year;

