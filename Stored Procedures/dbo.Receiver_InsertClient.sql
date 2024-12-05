SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE      procedure [dbo].[Receiver_InsertClient]
AS

DECLARE @clientid int

	insert into receiver_client (name) values(null)
	select @clientid = Scope_Identity()


	INSERT INTO Receiver_StatusLookup
	(
	agencystatus,
	clientstatus,
	clientid
	)
	
	SELECT
	m.code,
	m.code,
	@clientid
	FROM status m group by m.code

	--INSERT DEFAULT HISTORY FOR NEW CLIENT
	
	SELECT @clientid

GO
