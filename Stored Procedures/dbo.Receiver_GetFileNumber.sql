SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       procedure [dbo].[Receiver_GetFileNumber]
	@file_number int,
	@client_id int
AS
	
	declare @receiverNumber int
	select @receivernumber = max(receivernumber)
	from receiver_reference 
	where sendernumber = @file_number
	and clientid = @client_id
	
	if(@receivernumber is null)
	begin
		RAISERROR ('15001', 16, 1)
		return
	end

	select @receiverNumber

GO
