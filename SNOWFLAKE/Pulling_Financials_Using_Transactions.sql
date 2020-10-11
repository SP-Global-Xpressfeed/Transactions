/***********************************************************************************************
Returns Financials 

Packages Required:
Transactions Offering

Universal Identifiers:
companyId

Primary Columns Used:
companyId
dataItemId
financialInstanceId
objectId
transactionId

Database_Type:
SNOWFLAKE

Query_Version:
V1

Query_Added_Date:
10/01/2020

DatasetKey:
44

The following sample SQL query returns the financials for a company using the
SP Capital IQ Transactions package in Xpressfeed.

***********************************************************************************************/

SELECT o.transactionId 

, c.companyName
, todf.financialInstanceId
, todf.dataItemId
, di.dataItemName
, todf.dataItemValue
, todf.currencyId 

FROM ciqTransOffering o 

JOIN ciqCompany c ON c.companyId = o.companyId
JOIN ciqTransOfferToPrimaryFeat pf ON pf.transactionId = o.transactionId
JOIN ciqTransOfferingDataInteger todi ON o.transactionId = todi.objectId
JOIN ciqTransOfferDataFinancial todf ON todi.dataItemIntegerValue = todf.financialInstanceId
JOIN ciqDataItem di ON todf.dataItemId = di.dataItemId 

WHERE financialInstanceId = 370201654 
