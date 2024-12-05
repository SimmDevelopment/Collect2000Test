SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [ChampionChallenger].[Remove_GroupAccounts]
	@ExperimentID INT
AS
BEGIN
	DELETE FROM ChampionChallenger.GroupAccounts WHERE GroupID IN (SELECT GroupID FROM ChampionChallenger.Groups AS G WHERE G.ExperimentID = @ExperimentID)
END

GO
