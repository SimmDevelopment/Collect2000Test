SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ChampionChallenger].[vw_CurrentExperimentAccounts]
AS
	SELECT
		GA.*
	FROM
		ChampionChallenger.Experiments AS E
	 INNER JOIN
		ChampionChallenger.Groups AS G
			ON G.ExperimentID = E.ExperimentID
	 INNER JOIN
		ChampionChallenger.GroupAccounts AS GA
			ON GA.GroupID = G.GroupID
	WHERE
		E.StartDate > GETDATE() OR
		E.EndDate < GETDATE()

GO
