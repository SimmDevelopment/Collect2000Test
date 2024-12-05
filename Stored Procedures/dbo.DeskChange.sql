SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[DeskChange]
	@number int,
	@qlevel varchar (3),
	@qdate varchar (8),
	@newdesk varchar (10),
	@returnSts int output
as 
Declare @Branch varchar(5)
Select @Branch = Branch from desk where Code = @newdesk


update master set qlevel=@qlevel,qdate=@qdate,desk=@newdesk, Branch = @Branch where number =@number

Set @ReturnSts = @@error
Return @ReturnSts
GO
