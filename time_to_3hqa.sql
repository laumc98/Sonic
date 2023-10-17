/* AA : Sonic : time to 3HQA: prod */
SELECT
    opportunity_reference_id AS 'Alfa ID',
    date(timestamp) AS 'hqa_date'
FROM
    (
        SELECT
            hqa.*,
            IF(
                BINARY @index <> BINARY hqa.opportunity_reference_id,
                @sum := 1,
                @sum := @sum + 1
            ) AS hqa_sum,
            IF(
                BINARY @index <> BINARY hqa.opportunity_reference_id,
                @index := hqa.opportunity_reference_id,
                @index := @index
            ) AS idd
        FROM
            (
                SELECT
                    applications.opportunity_reference_id,
                    applications.timestamp
                FROM
                    applications
                    LEFT JOIN mutual_matches ON (
                        mutual_matches.gg_id = applications.gg_id
                        AND mutual_matches.opportunity_reference_id = applications.opportunity_reference_id
                    )
                WHERE
                    applications.filters_passed = true
                    OR mutual_matches.timestamp IS NOT NULL 
                ORDER BY
                    applications.opportunity_reference_id,
                    applications.timestamp
            ) AS hqa
            CROSS JOIN (
                SELECT
                    @sum := 0,
                    @index := 0
            ) counter
    ) numbered
WHERE
    hqa_sum = 3