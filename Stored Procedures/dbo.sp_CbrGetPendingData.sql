SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*dbo.sp_CbrGetPendingData*/
CREATE         PROCEDURE [dbo].[sp_CbrGetPendingData]
-- Name:	sp_CbrGetPendingData
-- Function:    This procedure will retrieve cbrpendingfile data
--		This procedure is called by the Credit Bureau Reporting Wizard
-- Creation: 	01/29/2003 jcc
-- Change History:
--		03/26/2003 jcc added field ExceptionType (int) to table CbrPendingFile
--		conditional where clause required to not retrieve exception records
--		WHERE (p.ExceptionType is null OR p.ExceptionType = 0)
--		04/14/2003 jcc added new field cbrrpttype from join to customer table
--		12/3/2003 jcc added new field originalcreditor from join to master table
--		5/20/2004 jcc changed from returning p.* to explicitly naming cbrpendingfile 
--		columns in order to return zero for nulls on current0 and current1.
AS
	--retrieve cbrpendingfile data
	SELECT p.Number, p.Entered, isnull(p.Current0,0)Current0, p.Status, p.ActivityType, p.SpecialComment, 
		isnull(p.Current1,0)Current1, p.ActualPaymentAmount, p.ExceptionType,
		m.received, m.original1, m.delinquencydate, m.clidlc, 
		m.returned, m.lastpaid, m.Name, m.SSN, m.homephone, m.street1, m.street2, 
		m.city, m.state, m.zipcode, m.mr, c.Name AS CustomerName, c.cbrclass AS CbrClass,
		c.cbrrpttype, m.originalcreditor 
	FROM CBRPendingFile p with(nolock)
	INNER JOIN master m with(nolock) ON p.Number = m.number 
	INNER JOIN Customer c with(nolock) ON c.customer = m.customer 
	WHERE (p.ExceptionType is null OR p.ExceptionType = 0)
	ORDER BY p.Number ASC
GO
