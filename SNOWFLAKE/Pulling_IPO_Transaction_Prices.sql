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
SNOWFLAKE

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

pft.transactionPrimaryFeatureName AS PrimaryFeature,

i.dataItemValue  AS TotalTransactionSizeUSD , 

j.dataItemValue AS PrimarySharesOffered ,

k.dataItemValue AS Price , 

l.dataItemValue AS DiscountPerSecurity,

m.dataItemValue  AS NetProceeds 

FROM ciqTransOffering o 

JOIN ciqCompany c ON c.companyId = o.companyId
JOIN ciqTransOfferingRegistration r ON r.transactionId = o.transactionId
JOIN ciqTransConsidStatusType cst ON cst.considerationStatusTypeId = r.considerationStatusTypeId
JOIN ciqTransOfferSecurityDetail sd ON sd.transactionConsiderationId = r.transactionConsiderationId
JOIN ciqTransOfferToPrimaryFeat pf ON pf.transactionId = o.transactionId
JOIN ciqTransPrimaryFeatureType pft ON  pft.transactionPrimaryFeatureId = pf.transactionPrimaryFeatureId 
JOIN ciqTransOfferingDataNumeric i on i.objectId = o.transactionId and i.dataitemid = 102325
JOIN ciqTransOfferingDataNumeric j on j.objectId = sd.considerationDetailId and j.dataitemid = 113369
JOIN ciqTransOfferingDataNumeric k on k.objectId = sd.considerationDetailId and k.dataitemid = 105189
JOIN ciqTransOfferingDataNumeric l on l.objectId = sd.considerationDetailId and l.dataitemid = 105153
JOIN ciqTransOfferingDataNumeric m on m.objectId = r.transactionConsiderationId and m.dataitemid = 105174
JOIN ciqTransOfferingDataBit PB on PB.objectId =  sd.considerationDetailId and PB.dataItemBitValue = 1 --Equity offering (IPO or Secondary Offering) 

--Most recent registration history record 
WHERE r.primaryFlag = 1--Looking at the primary security in the transaction

--AND (SELECT i.dataItemBitValue FROM ciqTransOfferingDataBit i WHERE i.dataItemId = 105172 
--AND i.objectId = sd.considerationDetailId) = 1--Equity offering (IPO or Secondary Offering) 
AND pf.transactionPrimaryFeatureId IN (5, 6)--Status is Closed 
AND r.considerationStatusTypeId = 6--Closed date is in the last week 
AND CAST(r.offerDate AS DATE) = cast('2020-10-01' as date) - interval '1 Week'  ---date_part(WEEK, -1, '10/01/2020') ---INPUT THE LATEST DATE HERE 

ORDER BY r.offerDate DESC, c.companyName