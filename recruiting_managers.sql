/* AA : Sonic : recruiting managers: prod */
SELECT
    organization_service_providers.organization_id AS 'Company_id',
    organization_service_providers.account_manager_person_gg_id AS 'gg_id'
FROM
    organization_service_providers
GROUP BY 
    organization_service_providers.organization_id
