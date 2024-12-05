SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




CREATE    procedure [dbo].[sp_Custom_PostShermanAccountBalanceUpdate]
AS
BEGIN

	DECLARE @DABatchNumber int
	DECLARE @DARBatchNumber int	
	DECLARE @DateRan datetime
	DECLARE @CreatedDate datetime
	DECLARE @ShermanBatchNumber int
	
	-- Truncate Tables Holding Payment Batches and Payment Batch Items
	TRUNCATE TABLE [ShermanPaymentBatches]
	TRUNCATE TABLE [ShermanPaymentBatchItems]
	TRUNCATE TABLE [ShermanBalanceHolding]

	-- Find the maximum date ran
	SELECT @DateRan=MAX([DateRan])
	FROM ShermanBalanceUpdate WITH (NOLOCK)
	
	-- Remove records 2 days prior
	DELETE FROM ShermanBalanceUpdate
	WHERE [DateRan]< @DateRan-2

	-- Find a creation date
	SELECT @CreatedDate=getdate()
	
	-- Find a BatchNumber to update the ShermanBalanceUpdate records
	SELECT @ShermanBatchNumber=ISNULL(NextNumber,0)+1 FROM ShermanBALFileControl

	-- Update the control file.
	UPDATE ShermanBALFileControl
	SET NextNumber=@ShermanBatchNumber

	-- Update the ShermanBalanceUpdate
	UPDATE ShermanBalanceUpdate
	SET [BatchNumber] = @ShermanBatchNumber
	WHERE [DateRan]=@DateRan AND [BatchNumber] IS NULL 
	
	-- Need to Load records into the Sherman Balance Holding We do not want to use accounts that are in 
	-- a closed or returned QLevel and ensure the maximum (latest) record from the ShermanBalanceUpdate is used
	-- (s.UID IN clause WHERE statement accounts for this) In the WHERE clause we find accounts that have
	-- a balance difference between what Sherman shows and what the accounts(Uninvoiced PU,PURs are not included when
	-- finding the account balance).
	INSERT INTO [dbo].[ShermanBalanceHolding]
	([Number],[Balance1],[Balance2],[Balance3],[Balance4])
	SELECT DISTINCT
	m.number,
	[dbo].[Custom_ShermanBalanceByBucket](m.number,1) -(s.PrinOwing-s.PrinCollected) as Balance1,
	[dbo].[Custom_ShermanBalanceByBucket](m.number,2) -(s.InterestOwing-s.InterestCollected) as Balance2,	
	[dbo].[Custom_ShermanBalanceByBucket](m.number,3) -(s.MiscExtraOwing-s.MiscExtraCollected) as Balance3,
	[dbo].[Custom_ShermanBalanceByBucket](m.number,4) -(s.AttyFeeOwing-s.AttyFeeCollected) as Balance4
	FROM ShermanBalanceUpdate s WITH (NOLOCK)
	INNER JOIN master m WITH (NOLOCK)
	ON m.number=s.number
	LEFT OUTER JOIN payhistory ph WITH(NOLOCK)
	ON ph.number=m.number
	WHERE(((s.InterestOwing-s.InterestCollected) <> [dbo].[Custom_ShermanBalanceByBucket](m.number,2)) OR
		  ((s.PrinOwing-s.PrinCollected) <> [dbo].[Custom_ShermanBalanceByBucket](m.number,1)) OR
		  ((s.MiscExtraOwing-s.MiscExtraCollected) <> [dbo].[Custom_ShermanBalanceByBucket](m.number,3)) OR 
		  ((s.AttyFeeOwing-s.AttyFeeCollected) <> [dbo].[Custom_ShermanBalanceByBucket](m.number,4))) AND
			@DateRan=s.DateRan and s.BatchNumber=@ShermanBatchNumber and
			m.Qlevel NOT IN('998','999') AND 
			s.UID IN(SELECT max(uid) FROM ShermanBalanceUpdate
					GROUP by Number)

	-- Find candidate records that need to have adjustments made first lets look for increasing adjustment first (DAs) this will be found 
	-- by a record having one bucket 1 - 4 with a positive balance
	INSERT INTO [ShermanPaymentBatchItems]
	([BatchNumber],[FileNum],[DatePaid],[Entered],[PmtType],
	[Paid0],[Paid1],[Paid2],[Paid3],[Paid4],[Paid5],[Paid6],[Paid7],[Paid8],[Paid9],[Paid10],
	[Fee0],[Fee1],[Fee2],[Fee3],[Fee4],[Fee5],[Fee6],[Fee7],[Fee8],[Fee9],[Fee10],[InvoiceFlags],
	[Comment],[FeeSched],[DateRan])
	SELECT 
	3 as BatchNumber,
	m.number,
	CAST(CONVERT(varchar(10),GetDate(),20) + ' 00:00:00.000' as datetime),
	CAST(CONVERT(varchar(10),GetDate(),20) + ' 00:00:00.000' as datetime),
	3 as PmtType,
	CASE WHEN s.Balance1 > 0 THEN s.Balance1 ELSE 0 END + 
	CASE WHEN s.Balance2 > 0 THEN s.Balance2 ELSE 0 END + 
	CASE WHEN s.Balance3 > 0 THEN s.Balance3 ELSE 0 END + 
	CASE WHEN s.Balance4 > 0 THEN s.Balance4 ELSE 0 END as paid0, -- paid0
	CASE WHEN s.Balance1 > 0 THEN s.Balance1 ELSE 0 END as paid1, -- paid1
	CASE WHEN s.Balance2 > 0 THEN s.Balance2 ELSE 0 END as paid2, -- paid2	
	CASE WHEN s.Balance3 > 0 THEN s.Balance3 ELSE 0 END as paid3, -- paid3
	CASE WHEN s.Balance4 > 0 THEN s.Balance4 ELSE 0 END as paid4, -- paid4	
	0,0,0,0,0,0, -- Paid5 - paid10,
	0,0,0,0,0,0,0,0,0,0,0, -- fee0 - fee10
	'0000000000' as invoiceflags,
	'Sherman BAL Decreasing Adj.'as comment,
	'',@DateRan
	FROM ShermanBalanceHolding s WITH (NOLOCK)
	INNER JOIN master m WITH (NOLOCK)
	ON m.number=s.number
	INNER JOIN customer c WITH (NOLOCK)
	ON c.customer=m.customer
	WHERE s.Balance1 > 0 OR s.Balance2 > 0 OR s.Balance3 > 0 or s.Balance4 > 0

	-- Find candidate records that need to have adjustments made first lets look for decreasing adjustment first (DAs) this will be found 
	-- by a record having one bucket 1 - 4 with a negative balance
	INSERT INTO [ShermanPaymentBatchItems]
	([BatchNumber],[FileNum],[DatePaid],[Entered],[PmtType],
	[Paid0],[Paid1],[Paid2],[Paid3],[Paid4],[Paid5],[Paid6],[Paid7],[Paid8],[Paid9],[Paid10],
	[Fee0],[Fee1],[Fee2],[Fee3],[Fee4],[Fee5],[Fee6],[Fee7],[Fee8],[Fee9],[Fee10],[InvoiceFlags],
	[Comment],[FeeSched],[DateRan])
	SELECT 
	7 as BatchNumber,
	m.number,
	CAST(CONVERT(varchar(10),GetDate(),20) + ' 00:00:00.000' as datetime),
	CAST(CONVERT(varchar(10),GetDate(),20) + ' 00:00:00.000' as datetime),
	7 as PmtType,
	CASE WHEN s.Balance1 < 0 THEN ABS(s.Balance1) ELSE 0 END + 
	CASE WHEN s.Balance2 < 0 THEN ABS(s.Balance2) ELSE 0 END + 
	CASE WHEN s.Balance3 < 0 THEN ABS(s.Balance3) ELSE 0 END + 
	CASE WHEN s.Balance4 < 0 THEN ABS(s.Balance4) ELSE 0 END as paid0, -- paid0
	CASE WHEN s.Balance1 < 0 THEN ABS(s.Balance1) ELSE 0 END as paid1, -- paid1
	CASE WHEN s.Balance2 < 0 THEN ABS(s.Balance2) ELSE 0 END as paid2, -- paid2	
	CASE WHEN s.Balance3 < 0 THEN ABS(s.Balance3) ELSE 0 END as paid3, -- paid3
	CASE WHEN s.Balance4 < 0 THEN ABS(s.Balance4) ELSE 0 END as paid4, -- paid4	
	0,0,0,0,0,0, -- Paid5 - paid10,
	0,0,0,0,0,0,0,0,0,0,0, -- fee0 - fee10
	'0000000000' as invoiceflags,
	'Sherman BAL Increasing Adj.'as comment,
	'',@DateRan
	FROM ShermanBalanceHolding s WITH (NOLOCK)
	INNER JOIN master m WITH (NOLOCK)
	ON m.number=s.number
	INNER JOIN customer c WITH (NOLOCK)
	ON c.customer=m.customer
	WHERE s.Balance1 < 0 OR s.Balance2 < 0 OR s.Balance3 < 0 or s.Balance4 < 0

	-- If we have records in the Sherman Payment Batches Items
	IF EXISTS(SELECT filenum 
			  FROM ShermanPaymentBatchItems)BEGIN
	
		-- Insert DA Batch
		INSERT INTO[ShermanPaymentBatches]
		([BatchNumber],
		[BatchType],
		[CreatedDate],
		[LastAmmended],
		[ItemCount],
		[SysMonth],
		[SysYear],
		[ProcessedDate],
		[ProcessedBy])
		SELECT TOP 1 
		-3,3,@CreatedDate,@CreatedDate,
		(SELECT COUNT(filenum) FROM ShermanPaymentBatchItems WHERE PmtType=3),
		c.currentmonth,c.currentyear,NULL,NULL
		FROM ShermanPaymentBatchItems s WITH (NOLOCK),
		ControlFile c WITH (NOLOCK)
		WHERE s.PmtType=3

		-- Insert DAR Batch
		INSERT INTO[ShermanPaymentBatches]
		([BatchNumber],
		[BatchType],
		[CreatedDate],
		[LastAmmended],
		[ItemCount],
		[SysMonth],
		[SysYear],
		[ProcessedDate],
		[ProcessedBy])
		SELECT TOP 1 
		-7,7,@CreatedDate,@CreatedDate,
		(SELECT COUNT(filenum) FROM ShermanPaymentBatchItems WHERE PmtType=7),
		c.currentmonth,c.currentyear,NULL,NULL
		FROM ShermanPaymentBatchItems s WITH (NOLOCK),
		ControlFile c WITH (NOLOCK)
		WHERE s.PmtType=7
		
		-- Determine the next batch id we can use for any DAs...
		SELECT @DABatchNumber=MAX([BatchNumber])+1 FROM PaymentBatches WITH(NOLOCK)
		
		-- Now we need to Insert into PaymentBatches for the DAs
		INSERT INTO PaymentBatches
		([BatchNumber],[BatchType],	[CreatedDate],[LastAmmended],[ItemCount],[SysMonth],[SysYear],[ProcessedDate],[ProcessedBy])
		SELECT @DABatchNumber,s.BatchType,s.CreatedDate,s.LastAmmended,s.ItemCount,s.SysMonth,s.SysYear,s.ProcessedDate,s.ProcessedBy
		FROM ShermanPaymentBatches s 
		WHERE s.BatchType=3

		-- Insert DAs into PaymentBatchItems
		INSERT INTO [PaymentBatchItems](
		[BatchNumber],[FileNum],[DatePaid],[Entered],[PmtType],[Paid0],[Paid1],	[Paid2],[Paid3],[Paid4],[Paid5],
		[Paid6],[Paid7],[Paid8],[Paid9],[Paid10],[Fee0],[Fee1],[Fee2],[Fee3],[Fee4],[Fee5],[Fee6],[Fee7],[Fee8],
		[Fee9],[Fee10],[InvoiceFlags],[Comment],[FeeSched],
		[InvKeycode],[overpaidamt],[forwardeefee],[ISPif],[IsSettlement],[paymethod],[surcharge],
		[collectorfee],[collectorfeesched])
		SELECT @DABatchNumber,[FileNum],[DatePaid],[Entered],[PmtType],[Paid0],[Paid1],	[Paid2],[Paid3],[Paid4],[Paid5],
		[Paid6],[Paid7],[Paid8],[Paid9],[Paid10],[Fee0],[Fee1],[Fee2],[Fee3],[Fee4],[Fee5],[Fee6],[Fee7],[Fee8],
		[Fee9],[Fee10],[InvoiceFlags],[Comment],[FeeSched],
		0,0,0,0,0,'',0,	0,''
		FROM ShermanPaymentBatchItems
		WHERE PmtType=3

		-- Determine the next batch id we can use for any DARs...
		SELECT @DARBatchNumber=MAX([BatchNumber])+1 FROM PaymentBatches WITH(NOLOCK)

		-- Now we need to Insert into PaymentBatches for the DARs
		INSERT INTO PaymentBatches
		([BatchNumber],[BatchType],	[CreatedDate],[LastAmmended],[ItemCount],[SysMonth],[SysYear],[ProcessedDate],[ProcessedBy])
		SELECT @DARBatchNumber,s.BatchType,s.CreatedDate,s.LastAmmended,s.ItemCount,s.SysMonth,s.SysYear,s.ProcessedDate,s.ProcessedBy
		FROM ShermanPaymentBatches s 
		WHERE s.BatchType=7

		-- Insert DARs into PaymentBatchItems
		INSERT INTO [PaymentBatchItems](
		[BatchNumber],[FileNum],[DatePaid],[Entered],[PmtType],[Paid0],[Paid1],	[Paid2],[Paid3],[Paid4],[Paid5],
		[Paid6],[Paid7],[Paid8],[Paid9],[Paid10],[Fee0],[Fee1],[Fee2],[Fee3],[Fee4],[Fee5],[Fee6],[Fee7],[Fee8],
		[Fee9],[Fee10],[InvoiceFlags],[Comment],[FeeSched],
		[InvKeycode],[overpaidamt],[forwardeefee],[ISPif],[IsSettlement],[paymethod],[surcharge],
		[collectorfee],[collectorfeesched])
		SELECT @DARBatchNumber,[FileNum],[DatePaid],[Entered],[PmtType],[Paid0],[Paid1],	[Paid2],[Paid3],[Paid4],[Paid5],
		[Paid6],[Paid7],[Paid8],[Paid9],[Paid10],[Fee0],[Fee1],[Fee2],[Fee3],[Fee4],[Fee5],[Fee6],[Fee7],[Fee8],
		[Fee9],[Fee10],[InvoiceFlags],[Comment],[FeeSched],
		0,0,0,0,0,'',0,	0,''
		FROM ShermanPaymentBatchItems
		WHERE PmtType=7
	END
END					





GO
