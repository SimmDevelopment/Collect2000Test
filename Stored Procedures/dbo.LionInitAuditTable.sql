SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionInitAuditTable    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LionInitAuditTable]
AS
BEGIN
	SET NOCOUNT ON;

	if not exists(Select * from LionAuditActions where Uid='B94497A5-5488-4535-BDE0-5228632FAA63')
	BEGIN
		Insert into LionAuditActions([Uid],[Description]) Values('B94497A5-5488-4535-BDE0-5228632FAA63','Logged In')
	END

	if not exists(Select * from LionAuditActions where Uid='CD44573F-2676-4F3F-ABDD-6E7E4F2A99F9')
	BEGIN
		Insert into LionAuditActions([Uid],[Description]) Values('CD44573F-2676-4F3F-ABDD-6E7E4F2A99F9','Logged Out')
	END

	if not exists(Select * from LionAuditActions where Uid='4458A19C-B064-41E8-91DB-2CED765D0D3C')
	BEGIN
		Insert into LionAuditActions([Uid],[Description]) Values('4458A19C-B064-41E8-91DB-2CED765D0D3C','Viewed Account')
	END

	if not exists(Select * from LionAuditActions where Uid='900B2729-3DA2-4C97-9C96-1C041B499C47')
	BEGIN
		Insert into LionAuditActions([Uid],[Description]) Values('900B2729-3DA2-4C97-9C96-1C041B499C47','Inserted Note')
	END

	if not exists(Select * from LionAuditActions where Uid='A5921705-4CED-40DC-BB33-68F4B238D440')
	BEGIN
		Insert into LionAuditActions([Uid],[Description]) Values('A5921705-4CED-40DC-BB33-68F4B238D440','Sent Admin Email')
	END
	
	if not exists(Select * from LionAuditActions where Uid='52690808-E7B8-4406-912E-AED0CE0DA49A')
	BEGIN
		Insert into LionAuditActions([Uid],[Description]) Values('52690808-E7B8-4406-912E-AED0CE0DA49A','Ran Report')
	END
	
	if not exists(Select * from LionAuditActions where Uid='96C4507E-F96E-4A78-9935-9243B4D7AD4E')
	BEGIN
		Insert into LionAuditActions([Uid],[Description]) Values('96C4507E-F96E-4A78-9935-9243B4D7AD4E','Login Failed')
	END

	if not exists(Select * from LionAuditActions where Uid='C4C2BD5B-B3FE-4F0A-B4C0-E5F7F2AE9033')
	BEGIN
		Insert into LionAuditActions([Uid],[Description]) Values('C4C2BD5B-B3FE-4F0A-B4C0-E5F7F2AE9033','Viewed Account Failed')
	END



END



GO
