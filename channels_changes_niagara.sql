/* AA : Sonic : Niagara channels changes : prod */ 
SELECT
    opportunity_channels.opportunity_reference_id AS 'Alfa ID',
    opportunity_channels.channel,
    opportunity_channels.source,
    opportunity_channels.active,
    opportunity_channels.created,
    opportunity_channels.modified
FROM
   opportunity_channels
WHERE 
   opportunity_channels.created >= date(date_add(now(6), INTERVAL -15 day))
   AND opportunity_channels.source = 'NIAGARA'
   AND opportunity_channels.active = 'False'
LIMIT 800000