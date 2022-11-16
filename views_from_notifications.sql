/* AA : SONIC : views from notifications : prod */ 
SELECT
    SUBSTRING("atomic"."events"."page_urlpath",7,8) as "Alfa ID",
    "atomic"."events"."mkt_medium" AS "UTM",
    count(distinct "atomic"."events"."domain_userid") AS "count"
FROM
    "atomic"."events"
WHERE
    (
        "atomic"."events"."event" = 'page_view'
        AND (
            lower("atomic"."events"."page_url") like '%post%'
        )
        AND (
            lower("atomic"."events"."page_urlpath") like '%post%'
        )
        AND (
            "atomic"."events"."mkt_medium" = 'am_sug'
            OR "atomic"."events"."mkt_medium" = 'srh_jobs'
            OR "atomic"."events"."mkt_medium" = 'ja_mtc'
            OR "atomic"."events"."mkt_medium" = 'rc_cb_rcdt'
            OR "atomic"."events"."mkt_medium" = 'sml_jobs'
            OR "atomic"."events"."mkt_medium" = 'rc_sml_jobs'
            OR "atomic"."events"."mkt_medium" = 'rc_trrx_inv'
            OR "atomic"."events"."mkt_medium" = 'ref_ts'
            OR "atomic"."events"."mkt_medium" = 'am_inv'
            OR "atomic"."events"."mkt_medium" = 'rc_am_sug'
            OR "atomic"."events"."mkt_medium" = 'rc_ccg'
            OR "atomic"."events"."mkt_medium" = 'rc_syn'
            OR "atomic"."events"."mkt_medium" = 'rc_src'
            OR "atomic"."events"."mkt_medium" = 'syn_paid'
            OR "atomic"."events"."mkt_medium" = 'rc_syn_paid'
            OR "atomic"."events"."mkt_medium" = 'rc_src_trrx_inv'
            OR "atomic"."events"."mkt_medium" = 'rc_syn_trrx_inv'
        )
    )
GROUP BY
    SUBSTRING("atomic"."events"."page_urlpath",7,8),
    "atomic"."events"."mkt_medium"