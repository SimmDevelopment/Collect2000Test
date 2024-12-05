SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Exchange_GetAllVersionHistory]
AS
BEGIN
	SET NOCOUNT ON;

	Select	vh.id			as [ID],
			vh.Altered		as [Altered],
			vh.UserID		as [UserID],
			u.UserName		as [UserName],
			vh.TreePath		as [TreePath],
			vh.Comment		as [Comment]
	From Exchange_VersionHistory vh
	left Join Users u on u.id=vh.UserID	
	order by vh.Altered desc
END
GO
