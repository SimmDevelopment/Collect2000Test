SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   procedure [dbo].[Receiver_DeleteClient]
	@clientId int
AS
	delete from receiver_client where clientid = @clientId


GO
