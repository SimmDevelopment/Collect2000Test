SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_College_Avenue_Remediation_Reconciliation] 
	@customer varchar(8000)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS [SEQID_Loan],e.SubStatuses as [Days_Late],(select (thedata) from miscextra with (nolock) where number = m.number and title = 'ACCOUNT_BALANCE')as [Account_Balance],
	m.current1 AS [Amount_Due], e.CurrentDue as [Amount_Past_Due], m.clidlp as [Last_Payment_Date], m.clialp as [Last_Payment_Amount]
From master m with (nolock) INNER JOIN EarlyStageData e WITH (NOLOCK) ON m.number = e.AccountID
WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|'))AND closed IS null

	
END
GO
