/***********************************************************************************************
Returns Tender Offer Transactions With Percent Sought Greater Than Percent Acquired

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
MSSQL

Query_Version:
V1

Query_Added_Date:
10/01/2020

DatasetKey:
44

The following sample SQL query returns MA transactions for tender offers where the percent sought
on the announced date is greater than the percent acquired on the final date using the SP Capital 
IQ tables in Xpressfeed.

***********************************************************************************************/

SELECT t.companyID
, tarco.companyName AS targetCompany
, rel.companyid, bco.companyName AS buyer
, t.transactionId, tc.currencyId
, st.statusDatetime AS announcedDate
, stid.statusName AS Announced
, tdno.dataItemValue AS PercentSought
, tdno1.dataItemValue AS ValueOffered
, stc.statusDatetime AS closedDate
, stidc.statusName AS ClosedStatus
, tdnoc.dataItemValue AS PercentAcquired
, tdnoc1.dataItemValue AS ValuePaid

FROM ciqTransMA t

INNER JOIN ciqTransMACompanyRel rel ON rel.transactionId = t.transactionId

AND rel.transactionToCompanyRelTypeId = 1

JOIN ciqTransMAConsideration tc ON t.transactionId = tc.transactionId

JOIN ciqTransMADataNumeric tdno ON tc.transactionConsiderationId = tdno.objectId 

AND tdno.dataItemId = 101024

JOIN ciqTransMADataNumeric tdno1 ON  tc.transactionConsiderationId = tdno1.objectId 

AND tdno1.dataItemId = 102086

JOIN ciqCompany tarco ON tarco.companyId = t.companyid

JOIN ciqCompany bco ON bco.companyID = rel.companyid

JOIN ciqTransMAStatusToDate st ON st.transactionID = t.transactionId 

AND st.statusDatetime = tc.offerdate AND st.statusId = 1

JOIN ciqTransactionStatus stid ON stid.statusId = st.statusId

JOIN ciqTransMAConsideration tcc ON t.transactionId = tcc.transactionId

JOIN ciqTransMADataNumeric tdnoc ON tcc.transactionConsiderationId = tdnoc.objectId

AND tdnoc.dataItemId = 101024

JOIN ciqTransMADataNumeric tdnoc1 ON tcc.transactionConsiderationId = tdnoc1.objectId

AND tdnoc1.dataItemId = 102086

JOIN ciqTransMAStatusToDate stc ON stc.transactionID = t.transactionId

AND stc.statusDatetime = tcc.offerdate AND stc.statusId in (2,4)

JOIN ciqTransactionStatus stidc ON stidc.statusId = stc.statusId

WHERE tdno.dataItemValue = tdnoc.dataItemValue

AND EXISTS 

( SELECT NULL FROM ciqTransMAToTransFeature tender

WHERE tender.transactionId = t.transactionId

AND tender.transactionFeatureId IN ( 43 , 131 , 162 , 165 ))

ORDER BY tc.currentdate DESC