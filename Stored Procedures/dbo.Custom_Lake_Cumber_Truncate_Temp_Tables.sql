SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 08/12/2024
-- Description:	Reset Temp tables for next import.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Lake_Cumber_Truncate_Temp_Tables]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

TRUNCATE TABLE Custom_Lake_Cumber_Import_Adjust_Data
TRUNCATE TABLE Custom_Lake_Cumber_Import_Charges_Data
TRUNCATE TABLE Custom_Lake_Cumber_Import_Guarantor_Data
TRUNCATE TABLE Custom_Lake_Cumber_Import_INS_Data
TRUNCATE TABLE Custom_Lake_Cumber_Import_Patient_Data


END
GO
