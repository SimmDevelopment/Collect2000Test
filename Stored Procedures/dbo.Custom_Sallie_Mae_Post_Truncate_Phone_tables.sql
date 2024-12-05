SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 11/04/2021
-- Description:	Truncate Temp Tables
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Sallie_Mae_Post_Truncate_Phone_tables] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	TRUNCATE TABLE Custom_Sallie_Mae_Post_Phones_Import
	TRUNCATE TABLE Custom_Sallie_Mae_Post_POE_Import

END
GO
