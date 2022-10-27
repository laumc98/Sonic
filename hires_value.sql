/* AA : Sonic : hires value : prod */ 
SELECT
    ID,
    SUBSTR(currency, 1, 3) AS currency_code,
    CASE
        periodicity
        WHEN 'yearly' THEN value
        WHEN 'monthly' THEN value * 12
        WHEN 'weekly' THEN value * 48
        WHEN 'daily' THEN value * 240
        WHEN 'hourly' THEN value * 1920
        WHEN 'project' THEN value
    END AS yearly_value
FROM
    (
        SELECT
            ooh.id AS hire_id,
            oc.periodicity,
            oc.currency,
            ooh.hiring_date,
            o.id AS ID,
            COALESCE(NULLIF(oc.max_amount,0), oc.min_amount) AS value
        FROM
            opportunity_operational_hires ooh
        INNER JOIN opportunities o ON o.id = ooh.opportunity_id
        INNER JOIN opportunity_compensations oc ON o.id = oc.opportunity_id AND oc.active
        WHERE
            o.id NOT IN (1861230, 1316677)
            AND o.id NOT IN (
                SELECT
                    DISTINCT opportunity_id
                FROM
                    opportunity_organizations
                WHERE
                    organization_id = 748404
                    AND active
            )
            AND o.objective not like '**%'
    ) AS compensations
GROUP BY 1