SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 05/05/2023
-- Description:	Delete custom import table
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Doc2Doc_Delete_Active_Acct_Table]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	TRUNCATE TABLE Custom_Doc2Doc_Import_Active_Accounts
	
END
GO
