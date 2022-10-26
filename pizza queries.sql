SELECT 
s1.item_name, s1.ing_id, s1.ing_name, s1.ing_weight,
s1.ing_price, s1.order_quantity, s1.recipe_quantity,
s1.order_quantity*s1.recipe_quantity AS ordered_weight,
s1.ing_price/s1.ing_weight AS unit_cost,
(s1.order_quantity*s1.recipe_quantity)*(s1.ing_price/s1.ing_weight) AS ingredient_cost
FROM (SELECT 
	o.item_id, i.sku, i.item_name, r.ing_id, ing.ing_name, r.quantity AS recipe_quantity, 
    SUM(o.quantity) AS order_quantity, ing.ing_weight, ing.ing_price
FROM orders o
	LEFT JOIN item i on o.item_id = i.item_id
	LEFT JOIN recipe r ON i.sku = r.recipe_id
    LEFT JOIN ingredient ing ON ing.ing_id = r.ing_id
GROUP BY 
	o.item_id, i.sku, i.item_name, r.ing_id, r.quantity, ing.ing_name, ing.ing_weight, ing.ing_price) s1;

SELECT
s2.ing_name, s2.ordered_weight, ing.ing_weight, inv.quantity,
ing.ing_weight*inv.quantity AS total_inv_weight,
(ing.ing_weight * inv.quantity)-s2.ordered_weight AS remaining_weight
FROM
(SELECT ing_id, ing_name, SUM(ordered_weight) AS ordered_weight
FROM stock1
GROUP BY ing_id, ing_name) s2
LEFT JOIN inventory inv ON inv.item_id = s2.ing_id
LEFT JOIN ingredient ing ON ing.ing_id = s2.ing_id;

SELECT 
r.date, s.first_name, s.last_name, s.hourly_rate,
sh.start_time, sh.end_time,
((HOUR(TIMEDIFF(sh.end_time,sh.start_time))*60)+(MINUTE(TIMEDIFF(sh.end_time,sh.start_time))))/60 AS hours_in_shift,
((HOUR(TIMEDIFF(sh.end_time,sh.start_time))*60)+(MINUTE(TIMEDIFF(sh.end_time,sh.start_time))))/60 *s.hourly_rate AS staff_cost
FROM rota r
LEFT JOIN staff s ON r.staff_id = s.staff_id
LEFT JOIN shift sh ON r.shift_id = sh.shift_id;