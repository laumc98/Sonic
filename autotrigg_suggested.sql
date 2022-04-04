SELECT 
    oam.opportunity_id as 'ID',
    count(*) as 'trigg_sugg_notifications'
FROM  
    opportunity_automated_messages as oam 
    left join automated_messages as am on (oam.automated_message_id = am.id)
    left join opportunity_columns as oc on (oam.column_id = oc.id)
    left join automated_messages_notifications as amn on (am.id = amn.automated_message_id)
WHERE
    oam.active = true 
    and am.active = true
    and amn.status = 'sent'
GROUP BY 1