/* AA : Sonic : # of HQA/opp: prod */
SELECT
    hqa_total.Alfa_ID AS 'Alfa ID',
    hqa_total.HQA_Total AS 'HQA Total',
    hqa_disqualified.HQA_Disqualified AS 'HQA Disqualified'
FROM
    (
        SELECT
            applications.opportunity_reference_id AS 'Alfa_ID',
            count(distinct applications.gg_id) AS 'HQA_Total'
        FROM
            applications
        WHERE
            applications.match_score > 0.80
            AND (
                applications.filters_passed = true
                OR applications.filters_passed IS NULL
            )
        GROUP BY
            applications.opportunity_reference_id
    ) AS hqa_total
    CROSS JOIN (
        SELECT
            disqualifications.opportunity_reference_id AS 'Alfa_ID',
            count(distinct disqualifications.gg_id) AS 'HQA_Disqualified'
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
        GROUP BY
            disqualifications.opportunity_reference_id
    ) AS hqa_disqualified ON hqa_total.Alfa_ID = hqa_disqualified.Alfa_ID