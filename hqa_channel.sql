/* AA : Sonic : # of HQA per channel: prod */
SELECT
    applications.opportunity_reference_id AS 'Alfa ID',
    applications.utm_medium AS 'UTM',
    count(*) AS 'HQA'
FROM
    applications
WHERE
    applications.match_score > 0.80
    AND (
        applications.filters_passed = true
        OR applications.filters_passed IS NULL
        )
GROUP BY
    applications.opportunity_reference_id,
    applications.utm_medium