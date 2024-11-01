SELECT P.nom_produit, F.nom_fournisseur, SUM(V.vente)
FROM warehouseC.catalogue.produits AS P
INNER JOIN lakehouseC.dbo.ventes AS V ON V.produit = P.produit
INNER JOIN lakehouseC.dbo.fournisseurs as F ON F.fournisseur = P.fournisseur
GROUP BY P.nom_produit, F.nom_fournisseur
