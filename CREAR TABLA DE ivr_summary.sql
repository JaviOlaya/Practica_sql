--CREAR TABLA DE ivr_summary

SELECT ic.ivr_id,
 ic.phone_number,
 ic.ivr_result,
case
  when ic.vdn_label like 'ATC%' THEN 'FRONT'
  when ic.vdn_label like 'TECH%' THEN 'TECH'
  else 'RESTO'
END as vdn_aggregation,
 ic.start_date,
 ic.end_date,
 ic.total_duration,
 ic.customer_segment,
  CASE
    WHEN SUM(CASE WHEN si.document_type = 'DNI' THEN 1 ELSE 0 END) >0 THEN 'DNI'

    WHEN SUM(CASE WHEN si.document_type = 'CIF' THEN 1 ELSE 0 END) >0 THEN 'CIF'

    WHEN SUM(CASE WHEN si.document_type = 'NIE'  THEN 1 ELSE 0 END) >0 THEN 'NIE'

    WHEN SUM(CASE WHEN si.document_type = 'PASSPORT' THEN 1 ELSE 0 END) >0 THEN 'PASSPORT'

    ELSE MAX(si.document_type)

  END AS document_type,

  CASE 
      WHEN SUM(CASE WHEN si.document_type = 'DNI' THEN 1 ELSE 0 END) > 0 
        THEN MAX(CASE WHEN si.document_type = 'DNI' THEN  si.document_identification ELSE NULL END)


      WHEN SUM(CASE WHEN si.document_type = 'CIF' THEN 1 ELSE 0 END) > 0 
          THEN MAX(CASE WHEN si.document_type = 'CIF' THEN  si.document_identification ELSE NULL END)

      WHEN SUM(CASE WHEN si.document_type = 'NIE' THEN 1 ELSE 0 END) > 0 
          THEN MAX(CASE WHEN si.document_type = 'NIE' THEN  si.document_identification ELSE NULL END)

      WHEN SUM(CASE WHEN si.document_type = 'PASSPORT' THEN 1 ELSE 0 END) > 0 
          THEN MAX(CASE WHEN si.document_type = 'PASSPORT' THEN  si.document_identification ELSE NULL END)
        ELSE MAX(CASE WHEN si.document_type = 'UNKNOWN' THEN  si.document_identification ELSE NULL END)
  END AS document_identification,
  case when sum(case when si.customer_phone <>'UNKNOWN' THEN 1 ELSE 0 END) > 0
    THEN MAX(CASE WHEN si.customer_phone <>'UNKNOWN' THEN  si.customer_phone ELSE NULL END)
    ELSE 'UNKNOWN'
  end as customer_phone,
  case when sum(case when  si.billing_account_id <>'UNKNOWN' THEN 1 ELSE 0 END) > 0
    THEN MAX(CASE WHEN  si.billing_account_id <>'UNKNOWN' THEN   si.billing_account_id ELSE NULL END)
    ELSE 'UNKNOWN'
  end as  billing_account_id,
  MAX(CASE WHEN im.module_name ='AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg,
  MAX(CASE WHEN si.step_name = 'CUSTOMERINFOBYPHONE.TX' and si.step_result='OK' THEN 1 ELSE 0 END) AS info_by_phone_lg,
  MAX(CASE
       WHEN si.step_name = 'CUSTOMERINFOBYDNI.TX' and si.step_result='OK' THEN 1
       ELSE 0 
      END) AS info_by_dni_lg,
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
GROUP BY ic.ivr_id,
 ic.phone_number,
 ic.ivr_result, ic.start_date,
 ic.end_date,
 ic.total_duration,
 ic.customer_segment,ic.vdn_label
 ORDER BY ic.ivr_id