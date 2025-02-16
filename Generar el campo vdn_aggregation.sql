--Generar el campo vdn_aggregation


SELECT  ic.ivr_id AS calls_ivr_id,
case
  when vdn_label like 'ATC%' THEN 'FRONT'
  when vdn_label like 'TECH%' THEN 'TECH'
  else 'RESTO'
END as vdn_aggregation
FROM `keepcoding.ivr_calls` AS ic
LEFT JOIN  `Bootcamp_keepcoding.ivr_modules` AS im
on ic.ivr_id = im.ivr_id  
LEFT JOIN `keepcoding.ivr_steps` AS si
on im.ivr_id=si.ivr_id AND im.module_sequece=si.module_sequece
group by calls_ivr_id, vdn_aggregation
LIMIT 100;