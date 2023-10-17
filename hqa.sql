/* AA : Sonic : # of HQA/opp: prod */
SELECT
    opportunity.ref_id AS 'Alfa ID',
    hqa_active.HQA_Active AS 'HQA_Active',
    mm_active.Active_MM AS 'Active_MM',
    hqa_disqualified.HQA_Disqualified AS 'HQA Disqualified'
FROM
    opportunity
    LEFT JOIN (
        SELECT
            disqualifications.opportunity_reference_id AS 'Alfa_ID',
            count(distinct disqualifications.gg_id) AS 'HQA_Disqualified'
        FROM
            disqualifications
            LEFT JOIN applications ON (
                applications.gg_id = disqualifications.gg_id
                AND applications.opportunity_reference_id = disqualifications.opportunity_reference_id
            )
        WHERE
            applications.filters_passed = true  
        GROUP BY
            disqualifications.opportunity_reference_id
    ) AS hqa_disqualified ON opportunity.ref_id = hqa_disqualified.Alfa_ID
    LEFT JOIN (
        SELECT
            applications.opportunity_reference_id AS 'Alfa_ID',
            count(*) AS 'HQA_Active'
        FROM
            applications
            LEFT JOIN disqualifications ON (disqualifications.gg_id = applications.gg_id AND disqualifications.opportunity_reference_id = applications.opportunity_reference_id)
            LEFT JOIN mutual_matches ON (mutual_matches.gg_id = applications.gg_id AND mutual_matches.opportunity_reference_id = applications.opportunity_reference_id)
        WHERE
            applications.filters_passed = true
            AND disqualifications.timestamp IS NULL
            AND mutual_matches.timestamp IS NULL
        GROUP BY
            applications.opportunity_reference_id
    ) AS hqa_active ON opportunity.ref_id = hqa_active.Alfa_ID
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
    ) AS mm_active ON opportunity.ref_id = mm_active.Alfa_ID
WHERE 
    JSON_EXTRACT(opportunity.opportunity_snapshot, '$."crawled"') = FALSE
    AND (hqa_active.HQA_Active IS NOT NULL 
        OR mm_active.Active_MM IS NOT NULL 
        OR hqa_disqualified.HQA_Disqualified IS NOT NULL 
    )
GROUP BY 
    opportunity.ref_id