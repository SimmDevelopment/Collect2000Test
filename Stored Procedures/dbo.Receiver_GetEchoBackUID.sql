SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_GetEchoBackUID]
@clientid int,
@file_number int,
@principle money,
@interest money,
@other3 money,
@other4 money,
@other5 money,
@other6 money,
@other7 money,
@other8 money,
@other9 money,
@payment_date datetime,
@batch_type varchar(3),
@payment_identifier int,
@date_column_to_check_flags int,
@days_prior int
AS
BEGIN
	DECLARE @receiverNumber INT
	SELECT @receivernumber = max(receivernumber) FROM receiver_reference WITH (NOLOCK) WHERE sendernumber = @file_number and clientid = @clientid
	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END
	DECLARE @searchedBatchType varchar(3)

	DECLARE @amountToMatch money
	SET @amountToMatch = ISNULL(@principle,0)+ISNULL(@other3,0)+ISNULL(@other4,0)+ISNULL(@other5,0)+ISNULL(@other6,0)+ISNULL(@other7,0)+
		ISNULL(@other8,0)+ISNULL(@other9,0)

	DECLARE @priorDate datetime
	IF(@days_prior IS NULL OR @days_prior < 0)
	BEGIN
		SET @priorDate = @payment_date
		SET @days_prior = 0
	END
	ELSE
	BEGIN
		SET @priorDate = DATEADD(d,-@days_prior,@payment_date)
	END
	-- Now lets determine what batch type we need to look for.
	IF(@batch_type = 'PC') 
	BEGIN
		SET @searchedBatchType = 'PU'
	END
	ELSE
	BEGIN
		SET @searchedBatchType = 'PUR'
	END

--	SELECT @amountToMatch as amount,@priorDate as priorDate,@searchedBatchType as searchedBatchtype,
--	@days_Prior as daysPrior,@payment_date as paymentDate,@file_number as sendernumber,@receiverNumber  as receivernumber,
--	@date_column_to_check_flags as columnflags

	-- The @date_column_to_check_flags is an Enumeration in .NET that can be used as a Flags type Enum 
	-- present values are:
	-- DateEntered = 0
	-- DatePaid = 1
	-- DateInvoiced = 2 and we are not yet using this as a flags enum so there aren't combinations presently.
	SELECT [UID] FROM Payhistory WITH(NOLOCK)
	WHERE [Number] = @receiverNumber 
		AND [BatchType] = @searchedBatchType 
		AND [Invoiced] IS NOT NULL -- Has to Be Invoiced.
		AND (	(@date_column_to_check_flags = 0 AND DATEDIFF(d,@priorDate,[Entered]) BETWEEN 0 AND @days_prior) OR
				(@date_column_to_check_flags = 1 AND DATEDIFF(d,@priorDate,[DatePaid]) BETWEEN 0 AND @days_prior) OR
				(@date_column_to_check_flags = 2 AND DATEDIFF(d,@priorDate,[Invoiced]) BETWEEN 0 AND @days_prior)
			)
		AND [dbo].[DetermineInvoicedAmount]([invoiceflags],[paid1],[paid2],[paid3],[paid4],[paid5],[paid6],[paid7],[paid8],[paid9],[paid10]) = @amountToMatch
		AND ISNULL([Echo],0) = 0 AND [Echoed] IS NULL
END

GO
