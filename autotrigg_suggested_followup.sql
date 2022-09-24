SELECT
    TRIM('"'FROM JSON_EXTRACT(`notifications`.`context`, '$.opportunityId')) as `Alfa ID`,
    count(*) as `trigg_sugg_follow_up`
FROM
    `notifications`
WHERE
    `notifications`.`template` = 'career-advisor-manual-invited-reminder'
    AND `notifications`.`status` = 'sent'
GROUP BY 1