SELECT
    o.ref_id AS 'Alfa ID',
    o.updated_on AS opportunity_updated_on,
    o.compensation_status,
    o.target_hires,
    c.channels,
    c.channels_open_date,
    activation.syn_activation_date,
    activation.src_activation_date,
    activation.paid_syn_activation_date,
    activation.max_src_activation_date,
    activation.max_syn_activation_date,
    activation.max_paid_syn_activation_date,
    vta_2.torre_alerts_views_to_application_ratio,
    thvtat.views_since_update AS torre_handled_views_since_update,
    thvtat.torre_handled_views_to_application_ratio_since_update,
    s.current_state,
    s.last_previous_state,
    s.reason_changed,
    s.last_state_transition
FROM
    opportunity AS o
    LEFT JOIN (
        SELECT
            opportunity_reference_id,
            GROUP_CONCAT(channel SEPARATOR ', ') as channels,
            MIN(created) as channels_open_date
        FROM
            opportunity_channels
        WHERE
            active = 1
        GROUP BY
            opportunity_reference_id
    ) c ON o.ref_id = c.opportunity_reference_id
    LEFT JOIN (
        SELECT
            opportunity_reference_id,
            MIN(CASE WHEN channel = 'EXTERNAL_NETWORKS' THEN created END) AS 'syn_activation_date',
            MAX(CASE WHEN channel = 'EXTERNAL_NETWORKS' THEN created END) AS 'max_syn_activation_date',
            MIN(CASE WHEN channel = 'EXTERNAL_SOURCING' THEN created END) AS 'src_activation_date',
            MAX(CASE WHEN channel = 'EXTERNAL_SOURCING' THEN created END) AS 'max_src_activation_date',
            MIN(CASE WHEN channel = 'PAID_EXTERNAL_NETWORK' THEN created END) AS 'paid_syn_activation_date',
            MAX(CASE WHEN channel = 'PAID_EXTERNAL_NETWORK' THEN created END) AS 'max_paid_syn_activation_date'
        FROM
            opportunity_channels
        WHERE
            opportunity_channels.source = 'NIAGARA'
        GROUP BY
            opportunity_reference_id
    ) activation ON o.ref_id = activation.opportunity_reference_id
    LEFT JOIN (
        SELECT
            st.opportunity_reference_id AS opportunity_reference_id,
            st.current_state AS current_state,
            st.timestamp AS last_state_transition,
            st.reason_changed AS reason_changed,
            ps.last_previous_state
        FROM
            state_transition AS st
            LEFT JOIN (
                SELECT
                    state_transition.opportunity_reference_id,
                    state_transition.current_state AS last_previous_state
                FROM
                    state_transition
                WHERE
                    state_transition.active = FALSE
                    AND state_transition.id IN (
                        SELECT 
                            MAX(state_transition.id)
                        FROM
                            state_transition
                        WHERE   
                            state_transition.active = FALSE
                        GROUP BY 
                            state_transition.opportunity_reference_id
                    )
                GROUP BY
                    state_transition.opportunity_reference_id
            ) ps ON st.opportunity_reference_id = ps.opportunity_reference_id
        WHERE
            st.active = TRUE
        GROUP BY 
            st.opportunity_reference_id
    ) s ON o.ref_id = s.opportunity_reference_id
    LEFT JOIN (
        SELECT
            v.opportunity_reference_id AS opportunity_reference_id,
            COUNT(a.id) / COUNT(v.opportunity_reference_id) AS torre_alerts_views_to_application_ratio
        FROM
            views AS v
            LEFT JOIN applications AS a ON v.gg_id = a.gg_id
            AND v.opportunity_reference_id = a.opportunity_reference_id
        WHERE
            v.utm_medium = 'ja_mtc'
        GROUP BY
            v.opportunity_reference_id
    ) vta_2 ON o.ref_id = vta_2.opportunity_reference_id
    LEFT JOIN (
        SELECT
            v.opportunity_reference_id AS opportunity_reference_id,
            COUNT(a.id) / COUNT(v.opportunity_reference_id) AS torre_handled_views_to_application_ratio_since_update,
            COUNT(v.opportunity_reference_id) AS views_since_update
        FROM
            views AS v
            LEFT JOIN opportunity AS opp ON v.opportunity_reference_id = opp.ref_id
            LEFT JOIN applications AS a ON v.gg_id = a.gg_id
            AND v.opportunity_reference_id = a.opportunity_reference_id
            AND a.timestamp >= opp.updated_on
        WHERE
            v.utm_medium IN (
                    'ja_mtc',
                    'srh_jobs',
                    'rc_cb_rcdt'
            )
            AND v.timestamp >= opp.updated_on
        GROUP BY
            v.opportunity_reference_id
    ) thvtat ON o.ref_id = thvtat.opportunity_reference_id
WHERE
    JSON_EXTRACT(o.opportunity_snapshot, '$."crawled"') = FALSE
GROUP BY
    o.ref_id