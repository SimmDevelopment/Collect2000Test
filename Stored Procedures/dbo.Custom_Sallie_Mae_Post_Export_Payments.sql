SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G. Meehan
-- Create date: 02/11/2022
-- Description:	Exports Payment File for Sallie Mae Post Default
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Sallie_Mae_Post_Export_Payments]
	-- Add the parameters for the stored procedure here
	@invoice varchar(255)

-- exec Custom_Sallie_Mae_Post_Export_Payments 23383

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 'PMT' AS RECID, M.id1 AS ARACID, 'SIMMS' AS ARACVENDID, (SELECT TOP 1 TheData from MiscExtra me WITH (NOLOCK) WHERE p.number = me.number AND Title = 'deb.0.zzencin') AS ZZENCIN, 
	--(SELECT TOP 1 TheData from MiscExtra me WITH (NOLOCK) WHERE p.number = me.number AND Title = 'deb.0.arreltypid') AS ARRELTYPID, 
		CASE WHEN batchtype LIKE '%r' THEN CASE WHEN (ISNULL(COALESCE((SELECT p1.seq FROM pdc p1 WITH (NOLOCK) WHERE p.number = p1.Number AND p1.uid = (SELECT p2.postdateuid FROM payhistory p2 WITH (NOLOCK) WHERE p2.UID =  p.ReverseOfUID)), (SELECT d.seq FROM DebtorCreditCards dcc WITH (NOLOCK)  INNER JOIN Debtors d1 WITH (NOLOCK) ON dcc.DebtorID = d1.DebtorID WHERE dcc.Number = p.number AND dcc.ID = (SELECT p2.postdateuid FROM payhistory p2 WITH (NOLOCK) WHERE p2.UID =  p.ReverseOfUID)), (SELECT d1.seq FROM Promises p2 WITH (NOLOCK) INNER JOIN Debtors d1 WITH (NOLOCK) ON p2.DebtorID = d1.DebtorID WHERE p2.AcctID = p.number AND p2.ID = (SELECT p2.postdateuid FROM payhistory p2 WITH (NOLOCK) WHERE p2.UID =  p.ReverseOfUID))), 0)) = 0 THEN 'PRIM' ELSE 'COMAK' END
	ELSE CASE WHEN (ISNULL(COALESCE((SELECT p1.seq FROM pdc p1 WITH (NOLOCK) WHERE p.number = p1.Number AND p1.uid = p.PostDateUID), 
	(SELECT d.seq FROM DebtorCreditCards dcc WITH (NOLOCK)  INNER JOIN Debtors d1 WITH (NOLOCK) ON dcc.DebtorID = d1.DebtorID WHERE dcc.Number = p.number AND p.PostDateUID = dcc.ID), (SELECT d1.seq FROM Promises p2 WITH (NOLOCK) INNER JOIN Debtors d1 WITH (NOLOCK) ON p2.DebtorID = d1.DebtorID WHERE p2.AcctID = p.number AND p2.ID = p.PostDateUID)), 0)) = 0 THEN 'PRIM' ELSE 'COMAK' END END AS ARRELTYPID,
	p.totalpaid AS AFSPAMT, FORMAT(p.datepaid, 'MMddyyyy') AS AFTREFFDTE, CASE WHEN batchtype LIKE '%r' THEN 'Y' ELSE 'N' END AS REVERSALiNDICATOR
FROM payhistory p WITH (NOLOCK) INNER JOIN master M WITH (NOLOCK) ON p.number = m.number
	INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number
WHERE p.customer IN ('0001120') AND invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))
AND d.Seq = (ISNULL(COALESCE((SELECT p1.SEQ FROM pdc p1 WITH (NOLOCK) WHERE p.number = p1.Number AND p1.uid = (SELECT p2.postdateuid FROM payhistory p2 WITH (NOLOCK) WHERE p2.UID =  p.ReverseOfUID)), (SELECT d.seq FROM DebtorCreditCards dcc WITH (NOLOCK)  INNER JOIN Debtors d1 WITH (NOLOCK) ON dcc.DebtorID = d1.DebtorID WHERE dcc.Number = p.number AND dcc.ID = (SELECT p2.postdateuid FROM payhistory p2 WITH (NOLOCK) WHERE p2.UID =  p.ReverseOfUID)), (SELECT d1.seq FROM Promises p2 WITH (NOLOCK) INNER JOIN Debtors d1 WITH (NOLOCK) ON p2.DebtorID = d1.DebtorID WHERE p2.AcctID = p.number AND p2.ID = (SELECT p2.postdateuid FROM payhistory p2 WITH (NOLOCK) WHERE p2.UID =  p.ReverseOfUID))), 0))




    -- Insert statements for procedure here

END
GO
