/* AA : SONIC : hires by oppid : prod */ 
SELECT
    o.id AS 'ID',
    tc.utm_medium AS 'UTM',
    count(*) AS 'hires'
FROM
    (
        SELECT
            DATE(ooh.hiring_date) AS 'hire_date',
            ooh.opportunity_candidate_id AS 'candidate_id'
        FROM 
            opportunity_operational_hires ooh
        WHERE
            ooh.hiring_date > '2021-7-18'
            
        UNION
        
        SELECT
            MIN(occh.created) AS 'hire_date',
            occh.candidate_id AS 'candidate_id'
        FROM
            opportunity_candidate_column_history occh
            INNER JOIN opportunity_candidates ocan ON occh.candidate_id = ocan.id
            INNER JOIN opportunities o ON ocan.opportunity_id = o.id
        WHERE
            occh.created >= '2022-01-01'
            AND occh.to_funnel_tag = 'hired'
            AND (
                o.fulfillment LIKE 'self%'
                OR o.fulfillment LIKE 'essentials%'
                OR o.fulfillment LIKE 'pro%'
                OR o.fulfillment LIKE 'ats%'
            )
        GROUP BY
            occh.candidate_id
    ) AS all_hires
    INNER JOIN opportunity_candidates ocan ON all_hires.candidate_id = ocan.id
    INNER JOIN opportunities o ON ocan.opportunity_id = o.id
    LEFT JOIN tracking_code_candidates tcc ON ocan.id = tcc.candidate_id
    LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
WHERE 
    date(all_hires.hire_date) > "2021-1-1"
    AND date(coalesce(null, o.first_reviewed, o.last_reviewed)) > date(date_add(now(6), INTERVAL -1 year))
GROUP BY 
    o.id,
    tc.utm_medium