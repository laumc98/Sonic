/* AA : Sonic : # of HQA/opp: prod */
SELECT
    hqa_total.Alfa_ID AS 'Alfa ID',
    hqa_total.HQA_Total AS 'HQA Total',
    hqa_disqualified.HQA_Disqualified AS 'HQA Disqualified',
    hqa_active.HQA_Active AS 'HQA_Active',
    mm_active.Active_MM AS 'Active_MM'
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
    LEFT JOIN (
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
    LEFT JOIN (
        SELECT
            applications.opportunity_reference_id AS 'Alfa_ID',
            count(*) AS 'HQA_Active'
        FROM
            applications
            LEFT JOIN disqualifications ON (disqualifications.gg_id = applications.gg_id AND disqualifications.opportunity_reference_id = applications.opportunity_reference_id)
            LEFT JOIN mutual_matches ON (mutual_matches.gg_id = applications.gg_id AND mutual_matches.opportunity_reference_id = applications.opportunity_reference_id)
            LEFT JOIN hires ON (hires.gg_id = applications.gg_id AND hires.opportunity_reference_id = applications.opportunity_reference_id)
        WHERE
            applications.match_score > 0.80
            AND (
                applications.filters_passed = true
                OR applications.filters_passed IS NULL
                )
            AND disqualifications.timestamp IS NULL
            AND mutual_matches.timestamp IS NULL
            AND hires.timestamp IS NULL
        GROUP BY
            applications.opportunity_reference_id
    ) AS hqa_active ON hqa_total.Alfa_ID = hqa_active.Alfa_ID
    LEFT JOIN (
        SELECT
            mutual_matches.opportunity_reference_id AS 'Alfa_ID',
            count(*) AS 'Active_MM'
        FROM
            mutual_matches
            LEFT JOIN disqualifications ON (disqualifications.gg_id = mutual_matches.gg_id AND disqualifications.opportunity_reference_id = mutual_matches.opportunity_reference_id)
            LEFT JOIN hires ON (hires.gg_id = mutual_matches.gg_id AND hires.opportunity_reference_id = mutual_matches.opportunity_reference_id)
        WHERE
            disqualifications.timestamp IS NULL
            AND hires.timestamp IS NULL
        GROUP BY
            mutual_matches.opportunity_reference_id
    ) AS mm_active ON hqa_total.Alfa_ID = mm_active.Alfa_ID