SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionInsertNote    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 11/20/2006
-- Description:	Used to insert a note
-- =============================================
CREATE PROCEDURE [dbo].[LionInsertNote]
	@number int,
	@user varchar(10),
	@action varchar(6),
	@result varchar(6),
	@comment text
AS
BEGIN
	SET NOCOUNT ON;

	Insert into Notes(number,user0,created,action,result,comment)
	Values(@number,@user,GETDATE(),@action,@result,@comment)

END


GO
