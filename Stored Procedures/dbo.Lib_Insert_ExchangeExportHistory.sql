SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[Lib_Insert_ExchangeExportHistory]
(
	@ExchangeClientID int,
	@ExchangeExportID uniqueidentifier,
	@UserID int,
	@ExchangeExportName varchar(200)
)
as
begin

	insert into [dbo].[Exchange_ExportHistory]
	(
		[ExchangeClientID],
		[ExchangeExportID],
		[UserID],
		[ExchangeExportName]
	)
	values
	(
		@ExchangeClientID,
		@ExchangeExportID,
		@UserID,
		@ExchangeExportName
	)

	select Scope_Identity()
end

GO
