SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Update_Worked_Date_FRD_Replaced] 
	-- Add the parameters for the stored procedure here
	@number INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE master
	SET worked = CONVERT(VARCHAR(8), GETDATE(), 112)
	WHERE number = @number AND status = 'FRD'

END
GO
