SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_FMC_SIMM_Closed]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select Account, [Name], SSN
from master with (Nolock)
where account in (select account from ztempfmcrecon) and (closed < dbo.F_START_OF_MONTH(getdate())) and received < dbo.F_START_OF_MONTH(getdate()) 
and account not in (select account from master with (Nolock) where closed is null and customer in (select customerid from fact with (Nolock) where customgroupid = 134))

END
GO
