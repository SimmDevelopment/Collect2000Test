SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnGetEndDatePCCUSB]
(
    @number INT,
    @startDate DATETIME,
    @endDate DATETIME
)
RETURNS varchar(max)
AS
BEGIN
    declare @output varchar(max)
    select @output = (select TOP 1 CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) 
    FROM DebtorCreditCards WITH (NOLOCK) 
    WHERE number = @number AND CAST(DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
    ORDER BY DepositDate DESC)
    
    
    --COALESCE(@output + ', ', '') + CONVERT(VARCHAR(10), DepositDate, 101) + ' - $' + CONVERT(VARCHAR, Amount)
    --from DebtorCreditCards dcc WITH (NOLOCK)
    --where Number = @number AND (IsActive = 1 OR printed = 'y') AND ProcessStatus NOT IN ('returned', 'deleted')
    --ORDER BY DepositDate

    return @output
END
GO
