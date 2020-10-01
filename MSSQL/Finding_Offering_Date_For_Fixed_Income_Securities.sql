/***********************************************************************************************
Returns Offering Date For Fixed Income Securities 

Packages Required:
Transactions
Transactions M&A Consideration
Transactions M&A Core
Transactions Offering

Universal Identifiers:
companyId

Primary Columns Used:
companyId
considerationStatusTypeId
countryId
securitySubTypeId
transactionConsiderationId
transactionId
transactionIdTypeId
transactionPrimaryFeatureId

Database_Type:
MSSQL

Query_Version:
V1

Query_Added_Date:
10/01/2020

DatasetKey:
44

The following sample SQL query returns the offering date for fixed-income offering 
of corporate bonds closed during 2017 for issuers located in specific countries 
using the SP Capital IQ Transactions package in Xpressfeed

***********************************************************************************************/

SELECT DISTINCT e.companyId

, e.companyName
, a.transactionid
, cg.isoCountry3
, pft.transactionPrimaryFeatureName AS PrimaryFeature
, tt.transactionIdTypeName AS transactionType
, b.offerDate, cs.considerationStatusTypeName AS status
, c.securityId
, sst.securitySubTypeName AS securitySubType
, sst.securitysubTypeID,b.offerDate

FROM ciqTransOffering a

JOIN ciqTransOfferingRegistration b ON a.transactionId = b.transactionId
JOIN ciqTransOfferSecurityDetail c ON c.transactionConsiderationId = b.transactionConsiderationId
JOIN ciqTransConsidStatusType cs ON cs.considerationStatusTypeID = b.considerationStatusTypeID
JOIN ciqCompany e ON e.companyid = a.companyId
JOIN ciqCountryGeo cg ON cg.countryid = e.countryId
JOIN ciqTransactionType tt ON tt.transactionidTypeID = a.transactionIdTypeid
JOIN ciqTransOfferToPrimaryFeat pt ON pt.transactionID = a.transactionID
JOIN ciqTransPrimaryFeatureType pft ON pft.transactionPrimaryFeatureId = pt.transactionPrimaryFeatureId
JOIN ciqTransSecuritySubType sst ON sst.securitySubTypeId = c.securitySubTypeId

WHERE cg.isoCountry3 IN ( 'CHN'

, 'IND', 'JPN', 'SGP', 'HKG', 'AUS' )

AND CAST(b.offerDate AS DATE) BETWEEN ( '2017-01-01' ) AND ( '2017-12-31' )
AND b.considerationStatusTypeID = 6 --closed
AND c.securitySubTypeId IN ( 24, 26 ) --corporate debt issues

ORDER BY 2