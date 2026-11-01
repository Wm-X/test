WITH RECURSIVE tree (
    guid,
    parent_guid,
    NAME,
    name_tree,
    name_tabs,
    account_type,
    depth
)
AS (
    SELECT guid,
           parent_guid,
           NAME,
           '' || NAME AS name_tree,
           '' AS name_tabs,
           account_type,
           0 AS depth
      FROM accounts
     WHERE parent_guid IS NULL 
       -- AND NAME <> 'Template Root'
    UNION ALL
    SELECT AC.guid,
           AC.parent_guid,
           AC.NAME,
           tree.name_tree || ':' || AC.NAME AS name_tree,
           substr('.................................',
                  1,
                  depth * 2) || AC.NAME AS name_tabs,
           AC.account_type,
           depth + 1 AS depth
      FROM tree
           JOIN
           accounts AC ON tree.guid = AC.parent_guid
),
CoA AS (
    SELECT *,
           substr(name_tree,
                  14) AS account
      FROM tree
     ORDER BY name_tree
)
Select * from CoA
LEFT JOIN schedxactions ON template_act_guid = CoA.guid
ORDER BY name_tree
