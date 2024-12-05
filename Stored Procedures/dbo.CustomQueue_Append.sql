SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CustomQueue_Append] @QueueID INTEGER, @Accounts IMAGE, @SetFollowup BIT, @Updated INTEGER OUTPUT, @Inserted INTEGER OUTPUT
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @ObjectName NVARCHAR(300);
DECLARE @SQL NVARCHAR(4000);

SELECT @ObjectName = QUOTENAME([sysusers].[name]) + '.' + QUOTENAME([sysobjects].[name])
FROM [dbo].[sysobjects]
INNER JOIN [dbo].[sysusers]
ON [sysobjects].[uid] = [sysusers].[uid]
WHERE [sysobjects].[id] = @QueueID
AND [sysobjects].[type] = 'U';

SET @SQL = '
DECLARE @Now DATETIME;
SET @Now = GETDATE();

DECLARE @n TABLE (
	[id] INTEGER NOT NULL IDENTITY(1, 1),
	[number] INTEGER NOT NULL,
	[ZipCode] VARCHAR(5) NULL
);

INSERT INTO @n ([number], [ZipCode])
SELECT [n].[value], LEFT([m].[ZipCode], 5)
FROM [dbo].[fnExtractIds](@Accounts, 1) AS [n]
INNER JOIN [dbo].[master] AS [m]
ON [m].[number] = [n].[value];

UPDATE ' + @ObjectName + '
SET [Done] = ''N'', [LastAccessed] = @Now, [ZipCode] = [n].[ZipCode], [SetFollowup] = @SetFollowup
FROM ' + @ObjectName + ' AS [cq]
INNER JOIN @n AS [n]
ON [cq].[Number] = [n].[number];

SET @Updated = @@ROWCOUNT;

INSERT INTO ' + @ObjectName + ' ([Number], [Done], [ZipCode], [SetFollowup], [LastAccessed])
SELECT [n].[Number], ''N'', [n].[ZipCode], @SetFollowup, @Now
FROM @n AS [n]
LEFT OUTER JOIN ' + @ObjectName + ' AS [cq]
ON [n].[Number] = [cq].[Number]
WHERE [cq].[Number] IS NULL;

SET @Inserted = @@ROWCOUNT;
';

EXEC sp_executesql @stmt = @SQL, @params = N'@Accounts IMAGE, @SetFollowup BIT, @Updated INTEGER OUTPUT, @Inserted INTEGER OUTPUT', @Accounts = @Accounts, @SetFollowup = @SetFollowup, @Updated = @Updated OUTPUT, @Inserted = @Inserted OUTPUT;

RETURN 0;

GO
