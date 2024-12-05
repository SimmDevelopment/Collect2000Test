SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnGet_Previous_Status](@input int)

RETURNS VARCHAR(5)

AS BEGIN
	
	DECLARE @retStatus VARCHAR(5)
	
	SET @retStatus = (SELECT TOP 1 oldstatus
	FROM StatusHistory sh WITH (NOLOCK)
	WHERE AccountID = @input
	ORDER BY DateChanged DESC)
	
	RETURN @retStatus;
END


GO
