# 4.	Transformations avec Spark

## PySpark

```python
# Lecture d'un fichier CSV dans un DataFrame
df = spark.read.csv("chemin_vers_fichier.csv", header=True, inferSchema=True)

# Filtrer les données où la colonne 'montant' est supérieure à 1000
df_filtre = df.filter(df["montant"] > 1000)

# Afficher les résultats
df_filtre.show()
```

## Exécuter un notebook depuis un autre

### Sans paramètres

```python
notebookutils.notebook.run("Notebook_nettoyage")
```

### Avec paramètres

```python
notebookutils.notebook.run("Notebook_transformation", 200, {"table_a_transformer": "clients"})
```

## Orchestrer l'exécution de plusieurs notebooks


```python
notebookutils.notebook.runMultiple(["Notebook_nettoyage", "Notebook_transformation"])
```

```python
DAG = {
    "activities": [
        {
            "name": "Notebook_nettoyage", 
            "path": "Notebook_nettoyage", 
            "timeoutPerCellInSeconds": 120,
        },
        {
            "name": "Notebook_transformation", 
            "path": "Notebook_transformation", 
            "timeoutPerCellInSeconds": 120,
            "retry": 1,
            "retryIntervalInSeconds": 10,
            "args": {"table_a_transformer": "ventes"},
            "dependencies": ["Notebook_nettoyage"]
        },
    ],
    "timeoutInSeconds": 3600,
    "concurrency": 5 
}

mssparkutils.notebook.runMultiple(DAG, {"displayDAGViaGraphviz":True, "DAGLayout":"planar", "DAGSize":11})
```

## Interagir avec Fabric depuis un notebook

### Importer un fichier sous forme de table

```python
notebookutils.lakehouse.loadTable(
    {
        "relativePath": "Files/nouveaux-clients.csv",
        "pathType": "File",
        "mode": "Overwrite",
        "recursive": False,
        "formatOptions": {
            "format": "Csv",
            "header": True,
            "delimiter": ","
        }
    }, "nom_de_la_table", "nom_du_lakehouse", "id de l'espace de travail")
```

### Rafraîchir un modèle sémantique

```python
import sempy.fabric as fabric
fabric.refresh_dataset(
    workspace="My workspace",
    dataset="ChrisWarehouse")
```

### Appeler l'API REST de Fabric

```python
import sempy.fabric as fabric
workspaceId = fabric.get_workspace_id()
payload = {
        "displayName": "lakehouseTemporaire",
        "type": "Lakehouse"
          }
response = client.post(f"/v1/workspaces/{workspaceId}/items",json= payload)
```

Cet autre exemple permet de lancer l'exécution d'un Pipeline :

```python
import sempy.fabric as fabric
workspaceId = fabric.get_workspace_id()
pipelineId= "b9d7511a-a171-4c24-a3f0-e099e94a6989"
payload = { 
  "executionData": { 
    "parameters": {
      "param_waitsec": "10" 
    } 
  } 
}
response = client.post(f"/v1/workspaces/{workspaceId}/items/{pipelineId}/jobs/instances?jobType=Pipeline",json= payload)

```