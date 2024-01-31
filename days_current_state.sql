/* AA : SONIC : days in current state : prod */ 
WITH active_opps AS (
    SELECT
        state_transition.*
    FROM 
        opportunity
        LEFT JOIN state_transition ON opportunity.ref_id = state_transition.opportunity_reference_id
    WHERE
        state_transition.current_state = 'default_active_seeking_state'
        AND state_transition.active = true
    GROUP BY 
        state_transition.opportunity_reference_id
),
previous_states AS (
    SELECT
        state_transition.opportunity_reference_id,
        max(state_transition.timestamp) AS previous_state_date
    FROM 
        state_transition
    WHERE
        state_transition.opportunity_reference_id IN (SELECT active_opps.opportunity_reference_id FROM active_opps)
        AND state_transition.active = false
        AND state_transition.current_state != (SELECT active_opps.current_state FROM active_opps LIMIT 1)
    GROUP BY 
        state_transition.opportunity_reference_id
)
SELECT 
    active_opps.opportunity_reference_id AS 'Alfa ID',
    timestampdiff(day,previous_states.previous_state_date,active_opps.timestamp) as days_in_current_state
FROM 
    active_opps 
    LEFT JOIN previous_states ON active_opps.opportunity_reference_id = previous_states.opportunity_reference_id