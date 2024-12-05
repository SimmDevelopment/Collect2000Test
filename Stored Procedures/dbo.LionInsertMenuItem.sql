SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[LionInsertMenuItem]
	@name varchar(100),
	@treePath varchar(1000),
	@url varchar(1000),
	@reportDef text,
	@target varchar(50)
AS
BEGIN

	declare @transId varchar(20)
	set @transId = (SELECT CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS varchar(20)))

	BEGIN TRANSACTION @transId

	INSERT INTO [dbo].[LionMenus]
			   ([Name]
			   ,[TreePath]
			   ,[URL]
			   ,[ReportDefinition]
			   ,[Target])
		 VALUES
			   (@name
			   ,@treePath
			   ,@url
			   ,@reportDef
			   ,@target)

	IF (@@ERROR <> 0) GOTO ErrorHandler

	COMMIT TRANSACTION @transId
	RETURN
	
	ErrorHandler:
	ROLLBACK TRANSACTION @transId

END
GO
