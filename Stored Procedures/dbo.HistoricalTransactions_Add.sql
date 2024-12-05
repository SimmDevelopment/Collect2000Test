SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[HistoricalTransactions_Add]
@FileNumber INTEGER,
@TransactionDate DATETIME,
@AmountOfTransaction MONEY,
@TransactionType VARCHAR(10) = NULL,
@TransactionReference VARCHAR(100) = NULL,
@TransactionComment VARCHAR(1000) = NULL

AS

BEGIN 
	INSERT INTO HistoricalTransactions(
		FileNumber, 
		TransactionDate, 
		AmountOfTransaction,
		TransactionType,
		TransactionReference,
		TransactionComment,
		DateCreated
	)
	VALUES
	(
		@FileNumber, 
		@TransactionDate,
		@AmountOfTransaction, 
		@TransactionType,
		@TransactionReference,
		@TransactionComment,
		GETUTCDATE()			
	)
END
GO
