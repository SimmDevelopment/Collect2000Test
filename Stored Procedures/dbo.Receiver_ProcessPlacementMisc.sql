SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      procedure [dbo].[Receiver_ProcessPlacementMisc]
	@file_number int,
	@account varchar(30),  
	@title varchar(30),
	@misc_data varchar(100),
	@clientid int
AS

	declare @receiverNumber int
	select @receivernumber = max(receivernumber) from receiver_reference where sendernumber = @file_number and clientid = @clientid
	if(@receivernumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end

	
	insert into
		miscextra
		(
			number
			,title
			,thedata
		)			
		values
		(	
			 @receiverNumber
			,@title
			,@misc_data
		)
 INSERT INTO Notes(number,user0,action,result,comment,created)
 VALUES (@receiverNumber,'AIM','+++++','+++++','Misc Extra Data Added | ' + @title + ' | ' + @misc_data,getdate())

GO
