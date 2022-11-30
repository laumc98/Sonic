/* AA : SONIC : mutual m by candidate recruiters : prod */ 
SELECT
    date(occh.created) AS 'mutualm_date',
    p.name AS 'Candidate Recruiter',
    o.id AS 'ID',
    count(distinct occh.candidate_id) AS 'Mutual matches'
FROM
    opportunity_candidate_column_history occh
    INNER JOIN opportunity_columns oc ON occh.to = oc.id
    INNER JOIN opportunities o ON oc.opportunity_id = o.id
    LEFT JOIN people p ON o.candidate_recruiter_person_id = p.id
WHERE
    oc.name = 'mutual matches'
    AND occh.created >= '2022-10-23'
    AND o.candidate_recruiter_person_id IS NOT NULL
GROUP BY 
    date(occh.created),
    p.name,
    o.id