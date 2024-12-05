SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Deceased_SelectTransactionsReadyForFile]

@agencyId int,
@transactionTypeID int
AS
BEGIN
CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
EXEC dbo.AIM_InsertExecutingTransactions @transactionTypeID,@agencyId

SELECT
	
	  'CDEC' as record_type,
      d.debtorid as debtor_number,
      d.accountid as file_number,
      d.ssn as ssn,
      d.FirstName as first_name,
      d.LastName  as last_name,
      d.state as state,
      d.postalcode as postal_code,
      d.dob as date_of_birth,
      d.dod as date_of_death,
      d.matchcode as match_code,
      d.transmitteddate as transmit_date,
	  [ClaimDeadline] AS    claim_deadline_date,
      [DateFiled] AS		 filed_date,
      [CaseNumber] AS		 case_number,
      [Executor] AS		 executor,
      [ExecutorPhone] AS	 executor_phone,
      [ExecutorFax] AS		 executor_fax,
      [ExecutorStreet1] AS	 executor_street1,
      [ExecutorStreet2] AS	 executor_street2,
      [ExecutorState] AS	 executor_state,
      [ExecutorCity] AS	 executor_city,
      [ExecutorZipcode] AS	 executor_zipcode,
      [CourtCity] AS		 court_city,
      [CourtDistrict] AS	 court_district,
      [CourtDivision] AS	 court_division,
      [CourtPhone] AS		 court_phone,
      [CourtStreet1] AS	 court_street1,
      [CourtStreet2] AS	 court_street2,
      [CourtState] AS		 court_state,
      [CourtZipcode] AS	 court_zipcode
FROM #AIMExecutingExportTransactions [temp]
JOIN Deceased d WITH (NOLOCK) ON [temp].[ForeignTableUniqueID] = d.ID

     

UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions

END

GO
