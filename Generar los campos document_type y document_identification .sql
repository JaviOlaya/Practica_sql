/*
Generar los campos document_type y 
document_identification
*/
SELECT  ic.ivr_id AS calls_ivr_id,
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

FROM `keepcoding.ivr_calls` AS ic
INNER JOIN  `keepcoding.ivr_modules` AS im
on ic.ivr_id = im.ivr_id  
INNER JOIN `keepcoding.ivr_steps` AS si
on im.ivr_id=si.ivr_id AND im.module_sequece=si.module_sequece
group by calls_ivr_id
order by calls_ivr_id;