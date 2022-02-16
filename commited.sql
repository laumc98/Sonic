select
   opportunity_id as 'ID',
    (case
      when type = 'commit' and value is True then 'True'
      when type = 'commit' and value is False then 'False'
     end) as 'Commited'
from opportunity_changes_history
where type in (select type from opportunity_changes_history where type = 'commit')
group by ID
order by ID desc