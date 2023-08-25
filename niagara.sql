SELECT
    `opportunity`.`ref_id` AS `Alfa ID`,
    `opportunity`.`objective` AS `objective`,
    `opportunity`.`active` AS `active`,
    `opportunity`.`updated_on` AS `opportunity_updated_on`,
    `opportunity`.`compensation_status` AS `compensation_status`,
    `opportunity`.`timeframe` AS `timeframe`,
    `opportunity`.`target_hires` AS `target_hires`,
    `c`.`channels`,
    `c`.`channels_open_date`,
    `syn_activation`.`syn_activation_date`,
    `src_activation`.`src_activation_date`,
    `paid_syn_activation`.`paid_syn_activation_date`,
    `max_src_activation`.`max_src_activation_date`,
    `max_syn_activation`.`max_syn_activation_date`,
    `max_paid_syn_activation`.`max_paid_syn_activation_date`,
    `a`.`applicationsCount` as `applications`,
    `mm`.`countMM` as `mutual_matches`,
    `atm`.`applications_count` as `high_quality_app`,
    `atm`.`mutual_matches_count` as `hq_mutual_matches`,
    `amm`.`countActiveMutualMatches` as `non_disqualified_mutual_matches`,
    `aa`.`countActiveApplications` as `non_disqualified_applications`,
    `hqamm`.`countActiveMutualMatches` as `non_disqualified_hq_mm`,
    `hqaa`.`countActiveApplications` as `non_disqualified_hq_applications`,
    `atm`.`hqa_to_mm_ratio`,
    `hqtmmst`.`hqa_to_mm_ratio_since_update`,
    `vta`.`torre_handled_views_to_application_ratio`,
    `vta`.`torre_alerts_views_to_application_ratio`,
    `thvtat`.`views_since_update` as `torre_handled_views_since_update`,
    `thvtat`.`apps_since_update` as `torre_handled_applications_since_update`,
    `thvtat`.`torre_handled_views_to_application_ratio_since_update`,
    `s`.`current_state` as `current_state`,
    `previous_state`.`last_previous_state` as 'last_previous_state',
    `s`.`reason_changed`,
    `s`.`last_state_transition` as `last_state_transition`
FROM
    `opportunity`
    LEFT JOIN (
        select
            opportunity_reference_id,
            GROUP_CONCAT(channel SEPARATOR ', ') as channels,
            created as `channels_open_date`
        from
            opportunity_channels
        where
            active = 1
        group by
            opportunity_reference_id
    ) c ON `opportunity`.`ref_id` = `c`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            opportunity_reference_id,
            MIN(created) AS 'syn_activation_date'
        FROM
            opportunity_channels
        WHERE
            opportunity_channels.source = 'NIAGARA'
            AND channel = 'EXTERNAL_NETWORKS'
        GROUP BY 
            opportunity_reference_id
    ) syn_activation ON `opportunity`.`ref_id` = `syn_activation`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            opportunity_reference_id,
            MIN(created) AS 'src_activation_date'
        FROM
            opportunity_channels
        WHERE
            opportunity_channels.source = 'NIAGARA'
            AND channel = 'EXTERNAL_SOURCING'
        GROUP BY 
            opportunity_reference_id
    ) src_activation ON `opportunity`.`ref_id` = `src_activation`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            opportunity_reference_id,
            MIN(created) AS 'paid_syn_activation_date'
        FROM
            opportunity_channels
        WHERE
            opportunity_channels.source = 'NIAGARA'
            AND channel = 'PAID_EXTERNAL_NETWORK'
        GROUP BY 
            opportunity_reference_id
    ) paid_syn_activation ON `opportunity`.`ref_id` = `paid_syn_activation`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            opportunity_reference_id,
            MAX(created) AS 'max_src_activation_date'
        FROM
            opportunity_channels
        WHERE
            opportunity_channels.source = 'NIAGARA'
            AND channel = 'EXTERNAL_SOURCING'
        GROUP BY 
            opportunity_reference_id
    ) max_src_activation ON `opportunity`.`ref_id` = `max_src_activation`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            opportunity_reference_id,
            MAX(created) AS 'max_syn_activation_date'
        FROM
            opportunity_channels
        WHERE
            opportunity_channels.source = 'NIAGARA'
            AND channel = 'EXTERNAL_NETWORKS'
        GROUP BY 
            opportunity_reference_id
    ) max_syn_activation ON `opportunity`.`ref_id` = `max_syn_activation`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            opportunity_reference_id,
            MAX(created) AS 'max_paid_syn_activation_date'
        FROM
            opportunity_channels
        WHERE
            opportunity_channels.source = 'NIAGARA'
            AND channel = 'PAID_EXTERNAL_NETWORK'
        GROUP BY 
            opportunity_reference_id
    ) max_paid_syn_activation ON `opportunity`.`ref_id` = `max_paid_syn_activation`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            `applications`.`opportunity_reference_id` AS `opportunity_reference_id`,
            count(*) AS `applicationsCount`
        FROM
            `applications`
        GROUP BY
            `applications`.`opportunity_reference_id`
    ) a on `opportunity`.`ref_id` = `a`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            `mutual_matches`.`opportunity_reference_id` AS `opportunity_reference_id`,
            count(*) AS `countMM`
        FROM
            `mutual_matches`
        GROUP BY
            `mutual_matches`.`opportunity_reference_id`
    ) mm on `opportunity`.`ref_id` = `mm`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            `state_transition`.`opportunity_reference_id` AS `opportunity_reference_id`,
            `state_transition`.`current_state` AS `current_state`,
            `state_transition`.`timestamp` AS `last_state_transition`,
            `state_transition`.`reason_changed` AS `reason_changed`
        FROM
            `state_transition`
        WHERE
            `state_transition`.`active` = TRUE
    ) s on `opportunity`.`ref_id` = `s`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            `state_transition`.`opportunity_reference_id`,
            `state_transition`.`current_state` AS `last_previous_state`,
            `state_transition`.`timestamp`
        FROM
            `state_transition`
            INNER JOIN (
                SELECT
                    `state_transition`.`opportunity_reference_id`,
                    MAX(`state_transition`.`timestamp`) AS `max_timestamp`
                FROM
                    `state_transition`
                WHERE
                    `state_transition`.`active` = FALSE
                GROUP BY
                    `state_transition`.`opportunity_reference_id`
            ) subq ON `state_transition`.`opportunity_reference_id` = `subq`.`opportunity_reference_id` AND `state_transition`.`timestamp` = `subq`.`max_timestamp`
        WHERE 
            `state_transition`.`active` = FALSE
        GROUP BY 
            `state_transition`.`opportunity_reference_id`
    ) previous_state on `opportunity`.`ref_id` = `previous_state`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            `views`.`opportunity_reference_id` AS `opportunity_reference_id`,
            count(`Applications`.`id`) / count(`views`.`opportunity_reference_id`) as `torre_handled_views_to_application_ratio`
        FROM
            `views`
            LEFT JOIN `applications` `Applications` ON (
                `views`.`gg_id` = `Applications`.`gg_id`
                AND `views`.`opportunity_reference_id` = `Applications`.`opportunity_reference_id`
            )
        WHERE
            (
                `views`.`utm_medium` = 'ja_mtc'
                OR `views`.`utm_medium` = 'srh_jobs'
                OR `views`.`utm_medium` = 'rc_cb_rcdt'
            )
        GROUP BY
            `views`.`opportunity_reference_id`
    ) vta on `opportunity`.`ref_id` = `vta`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            `views`.`opportunity_reference_id` AS `opportunity_reference_id`,
            count(`Applications`.`id`) / count(`views`.`opportunity_reference_id`) as `torre_alerts_views_to_application_ratio`
        FROM
            `views`
            LEFT JOIN `applications` `Applications` ON (
                `views`.`gg_id` = `Applications`.`gg_id`
                AND `views`.`opportunity_reference_id` = `Applications`.`opportunity_reference_id`
            )
        WHERE
            (
                `views`.`utm_medium` = 'ja_mtc'
            )
        GROUP BY
            `views`.`opportunity_reference_id`
    ) vta_2 on `opportunity`.`ref_id` = `vta_2`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            `applications`.`opportunity_reference_id` AS `opportunity_reference_id`,
            count(`applications`.`gg_id`) AS `applications_count`,
            count(`Mutual Matches`.`id`) AS `mutual_matches_count`,
            count(`Mutual Matches`.`id`) / count(`applications`.`gg_id`) as `hqa_to_mm_ratio`
        FROM
            `applications`
            LEFT JOIN `mutual_matches` `Mutual Matches` ON (
                `applications`.`gg_id` = `Mutual Matches`.`gg_id`
                AND `applications`.`opportunity_reference_id` = `Mutual Matches`.`opportunity_reference_id`
            )
        WHERE
            (
                `applications`.`match_score` >= 0.85
                AND `applications`.`filters_passed` = TRUE
            )
        GROUP BY
            `applications`.`opportunity_reference_id`
    ) atm on `opportunity`.`ref_id` = `atm`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            mutual_matches.opportunity_reference_id,
            count(*) as countActiveMutualMatches
        FROM
            mutual_matches
            LEFT JOIN disqualifications on disqualifications.opportunity_reference_id = mutual_matches.opportunity_reference_id
            AND disqualifications.gg_id = mutual_matches.gg_id
        WHERE
            disqualifications.id is null
        GROUP BY
            mutual_matches.opportunity_reference_id
    ) amm on `opportunity`.`ref_id` = `amm`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            applications.opportunity_reference_id,
            count(*) as countActiveApplications
        FROM
            applications
            LEFT JOIN disqualifications on disqualifications.opportunity_reference_id = applications.opportunity_reference_id
            AND disqualifications.gg_id = applications.gg_id
        WHERE
            disqualifications.id is null
        GROUP BY
            applications.opportunity_reference_id
    ) aa on `opportunity`.`ref_id` = `aa`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            applications.opportunity_reference_id,
            count(*) as countActiveApplications
        FROM
            applications
            LEFT JOIN disqualifications on disqualifications.opportunity_reference_id = applications.opportunity_reference_id
            AND disqualifications.gg_id = applications.gg_id
        WHERE
            disqualifications.id is null
            and applications.match_score >= 0.85
            and applications.filters_passed = true
        GROUP BY
            applications.opportunity_reference_id
    ) hqaa on `opportunity`.`ref_id` = `hqaa`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            mutual_matches.opportunity_reference_id,
            count(*) as countActiveMutualMatches
        FROM
            mutual_matches
            LEFT JOIN disqualifications on disqualifications.opportunity_reference_id = mutual_matches.opportunity_reference_id
            AND disqualifications.gg_id = mutual_matches.gg_id
            LEFT JOIN applications on applications.opportunity_reference_id = mutual_matches.opportunity_reference_id
            AND applications.gg_id = mutual_matches.gg_id
        WHERE
            disqualifications.id is null
            AND applications.match_score >= 0.85
            and applications.filters_passed = true
        GROUP BY
            mutual_matches.opportunity_reference_id
    ) hqamm on `opportunity`.`ref_id` = `hqamm`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            `views`.`opportunity_reference_id` AS `opportunity_reference_id`,
            count(`Applications`.`id`) / count(`views`.`opportunity_reference_id`) as `torre_handled_views_to_application_ratio_since_update`,
            count(`views`.`opportunity_reference_id`) as `views_since_update`,
            count(`Applications`.`id`) as `apps_since_update`
        FROM
            `views`
            LEFT JOIN `opportunity` ON `views`.`opportunity_reference_id` = `opportunity`.`ref_id`
            LEFT JOIN `applications` `Applications` ON (
                `views`.`gg_id` = `Applications`.`gg_id`
                AND `views`.`opportunity_reference_id` = `Applications`.`opportunity_reference_id`
                AND `Applications`.`timestamp` >= `opportunity`.`updated_on`
            )
        WHERE
            (
                `views`.`utm_medium` = 'ja_mtc'
                OR `views`.`utm_medium` = 'srh_jobs'
                OR `views`.`utm_medium` = 'rc_cb_rcdt'
            )
            AND `views`.`timestamp` >= `opportunity`.`updated_on`
        GROUP BY
            `views`.`opportunity_reference_id`
    ) thvtat on `opportunity`.`ref_id` = `thvtat`.`opportunity_reference_id`
    LEFT JOIN (
        SELECT
            `applications`.`opportunity_reference_id` AS `opportunity_reference_id`,
            count(`Mutual Matches`.`id`) / count(`applications`.`gg_id`) as `hqa_to_mm_ratio_since_update`
        FROM
            `applications`
            LEFT JOIN `opportunity` ON `applications`.`opportunity_reference_id` = `opportunity`.`ref_id`
            LEFT JOIN `mutual_matches` `Mutual Matches` ON (
                `applications`.`gg_id` = `Mutual Matches`.`gg_id`
                AND `applications`.`opportunity_reference_id` = `Mutual Matches`.`opportunity_reference_id`
                AND `Mutual Matches`.`timestamp` >= `opportunity`.`updated_on`
            )
        WHERE
            (
                `applications`.`match_score` >= 0.85
                AND `applications`.`filters_passed` = TRUE
            )
            AND `applications`.`timestamp` >= `opportunity`.`updated_on`
        GROUP BY
            `applications`.`opportunity_reference_id`
    ) hqtmmst on `opportunity`.`ref_id` = `hqtmmst`.`opportunity_reference_id`
GROUP BY
    `opportunity`.`ref_id`