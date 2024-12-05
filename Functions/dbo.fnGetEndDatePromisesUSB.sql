SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[fnGetEndDatePromisesUSB]
(
    @number INT,
    @startDate DATETIME,
    @endDate DATETIME
)
RETURNS varchar(max)
AS
BEGIN
    declare @output varchar(max)
    select @output = (select TOP 1 CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) 
    FROM Promises WITH (NOLOCK) 
    WHERE AcctID = @number AND (CAST(Entered AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) ) 
    ORDER BY DueDate DESC)
    
    
    
    --COALESCE(@output + ', ', '') + CONVERT(VARCHAR(10), DueDate, 101) + ' - $' + CONVERT(VARCHAR, Amount)
    --from Promises WITH (NOLOCK)
    --where AcctID = @number AND Active = 1
    --ORDER BY DueDate

    return @output
END
GO
