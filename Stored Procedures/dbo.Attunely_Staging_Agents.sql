SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Attunely_Staging_Agents]
	@FromDate DATETIME
AS
BEGIN
	SET NOCOUNT ON; 
	DECLARE @Updated BIT = 0

	UPDATE Attunely_Agents
	SET Display = u.UserName, RecordTime = GETUTCDATE()
	FROM Users u
		INNER JOIN Attunely_Agents a 
			ON u.LoginName = a.AgentKey 
	WHERE a.Display NOT LIKE u.UserName
	
	IF @@ROWCOUNT > 0 SET @Updated = 1

	INSERT INTO Attunely_Agents (AgentKey, Display, RecordTime)
	SELECT DISTINCT
		u.LoginName,
		u.UserName,
		GETUTCDATE()
	FROM Users u
		LEFT OUTER JOIN Attunely_Agents a 
			ON u.LoginName = a.AgentKey 
	WHERE a.AgentKey IS NULL
	
	IF @@ROWCOUNT > 0 SET @Updated = 1
	SELECT @Updated
END
GO
