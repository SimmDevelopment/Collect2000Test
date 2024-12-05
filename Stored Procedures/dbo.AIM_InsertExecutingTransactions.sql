SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_InsertExecutingTransactions]
@transactiontypeid INT,
@agencyId INT
AS

BEGIN

DECLARE @sqlbatchsize int
SELECT @sqlbatchsize = CAST(CAST(VALUE AS VARCHAR)AS INT) FROM Aim_AppSetting WHERE [Key] = 'AIM.Database.SqlBatchTransactionSize'

DECLARE @executeSQL VARCHAR(8000)
SET @executeSQL =
'INSERT INTO #AIMExecutingExportTransactions (AccountTransactionID,ForeignTableUniqueId)
SELECT TOP ' + cast(@sqlbatchsize as VARCHAR(16)) + ' AccountTransactionID,ForeignTableUniqueId
FROM	AIM_AccountReference AR WITH (NOLOCK)
	JOIN AIM_accounttransaction ATR WITH (NOLOCK) ON ATR.AccountReferenceID = AR.AccountReferenceid
	AND ATR.AgencyID = AR.CurrentlyPlacedAgencyID AND ATR.CreatedDateTime > AR.LastPlacementDate
WHERE	atr.agencyid = ' + CAST(@agencyId as VARCHAR(8)) + ' 
	AND transactiontypeid = ' + CAST(@transactiontypeid AS VARCHAR(8)) + '
	AND transactionstatustypeid = 1
	AND ATR.AgencyID IS NOT NULL '

EXEC(@executeSQL)


END

GO
