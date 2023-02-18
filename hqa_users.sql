/* AA : SONIC : hqa gg_ids : prod */ 
SELECT
    applications.opportunity_reference_id AS 'Alfa ID',
    applications.gg_id,
    applications.match_score,
    applications.utm_medium AS 'UTM',
    disqualifications.timestamp AS 'disqualified_date'
FROM
    applications
    LEFT JOIN disqualifications ON (
        disqualifications.gg_id = applications.gg_id
        AND disqualifications.opportunity_reference_id = applications.opportunity_reference_id
    )
WHERE
    applications.match_score > 0.80
    AND (
        applications.filters_passed = true
        OR applications.filters_passed IS NULL
    )
ORDER BY
    applications.opportunity_reference_id ASC