select
   opportunity_candidates.opportunity_id as ID,
   date(opportunity_candidates.interested) as interested_date,
   `Tracking Codes`.`utm_medium` as utm_medium,
   sum(case when utm_medium = 'ja_mtc' then 1 else 0 end) as 'Job alerts from preferences matches',
   sum(case when utm_medium = 'ja_rlvsgl_prs' then 1 else 0 end) as 'Job alerts from relevant signals to people',
   sum(case when utm_medium = 'ja_allsgl_prs' then 1 else 0 end) as 'Job alerts from all signals to people',
   sum(case when utm_medium = 'ja_rlvsgl_org' then 1 else 0 end) as 'Job alerts from relevant signals to organization',
   sum(case when utm_medium = 'ja_allsgl_org' then 1 else 0 end) as 'Job alerts from all signals to organization',
   sum(case when utm_medium = 'rc_cb_rcdt' then 1 else 0 end) as 'Recruiter chatbot to registered candidates',
   sum(case when utm_medium = 'rc_ccg' then 1 else 0 end) as 'Recruiter chatbot to community created genomes',
   sum(case when utm_medium = 'rc_syn' then 1 else 0 end) as 'Recruiter chatbot to syndication candidates',
   sum(case when utm_medium = 'rc_src' then 1 else 0 end) as 'Recruiter chatbot to sourcing candidates',
   sum(case when utm_medium = 'am_sug' then 1 else 0 end) as 'Auto triggered messages sent to suggested candidates that are invited to the job by the TS',
   sum(case when utm_medium = 'srh_jobs' then 1 else 0 end) as 'Job search',
   sum(case when utm_medium = 'sml_jobs' then 1 else 0 end) as 'Similar jobs (at the job listing, at the end of an application)',
   sum(case when utm_medium = 'am_inv' then 1 else 0 end) as 'Auto triggered messages sent to invited external candidates by the TS',
   sum(case when utm_medium = 'google_jobs' then 1 else 0 end) as 'Google for jobs',
   sum(case when utm_medium = 'fb_jobs' then 1 else 0 end) as 'Facebook jobs',
   sum(case when utm_medium = 'ref_ts' then 1 else 0 end) as 'Referrals from the talent seeker and their network',
   sum(case when utm_medium = 'shr_ts' then 1 else 0 end) as 'Talent seeker sharing their own post (social media posts, their own site, etc.)',
   sum(case when utm_medium = 'ro_sug' then 1 else 0 end) as 'Personal reach out to suggested candidates invited to the job by the TS (manually invited)',
   sum(case when utm_medium = 'pr_sml_jobs' then 1 else 0 end) as 'Personal reach out to candidates that applied to similar opportunities',
   sum(case when utm_medium = 'rc_trrx_inv' then 1 else 0 end) as 'Manual invite by Torrex of registered candidates (internal sourcing)',
   sum(case when utm_medium = 'syn' then 1 else 0 end) as 'Syndication through external networks and platforms',
   sum(case when utm_medium = 'src' then 1 else 0 end) as 'Sourcing',
   sum(case when utm_medium = 'ref_ptn' then 1 else 0 end) as 'Referrals from partners',
   sum(case when utm_medium = 'ref_cdt' then 1 else 0 end) as 'Referrals from candidates',
   sum(case when utm_medium = 'ref_vst_imp' then 1 else 0 end) as 'Referrals from visitors that share a job outside Torre (implicitly)',
   sum(case when utm_medium = 'syn_rqt' then 1 else 0 end) as 'Syndication as requested (on behalf of) the talent seeker',
   sum(case when utm_medium = 'trr_webinars' then 1 else 0 end) as 'Webinars Torre Access'
FROM opportunity_candidates
LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates - Person` ON `opportunity_candidates`.`id` = `Tracking Code Candidates - Person`.`candidate_id`
LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates - Person`.`tracking_code_id` = `Tracking Codes`.`id`
LEFT JOIN opportunities on opportunities.id = opportunity_candidates.opportunity_id
WHERE opportunity_candidates.interested is not null
GROUP BY  ID
ORDER BY ID desc