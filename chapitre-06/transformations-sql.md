# Les transformations SQL

## Transformations avec Spark SQL

### Créer une vue temporaire pour les clients actifs

```sql
CREATE OR REPLACE TEMP VIEW clients_actifs AS
SELECT 
  id_client,
  nom,
  email
FROM 
  lakehouse_db.clients
WHERE 
  date_inscription >= '2024-01-01';

-- Sauvegarde des clients actifs dans une table Delta
CREATE TABLE lakehouse_db.clients_actifs
USING DELTA
AS SELECT * FROM clients_actifs;

```

### Combiner PySpark et SparkSQL

```python
%%pyspark
df_clients = spark.read.format("csv").option("header", "true").load("Files/customers-100.csv")

# Création d'une vue temporaire
df_clients.createOrReplaceTempView("clients")

df_clients_francais = spark.sql("""
SELECT Index, `Customer Id` as NumeroClient, `First Name` as Prenom, `Last Name` as Nom
FROM clients
WHERE startswith(Country, 'Fr')
""")

display(df_clients_francais)

df_clients_francais.write.format("delta").mode("overwrite").save("Tables/clients_francais")

```

## 3.2.	Techniques de transformations SQL

### CASE WHEN

```sql
SELECT 
    c.client_id,
    c.nom,
    CASE 
        WHEN SUM(v.montant) > 10000 THEN 'Premium'
        ELSE 'Standard'
    END AS statut_client
FROM 
    clients c
JOIN 
    ventes v ON c.client_id = v.client_id
GROUP BY 
    c.client_id, c.nom;

```

### COALESCE

```sql
SELECT 
    client_id,
    nom,
    COALESCE(numero_telephone_portable, numero_telephone_fixe, 'Non fourni') AS contact
FROM 
    clients;
```

### Null if

```sql
SELECT 
    vente_id,
    prix_vente,
    prix_achat,
    prix_vente - NULLIF(prix_vente, prix_achat) AS marge_beneficiaire
FROM 
    ventes;

```

### Numérotation des lignes

```sql
SELECT 
    client_id,
    vente_id,
    montant,
    ROW_NUMBER() OVER(PARTITION BY client_id ORDER BY montant DESC) AS rang_vente
FROM 
    ventes;

```

### 3.2.3.	Fonctions de fenêtrage 

```sql
SELECT 
    client_id,
    vente_id,
    montant,
    SUM(montant) OVER(PARTITION BY client_id ORDER BY vente_date) AS total_cumule
FROM 
    ventes;


SELECT 
    client_id,
    vente_id,
    montant,
    AVG(montant) OVER(PARTITION BY client_id ORDER BY vente_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moyenne_mobile
FROM 
    ventes;

SELECT 
    client_id,
    vente_id,
    montant,
    LAG(montant, 1, 0) OVER(PARTITION BY client_id ORDER BY vente_date) AS montant_precedent,
    montant - LAG(montant, 1, 0) OVER(PARTITION BY client_id ORDER BY vente_date) AS variation_montant
FROM 
    ventes;
```

## Sauvegarder les résultats d'une transformation

### CETAS

```sql
CREATE TABLE ventes_traitees AS
SELECT 
    client_id,
    vente_id,
    montant,
    ROW_NUMBER() OVER(PARTITION BY client_id ORDER BY vente_date) AS rang_vente
FROM 
    ventes;

```


### INSERT NITO

```sql
INSERT INTO ventes_traitees (client_id, vente_id, montant, categorie)
SELECT 
    client_id,
    vente_id,
    montant,
    CASE 
        WHEN montant > 1000 THEN 'Haute'
        ELSE 'Basse'
    END AS categorie
FROM 
    ventes;

```

## Création de requêtes paramétisées

```sql
SELECT 
    vente_id,
    montant
FROM 
    ventes
WHERE 
    client_id = @ClientID;

CREATE PROCEDURE AjouterVente
    @ClientID INT,
    @Montant DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO ventes (client_id, montant)
    VALUES (@ClientID, @Montant);
END;
```