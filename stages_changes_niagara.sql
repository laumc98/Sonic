/* AA : Sonic : Niagara stages changes : prod */ 
SELECT
    state_transition.opportunity_reference_id AS 'Alfa ID',
    state_transition.current_state,
    state_transition.active,
    state_transition.reason_changed,
    state_transition.timestamp
FROM
   state_transition
WHERE 
    state_transition.timestamp >= date(date_add(now(6), INTERVAL -20 day))