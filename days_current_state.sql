/* AA : SONIC : days in current state : prod */ 
SELECT
    states.opportunity_reference_id AS 'Alfa ID',
    states.current_state,
    states.current_state_date,
    states.previous_state,
    MAX(states.previous_state_date) AS last_previous_state_date,
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
    ) AS states
    LEFT JOIN opportunity ON states.opportunity_reference_id = opportunity.ref_id
WHERE 
    opportunity.ref_id IS NOT NULL
    AND states.current_state = 'default_active_seeking_state'
    AND states.current_state != states.previous_state
GROUP BY 
    states.opportunity_reference_id