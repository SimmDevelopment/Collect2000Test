SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 09/19/2024
-- Description:	Truncate data out of main import table
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NelNetFM_Delete_Main_Table] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	TRUNCATE TABLE Custom_NelNet_FM_Main_File
END
GO
