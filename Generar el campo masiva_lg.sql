-- Generar el campo masiva_lg

 SELECT  ic.ivr_id AS calls_ivr_id,
  MAX(CASE WHEN im.module_name ='AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg
FROM `keepcoding.ivr_calls` AS ic
INNER JOIN  `keepcoding.ivr_modules` AS im
on ic.ivr_id = im.ivr_id  
INNER JOIN `keepcoding.ivr_steps` AS si
on im.ivr_id=si.ivr_id AND im.module_sequece=si.module_sequece
group by calls_ivr_id
order by calls_ivr_id limit 100;