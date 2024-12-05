SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnGetFuturePCCUSB]
(
    @number int
)
RETURNS varchar(max)
AS
BEGIN
    declare @output varchar(max)
    select @output = COALESCE(@output + ', ', '') + CONVERT(VARCHAR(10), DepositDate, 101) + ' - $' + CONVERT(VARCHAR, Amount)
    from DebtorCreditCards dcc WITH (NOLOCK)
    where Number = @number AND (IsActive = 1 OR printed = 'y') AND ProcessStatus NOT IN ('returned', 'deleted')
    ORDER BY DepositDate

    return @output
END
GO
