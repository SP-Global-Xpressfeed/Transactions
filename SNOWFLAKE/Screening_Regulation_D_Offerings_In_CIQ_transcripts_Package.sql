/***********************************************************************************************
Returns Regulation D Offerings

Packages Required:
Transactions
Transactions M&A Consideration
Transactions M&A Core

Universal Identifiers:
companyId

Primary Columns Used:
companyId
dataItemId
objectId
statusId
transactionConsiderationId
transactionFeatureId
transactionId

Database_Type:
SNOWFLAKE

Query_Version:
V1

Query_Added_Date:
10/01/2020

DatasetKey:
44

The following sample SQL query rovide workarounds to screen the SP Capital IQ Transactions package for 
Regulation D offerings in Xpressfeed.
Note: Uncomment the second query for Private Placement Transactions (To optimize time select for Top 10000
companyIds)

***********************************************************************************************/

--Public Offerings and Shelf Registrations:
SELECT *FROM ciqTransOffering a

JOIN ciqTransactionType b ON a.transactionIdTypeId = b.transactionIdTypeId
JOIN ciqTransOfferingDataVarchar c ON a.transactionId = c.objectId

WHERE c.dataItemVarcharValue LIKE '%regulation D%'

/****
SELECT *FROM ciqTransaction a 
JOIN ciqTransactionType b ON a.transactionIdTypeId = b.transactionIdTypeId
WHERE comments LIKE '%regulation d%'
****/