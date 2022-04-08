SELECT "atomic"."com_torrelabs_similar_opportunity_clicked_1"."opportunity_id" AS "Alfa ID",count(*) as "sml_jobs_clicks"
FROM "atomic"."com_torrelabs_similar_opportunity_clicked_1"
WHERE ("atomic"."com_torrelabs_similar_opportunity_clicked_1"."element_type" = 'job-preview-card'
      AND "atomic"."com_torrelabs_similar_opportunity_clicked_1"."root_tstamp"  < CAST(getdate() AS date))
GROUP BY "atomic"."com_torrelabs_similar_opportunity_clicked_1"."opportunity_id"