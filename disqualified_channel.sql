SELECT
    o.id as ID,
    `Tracking Codes`.`utm_medium` as utm_medium,
    sum(case when oc.id is not null and oc.interested is not null and (last_evaluation.last_not_interest is not null and (last_evaluation.last_interest is null or last_evaluation.last_interest < last_evaluation.last_not_interest)) then 1 else 0 end) as Disqualified
FROM opportunities o
LEFT JOIN opportunity_candidates oc on o.id=oc.opportunity_id
LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates - Person` ON `oc`.`id` = `Tracking Code Candidates - Person`.`candidate_id`
LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates - Person`.`tracking_code_id` = `Tracking Codes`.`id`
left join (
  select me.candidate_id, max(me.interested) as last_interest, max(me.not_interested) as last_not_interest
  from member_evaluations me
  group by me.candidate_id) last_evaluation on last_evaluation.candidate_id = oc.id
WHERE oc.interested is not null AND utm_medium IN ('ja_mtc','ja_rlvsgl_prs','ja_allsgl_prs','ja_rlvsgl_org','ja_allsgl_org','rc_cb_rcdt','rc_ccg','rc_syn','rc_src','am_sug','srh_jobs','sml_jobs','am_inv','google_jobs','fb_jobs','ref_ts','shr_ts','ro_sug','pr_sml_jobs','rc_trrx_inv','syn','src','ref_ptn','ref_cdt','ref_vst_imp','syn_rqt','trr_webinars')
group by ID, utm_medium
order by ID desc
