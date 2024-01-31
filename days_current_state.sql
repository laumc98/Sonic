/* AA : SONIC : days in current state : prod */ 
SELECT
    states.opportunity_reference_id AS 'Alfa ID',
    timestampdiff(day,MAX(states.previous_state_date),states.current_state_date) as days_in_current_state
FROM
    (
        SELECT
            state_transition.opportunity_reference_id,
            current.current_state AS current_state,
            current.timestamp AS current_state_date,
            previous.current_state AS previous_state,
            previous.timestamp AS previous_state_date
        FROM
            state_transition
            LEFT JOIN (
                SELECT
                    state_transition.opportunity_reference_id,
                    state_transition.current_state,
                    state_transition.timestamp
                FROM
                    state_transition
                WHERE
                    state_transition.active = TRUE
            ) current ON state_transition.opportunity_reference_id = current.opportunity_reference_id
            LEFT JOIN (
                SELECT
                    state_transition.opportunity_reference_id,
                    state_transition.current_state,
                    state_transition.timestamp
                FROM 
                    state_transition
                WHERE
                    state_transition.active = FALSE
                ORDER BY 
                    state_transition.timestamp DESC
            ) previous ON state_transition.opportunity_reference_id = previous.opportunity_reference_id
        WHERE 
            current.current_state = 'default_active_seeking_state'
            AND current.current_state != previous.current_state
    ) AS states
    LEFT JOIN opportunity ON states.opportunity_reference_id = opportunity.ref_id
WHERE 
    opportunity.ref_id IS NOT NULL
GROUP BY 
    states.opportunity_reference_id