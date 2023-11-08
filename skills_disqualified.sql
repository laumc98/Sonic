/* AA : Sonic : skills disqualified: prod */ 
SELECT 
    member_evaluations.candidate_id, 
    member_evaluations_reason.reason AS 'reason_2',
    member_evaluations_reason.code AS 'Skill ID'
FROM 
    member_evaluations_reason
    LEFT JOIN member_evaluations ON member_evaluations_reason.member_evaluation_id = member_evaluations.id
WHERE 
    member_evaluations_reason.reason = 'skills-required'
    AND (member_evaluations_reason.created >= date(date_add(now(6), INTERVAL -60 day))
            AND member_evaluations_reason.created < date(date_add(now(6), INTERVAL 1 day)))
    AND member_evaluations_reason.active = true