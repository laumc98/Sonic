/* AA : Sonic : app by channel: prod */ 
SELECT
   opportunity_candidates.opportunity_id as ID,
   sum(case when utm_medium = 'ja_mtc' then 1 else 0 end) as 'Job alerts from matches',
   sum(case when utm_medium = 'ja_rlvsgl_prs' then 1 else 0 end) as 'Job alerts from relevant signals people',
   sum(case when utm_medium = 'ja_allsgl_prs' then 1 else 0 end) as 'Job alerts from all signals people',
   sum(case when utm_medium = 'ja_rlvsgl_org' then 1 else 0 end) as 'Job alerts from relevant signals organization',
   sum(case when utm_medium = 'ja_allsgl_org' then 1 else 0 end) as 'Job alerts from all signals organization',
   sum(case when utm_medium = 'rc_cb_rcdt' then 1 else 0 end) as 'Recruiter chatbot',
   sum(case when utm_medium = 'rc_ccg' then 1 else 0 end) as 'Recruiter chatbot to CCGs',
   sum(case when utm_medium = 'rc_syn' then 1 else 0 end) as 'Recruiter chatbot syndication',
   sum(case when utm_medium = 'rc_src' then 1 else 0 end) as 'Recruiter chatbot sourcing',
   sum(case when utm_medium = 'am_sug' then 1 else 0 end) as 'Auto triggered messages to suggested candidates',
   sum(case when utm_medium = 'rc_am_sug' then 1 else 0 end) as 'Auto triggered to suggested candidates',
   sum(case when utm_medium = 'srh_jobs' then 1 else 0 end) as 'Job search',
   sum(case when utm_medium = 'sml_jobs' then 1 else 0 end) as 'Similar jobs',
   sum(case when utm_medium = 'rc_sml_jobs' then 1 else 0 end) as 'Personal reach out to candidates of similar jobs 2',
   sum(case when utm_medium = 'am_inv' then 1 else 0 end) as 'Auto triggered messages to invited external candidates',
   sum(case when utm_medium = 'google_jobs' then 1 else 0 end) as 'Google for jobs',
   sum(case when utm_medium = 'fb_jobs' then 1 else 0 end) as 'Facebook jobs',
   sum(case when utm_medium = 'ref_ts' then 1 else 0 end) as 'Referrals from the TS',
   sum(case when utm_medium = 'shr_ts' then 1 else 0 end) as 'Talent seekers sharing their own post',
   sum(case when utm_medium = 'ro_sug' then 1 else 0 end) as 'Personal reach out to manually invited',
   sum(case when utm_medium = 'pr_sml_jobs' then 1 else 0 end) as 'Personal reach out to candidates of similar jobs',
   sum(case when utm_medium = 'rc_trrx_inv' then 1 else 0 end) as 'Manual invite by Torrex of registered candidates (internal sourcing)',
   sum(case when utm_medium = 'syn' then 1 else 0 end) as 'Syndication',
   sum(case when utm_medium = 'src' then 1 else 0 end) as 'Sourcing',
   sum(case when utm_medium = 'ref_ptn' then 1 else 0 end) as 'Referrals from partners',
   sum(case when utm_medium = 'ref_cdt' then 1 else 0 end) as 'Referrals from candidates',
   sum(case when utm_medium = 'ref_vst_imp' then 1 else 0 end) as 'Referrals from visitors that share a job outside Torre (implicitly)',
   sum(case when utm_medium = 'syn_rqt' then 1 else 0 end) as 'Syndication as requested',
   sum(case when utm_medium = 'trr_webinars' then 1 else 0 end) as 'Webinars Torre Access',
   sum(case when utm_medium = 'syn_paid' then 1 else 0 end) as 'Paid syn manual',
   sum(case when utm_medium = 'rc_syn_paid' then 1 else 0 end) as 'Paid syn automatic',
   sum(case when utm_medium is null then 1 else 0 end) as 'Unknown'
FROM opportunity_candidates
    LEFT JOIN tracking_code_candidates ON opportunity_candidates.id = tracking_code_candidates.candidate_id
    LEFT JOIN tracking_codes ON tracking_code_candidates.tracking_code_id = tracking_codes.id
    LEFT JOIN opportunities on opportunities.id = opportunity_candidates.opportunity_id
WHERE 
    opportunity_candidates.interested is not null
GROUP BY ID
ORDER BY ID desc