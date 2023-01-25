/* AA : Sonic : opportunity operators: prod */ 
SELECT
    opportunities.opportunity_id AS 'Alfa ID',
    operators.operator_gg_id AS 'gg_id',
    opportunity_operators.role,
    operators.slack_id
FROM 
    opportunity_operators
    LEFT JOIN opportunities ON opportunity_operators.opportunity_id = opportunities.id
    LEFT JOIN operators ON opportunity_operators.operator_id = operators.id
WHERE 
    opportunity_operators.deactivated IS NULL
    AND opportunities.opportunity_id != 'VWYo8bvd'
    AND opportunities.opportunity_id != 'Gdj786Yr'
GROUP BY 
    opportunities.opportunity_id,
    operators.operator_gg_id,
    opportunity_operators.role