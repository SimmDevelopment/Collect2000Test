SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/16/2022
-- Description:	Clear Generic Tables for Suntrust BBT Placement File Import
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Suntrust_BBT_Truncate_Exchange_Tables] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
TRUNCATE TABLE Custom_SunTrust_BBT_Temp_ARec
TRUNCATE TABLE Custom_SunTrust_BBT_Temp_CRec
TRUNCATE TABLE Custom_SunTrust_BBT_Temp_DRec
TRUNCATE TABLE Custom_SunTrust_BBT_Temp_HRec
TRUNCATE TABLE Custom_SunTrust_BBT_Temp_KRec
TRUNCATE TABLE Custom_SunTrust_BBT_Temp_MRec
TRUNCATE TABLE Custom_SunTrust_BBT_Temp_URec
TRUNCATE TABLE Custom_SunTrust_BBT_Temp_XRec


END
GO
