/* AA : Sonic : # of HQA per channel: prod */
SELECT
    applications.opportunity_reference_id AS 'Alfa ID',
    applications.utm_medium AS 'UTM',
    count(*) AS 'HQA'
FROM
    applications
    LEFT JOIN disqualifications ON (disqualifications.gg_id = applications.gg_id AND disqualifications.opportunity_reference_id = applications.opportunity_reference_id)
WHERE
    applications.filters_passed = true
    AND disqualifications.timestamp IS NULL
GROUP BY
    applications.opportunity_reference_id,
    applications.utm_medium