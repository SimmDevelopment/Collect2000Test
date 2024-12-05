SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan, Simm Associates, Inc.
-- Create date: 4/20/2013
-- Description:	Fixes a bug where the qlevel will not come across in the import file
-- =============================================
CREATE PROCEDURE [dbo].[Custom_RTR_Chase_Post_Maintenance] 
	-- Add the parameters for the stored procedure here
	@number int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- update the qlevel field to 601
	UPDATE master
	SET qlevel = '601'
	WHERE number = @number
END
GO
