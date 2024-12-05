SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[GetDebtorsLocalTime](
@debtorId INT=0
)
RETURNS DATETIME
AS
BEGIN	
	DECLARE @debtorsLocalTime DATETIME=GETDATE()
	DECLARE @UtcNow DATETIME;

	SET @UtcNow = GETUTCDATE();

				
select @debtorsLocalTime = (
select  top 1 dateadd(HOUR, -
case WHEN DATEPART(HOUR, @UtcNow) >= 6 AND DATEPART(HOUR, @UtcNow) <= 18
				THEN EarlyTimeZone else latetimezone end, @UtcNow) from debtors d
where d.DebtorID = @debtorId)


	RETURN @debtorsLocalTime	
END

GO
