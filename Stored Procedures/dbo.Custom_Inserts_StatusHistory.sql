SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Custom_Inserts_StatusHistory]

@number int,
@oldStatus varchar(5),
@newStatus varchar(5)

as
begin

Insert into StatusHistory
(
Accountid,
datechanged,
username,
oldstatus,
newstatus

)
values
(
@number,
getdate(),
'Exchange',
@oldStatus,
@newStatus
)







INSERT INTO NOTES (number,ctl,created,user0,action,result,comment,seq)
values ( @number, null, getdate(),'Exchange','+++++','+++++','Status has changed (Old Status = ' + @oldStatus + ') (New Status = ' + @newStatus + ')',null)

end

GO
