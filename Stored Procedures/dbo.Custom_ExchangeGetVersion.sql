SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 05/15/2006
-- Description:	Will determine the current version for Exchange
-- =============================================
CREATE PROCEDURE [dbo].[Custom_ExchangeGetVersion]
	-- Add the parameters for the stored procedure here
	@minor int output,
	@major int output
--,	@ok bit output
AS
BEGIN
	SET NOCOUNT ON;

	Select @major=[IntValue1],@minor=[IntValue2]
	From GlobalSettings
	where [Namespace]='Latitude.Exchange'
	and [SettingName]='Exchange.Version'	

END
-------------------------------------

GO
