/***********************************************************************************************
Returns Consideration Details For A Transaction

Packages Required:
Transactions M&A Consideration
Transactions M&A Core

Universal Identifiers:
companyId

Primary Columns Used:
dataItemId
objectId
transactionConsiderationId
transactionId

Database_Type:
MSSQL

Query_Version:
V1

Query_Added_Date:
10/01/2020

DatasetKey:
44

The following sample SQL query returns the consideration details including Consideration to
Shareholders, Offer Per Share, and Total Stock for a specific transaction using the 
SP Capital IQ Transaction packages in Xpressfeed

***********************************************************************************************/

SELECT a.companyId

, c.dataItemId

, di.dataitemname

, c.dataItemValue

, a.*

, b.transactionConsiderationID

, b.transactionID

, offerDate

,currentDate

,primaryFlag

FROM ciqTransMA a

JOIN ciqTransMAConsideration b ON a.transactionID=b.transactionID
JOIN ciqTransMADataNumeric c ON b.transactionConsiderationID=c.objectID
JOIN ciqDataItem di ON c.dataItemId = di.dataItemId

WHERE a.companyID = 7704259 --LinkedIn Corporation

AND announcedDay = 13 AND announcedMonth = 6 and announcedYear = 2016 --AnnouncedDate
AND c.dataItemID IN (102086, 102092, 101057)