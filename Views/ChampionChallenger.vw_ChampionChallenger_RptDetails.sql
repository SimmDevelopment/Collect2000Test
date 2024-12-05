SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-----------------------------------------------------------------------------------------------
--	Detailed View for the initial ChampionChallenger "Canned" Report(s).
--	Create VIEWS needed for "ChampionChallenger Overview" Crystal Report, a very basic, canned,
--		off-the-shelf report for the ChampionChallenger product.
--
--	2013/02/18 STM - Initial code of View to create Basic CC Overview Report.
--	2013/02/19 STM - split inner query into separate View to allow research or later reporting
--					of accounts (or links) involved in producing these totals.
--	2013/03/01 STM - separate the [vw_ChampionChallenger_RptDetails] VIEW from the 
--					[vw_ChampionChallenger_Report1] VIEW for loading into PERFORCE and deploying.
-----------------------------------------------------------------------------------------------
CREATE VIEW [ChampionChallenger].[vw_ChampionChallenger_RptDetails] AS 

SELECT gt.GroupTypeID, 
	gt.Name AS GroupTypeName, 
	E.Name, E.[Description],
	m.current0, 
	m.original, 
	m.paid * -1 AS Paid,
	PmtsForExperiment.totalpaid,
	CASE WHEN PmtsForExperiment.totalpaid IS NOT NULL THEN 1 ELSE 0 END AS HasPmtBit,
	CASE WHEN m.link = 0 OR m.link IS NULL
		 THEN m.number
		 ELSE m.link
	END AS LinkOrAccountID,
	m.link,
	CASE WHEN m.link = 0 OR m.link IS NULL
		 THEN 'Single'
		 ELSE 'Linked'
	END AS Linked_or_Single_Acct,
	m.number AS MasterNumber
FROM ChampionChallenger.GroupTypes AS gt
	JOIN ChampionChallenger.Groups AS g
	  ON gt.GroupTypeID = g.GroupTypeID
	LEFT JOIN ChampionChallenger.Experiments AS E
	  ON E.ExperimentID = g.ExperimentID
	LEFT JOIN ChampionChallenger.ExperimentTypes AS et
	  ON E.ExperimentTypeID =  et.ExperimentTypeID
	LEFT JOIN ChampionChallenger.PopulationTypes AS pt
	  ON E.PopulationTypeID = pt.PopulationTypeID
	LEFT JOIN ChampionChallenger.GroupAccounts AS ga
	  ON g.GroupID = ga.GroupID
	JOIN master m
	  ON ga.AccountID = m.number
	-- below is to get Payhistory (if any), not Adjustments, posted after Experiment began
	LEFT JOIN (
				SELECT number, SUM(totalpaid) AS totalpaid
				FROM payhistory p
				JOIN ChampionChallenger.GroupAccounts AS ga
				  ON p.number = ga.AccountID
				JOIN ChampionChallenger.Groups AS g
				  ON ga.GroupID = g.GroupID
				JOIN ChampionChallenger.Experiments AS E
				  ON g.ExperimentID = E.ExperimentID
				WHERE P.datepaid >= E.StartDate
				  AND p.batchtype NOT IN ('DA','DAR')
				GROUP BY number
			  ) AS PmtsForExperiment
	  ON m.number = PmtsForExperiment.number;
GO
