SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[SP_ChangeQLevel] @FileNumber int, @NewQLevel varchar (3), @ReturnSts int OUTPUT
AS

UPDATE master
set Qlevel = @NewQLevel
where number = @FileNumber

IF (@@error = 0) BEGIN
	Set @ReturnSts = 1
End
Else BEGIN
	set @ReturnSts = 0
End 



GO
