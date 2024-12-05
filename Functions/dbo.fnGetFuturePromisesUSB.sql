SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnGetFuturePromisesUSB]
(
    @number int
)
RETURNS varchar(max)
AS
BEGIN
    declare @output varchar(max)
    select @output = COALESCE(@output + ', ', '') + CONVERT(VARCHAR(10), DueDate, 101) + ' - $' + CONVERT(VARCHAR, Amount)
    from Promises WITH (NOLOCK)
    where AcctID = @number AND Active = 1
    ORDER BY DueDate

    return @output
END
GO
