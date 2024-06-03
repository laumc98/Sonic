/* AA : SONIC : hires by oppid : prod */ 
WITH 
groupped_services AS (
    SELECT
        opportunity_id,
        GROUP_CONCAT(service_code) AS services
    FROM
        opportunity_services
    WHERE
        deleted IS NULL
    GROUP BY
        opportunity_id
),
opps_services AS (
    SELECT
        o.id AS opportunity_id,
        CASE
            WHEN crawled THEN 'crawled'
            WHEN (
                (
                    FIND_IN_SET('1', gs.services)>0 /* agile */
                    OR FIND_IN_SET('7', gs.services)>0 /* staff augmentation */
                    OR FIND_IN_SET('20', gs.services)>0 /* hunt */
                )
            ) THEN 'rpo'
            WHEN (
                (
                    FIND_IN_SET('8', gs.services)>0 /* ats */
                    OR FIND_IN_SET('9', gs.services)>0 /* pro */
                    OR FIND_IN_SET('16', gs.services)>0 /* torre_os */
                ) AND o.created>='2023-12-01'
            ) THEN 'torre_os'
            WHEN (
                (
                    FIND_IN_SET('2', gs.services)>0 /* essentials */
                    OR FIND_IN_SET('6', gs.services)>0 /* self service */
                    OR services = ''
                    OR services IS NULL
                )  AND o.created>='2023-12-01'
            ) THEN 'torre_free'
            ELSE 'others'
        END AS business_line,
        (
            (
                FIND_IN_SET('11', gs.services)>0 /* boost */
                OR FIND_IN_SET('12', gs.services)>0 /* boost hqa */
                OR FIND_IN_SET('17', gs.services)>0 /* torre_reach_essential */
                OR FIND_IN_SET('18', gs.services)>0 /* torre_reach_syndication */
                OR FIND_IN_SET('19', gs.services)>0 /* torre_reach_sourcing */
            ) AND o.created>='2023-12-01'
        ) AS reach,
        services
    FROM
        opportunities o
    LEFT JOIN groupped_services gs ON
        gs.opportunity_id = o.id
),
hires AS (
    SELECT
        o.id AS 'ID',
        tc.utm_medium AS 'UTM',
        count(distinct all_hires.candidate_id) AS 'hires'
    FROM
        (
            SELECT
                DATE(ooh.hiring_date) AS 'hire_date',
                ooh.opportunity_candidate_id AS 'candidate_id'
            FROM 
                opportunity_operational_hires ooh
            WHERE
                ooh.hiring_date > '2021-7-18'
                
            UNION
            
            SELECT
                MIN(occh.created) AS 'hire_date',
                occh.candidate_id AS 'candidate_id'
            FROM
                opportunity_candidate_column_history occh
                INNER JOIN opportunity_candidates ocan ON occh.candidate_id = ocan.id
                INNER JOIN opportunities o ON ocan.opportunity_id = o.id
                LEFT JOIN opps_services os ON ocan.opportunity_id = os.opportunity_id
            WHERE
                occh.created >= '2022-01-01'
                AND occh.to_funnel_tag = 'hired'
                AND (
                    os.business_line IN ('torre_os', 'torre_free')
                    OR os.business_line IS NULL            
                )
            GROUP BY
                occh.candidate_id
        ) AS all_hires
        INNER JOIN opportunity_candidates ocan ON all_hires.candidate_id = ocan.id
        INNER JOIN opportunities o ON ocan.opportunity_id = o.id
        LEFT JOIN opps_services os ON ocan.opportunity_id = os.opportunity_id
        LEFT JOIN tracking_code_candidates tcc ON ocan.id = tcc.candidate_id
        LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
    WHERE 
        date(all_hires.hire_date) > "2021-1-1"
        AND date(coalesce(null, o.first_reviewed, o.last_reviewed)) > date(date_add(now(6), INTERVAL -1 year))
        AND o.crawled = FALSE 
    GROUP BY 
        o.id,
        tc.utm_medium
) SELECT * FROM hires;