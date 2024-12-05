SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Jeff Mixon
-- Create date: 03/27/2007
-- Description:	Will set a generic AppSettings value
-- =============================================
/*
declare @key varchar(100)
declare @value varchar(1000)
set @key = 'FirstRun'
set @value = 'True'

exec LionSetGenericAppSetting @key, @value
*/
CREATE PROCEDURE [dbo].[LionSetGenericAppSetting]
	@key	varchar(100),
	@value	varchar(1000)
AS
BEGIN

	SET NOCOUNT ON;
	declare @transid varchar(10)
	set @transid = 'LLSGAS'

	BEGIN TRANSACTION @transid

	IF EXISTS (select * from lionappsettings where Name = @key)
	BEGIN
		DELETE FROM LionAppSettings
		WHERE Name = @key
	END
	IF (@@ERROR <> 0)
	GOTO ERRORHANDLER
	
	INSERT INTO LionAppSettings([Name], [Value])
	VALUES (@key, @value)
	IF (@@ERROR <> 0)
	GOTO ERRORHANDLER

	COMMIT TRANSACTION @transid
	RETURN

	ERRORHANDLER:
	BEGIN
		ROLLBACK TRANSACTION @transid
		RAISERROR (N'Unable to set value. Error id %d',15,1, @@ERROR);
	END
END
GO
