select id as 'Skill ID',
term as 'Skills name'

from terms

where true
and status = 'APPROVED'
and type = 'SKILL';