SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 06/08/2022
-- Description:	Reset Temp table prior to loading new accounts from placement file
-- =============================================
CREATE PROCEDURE [dbo].[Custom_PurchasePower_Truncate_Import_Accts_Table]

	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	TRUNCATE TABLE Custom_PurchasePower_Import_Accts
	
END
GO
