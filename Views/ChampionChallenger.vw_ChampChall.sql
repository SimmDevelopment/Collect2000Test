SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ChampionChallenger].[vw_ChampChall]
WITH SCHEMABINDING
AS 
SELECT
	E.ExperimentID,
  E.Name AS ExperimentName,
  E.Code AS ExperimentCode,
  E.[Description] AS ExperimentDescription,
  ET.Name AS ExperimentType,
  PT.PopulaitonTypeDescription AS PopulationType,
  G.Name AS GroupName,
  G.Code AS GroupCode,
  G.[Description] AS GroupDescription,
  GT.Name AS GroupType,
  G.Percentage AS GroupPercentage,
  E.Percentage AS ExperimentPercentage,
  E.StartDate,
  E.EndDate,
  U.UserName,
  GA.AccountID
FROM
	ChampionChallenger.Experiments AS E
	INNER JOIN
	ChampionChallenger.Groups AS G
		ON E.ExperimentID = G.ExperimentID
	INNER JOIN
		ChampionChallenger.GroupAccounts AS GA
			ON G.GroupID = GA.GroupID
	INNER JOIN
		ChampionChallenger.GroupTypes AS GT
			ON GT.GroupTypeID = G.GroupTypeID
	INNER JOIN
		ChampionChallenger.ExperimentTypes AS ET
			ON ET.ExperimentTypeID = E.ExperimentTypeID
	INNER JOIN
		ChampionChallenger.PopulationTypes AS PT
			ON PT.PopulationTypeID = E.PopulationTypeID
	INNER JOIN
		dbo.Users AS U
			ON E.UserID = U.ID

GO
