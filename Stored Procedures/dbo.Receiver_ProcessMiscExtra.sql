SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  Procedure [dbo].[Receiver_ProcessMiscExtra]


@file_number int,
@account varchar(30),
@title varchar(30),
@thedata varchar(100),
@clientid int

as
DECLARE @number int
select @number = max(receivernumber) from receiver_reference rr with (nolock) where sendernumber= @file_number and clientid = @clientid


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

DECLARE @miscextraid int
SELECT @miscextraid = ID FROM MiscExtra WITH (NOLOCK) WHERE Number = @number and Title = @title

IF(@miscextraid IS NOT NULL)
BEGIN
UPDATE MiscExtra SET TheData = @thedata
WHERE ID = @miscextraid

INSERT INTO Notes(number,user0,action,result,comment,created)
VALUES (@number,'AIM','+++++','+++++','Misc Extra Data Changed From | ' + @title + ' | ' + @thedata,getdate())

END
ELSE
BEGIN
INSERT INTO MISCEXTRA(number,title,thedata)
VALUES (@number,@title,@thedata)

INSERT INTO Notes(number,user0,action,result,comment,created)
VALUES (@number,'AIM','+++++','+++++','Misc Extra Data Added | ' + @title + ' | ' + @thedata,getdate())
END

GO
