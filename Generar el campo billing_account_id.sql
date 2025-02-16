--Generar el campo billing_account_id

SELECT  ic.ivr_id AS calls_ivr_id,
   
  case when sum(case when  si.billing_account_id <>'UNKNOWN' THEN 1 ELSE 0 END) > 0
    THEN MAX(CASE WHEN  si.billing_account_id <>'UNKNOWN' THEN   si.billing_account_id ELSE NULL END)
    ELSE 'UNKNOWN'
  end as  billing_account_id
FROM `keepcoding.ivr_calls` AS ic
LEFT JOIN  `keepcoding.ivr_modules` AS im
on ic.ivr_id = im.ivr_id  
LEFT JOIN `keepcoding.ivr_steps` AS si
on im.ivr_id=si.ivr_id AND im.module_sequece=si.module_sequece
group by calls_ivr_id
order by calls_ivr_id;