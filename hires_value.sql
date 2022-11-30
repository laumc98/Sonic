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
            o.id AS ID,
            oc.periodicity,
            oc.currency,
            COALESCE(NULLIF(oc.max_amount,0), oc.min_amount) AS value
        FROM
            opportunities o
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
            AND date(coalesce(null, o.first_reviewed, o.last_reviewed)) > date(date_add(now(6), INTERVAL -1 year))
    ) AS compensations
GROUP BY 1