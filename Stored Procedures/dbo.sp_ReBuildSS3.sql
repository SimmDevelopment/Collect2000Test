SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_ReBuildSS3*/
CREATE Procedure [dbo].[sp_ReBuildSS3]    --Rebuilds the Adjustments (Also see sp_RebuildSS1 and 2)
	@Cust varchar (7)
AS
Declare @MSysMo tinyint
Declare @MSysYr smallint
Declare @Batch varchar (3)
Declare @PmtDate datetime
Declare @Paid money
Declare @Fee money
Declare @ConversionDate datetime
Declare @Err int

SET NOCOUNT ON

DECLARE crsr CURSOR FAST_FORWARD READ_ONLY FOR
SELECT m.SysMonth, m.SysYear, p.batchtype, p.entered,
       sum(p.paid1+p.paid2+p.paid3+p.paid4+p.paid5+p.paid6+p.paid7+p.paid8+p.paid9+p.paid10) as PaidAmt
FROM master m with(NOLOCK) INNER JOIN PayHistory p WITH(NOLOCK)
ON m.number = p.number
WHERE m.customer = @Cust and p.Batchtype in ('DA', 'DA ', 'DAR') and m.status not in (Select code from Status where ReduceStats = 1)
Group by m.SysYear, m.SysMonth, p.batchtype, p.entered
SELECT @ConversionDate= crdate from sysobjects where name = 'paymentbatches'
IF @@Error <> 0
	Return @@Error

OPEN crsr
SET @Err = @@Error
IF @Err <> 0 GOTO ErrorHandler
FETCH NEXT FROM crsr
INTO @MSysMo, @MSysYr, @Batch, @PmtDate, @Paid
SET @Err = @@Error
IF @Err <> 0 GOTO ErrorHandler
WHILE @@FETCH_STATUS = 0 BEGIN
	IF @PmtDate < @ConversionDate BEGIN
		IF @Batch in ('DA', 'DA ') BEGIN
			UPDATE StairStep SET NetDollarsPlaced = NetDollarsPlaced + @Paid,
			Adjustments = Adjustments - @Paid
			WHERE Customer = @Cust and SSMonth = @MSysMo and SSYear = @MSysYr
		END
		ELSE BEGIN
			UPDATE StairStep SET NetDollarsPlaced = NetDollarsPlaced - @Paid,
			Adjustments = Adjustments + @Paid
			WHERE Customer = @Cust and SSMonth = @MSysMo and SSYear = @MSysYr
		END
	END
	ELSE BEGIN
		IF @Batch in ('DA', 'DA ') BEGIN
			UPDATE StairStep SET NetDollarsPlaced = NetDollarsPlaced - @Paid,
			Adjustments = Adjustments + @Paid
			WHERE Customer = @Cust and SSMonth = @MSysMo and SSYear = @MSysYr
		END
		ELSE BEGIN
			UPDATE StairStep SET NetDollarsPlaced = NetDollarsPlaced + @Paid,
			Adjustments = Adjustments - @Paid
			WHERE Customer = @Cust and SSMonth = @MSysMo and SSYear = @MSysYr
		END
	END
	SET @Err = @@Error
	IF @Err <> 0 GOTO ErrorHandler
	FETCH NEXT FROM crsr
	INTO @MSysMo, @MSysYr, @Batch, @PmtDate, @Paid
	SET @Err = @@Error
	IF @Err <> 0 GOTO ErrorHandler
END
CLOSE crsr
DEALLOCATE crsr
Return @@Error
ErrorHandler:
	CLOSE crsr
	DEALLOCATE crsr
	Return @Err
GO
