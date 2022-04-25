select
   opportunity_id as 'ID',
    (case
      when type = 'outbound' and value is True then 'True'
      when type = 'outbound' and value is False then 'False'
     end) as 'Outbound Efforts'
from opportunity_changes_history
where type in (select type from opportunity_changes_history where type = 'outbound')
group by ID
order by ID desc