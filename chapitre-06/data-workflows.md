# Data workfolws

```python
from datetime import datetime   
from airflow import DAG
from airflow.operators.bash import BashOperator

# Définition des arguments par défaut
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 5, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1
}

# Création du DAG
with DAG(
    'dags-dag1.py',
    default_args=default_args,
    description='Un Hello World',
    schedule_interval=None,
    catchup=False
) as dag:

    # Définition des tâches
    hello_task = BashOperator(
        task_id='hello_world_task',
        bash_command='echo "Bonjour depuis Fabric !"'
    )

    # Définition de la deuxième tâche
    fin_task = BashOperator(
        task_id='fin_transformation_task',
        bash_command='echo "Fin de la transformation"'
    )

    # Agencement des tâches
    hello_task >> fin_task

```