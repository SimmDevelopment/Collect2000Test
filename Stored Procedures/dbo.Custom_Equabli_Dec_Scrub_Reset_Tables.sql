SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Brian G Meehan
-- Create date: 05/03/2023
-- Description:	Clear out tables used for Equabli's Deceased Scrubs
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Dec_Scrub_Reset_Tables] 

AS
BEGIN

	SET NOCOUNT ON;

TRUNCATE TABLE Custom_Equabli_Dec_Scrub_Seed_Data
TRUNCATE TABLE Custom_Equabli_Deceased_Returned


END
GO
