SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Fortress_Debtor_Delete]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete from debtors
where debtorid in (
select debtorid 
from debtors d with (Nolock) inner join master m with (Nolock) on d.number = m.number
where (d.name = ',' or d.firstname = '') and d.ssn = '' and customer in ('0001034'))

END
GO
