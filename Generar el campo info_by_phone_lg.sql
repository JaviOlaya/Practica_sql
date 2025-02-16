--Generar el campo info_by_phone_lg

 SELECT  ic.ivr_id AS calls_ivr_id,
  MAX(CASE WHEN si.step_name = 'CUSTOMERINFOBYPHONE.TX' and si.step_result='OK' THEN 1 ELSE 0 END) AS info_by_phone_lg
FROM `keepcoding.ivr_calls` AS ic
LEFT JOIN  `keepcoding.ivr_modules` AS im
on ic.ivr_id = im.ivr_id  
LEFT JOIN `keepcoding.ivr_steps` AS si
on im.ivr_id=si.ivr_id AND im.module_sequece=si.module_sequece
group by calls_ivr_id
order by calls_ivr_id limit 1000;