COPY INTO dim_stockitems
FROM 'https://labfabricstorageaccount.blob.core.windows.net/wwi/wwicsvfiles/DimStockItem.csv'
WITH (
FILE_TYPE = 'CSV',
CREDENTIAL=(IDENTITY= 'Shared Access Signature', SECRET='xxxxxxxxxxxxxxxxxxxxxxxxx')
)