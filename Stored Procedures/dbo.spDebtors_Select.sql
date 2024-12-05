SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










/*spDebtors_Select*/
CREATE         PROCEDURE [dbo].[spDebtors_Select] 
	@AccountID int
AS

 /*
**Name            :spDebtors_Select
**Function        :Returns all Debtors for a given account and joins Restriction.ID, DebtorsAttorney.ID and Bankruptcy.ID
**Creation        :8/19/2004 mr for version 4.0.29
**Used by         :Latitude.Debtors class
**Change History  :
*/


set Nocount on

SELECT 		dbo.Debtors.*, dbo.restrictions.home AS NoHomeCalls, 
		dbo.restrictions.job AS NoWorkCalls, dbo.restrictions.calls AS NoCalls, dbo.restrictions.comment AS RestrictionComment, 
                dbo.restrictions.suppressletters AS SuppressLetters, dbo.restrictions.RestrictionID AS RestrictionsID, dbo.DebtorAttorneys.ID AS AttorneyID, 
                dbo.Bankruptcy.BankruptcyID AS BankruptcyID,
		ISNULL(dbo.Debtors.EarlyTimeZone, dbo.fnGetTimeZoneEx(dbo.Debtors.State, dbo.Debtors.ZipCode, ISNULL([Debtors].[homephone], [Debtors].[workphone]), '8:00 AM')) AS [Debtor_EarlyTimeZone],
		ISNULL(dbo.Debtors.LateTimeZone, dbo.fnGetTimeZoneEx(dbo.Debtors.State, dbo.Debtors.ZipCode, ISNULL([Debtors].[homephone], [Debtors].[workphone]), '8:00 PM')) AS [Debtor_LateTimeZone],
		GETUTCDATE() AS [ServerUtcDate]
FROM            dbo.Debtors with(nolock) INNER JOIN
		dbo.DebtorTimeZones ON dbo.Debtors.DebtorID = dbo.DebtorTimeZones.DebtorID LEFT OUTER JOIN
                dbo.restrictions with(nolock) ON dbo.Debtors.DebtorID = dbo.restrictions.DebtorID LEFT OUTER JOIN
                dbo.DebtorAttorneys with(nolock) ON dbo.Debtors.DebtorID = dbo.DebtorAttorneys.DebtorID LEFT OUTER JOIN
                dbo.Bankruptcy with(nolock) ON dbo.Debtors.DebtorID = dbo.Bankruptcy.DebtorID
WHERE 		Debtors.Number = @AccountID Order by Debtors.Seq, Debtors.DebtorID

Return @@Error









GO
