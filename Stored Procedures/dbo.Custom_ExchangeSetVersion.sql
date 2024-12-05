SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 05/15/2005
-- Description:	This will set the version for Exchange
-- =============================================

CREATE PROCEDURE [dbo].[Custom_ExchangeSetVersion]
	-- Add the parameters for the stored procedure here
	@minor int,
	@major int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Delete from GlobalSettings
	where [Namespace]='Latitude.Exchange'
	and [SettingName]='Exchange.Version'

	Insert into GlobalSettings([NameSpace],[SettingName],[SettingType],[Description],[IntValue1],[IntValue2])
	Values
	('Latitude.Exchange','Exchange.Version',1,'Current version of Latitude Exchange',@major,@minor)
END
GO
