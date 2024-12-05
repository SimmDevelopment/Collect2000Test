SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Judgment_SelectTransactionsReadyForFile]
@agencyId int,
@transactionTypeID int
AS

BEGIN
CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
EXEC dbo.AIM_InsertExecutingTransactions @transactionTypeID,@agencyId


SELECT
	  'CJDG' as record_type
	  ,cc.AccountID as [file_number]
      ,CASE cc.Judgement WHEN 0 THEN 'F' ELSE 'T' END AS [JudgementFlag]
      ,[CaseNumber]
      ,[JudgementAmt]
	  ,[JudgementIntAward]
      ,[JudgementCostAward]
	  ,[JudgementAttorneyCostAward]
      ,[JudgementOtherAward]
      ,[JudgementIntRate]
	  ,[IntFromDate]
	  ,[AttorneyAckDate]
	  ,[DateFiled]
	  ,[ServiceDate]
      ,[JudgementDate]
	  ,[JudgementRecordedDate]
	  ,[DateAnswered]
      ,[StatuteDeadline]
      ,[CourtDate]
      ,[DiscoveryCutoff]
      ,[DiscoveryReplyDate]
      ,[MotionCutoff]
      ,[ArbitrationDate]
      ,[LastSummaryJudgementDate]
      ,[Status]
      ,[ServiceType]
      ,[MiscInfo1]
      ,[MiscInfo2]
      ,[Remarks]
      ,[Plaintiff]
      ,[Defendant]
      ,[JudgementBook]
      ,[JudgementPage]
      ,[Judge]
      ,[CourtRoom]
	  ,c.[CourtName] AS [CourtName]
      ,c.[County] AS [CourtCounty]
      ,c.[Address1] AS [CourtStreet1]
      ,c.[Address2] AS [CourtStreet2]
      ,c.[City] AS [CourtCity]
      ,c.[State] AS [CourtState]
      ,c.[Zipcode] AS [CourtZipcode]
      ,c.[Phone] AS [CourtPhone]
      ,c.[Fax] AS [CourtFax]
      ,c.[Salutation] AS [CourtSalutation]
      ,c.[ClerkFirstName] AS [CourtClerkFirstName]
      ,c.[ClerkMiddleName] AS [CourtClerkMiddleName]
      ,c.[ClerkLastName] AS [CourtClerkLastName]
      ,c.[Notes] AS [CourtNotes]
FROM #AIMExecutingExportTransactions j JOIN 
CourtCases cc WITH (NOLOCK) ON cc.CourtCaseID = j.foreigntableuniqueid
JOIN Courts c WITH (NOLOCK) ON cc.CourtID = c.CourtID

UPDATE AIM_AccountTransaction
SET TransactionStatusTypeID = 4
FROM AIM_AccountTransaction ATR WITH (NOLOCK)
JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
WHERE ATR.TransactionStatusTypeID = 1

DROP TABLE #AIMExecutingExportTransactions
END

GO
