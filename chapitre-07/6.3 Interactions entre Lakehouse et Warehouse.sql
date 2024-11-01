SELECT P.nom, SUM(V.montant)
FROM monlakehouse.dbo.produits AS P
JOIN monwarehouse.sales.ventes AS V
ON P.product_id = V.product_id
WHERE V.date_order > '2024-01-01'
GROUP BY P.nom;


INSERT INTO monwarehouse.crm.clients (id, nom, email)
SELECT id, nom, email
FROM monlakehouse.dbo.contacts
WHERE statut = 'prospect';

