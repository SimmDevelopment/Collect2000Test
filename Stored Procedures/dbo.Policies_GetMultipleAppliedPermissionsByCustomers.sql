SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_GetMultipleAppliedPermissionsByCustomers] @PermissionIDs IMAGE, @UserID INTEGER, @CustomerCodes TEXT, @LittleEndian BIT = 1
AS
SET NOCOUNT ON;

DECLARE @Permissions TABLE (
	[ID] INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	[PermissionID] INTEGER NOT NULL
);
DECLARE @Index INTEGER;
DECLARE @PermissionID INTEGER;
DECLARE @Configured BIT;

INSERT INTO @Permissions ([ID], [PermissionID])
SELECT [rowid], [value]
FROM [dbo].[fnExtractIDs](@PermissionIDs, @LittleEndian)
ORDER BY [rowid];

SET @Index = 1;

WHILE EXISTS (SELECT * FROM @Permissions WHERE [ID] = @Index) BEGIN
	SELECT @PermissionID = [PermissionID]
	FROM @Permissions
	WHERE [ID] = @Index;

	EXEC [dbo].[Policies_GetAppliedPermissionsByCustomers] @PermissionID = @PermissionID, @UserID = @UserID, @CustomerCodes = @CustomerCodes, @Configured = @Configured OUTPUT;

	SET @Index = @Index + 1;
END;

RETURN 0;

GO
