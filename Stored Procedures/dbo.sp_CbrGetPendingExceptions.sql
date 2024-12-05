SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*dbo.sp_CbrGetPendingExceptions*/
CREATE         PROCEDURE [dbo].[sp_CbrGetPendingExceptions]
-- Name:	sp_CbrGetPendingExceptions
-- Function:    This procedure will retrieve cbrpendingfile exceptions
--		This procedure is called by the Credit Bureau Reporting Wizard
-- Creation: 	03/26/2003 jcc
-- Change History:
--		04/14/2003 jcc added new field cbrrpttype from join to customer table
--		07/14/2003 jcc removed query of m.current1 because this field is now
--		returned from CbrPendingFile table
AS

--retrieve cbrpendingfile exceptions

	SELECT p.*, m.received, m.original1, m.delinquencydate, m.clidlc, 
		m.returned, m.lastpaid, m.Name, m.SSN, m.homephone, m.street1, m.street2, 
		m.city, m.state, m.zipcode, m.mr, m.customer, c.Name AS CustomerName, c.cbrclass AS CbrClass,
		c.cbrrpttype 
	FROM CBRPendingFile p with(nolock)
	INNER JOIN master m with(nolock) ON p.Number = m.number 
	INNER JOIN Customer c with(nolock) ON c.customer = m.customer 
	WHERE (p.ExceptionType > 0)
	ORDER BY p.Number ASC
GO
