/* AA : Sonic : skills terms: prod */ 
select
    terms.id as 'Skill ID',
    terms.term as 'Skills name'
from
    terms
    left join term_types on terms.id = term_types.term_id
where
    terms.status = 'APPROVED'
    and term_types.type = 'SKILL'