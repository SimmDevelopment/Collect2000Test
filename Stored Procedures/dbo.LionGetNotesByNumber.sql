SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetNotesByNumber    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionGetNotesByNumber]
(
	@number int
)
AS
	SET NOCOUNT ON;
SELECT	nv.UID, 
		nv.number, 
		nv.ctl,
		nv.created, 
		nv.user0, 
		nv.action, 
		nv.result, 
		nv.comment, 
		nv.IsPrivate 
FROM dbo.LionNotesView nv
Where nv.number=@number and (nv.IsPrivate is null or nv.IsPrivate != 1 )
order by created desc





GO
