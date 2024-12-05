SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jeff Mixon
-- Create date: 03/27/2007
-- Description:	Will get a generic AppSettings value
-- =============================================
CREATE PROCEDURE [dbo].[LionGetGenericAppSetting]
	@key varchar(100),
	@value varchar(1000) output
AS
BEGIN

	set @value = ''

	select @value = Value FROM LionAppSettings
					WITH (nolock)
					WHERE Name = @key

END
GO
