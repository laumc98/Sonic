/* AA : SONIC : mm by oppid : prod */ 
SELECT 
    oc.opportunity_id AS ID,
    tc.utm_medium AS UTM,
    count(distinct occh.candidate_id) AS mutuals
FROM
    opportunity_candidate_column_history occh
    INNER JOIN opportunity_columns oc ON occh.to = oc.id
    INNER JOIN opportunities o ON oc.opportunity_id = o.id
    LEFT JOIN tracking_code_candidates tcc ON occh.candidate_id = tcc.candidate_id
    LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
WHERE
    oc.name = 'mutual matches'
    AND occh.created >= '2021-01-01'
    AND o.objective NOT LIKE '**%'
    AND o.id IN (
        SELECT
            DISTINCT o.id AS opportunity_id
        FROM
            opportunities o
            INNER JOIN opportunity_members omp ON omp.opportunity_id = o.id
            AND omp.poster = TRUE
            INNER JOIN person_flags pf ON pf.person_id = omp.person_id
            AND pf.opportunity_crawler = FALSE
        WHERE
            date(coalesce(null, o.first_reviewed, o.last_reviewed)) >= date(date_add(now(6), INTERVAL -1 year))
            AND o.objective NOT LIKE '**%'
            AND o.review = 'approved'
    )
GROUP BY
    oc.opportunity_id,
    tc.utm_medium