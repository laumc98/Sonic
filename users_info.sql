/* AA : SONIC : people info : prod */ 
SELECT
    people.gg_id,
    people.name,
    people.username,
    people.professional_headline,
    people.email,
    people.phone
FROM 
    people
WHERE
    people.name not like '**test'