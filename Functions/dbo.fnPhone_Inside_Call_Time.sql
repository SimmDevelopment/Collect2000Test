SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [dbo].[fnPhone_Inside_Call_Time]
(
	@areacode varchar(3),
	@prefix varchar(3)
)
RETURNS bit
AS
BEGIN
	-- Declare the return variable here
	DECLARE @retStatus bit
	
SELECT @retStatus = CASE WHEN DATEPART(hh, timecur) BETWEEN 8 AND 20 THEN 1 ELSE 0 END
				FROM dbo.AreaCode
				WHERE areacode = @areacode AND prefix = @prefix

	-- Return the result of the function
	RETURN @retStatus

END


GO
