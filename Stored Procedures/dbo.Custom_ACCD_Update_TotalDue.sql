SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_ACCD_Update_TotalDue]
	-- Add the parameters for the stored procedure here
	@number INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update EarlyStageData
set StatementMinDue = (SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE title = 'totaldue' AND number = @number)
where AccountID = @number

END
GO
