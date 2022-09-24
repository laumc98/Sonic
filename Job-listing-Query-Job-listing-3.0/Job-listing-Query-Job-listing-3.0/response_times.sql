/* AA : Sonic : response times: prod */ 
select
   opportunity_candidates.opportunity_id as ID,
   date(opportunities.reviewed) as approved_date,
   date(opportunity_candidates.interested) as interested_date,
   `Tracking Codes`.`utm_medium` as utm_medium,
   min(
      IF (
         date(opportunities.reviewed) < date(opportunity_candidates.interested),
         timestampdiff(
            day,
            date(opportunities.reviewed),
            date(opportunity_candidates.interested)
         ),
         (
            timestampdiff(
               day,
               date(opportunity_candidates.interested),
               date(opportunities.reviewed)
            ) * -1
         )
      )
   ) AS 'RT'
FROM
   opportunity_candidates
   LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates - Person` ON `opportunity_candidates`.`id` = `Tracking Code Candidates - Person`.`candidate_id`
   LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates - Person`.`tracking_code_id` = `Tracking Codes`.`id`
   LEFT JOIN opportunities on opportunities.id = opportunity_candidates.opportunity_id
WHERE
   opportunity_candidates.interested is not null
   AND utm_medium IN (
      'ja_mtc',
      'ja_rlvsgl_prs',
      'ja_allsgl_prs',
      'ja_rlvsgl_org',
      'ja_allsgl_org',
      'rc_cb_rcdt',
      'rc_ccg',
      'rc_syn',
      'rc_src',
      'am_sug',
      'srh_jobs',
      'sml_jobs',
      'am_inv',
      'google_jobs',
      'fb_jobs',
      'ref_ts',
      'shr_ts',
      'ro_sug',
      'pr_sml_jobs',
      'rc_trrx_inv',
      'syn',
      'src',
      'ref_ptn',
      'ref_cdt',
      'ref_vst_imp',
      'syn_rqt',
      'trr_webinars'
   )
group by
   ID,
   utm_medium
order by
   ID desc