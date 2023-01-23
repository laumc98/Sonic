/* AA : Sonic : speed metrics: prod */ 
SELECT 
    opportunity.ref_id AS 'Alfa ID',
    sourcing.src_first_app,
    sourcing.src_min_diff,
    syndication.syn_first_app,
    syndication.syn_min_diff,
    paid_syndication.paid_syn_first_app,
    paid_syndication.paid_syn_min_diff
FROM 
    opportunity
    INNER JOIN (
        SELECT
            opportunity_channels.opportunity_reference_id
        FROM
            opportunity_channels
            INNER JOIN (
                SELECT 
                    applications.opportunity_reference_id,
                    min(applications.timestamp) AS first_application
                FROM 
                    applications
                WHERE 
                    (applications.utm_medium = 'rc_src'
                        OR applications.utm_medium = 'rc_src_trrx_inv'
                        OR applications.utm_medium = 'rc_syn'
                        OR applications.utm_medium = 'syn'
                        OR applications.utm_medium = 'rc_syn_trrx_inv'
                        OR applications.utm_medium = 'rc_syn_paid'
                        OR applications.utm_medium = 'syn_paid'
                        OR applications.utm_medium = 'rc_syn_paid_trrx_inv'
                        )
                    AND date(applications.timestamp) > '2022-10-25' 
                GROUP BY 
                    applications.opportunity_reference_id
            ) AS applications ON opportunity_channels.opportunity_reference_id = applications.opportunity_reference_id
        WHERE
            (opportunity_channels.channel = 'EXTERNAL_SOURCING'
                OR opportunity_channels.channel = 'EXTERNAL_NETWORKS'
                OR opportunity_channels.channel = 'PAID_EXTERNAL_NETWORK')
        GROUP BY 
            opportunity_channels.opportunity_reference_id
    ) AS opportunity_channels ON opportunity.ref_id = opportunity_channels.opportunity_reference_id
    LEFT JOIN (
        SELECT
            opportunity_channels.opportunity_reference_id,
            date(applications.first_application) AS src_first_app,
            min(TIMESTAMPDIFF(MINUTE,opportunity_channels.created,applications.first_application)) AS src_min_diff
        FROM
            opportunity_channels
            INNER JOIN (
                SELECT 
                    applications.opportunity_reference_id,
                    min(applications.timestamp) AS first_application
                FROM 
                    applications
                WHERE 
                    (applications.utm_medium = 'rc_src'
                        OR applications.utm_medium = 'rc_src_trrx_inv')
                    AND date(applications.timestamp) > '2022-10-25' 
                GROUP BY 
                    applications.opportunity_reference_id
            ) AS applications ON opportunity_channels.opportunity_reference_id = applications.opportunity_reference_id
        WHERE
            opportunity_channels.channel = 'EXTERNAL_SOURCING'
            AND date(opportunity_channels.created) > '2022-10-25' 
            AND TIMESTAMPDIFF(MINUTE,opportunity_channels.created,applications.first_application) >= 10
        GROUP BY
            opportunity_channels.opportunity_reference_id
    ) AS sourcing ON opportunity.ref_id = sourcing.opportunity_reference_id
    LEFT JOIN (
        SELECT
            opportunity_channels.opportunity_reference_id,
            date(applications.first_application) AS syn_first_app,
            min(TIMESTAMPDIFF(MINUTE,opportunity_channels.created,applications.first_application)) AS syn_min_diff
        FROM
            opportunity_channels
            INNER JOIN (
            SELECT 
                    applications.opportunity_reference_id,
                    min(applications.timestamp) AS first_application
                FROM 
                    applications
                WHERE 
                    (applications.utm_medium = 'rc_syn'
                        OR applications.utm_medium = 'syn'
                        OR applications.utm_medium = 'rc_syn_trrx_inv')
                    AND date(applications.timestamp) > '2022-10-25' 
                GROUP BY 
                    applications.opportunity_reference_id
            ) AS applications ON opportunity_channels.opportunity_reference_id = applications.opportunity_reference_id
        WHERE
            opportunity_channels.channel = 'EXTERNAL_NETWORKS'
            AND date(opportunity_channels.created) > '2022-10-25' 
            AND TIMESTAMPDIFF(MINUTE,opportunity_channels.created,applications.first_application) >= 10
        GROUP BY
            opportunity_channels.opportunity_reference_id
    ) AS syndication ON opportunity.ref_id = syndication.opportunity_reference_id
    LEFT JOIN (
        SELECT
            opportunity_channels.opportunity_reference_id,
            date(applications.first_application) AS paid_syn_first_app,
            min(TIMESTAMPDIFF(MINUTE,opportunity_channels.created,applications.first_application)) AS paid_syn_min_diff
        FROM
            opportunity_channels
            INNER JOIN (
                SELECT 
                    applications.opportunity_reference_id,
                    min(applications.timestamp) AS first_application
                FROM 
                    applications
                WHERE 
                    (applications.utm_medium = 'rc_syn_paid'
                        OR applications.utm_medium = 'syn_paid'
                        OR applications.utm_medium = 'rc_syn_paid_trrx_inv')
                    AND date(applications.timestamp) > '2022-10-25' 
                GROUP BY 
                    applications.opportunity_reference_id
            ) AS applications ON opportunity_channels.opportunity_reference_id = applications.opportunity_reference_id
        WHERE
            opportunity_channels.channel = 'PAID_EXTERNAL_NETWORK'
            AND date(opportunity_channels.created) > '2022-10-25' 
            AND TIMESTAMPDIFF(MINUTE,opportunity_channels.created,applications.first_application) >= 10
        GROUP BY
            opportunity_channels.opportunity_reference_id
    ) AS paid_syndication ON opportunity.ref_id = paid_syndication.opportunity_reference_id