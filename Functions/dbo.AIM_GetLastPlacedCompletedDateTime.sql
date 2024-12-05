SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[AIM_GetLastPlacedCompletedDateTime]
(
@agencyid int,
@accountreferenceid int
)
RETURNS DATETIME
AS
BEGIN
DECLARE @maxDateTime DATETIME
SELECT @maxDateTime = max(CompletedDateTime)
FROM AIM_AccountTransaction WITH (NOLOCK)
WHERE
	TransactionTypeId = 1 AND TransactionStatusTypeId = 3
	AND AgencyId = @agencyId AND AccountReferenceId = @accountreferenceid
	AND ValidPlacement = 1
GROUP BY AccountReferenceId

IF @maxDateTime = null
BEGIN
	RETURN null
END

RETURN @maxDateTime

END


GO
