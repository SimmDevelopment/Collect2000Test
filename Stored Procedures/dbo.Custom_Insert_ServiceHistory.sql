SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
Exec Custom_Insert_ServiceHistory @number=1648335257,@serviceid=152203,@historyXml = '<Test>Just A Test</Test>'
*/
CREATE  PROCEDURE [dbo].[Custom_Insert_ServiceHistory]
@number as int,	--file number
@serviceId as int,
@historyXml as text
AS

--first see if the record exists in the ServiceHistory table
--Declare @requestId int
	If EXISTS( select * from ServiceHistory where ServiceId=@ServiceId and XMLInfoReturned is null and Processed=0 and AcctId=@Number)
		--perfom an update
		Update ServiceHistory Set XMLInfoReturned=@historyXml,returnedDate=GETDATE(),Processed=1
		Where RequestId = (
			Select top 1 requestid 
			From ServiceHistory 
			Where ServiceId=@ServiceId and XMLInfoReturned is null and Processed=0 and AcctId=@Number	
		)
	else
			INSERT INTO ServiceHistory([AcctId],[DebtorId],[CreationDate],[ServiceId],[RequestedBy],[RequestedProgram],
				[XMLInfoReturned],[FileName],[SystemYear],[SystemMonth],[ReturnedDate],Processed)
			VALUES (
				@number,
				null,
				GETDATE(),
				@serviceId,			
				'EXG',						--RequestedBy
				'EXG',						--RequestedProgram
				@historyXml,				--XMLInfoReturned
				null,						--FileName
				DATEPART(year,GETDATE()),	--sysyear
				DATEPART(month,GETDATE()),	--sysmonth
				GETDATE(),					--returned date
				1							--processed
			)

GO
