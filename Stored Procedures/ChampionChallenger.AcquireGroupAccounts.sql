SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ChampionChallenger].[AcquireGroupAccounts]
	@GroupID NVARCHAR(100),
	@Percentage NVARCHAR(100),
	@FromClause NVARCHAR(MAX),
	@WhereClause NVARCHAR(MAX)
AS
BEGIN
	DECLARE
		@SQL NVARCHAR(MAX),
		@Parameters NVARCHAR(MAX)

	SET @SQL = 'INSERT INTO ChampionChallenger.GroupAccounts (GroupID, AccountID)
	SELECT TOP ' + @Percentage + ' PERCENT
		' + @GroupID + ',
		master.number
	' + @FromClause + '
  ' + @WhereClause + '
	ORDER BY
		NEWID()'
	
	EXECUTE sp_executesql @SQL

END
GO
