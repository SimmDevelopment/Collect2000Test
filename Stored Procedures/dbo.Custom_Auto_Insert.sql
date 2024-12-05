SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 03/09/2006
-- Description:	Used for Exchange automation
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Auto_Insert]
	@Id uniqueidentifier,
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
	[ID],
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
		@ID,
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
