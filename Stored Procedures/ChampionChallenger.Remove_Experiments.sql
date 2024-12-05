SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [ChampionChallenger].[Remove_Experiments]
	@ExperimentID INT
AS
BEGIN
	DELETE FROM ChampionChallenger.GroupAccounts WHERE GroupID IN (SELECT GroupID FROM ChampionChallenger.Groups AS G WHERE G.ExperimentID = @ExperimentID)
	DELETE FROM ChampionChallenger.Groups WHERE ExperimentID = @ExperimentID
	DELETE FROM ChampionChallenger.Experiments WHERE ExperimentID = @ExperimentID
END
GO
