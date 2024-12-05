SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_ReBuildSS2*/

CREATE  Procedure [dbo].[sp_ReBuildSS2]      --Rebuilds the Payment figures (Also see sp_RebuildSS1 and 3)
	@Cust varchar (7)
AS
Declare @CSysMo tinyint
Declare @CSysYr smallint
Declare @MSysMo tinyint
Declare @MSysYr smallint
Declare @PSysMo tinyint
Declare @PSysYr smallint
Declare @Batch varchar (3)
Declare @Paid money
Declare @Fee money
Declare @MoDiff smallint
Declare @Err int


SET NOCOUNT ON

DECLARE crsr CURSOR FAST_FORWARD READ_ONLY FOR
SELECT m.SysMonth, m.SysYear, p.SystemMonth, p.SystemYear, p.batchtype,
	isnull(sum(dbo.DetermineInvoicedAmount(p.invoiceflags, p.paid1, p.paid2, p.paid3, p.paid4, p.paid5, p.paid6, p.paid7, p.paid8, p.paid9, p.paid10)), 0) as PaidAmt,
	isnull(sum(dbo.DetermineInvoicedAmount(p.invoiceflags, p.fee1, p.fee2, p.fee3, p.fee4, p.fee5, p.fee6, p.fee7, p.fee8, p.fee9, p.fee10)), 0) as FeeAmt
--       sum(p.paid1+p.paid2+p.paid3+p.paid4+p.paid5+p.paid6+p.paid7+p.paid8+p.paid9+p.paid10) as PaidAmt,
 --      sum(p.fee1+p.fee2+p.fee3+p.fee4+p.fee5+p.fee6+p.fee7+p.fee8+p.fee9+p.fee10) as FeeAmt
FROM master m WITH(NOLOCK) INNER JOIN PayHistory p WITH(NOLOCK)
ON m.number = p.number
WHERE m.customer = @Cust and p.Batchtype in ('PU', 'PU ', 'PC', 'PC ', 'PUR', 'PCR', 'PA', 'PAR') and m.status not in(Select code from Status with(NOLOCK) where ReduceStats = 1)
Group by m.SysYear, m.SysMonth, p.batchtype, p.SystemYear, p.SystemMonth


SELECT @CSysMo = CurrentMonth, @CSysYr = CurrentYear FROM ControlFile WITH(NOLOCK)
OPEN crsr
SET @Err = @@Error
IF @Err <> 0 GOTO ErrorHandler
FETCH NEXT FROM crsr
INTO @MSysMo, @MSysYr, @PSysMo, @PSysYr, @Batch, @Paid, @Fee
SET @Err = @@Error
IF @Err <> 0 GOTO ErrorHandler
WHILE @@FETCH_STATUS = 0 BEGIN
	IF rtrim(@Batch) in ('PUR', 'PCR', 'PAR') BEGIN
		Set @Paid = @Paid * -1
		Set @Fee = @Fee * -1
	END
	UPDATE StairStep SET GTCollections = GTCollections + @Paid, GTFees = GTFees + @Fee
	WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo
	Set @MoDiff = ((@PSysYr * 12) + @PSysMo) - ((@MSysYr * 12) + @MSysMo)

	IF (@CSysYr = @PSysYr) and (@CSysMo = @PSysMo) --its this month's payment
		UPDATE Stairstep SET TMCollections = TMCollections + @Paid, TMFees = TMFees + @Fee
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo
	IF @MoDiff = 0
		UPDATE Stairstep SET Month1 = Month1 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo
	IF @MoDiff = 1
		UPDATE Stairstep SET Month2 = Month2 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 2
		UPDATE Stairstep SET Month3 = Month3 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 3
		UPDATE Stairstep SET Month4 = Month4 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 4
		UPDATE Stairstep SET Month5 = Month5 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 5
		UPDATE Stairstep SET Month6 = Month6 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 6
		UPDATE Stairstep SET Month7 = Month7 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 7
		UPDATE Stairstep SET Month8 = Month8 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 8
		UPDATE Stairstep SET Month9 = Month9 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 9
		UPDATE Stairstep SET Month10 = Month10 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 10
		UPDATE Stairstep SET Month11 = Month11 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 11
		UPDATE Stairstep SET Month12 = Month12 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 12
		UPDATE Stairstep SET Month13 = Month13 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 13
		UPDATE Stairstep SET Month14 = Month14 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 14
		UPDATE Stairstep SET Month15 = Month15 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 15
		UPDATE Stairstep SET Month16 = Month16 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 16
		UPDATE Stairstep SET Month17 = Month17 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 17
		UPDATE Stairstep SET Month18 = Month18 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 18
		UPDATE Stairstep SET Month19 = Month19 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 19
		UPDATE Stairstep SET Month20 = Month20 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 20
		UPDATE Stairstep SET Month21 = Month21 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 21
		UPDATE Stairstep SET Month22 = Month22 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 22
		UPDATE Stairstep SET Month23 = Month23 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff = 23
		UPDATE Stairstep SET Month24 = Month24 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	IF @MoDiff > 23
		UPDATE Stairstep SET Month99 = Month99 + @Paid
		WHERE Customer = @Cust and SSYear = @MSysYr and SSMonth = @MSysMo 
	SET @Err = @@Error
	IF @Err <> 0 GOTO ErrorHandler
	FETCH NEXT FROM crsr 
	INTO @MSysMo, @MSysYr, @PSysMo, @PSysYr, @Batch, @Paid, @Fee
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
