/* AA : Sonic : personal reach out to candidates of similar jobs invitation requests: prod */ 
SELECT 
    career_advisor_invitation_requests.opportunity_ref AS 'Alfa ID',
    career_advisor_invitation_requests.invited_candidates AS 'rc_sml_jobs_invitations'
FROM 
    career_advisor_invitation_requests
WHERE 
    career_advisor_invitation_requests.status = "completed"