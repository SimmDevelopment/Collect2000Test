SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[Custom_Auto_InsertNoId]
	--@Id=(newid()),
	@Name varchar(200),
	@Description varchar(500),
	@StopAllOnError bit,
	@ImportConfigXml text,
	@OwnerInterfacePath varchar(500),
	@AutoProcessAllowed bit,
	@ProcessType varchar(10),
	@ProtectionID int,
	@TransferID int
AS
BEGIN
	SET NOCOUNT ON;

	Insert into Custom_ExchangeAuto(
	[Name],
	[Description],
	[StopAllOnError],
	[ImportConfigXml],
	[OwnerInterfacePath],
	[AutoProcessAllowed],
	[ProcessType],
	[ProtectionID],
	[TransferID]
	)
	Values
	(
		@Name,
		@Description,
		@StopAllOnError,
		@ImportConfigXml,
		@OwnerInterfacePath,
		@AutoProcessAllowed,
		@ProcessType,
		 case when @ProtectionID = -1 then null else @ProtectionID end,
		case when @TransferID  = -1 then null else @TransferID end
	
	)

END

GO
