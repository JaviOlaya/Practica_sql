SELECT ic.ivr_id AS calls_ivr_id,
 ic.phone_number AS calls_phone_number,
 ic.ivr_result AS calls_ivr_result,
 ic.vdn_label AS calls_vdn_label,
 ic.start_date AS calls_start_date,
 FORMAT_DATE('%Y%m%d', ic.start_date) AS calls_start_date_id,
 ic.end_date AS calls_end_date,
 FORMAT_DATE('%Y%m%d', ic.end_date) AS calls_end_date_id,
 ic.total_duration AS calls_total_duration,
 ic.customer_segment AS calls_customer_segment,
 ic.ivr_language AS calls_ivr_language,
 ic.steps_module AS calls_steps_module,
 ic.module_aggregation AS calls_module_aggregation,
 im.module_sequece,
 im.module_name,
 im.module_duration,
 im.module_result,
 si.step_sequence,
 si.step_name, 
 si.step_result,
 si.step_description_error,
 step_description_error,
 document_type,
 document_identification,
 customer_phone,
 billing_account_id,
FROM `keepcoding.ivr_calls` AS ic
LEFT JOIN  `keepcoding.ivr_modules` AS im
on ic.ivr_id = im.ivr_id  
LEFT JOIN `keepcoding.ivr_steps` AS si
on im.ivr_id=si.ivr_id AND im.module_sequece=si.module_sequece
;