SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[custom_arrow_postNewbiz] 
	-- Add the parameters for the stored procedure here
	@number int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update master
	set previouscreditor = me.thedata
	from miscextra me inner join master m on me.number = m.number
	where m.number = @number and title = 'issuerSubName'


END
GO
