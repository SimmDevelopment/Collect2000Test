SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                   procedure [dbo].[Custom_Insert_Ltr_Series]
@number	int,
@ltrSerId	int

as

DECLARE @theDate as datetime
SET @theDate = GETDATE()

DECLARE @errorMessage as varchar(400)

begin

--first letter in letter series if days wait is zero inserted in letterrequest and letterrequestrecipient table
DECLARE @letterCode varchar(5)
SELECT @letterCode = code FROM letter l
join LtrSeriesConfig ls on ls.letterid = l.letterid
where ls.LtrSeriesId = @ltrSerId
and ISNULL(ls.daystowait,0) = 0
IF (LEN(LTRIM(RTRIM(@letterCode))) > 0 )
	EXECUTE Custom_Insert_Letter @number,@letterCode;

DECLARE @NullDate as datetime
SET @NullDate = '1/1/1753 12:00:00'

--inserts all letters into ltrseriesqueue table with days wait greater then zero
INSERT INTO [LtrSeriesQueue]([LtrSeriesConfigID], [DateToRequest], [DateRequested], [AccountID], [DebtorID], [PrimaryDebtorID], [DateCreated], [DateUpdated])
SELECT	 lsc.ltrSeriesConfigId
		,(GETDATE()+ISNULL(lsc.daystowait,0))
		,@NullDate
		,m.number
		,debt.debtorId
		,debt.debtorId
		,GETDATE()
		,GETDATE()
  FROM debtors debt 
  JOIN master m on m.number= @number
  JOIN LtrSeries ls on ls.LtrSeriesId = @ltrSerId
  JOIN LtrSeriesConfig lsc on lsc.LtrSeriesId = @ltrSerId
WHERE (	debt.number = @number  and debt.seq=0 
	and (m.current0 between ls.minBalance and ls.maxBalance ))
AND ISNULL(lsc.daystowait,0) > 0



END

--if( @@ROWCOUNT <= 0 ) BEGIN
 --   set @errorMessage = 'Unable to insert letter series[' + @ltrSerId + '] for account [' + cast(@number as varchar) +']';
--	select @errorMessage
 --   RAISERROR(@errorMessage,10,1)  with nowait
--END
GO
