SELECT * FROM Olist.olist_orders_dataset LIMIT 5;

#1 ¿Cuántas órdenes hay por status?
SELECT 
	COUNT(o.order_id) AS total_ordenes, 
	order_status 
FROM Olist.olist_orders_dataset o
GROUP BY order_status 
ORDER BY order_status DESC;

#2 TOP 10 Vendedores con mayor número de órdenes
SELECT 
	oi.seller_id, 
    COUNT(oi.order_id) AS total_ordenes, 
    RANK() OVER (ORDER BY COUNT(oi.order_id) DESC) AS ranking
FROM Olist.olist_order_items_dataset oi
GROUP BY seller_id
LIMIT 10;

#3 Mayores vendedores por zona
SELECT 
	os.seller_id, 
	SUM(oi.price) AS ingreso_total,
    os.seller_state,
    ROW_NUMBER() OVER (PARTITION BY os.seller_state ORDER BY SUM(oi.price)DESC) AS ranking
FROM Olist.olist_sellers_dataset os
JOIN Olist.olist_order_items_dataset oi ON os.seller_id = oi.seller_id
GROUP BY os.seller_id,os.seller_state
LIMIT 10;

#4 Top 5 categorías por ingreso total
SELECT 
	op.product_category_name,
    ROUND(SUM(oi.price),2) AS ingreso_total,
    ROW_NUMBER() OVER (ORDER BY SUM(oi.price) DESC) AS ranking
FROM Olist.olist_products_dataset op
JOIN Olist.olist_order_items_dataset oi ON op.product_id = oi.product_id
GROUP BY op.product_category_name
LIMIT 5;

#5 TOP 5 Zonas con ventas más bajas
SELECT 
	oc.customer_state,
    SUM(oi.price) AS ingreso_total
FROM Olist.olist_customers_dataset oc
JOIN Olist.olist_orders_dataset o ON oc.customer_id = o.customer_id
JOIN Olist.olist_order_items_dataset oi ON o.order_id = oi.order_id
GROUP BY oc.customer_state
ORDER BY ingreso_total ASC
LIMIT 5;