SELECT
    TRIM('"' FROM JSON_EXTRACT(notifications.context, '$.opportunityId')) AS 'Alfa ID',
    min(notifications.sent_at) AS 'first_cr_src_request_date'
FROM
    notifications
WHERE
    (
        (
            notifications.template = 'career-advisor-sourcing-first-evaluation'
            OR notifications.template = 'career-advisor-sourcing-first-evaluation-matrix-c'
            OR notifications.template = 'career-advisor-sourcing-first-evaluation-matrix-a'
            OR notifications.template = 'career-advisor-sourcing-first-evaluation-matrix-b'
            OR notifications.template = 'career-advisor-sourcing-already-exist'
        )
        AND notifications.status = 'sent'
        AND TRIM('"' FROM JSON_EXTRACT(notifications.context, '$.utmCampaign')) IN (
            'amdm',
            'mcog',
            'dffa',
            'czp',
            'jdpb',
            'dmc',
            'nsr',
            'mmor'
        )
    )
GROUP BY
    1