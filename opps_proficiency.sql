/* AA : Sonic : opps by proficiency: prod */ 
SELECT
    ID,
    GREATEST(ifnull(years, 0), ifnull(prof_years, 0)) AS max_years,
    CASE
        GREATEST(ifnull(years, 0), ifnull(prof_years, 0))
        WHEN 0 THEN 'novice'
        WHEN 1 THEN 'novice'
        WHEN 2 THEN 'novice'
        WHEN 3 THEN 'proficient'
        WHEN 5 THEN 'expert'
        WHEN 10 THEN 'master'
    END AS proficiency
FROM
    (
        SELECT
            o.id AS opportunity_id,
            max(
                CASE
                    ostr.experience
                    WHEN '' THEN -1
                    WHEN 'potential-to-develop' THEN 0
                    WHEN '1-plus-year' THEN 1
                    WHEN '2-plus-years' THEN 2
                    WHEN '3-plus-years' THEN 3
                    WHEN '5-plus-years' THEN 5
                    WHEN '10-plus-years' THEN 10
                END
            ) AS years,
            max(
                CASE
                    ostr.proficiency
                    WHEN '' THEN -1
                    WHEN 'novice' THEN 1
                    WHEN 'proficient' THEN 3
                    WHEN 'expert' THEN 5
                    WHEN 'master' THEN 10
                END
            ) AS prof_years
        FROM
            opportunity_strengths ostr
            INNER JOIN opportunities o ON o.id = ostr.opportunity_id
        WHERE
            ostr.active = TRUE
            AND NOT (
                ostr.experience = ''
                AND ostr.proficiency = ''
            )
            AND o.objective NOT LIKE '**%'
            AND date(coalesce(null, o.first_reviewed, o.last_reviewed)) >= '2021/06/01'
            AND o.review = 'approved'
        GROUP BY
            o.id
    ) g
    INNER JOIN (
        SELECT
            DISTINCT o.id
        FROM
            opportunities o
            INNER JOIN opportunity_members omp ON omp.opportunity_id = o.id
            AND omp.poster = TRUE
            INNER JOIN person_flags pf ON pf.person_id = omp.person_id
            AND pf.opportunity_crawler = false
    ) not_crawled ON g.opportunity_id = not_crawled.id;