SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionInsertAuditAction    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionInsertAuditAction]
	@LionUserID int,
	@Date datetime,
	@Page varchar(1000),
	@ActionCode uniqueidentifier,
	@Message varchar(8000),
	@UserIPAddress varchar(100),
	@UserHostName varchar(100),
	@RawUrl varchar(8000)
AS
BEGIN
	SET NOCOUNT OFF;
INSERT INTO [dbo].[LionAudit] ([LionUserID], [Date], [Page], [ActionCode], [Message], [UserIPAddress], [UserHostName], [RawUrl]) VALUES (@LionUserID, @Date, @Page, @ActionCode, @Message, @UserIPAddress, @UserHostName, @RawUrl);
	
SELECT ID, LionUserID, Date, Page, ActionCode, Message, UserIPAddress, UserHostName, RawUrl 
FROM LionAudit with (nolock)
WHERE (ID = SCOPE_IDENTITY())
END

GO
