SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_GetAppliedCustomerPermissions] @PermissionID INTEGER, @UserID INTEGER, @CustomerCodes TEXT, @IncludeUserPermission BIT = 0
AS
SET NOCOUNT ON;

DECLARE @Customers TABLE (
	[ID] INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	[customer] VARCHAR(7) UNIQUE
);
DECLARE @Index INTEGER;
DECLARE @CustomerCode VARCHAR(7);
DECLARE @Configured BIT;

IF @IncludeUserPermission = 1 BEGIN
	EXEC [dbo].[Policies_GetAppliedPermissions] @PermissionID = @PermissionID, @UserID = @UserID, @CustomerCode = NULL, @Configured = @Configured OUTPUT;
END;

INSERT INTO @Customers ([ID], [customer])
SELECT [CustomerCodes].[rowid], RTRIM(CAST([CustomerCodes].[value] AS VARCHAR(7)))
FROM [dbo].[fnExtractFixedStrings](@CustomerCodes, 7) AS [CustomerCodes];

SET @Index = 1;

WHILE EXISTS (SELECT * FROM @Customers WHERE [ID] = @Index) BEGIN
	SELECT @CustomerCode = [customer]
	FROM @Customers
	WHERE [ID] = @Index;

	EXEC [dbo].[Policies_GetAppliedPermissions] @PermissionID = @PermissionID, @UserID = @UserID, @CustomerCode = @CustomerCode, @Configured = @Configured OUTPUT;

	SET @Index = @Index + 1;
END;

RETURN 0;

GO
