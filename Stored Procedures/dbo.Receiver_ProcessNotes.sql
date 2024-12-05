SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  Procedure [dbo].[Receiver_ProcessNotes]


@file_number int,
@created_datetime datetime,
@note_action varchar(6),
@note_result varchar(6),
@note_comment text,
@clientid int

as

DECLARE @number int
select @number = max(receivernumber) from receiver_reference with (nolock) where sendernumber= @file_number
and clientid = @clientid

if(@number is null)
begin
	RAISERROR ('15001', 16, 1)
	return
end


DECLARE @Qlevel varchar(5)

SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
WHERE [number] = @number

IF(@QLevel = '999') 
BEGIN
	RAISERROR('Account has been returned, QLevel 999.',16,1)
	RETURN
END

INSERT INTO NOTES(number,ctl,created,user0,action,result,comment,seq, UtcCreated) 
VALUES (@number,'AIM',@created_datetime,'AIM',@note_action,@note_result,@note_comment,null,@created_datetime)

GO
