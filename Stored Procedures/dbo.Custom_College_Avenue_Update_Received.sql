SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_College_Avenue_Update_Received]
	-- Add the parameters for the stored procedure here
	@number INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update master
set received = dbo.date((SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE Number = me.number AND title = 'recvdate' ORDER BY dbo.date(TheData) DESC))
from miscextra me with (nolock)
where me.number = @number
and title = 'recvdate' and master.number = me.number


END
GO