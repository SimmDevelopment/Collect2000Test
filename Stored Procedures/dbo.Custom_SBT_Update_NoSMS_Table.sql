SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Custom_SBT_Update_NoSMS_Table]
as

DECLARE @RESULT as table
(
	number int not null,
	event_text varchar(255) 
)

DECLARE @intStaging int = (select count(*) as nRec from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging)
DECLARE @intPhoneNumbersDeliveryCodes int = (select count(*) from Custom_SBT_PhoneNumbers_DeliveryCodes)
DECLARE @CustomPhonesNoSMS int = (select count(*) from Custom_Phones_NoSMS)

insert into @result values (1,'Number of records in staging table:' + cast(@intStaging as varchar(24)))
insert into @result values (2,'Number of records in phone numbers delivery codes table:' + cast(@intPhoneNumbersDeliveryCodes as varchar(24)))
insert into @result values (3,'Number of records in custom phones no SMS table:' + cast(@CustomPhonesNoSMS as varchar(24)))

select count(*) as nRec from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging; 
select count(*) from Custom_SBT_PhoneNumbers_DeliveryCodes; 
select count(*) from Custom_Phones_NoSMS; 

insert into @result values (4,'Uploading file to staging table')

EXEC msdb.dbo.sp_start_job N'Solutions By Text - Upload File to Staging Table' ;  

insert into @result values (5,'File successfully loaded to staging table')

--give it 5 seconds to run the SSIS.  Otherwise the append runs before the staging table is filled.
waitfor delay '00:00:05'
/*
--/**/

insert into @result 
	select 3, 'Call records in historical file: ' + cast(count(*) as varchar(16))  as result from Custom_SBT_PhoneNumbers_DeliveryCodes

insert into @result 
	select 4, 'Call records in staging table: ' + cast(count(*) as varchar(16))  as result from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging

insert into @result 
	select 5, 'Call records in the SMS Blacklist table: ' + cast(count(*) as varchar(16))  as result from Custom_Phones_NoSMS

insert into @result 
	select 6, 'Building delivery codes temp table'

exec Custom_SBT_Step_03_Build_Delivery_Codes_Temp_Table

insert into @result 
	select 7, 'Updating NoSMS table (blacklist)' 

exec Custom_SBT_Step_04_Update_Custom_Phones_NoSMS

insert into @result 
	select 8, 'Adding notes to the Notes table'
	
exec Custom_SBT_Step_05_Update_Notes

insert into @result 
	select 9, 'Marking notes as written in the Phone_Numbers_Delivery_Codes table:'

exec Custom_SBT_Step_06_Mark_Note_As_Written

insert into @result 
	select 10, 'Clearing the staging table:' 

delete from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging

insert into @result
	select 11, 'Call records in historical file now: ' + cast(count(*) as varchar(16))  as result from Custom_SBT_PhoneNumbers_DeliveryCodes

insert into @result
	select 12, 'Call records in staging table: ' + cast(count(*) as varchar(16))  as result from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging

insert into @result
	select 13, 'Call records in the SMS Blacklist table: ' + cast(count(*) as varchar(16))  as result from Custom_Phones_NoSMS

--/**/
*/
delete from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging

--update the Custom_Power_Automate_Key_Value_Pairs table so the second part of the blacklist can run on automation
declare @strDateStatus varchar(20) = concat(convert(varchar, getdate(), 23), '|1') 

update collect2000simm.dbo.Custom_Power_Automate_Key_Value_Pairs set strValue=@strDateStatus where strKey='SMS_BLACKLIST'

waitfor delay '00:00:05'

SET @intStaging  = (select count(*) as nRec from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging)
SET @intPhoneNumbersDeliveryCodes  = (select count(*) from Custom_SBT_PhoneNumbers_DeliveryCodes)
SET @CustomPhonesNoSMS  = (select count(*) from Custom_Phones_NoSMS)

insert into @result values (6,'Number of records in staging table changed to:' + cast(@intStaging as varchar(24)))
insert into @result values (7,'Number of records in phone numbers delivery codes table changed to:' + cast(@intPhoneNumbersDeliveryCodes as varchar(24)))
insert into @result values (8,'Number of records in custom phones no SMS table changed to:' + cast(@CustomPhonesNoSMS as varchar(24)))

--display the output table
select * from @result
GO
