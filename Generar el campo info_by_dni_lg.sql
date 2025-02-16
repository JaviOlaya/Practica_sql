--Generar el campo info_by_dni_lg

 SELECT  ic.ivr_id AS calls_ivr_id,
  MAX(CASE
       WHEN si.step_name = 'CUSTOMERINFOBYDNI.TX' and si.step_result='OK' THEN 1
       ELSE 0 
      END) AS info_by_dni_lg
FROM `keepcoding.ivr_calls` AS ic
INNER JOIN  `keepcoding.ivr_modules` AS im
on ic.ivr_id = im.ivr_id  
INNER JOIN `keepcoding.ivr_steps` AS si
on im.ivr_id=si.ivr_id AND im.module_sequece=si.module_sequece
group by calls_ivr_id
order by calls_ivr_id limit 1000;