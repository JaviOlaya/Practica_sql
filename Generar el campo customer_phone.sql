--Generar el campo customer_phone

SELECT  ic.ivr_id AS calls_ivr_id,
   
  case when sum(case when si.customer_phone <>'UNKNOWN' THEN 1 ELSE 0 END) > 0
    THEN MAX(CASE WHEN si.customer_phone <>'UNKNOWN' THEN  si.customer_phone ELSE NULL END)
    ELSE 'UNKNOWN'
  end as customer_phone

FROM `keepcoding.ivr_calls` AS ic
INNER JOIN  `keepcoding.ivr_modules` AS im
on ic.ivr_id = im.ivr_id  
INNER JOIN `keepcoding.ivr_steps` AS si
on im.ivr_id=si.ivr_id AND im.module_sequece=si.module_sequece
group by calls_ivr_id
order by calls_ivr_id;