/*
Generar los campos repeated_phone_24H, 
cause_recall_phone_24H
*/

SELECT 
  ic.ivr_id AS calls_ivr_id,
  ic.phone_number AS calls_phone_number,
  ic.start_date,
  CASE 
    WHEN EXISTS (
      SELECT 1
      FROM `keepcoding.ivr_calls` AS ic_prev
      WHERE ic_prev.phone_number = ic.phone_number
        AND ic_prev.ivr_id <> ic.ivr_id
        AND ic_prev.start_date >= TIMESTAMP_SUB(ic.start_date, INTERVAL 24 HOUR)
        AND ic_prev.start_date < ic.start_date
    ) THEN 1
    ELSE 0
  END AS repeated_phone_24H,
  CASE 
    WHEN EXISTS (
      SELECT 1
      FROM `keepcoding.ivr_calls` AS ic_next
      WHERE ic_next.phone_number = ic.phone_number
        AND ic_next.ivr_id <> ic.ivr_id
        AND ic_next.start_date > ic.start_date
        AND ic_next.start_date <= TIMESTAMP_ADD(ic.start_date, INTERVAL 24 HOUR)
    ) THEN 1
    ELSE 0
  END AS cause_recall_phone_24H
FROM `keepcoding.ivr_calls` AS ic
LEFT JOIN  `keepcoding.ivr_modules` AS im
on ic.ivr_id = im.ivr_id  
LEFT JOIN `keepcoding.ivr_steps` AS si
on im.ivr_id=si.ivr_id AND im.module_sequece=si.module_sequece
group by calls_ivr_id
order by calls_ivr_id limit 1000;