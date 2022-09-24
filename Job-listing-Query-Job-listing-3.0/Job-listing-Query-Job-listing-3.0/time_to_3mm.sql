/* AA : Sonic : time to 3mm: prod */ 
SELECT
          opportunity_id AS ID,
          date(reviewed) AS reviewed_date,
          date(created) AS match_date,
          datediff(date(created),date(reviewed)) AS time_to_3mm
      FROM
          (SELECT
               matches.*,
               IF(
                           @index <> matches.opportunity_id,
                           @sum := 1,
                           @sum := @sum + 1
                   ) AS match_sum,
               IF(
                           @index <> matches.opportunity_id,
                           @index := matches.opportunity_id,
                           @index := @index
                   ) AS idd
           FROM
               (SELECT
                    oc.opportunity_id,
                    occh.created,
                    o.reviewed,
                    oc.name
                FROM
                    opportunity_candidate_column_history occh
                        INNER JOIN opportunity_columns oc ON occh.to = oc.id
                        INNER JOIN opportunities o ON oc.opportunity_id = o.id
                WHERE
                      oc.name = 'mutual matches'
                  AND occh.created >= '2021-01-01'
                  AND o.objective NOT LIKE '**%'
                  AND o.id IN (SELECT DISTINCT
                                   o.id AS opportunity_id
                               FROM
                                   opportunities o
                                       INNER JOIN opportunity_members omp ON omp.opportunity_id = o.id
                                       AND omp.poster = TRUE
                                       INNER JOIN person_flags pf ON pf.person_id = omp.person_id
                                       AND pf.opportunity_crawler = FALSE
                               WHERE
                                     o.reviewed >= '2021/01/01'
                                 AND o.objective NOT LIKE '**%'
                                 AND o.review = 'approved')
                ORDER BY
                    opportunity_id,
                    occh.created) AS matches
                   CROSS JOIN (SELECT
                                   @sum := 0,
                                   @index := 0) counter) numbered
      WHERE
          match_sum = 3