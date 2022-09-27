/* AA : Sonic : manual invite invited users: prod */ 
SELECT 
    career_advisor_suggested_opportunities.opportunity_id AS 'Alfa ID',
    count(*) AS 'rc_trrx_inv_invites'
FROM 
    career_advisor_suggested_opportunities
WHERE
    career_advisor_suggested_opportunities.status = "sent"
    AND career_advisor_suggested_opportunities.source = "trrx_inv"
GROUP BY 
    career_advisor_suggested_opportunities.opportunity_id