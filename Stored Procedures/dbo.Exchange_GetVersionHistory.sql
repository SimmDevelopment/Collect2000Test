SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Exchange_GetVersionHistory]
	@TreePath varchar(500)
AS
BEGIN

	SET NOCOUNT ON;

	Select	vh.id			as [ID],
			vh.Altered		as [Altered],
			vh.UserID		as [UserID],
			u.UserName		as [UserName],
			vh.TreePath		as [TreePath],
			vh.Comment		as [Comment],
			'Save Old Version'	AS [Client Definition],
			vh.[ClientDef]	AS [OldClient]
	From Exchange_VersionHistory vh
	left Join Users u on u.id=vh.UserID	
	Where vh.TreePath=@TreePath
	order by vh.Altered desc
END

GO
