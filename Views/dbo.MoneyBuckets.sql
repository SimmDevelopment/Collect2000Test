SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  VIEW [dbo].[MoneyBuckets]
AS
SELECT CAST(1 AS TINYINT) AS [Bucket], ISNULL([money1], '') AS [Description]
FROM controlFile
UNION
SELECT CAST(2 AS TINYINT) AS [Bucket], ISNULL([money2], '') AS [Description]
FROM controlFile
UNION
SELECT CAST(3 AS TINYINT) AS [Bucket], ISNULL([money3], '') AS [Description]
FROM controlFile
UNION
SELECT CAST(4 AS TINYINT) AS [Bucket], ISNULL([money4], '') AS [Description]
FROM controlFile
UNION
SELECT CAST(5 AS TINYINT) AS [Bucket], ISNULL([money5], '') AS [Description]
FROM controlFile
UNION
SELECT CAST(6 AS TINYINT) AS [Bucket], ISNULL([money6], '') AS [Description]
FROM controlFile
UNION
SELECT CAST(7 AS TINYINT) AS [Bucket], ISNULL([money7], '') AS [Description]
FROM controlFile
UNION
SELECT CAST(8 AS TINYINT) AS [Bucket], ISNULL([money8], '') AS [Description]
FROM controlFile
UNION
SELECT CAST(9 AS TINYINT) AS [Bucket], ISNULL([money9], '') AS [Description]
FROM controlFile
UNION
SELECT CAST(10 AS TINYINT) AS [Bucket], ISNULL([money10], '') AS [Description]
FROM controlFile


GO
