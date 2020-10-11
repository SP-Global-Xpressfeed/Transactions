/***********************************************************************************************
Returns IPO Transaction Prices

Packages Required:
Transactions M&A Consideration
Transactions M&A Core
Transactions Offering

Universal Identifiers:
companyId

Primary Columns Used:
companyId
considerationDetailId
considerationStatusTypeId
dataItemId
objectId
transactionConsiderationId
transactionId
transactionPrimaryFeatureId

Database_Type:
POSTGRESQL

Query_Version:
V1

Query_Added_Date:
10/01/2020

DatasetKey:
44

The following sample SQL query returns the IPO Transaction Prices using the SP
Capital IQ Transaction Offering packages in Xpressfeed.

***********************************************************************************************/

SELECT o.transactionId ,
--convert Announced Date fields to datetime ,
o.announcedDay || '-' || o.announcedMonth || '-' || o.announcedYear AS AnnouncedDate , 

r.offerDate AS ClosedDate , 

c.companyId CIQCompanyID , c.companyName AS Target_Or_Issuer ,

pft.transactionPrimaryFeatureName AS PrimaryFeature , 

(SELECT i.dataItemValue FROM ciqTransOfferingDataNumeric i WHERE i.dataItemId = 102325 AND i.objectId = o.transactionId) AS TotalTransactionSizeUSD , 

(SELECT i.dataItemValue FROM ciqTransOfferingDataNumeric i WHERE i.dataItemId = 113369 AND i.objectId = sd.considerationDetailId) AS PrimarySharesOffered ,

(SELECT i.dataItemValue FROM ciqTransOfferingDataNumeric i WHERE i.dataItemId = 105189 AND i.objectId = sd.considerationDetailId) AS Price , 

(SELECT i.dataItemValue FROM ciqTransOfferingDataNumeric i WHERE i.dataItemId = 105153 AND i.objectId = sd.considerationDetailId) AS DiscountPerSecurity,

(SELECT i.dataItemValue FROM  ciqTransOfferingDataNumeric i WHERE i.dataItemId = 105174 AND i.objectId = r.transactionConsiderationId) AS NetProceeds 

FROM ciqTransOffering o 

JOIN ciqCompany c ON c.companyId = o.companyId
JOIN ciqTransOfferingRegistration r ON r.transactionId = o.transactionId
JOIN ciqTransConsidStatusType cst ON cst.considerationStatusTypeId = r.considerationStatusTypeId
JOIN ciqTransOfferSecurityDetail sd ON sd.transactionConsiderationId = r.transactionConsiderationId
JOIN ciqTransOfferToPrimaryFeat pf ON pf.transactionId = o.transactionId
JOIN ciqTransPrimaryFeatureType pft ON  pft.transactionPrimaryFeatureId = pf.transactionPrimaryFeatureId 

--Most recent registration history record 
WHERE r.primaryFlag = 1--Looking at the primary security in the transaction

AND (SELECT i.dataItemBitValue FROM ciqTransOfferingDataBit i WHERE i.dataItemId = 105172 
AND i.objectId = sd.considerationDetailId) = 1--Equity offering (IPO or Secondary Offering) 
AND pf.transactionPrimaryFeatureId IN (5, 6)--Status is Closed 
AND r.considerationStatusTypeId = 6--Closed date is in the last week 
AND CAST(r.offerDate AS DATE) = cast('10-01-2020' as date) - interval '1 Week'  ---date_part(WEEK, -1, '10/01/2020') ---INPUT THE LATEST DATE HERE 

ORDER BY r.offerDate DESC, c.companyName