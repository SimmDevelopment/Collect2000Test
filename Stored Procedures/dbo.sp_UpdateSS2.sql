SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[sp_UpdateSS2]  --Updates the StairStep table with payments
(
	@AcctID int,
	@BatchType varchar (3),
	@Paid money,
	@Fee money
)
AS
	Declare @MonthDiff smallint
	Declare @AcctSysMo tinyint
	Declare @AcctSysYear smallint
	Declare @CurrentMonth as tinyint
	Declare @CurrentYear as smallint
	Declare @Customer varchar (7)
	Declare @ErrorCode int
	Declare @strMonth varchar(7)
	Declare @strPaid char(20)
	Declare @strFee char(20)
	Declare @strAcctSysMo varchar(2)
	Declare @strAcctSysYear char(4)

	SELECT @CurrentMonth=CurrentMonth, @CurrentYear=CurrentYear from controlfile

	SELECT @Customer=Customer, @AcctSysMo=SysMonth, @AcctSysYear=SysYear from master where number = @AcctID

	SET @MonthDiff = ((@CurrentYear * 12) + @CurrentMonth) - ((@AcctSysYear * 12) + @AcctSysMo) + 1
	IF @MonthDiff > 24 SET @MonthDiff = 99

	IF @BatchType in ('PUR', 'PCR', 'PAR', 'DAR')BEGIN
		Set @Paid = @Paid * -1
		Set @Fee = @Fee * -1
	END

	IF @Batchtype Not in ('DA', 'DAR') BEGIN
		IF @MonthDiff < 0 BEGIN
			-- this in an error, exit gracefully, returning a non zero value. 
			-- In this case lets go ahead and return the @MonthDiff value.
			Return @MonthDiff
		END
		
		Set @strMonth='Month' + ltrim(CONVERT(char(2),@MonthDiff))
		Set @strPaid=CONVERT(char(20),@Paid)
		Set @strFee =CONVERT(char(20), @Fee)
		Set @strAcctSysMo = ltrim(CONVERT(varchar(2),@AcctSysMo))
		Set @strAcctSysYear = ltrim(CONVERT(char(4), @AcctSysYear))

		EXEC ('Update StairStep Set ' + @strMonth + '=' + @strMonth + '+' + @strPaid + 
		',TMCollections = TMCollections  + ' + @strPaid + ', TMFees = TMFees + ' + @strFee +  
		',GTCollections = GTCollections + ' + @strPaid + ', GTFees = GTFees  + ' + @strFee +  
		 ' Where Customer = ''' + @Customer + ''' and SSMonth = ' + @strAcctSysMo + ' and SSYear = ' + @strAcctSysYear )

		Select @ErrorCode = @@Error
		IF @ErrorCode <> 0 BEGIN
			Return @ErrorCode
		END
	END
	ELSE BEGIN
		Update StairStep Set NetDollarsPlaced = NetdollarsPlaced - @Paid, Adjustments = Adjustments + @Paid
		WHERE Customer = @Customer and SSMonth = @AcctsysMo and SSYear = @AcctSysYear

		Select @ErrorCode = @@Error
		If @ErrorCode <> 0 BEGIN
			Return @Errorcode
		END
	END
GO
