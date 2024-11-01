
--OLS - Object Level Security
---------------------------------
GRANT SELECT ON [mondwh].[dbo].[orders] TO [emilie@fabricbook.fr]
DENY INSERT, UPDATE, DELETE ON [mondwh].[dbo].[orders] TO [jean-michel@fabricbook.fr]
REVOKE EXECUTE ON DATABASE::[mondwh] TO [public]

--CLS - Column-Level Security
---------------------------------
GRANT SELECT ON Orders(OrderID, ProductID, Quantity) TO [romain@fabricbook.fr];

--RLS - Row-Level Security
---------------------------------
CREATE SCHEMA security;
GO
-- On crée la fonction qui dit si une ligne est visbile ou pas
CREATE FUNCTION security.rls_orders(@commercial AS nvarchar(50))
    RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 as resultat
    WHERE @commercial = USER_NAME() OR USER_NAME() = 'boss@fabrickbook.fr';
GO
-- On lie la fonction à la table et à la colonne
CREATE SECURITY POLICY RLS_Orders
ADD FILTER PREDICATE security.rls_orders([commercial_colonne])
ON dbo.[dbo_Orders]
WITH (STATE = ON);
GO

--Dynamic Data Masking
---------------------------------
CREATE SCHEMA donnees_sensibles;
GO
CREATE TABLE donnees_sensibles.Employes (
    EmployeeID INT
    ,numero_secu CHAR(13) MASKED WITH (FUNCTION = 'partial(0,"XXX-XX-",4)') NULL
    ,email VARCHAR(256) MASKED WITH (FUNCTION = 'default()') NULL
    );
GO 
INSERT INTO donnees_sensibles.Employes
    VALUES (1, '1791221111222','jp@fabricbook.fr');
INSERT INTO donnees_sensibles.Employes
    VALUES (2, '2580575222111','tatasuzanne@fabricbook.fr');
GO

DENY UNMASK on donnees_sensibles.Employes TO [Data Scientists Role]
GRANT UNMASK on donnees_sensibles.Employes TO [dpo@fabricbook.fr]
