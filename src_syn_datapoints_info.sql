/* AA : Sonic : sourcing & syndication info from data points: prod */
SELECT
    o.opportunity_id AS 'Alfa ID',
    o.success_fee_percentage AS 'Success fee',
    REGEXP_SUBSTR(src_datapoint.comments, '(?<=Number of connections found: )\\d+(\\.\\d+)?') AS src_connections_found,
    REGEXP_SUBSTR(src_datapoint.comments, '(?<=Number of connections needed: )\\d+(\\.\\d+)?') AS src_connections_needed,
    REGEXP_SUBSTR(syn_datapoint.comments, '(?<=Applications needed: )\\d+(\\.\\d+)?') AS syn_applications_needed
FROM 
    opportunities o
    LEFT JOIN (
        SELECT
            d.opportunity_id,
            d.comments
        FROM 
            data_points d
        WHERE 
            d.comments IS NOT NULL
            AND d.id IN (
                SELECT 
                    MAX(id)
                FROM 
                    data_points
                WHERE
                    subject = 'sourcing-feedback'
                GROUP BY 
                    opportunity_id
            )
    ) src_datapoint ON o.id = src_datapoint.opportunity_id
    LEFT JOIN (
        SELECT
            d.opportunity_id,
            d.comments
        FROM 
            data_points d
        WHERE 
            d.comments IS NOT NULL
            AND d.id IN (
                SELECT 
                    MAX(id)
                FROM 
                    data_points
                WHERE
                    subject = 'syndication-log'
                GROUP BY 
                    opportunity_id
            )
    ) syn_datapoint ON o.id = syn_datapoint.opportunity_id