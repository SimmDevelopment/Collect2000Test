SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Citizens_NSF_File]
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select Name as [Customer Name],account as [Customer Account], id1 as [Product Code], 
--(SELECT datepaid FROM payhistory WITH (NOLOCK) WHERE p.ReverseOfUID = uid) as [Date of Payment],
    p.datepaid AS [NSF Date],CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2) ELSE p.paid1 + p.paid2 END AS [NSF Amount]
     --'NSF' as Reason
     
	FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE p.Invoice in (select string from dbo.CustomStringToSet(@invoice,'|') )
--where p.customer in ('0001802','0001803') --and invoiced = dbo.date(getdate()) 
--and batchtype = 'pu'

END
GO
