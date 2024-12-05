SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Custom_SBT_Step_03_Build_Delivery_Codes_Temp_Table]
as

--Need a no-op sql statement that matches the output so that SSIS can run the sproc.   That's how you get around the temp table problem. (https://www.sqlservercentral.com/articles/ssis-and-stored-procedures-using-temp-tables)
--DMA 12/13/2022
select null as Phone_Number, null as Delivery_Status, null as Delivery_Date, null as Note_Added

--Step 3: Build the delivery_codes table from the staging table

drop table if exists #tmpCustom_SBT_PhoneNumbers_DeliveryCodes

create table #tmpCustom_SBT_PhoneNumbers_DeliveryCodes
(
	phone_number varchar(16), 
	delivery_status varchar(255), 
	delivery_date datetime,
	nkey int null
)

drop table if exists #tmpCustom_SBT_PhoneNumbers_DeliveryCodesToday

create table #tmpCustom_SBT_PhoneNumbers_DeliveryCodesToday
(
	phone_number varchar(16), 
	delivery_status varchar(255), 
	delivery_date datetime,
	nkey int null
)

--Step 3: append to the delivery codes table based on the new data
--        Here we build the Custom_SBT_PhoneNumbers_DeliveryCodes table from the staging table.

insert into #tmpCustom_SBT_PhoneNumbers_DeliveryCodes
--Because commas screw up the field order, we have to adjust as best we can...
--We can handle up to a total of six commas before we start losing data.
--No longer a problem because SSIS works correctly.
 
--normal (0)
select phone_number, delivery_status, cast(delivery_date as datetime) as delivery_date,0
from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging
where isdate(delivery_date)>0
/*
This isn't needed any more because SSIS brings the records in correctly.

union

--one column shifted (161,964)
select  phone_number, deliverystatusid as delivery_status, cast(note as datetime) as delivery_date,0
from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging
where isdate(note)>0
and isdate(delivery_date)=0

union

--two columns shifted (9633)
select  phone_number, uniqueID as delivery_status, cast(delivery_status as datetime) as delivery_date,0
from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging
where isdate(delivery_status)>0
and isdate(note)=0
and isdate(delivery_date)=0

union

--three columns shifted (53)
select  phone_number, TransactionTicket as delivery_status, cast(deliverystatusid as datetime) as delivery_date,0
from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging
where isdate(deliverystatusid)>0
and isdate(delivery_status)=0
and isdate(note)=0
and isdate(delivery_date)=0

union

--four columns shifted (18)
select  phone_number, templateid as delivery_status, cast(uniqueid as datetime) as delivery_date,0
from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging
where isdate(uniqueID)>0
and isdate(deliverystatusid)=0
and isdate(delivery_status)=0
and isdate(note)=0
and isdate(delivery_date)=0

union

--five columns shifted (5)
select  phone_number, OrgCode as delivery_status, cast(TransactionTicket as datetime) as delivery_date,0
from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging
where isdate(TransactionTicket)>0
and isdate(uniqueID)=0
and isdate(deliverystatusid)=0
and isdate(delivery_status)=0
and isdate(note)=0
and isdate(delivery_date)=0

union

--six columns shifted (2)
select  phone_number, left(remarks, charindex(',',remarks)-1)  as delivery_status,cast(TemplateID as datetime) as delivery_date,0
from Custom_SBT_PhoneNumbers_DeliveryCodes_Staging
where isdate(TemplateID)>0
and isdate(TransactionTicket)=0
and isdate(uniqueID)=0
and isdate(deliverystatusid)=0
and isdate(delivery_status)=0
and isdate(note)=0
and isdate(delivery_date)=0

--order by phone_number, delivery_date
*/

declare @nDeliveryCodesRecOldCount int = (select count(*) from  Custom_SBT_PhoneNumbers_DeliveryCodes)
declare @nDeliveryCodesRecAdded int = (select count(*) from  #tmpCustom_SBT_PhoneNumbers_DeliveryCodes)

--create a temp table that has the old data plus the new data.
insert into #tmpCustom_SBT_PhoneNumbers_DeliveryCodesToday (phone_number, delivery_status, delivery_date, nKey)
select * from
(
	--Use a UNION so you don't crash with a duplicate problem.
	--Also, the existing records are not overwritten with a UNION, so you don't lose the flag
	select * from  Custom_SBT_PhoneNumbers_DeliveryCodes 
	union
	select phone_number, delivery_status, delivery_date, nKey from  #tmpCustom_SBT_PhoneNumbers_DeliveryCodes 
) h


/*
--------------------------------------------- #tmpCustom_SBT_PhoneNumbers_DeliveryCodes
--what's going on 
print '1'
select * from  #tmpCustom_SBT_PhoneNumbers_DeliveryCodes 
print '2'
select * from  #tmpCustom_SBT_PhoneNumbers_DeliveryCodesToday 
print '3'
	select * from  Custom_SBT_PhoneNumbers_DeliveryCodes 
	union
	select phone_number, delivery_status, delivery_date, nKey from  #tmpCustom_SBT_PhoneNumbers_DeliveryCodes 

---------------------------------------------
*/

--Using a RIGHT JOIN where the key is NULL.  This guarantees that no duplicates get in.
--DMA 12/21/2022

insert into Custom_SBT_PhoneNumbers_DeliveryCodes 
	select	dct.* 
	from	Custom_SBT_PhoneNumbers_DeliveryCodes dc
	right join #tmpCustom_SBT_PhoneNumbers_DeliveryCodesToday dct on  dc.Phone_Number=dct.phone_number and  dc.Delivery_Status=dct.delivery_status and  dc.Delivery_Date=dct.delivery_date where ( dc.Phone_Number is null and  dc.Delivery_Status is null and  dc.Delivery_Date is null)

--How many records are now in the table?
declare @nDeliveryCodesRecNewCount int = (select count(*) from  Custom_SBT_PhoneNumbers_DeliveryCodes)

--display audit counts to help with troubleshooting.
Print 'Phone records previously on file: ' + cast(@nDeliveryCodesRecOldCount as varchar(15))
Print 'Phone records added this pass: ' + cast(@nDeliveryCodesRecNewCount-@nDeliveryCodesRecOldCount as varchar(15)) + ' of ' + cast(@nDeliveryCodesRecAdded as varchar(15))
Print 'Phone records now on file: ' + cast(@nDeliveryCodesRecNewCount as varchar(16))

--nuke the temp tables
drop table #tmpCustom_SBT_PhoneNumbers_DeliveryCodes
drop table #tmpCustom_SBT_PhoneNumbers_DeliveryCodesToday

select * from Custom_SBT_PhoneNumbers_DeliveryCodes




GO
