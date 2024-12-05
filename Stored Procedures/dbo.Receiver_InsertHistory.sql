SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     procedure [dbo].[Receiver_InsertHistory]
	@fileTypeId int
	,@clientId int
AS
	insert into receiver_history (fileTypeId, clientId) values(@fileTypeId, @clientId)
	select Scope_Identity()
	
GO
