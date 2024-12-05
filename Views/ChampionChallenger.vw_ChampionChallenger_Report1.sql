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
CREATE VIEW [ChampionChallenger].[vw_ChampionChallenger_Report1] 
AS 
	SELECT GroupTypeID, 
		GroupTypeName, 
		Name, 
		[Description], 
		SUM(current0) AS current0, 
		SUM(original) AS original, 
		SUM(TotalPaid) AS TotalPaid, 
		MIN(MasterNumber) AS min_number,
		COUNT(LinkOrAccountID) AS NbrAcctLinks, 
		COUNT(MasterNumber) AS NbrAccts,
		SUM(HasPmtBit) AS NbrAcctsWithPaidAmt, 
		ISNULL(CAST ((SUM(TotalPaid) / SUM(original) ) AS Decimal(5,2) )* 100 , 0.00) AS Yield
	FROM ChampionChallenger.[vw_ChampionChallenger_RptDetails] AS Details
	GROUP BY GroupTypeID, GroupTypeName, Name, [Description];
GO
