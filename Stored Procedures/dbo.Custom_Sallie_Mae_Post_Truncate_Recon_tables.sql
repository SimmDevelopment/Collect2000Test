SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 05/25/2022
-- Description:	Truncate Recon Tables
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Sallie_Mae_Post_Truncate_Recon_tables] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	TRUNCATE TABLE Custom_Sallie_Mae_Post_Recon_Import
	

END
GO
