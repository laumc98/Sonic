/* AA : Sonic : Active users/channel: prod */ 
SELECT 
    o.id AS ID,
    tc.utm_medium,
    count(distinct oc.id) AS active_users
FROM 
    opportunities o 
    LEFT JOIN opportunity_candidates oc ON o.id = oc.opportunity_id
    LEFT JOIN opportunity_columns oc2 ON oc.column_id = oc2.id
    LEFT JOIN opportunity_operational_hires osh ON o.id = osh.opportunity_id 
    LEFT JOIN tracking_code_candidates tcc ON oc.id = tcc.candidate_id
    LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
    LEFT JOIN (
        SELECT 
            me.candidate_id, 
            max(me.interested) as last_interest, 
            max(me.not_interested) as last_not_interest
        FROM 
            member_evaluations me
        GROUP BY 
            me.candidate_id) AS last_evaluation on last_evaluation.candidate_id = oc.id
WHERE
    oc.id is not null 
    AND oc.interested is not null 
    AND oc.column_id is not null
    AND osh.hiring_date is null
    AND (last_evaluation.last_not_interest is null OR last_evaluation.last_interest > last_evaluation.last_not_interest)
    AND o.objective not like '**%'
    AND o.review = 'approved'
    AND o.status <> 'opening-soon'
    AND o.active = TRUE
    AND DATE(o.last_reviewed) > date(date_add(now(6), INTERVAL -1 year))
    AND o.id = 1880246
GROUP BY
    o.id,
    tc.utm_medium