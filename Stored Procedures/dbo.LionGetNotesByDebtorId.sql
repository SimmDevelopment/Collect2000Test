SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetNotesByDebtorId    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionGetNotesByDebtorId]
(
	@DebtorId int
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
Join Debtors d on d.number=nv.number
Where d.debtorId=@DebtorId and (nv.IsPrivate is null or nv.IsPrivate != 1 )
order by created desc


GO
