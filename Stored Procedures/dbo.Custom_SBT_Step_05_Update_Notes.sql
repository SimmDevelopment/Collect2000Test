SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Custom_SBT_Step_05_Update_Notes]
as

-------------------------------------------------------------------------------------------------------------------------------------
-- Step 5: Update Notes 
-- This query generates the data that will be pumped into the Notes table
-- and adds the notes to the table. 
-------------------------------------------------------------------------------------------------------------------------------------
select null as number, null as created, null as user0, null as action, null as result, null as comment

insert into notes (number, created, user0, action, result, comment) 
(
	--build a line that can go directly into the Notes table.
	select a.number, getdate() as Created, 'System' as user0, 'CO' as [Action], 'CO' as [Result], 'The phone number [' + a.homephone + '] has been removed from future SMS campaigns due to multiple attempts to contact that resulted in a response of "' + a.reason + '"' as Comment
	from
	(
		select distinct m.number, max(dc.Delivery_Date) as delivery_date, right(m.homephone,10) as homephone, cp.reason
		from Custom_SBT_PhoneNumbers_DeliveryCodes dc
		--left join [Collect2000SIMM].dbo.master m on m.homephone=dc.Phone_Number
		left join master m on m.homephone=dc.Phone_Number
		left join Custom_Phones_NoSMS cp on right(dc.Phone_Number,10)=cp.phone_number
		where m.homephone=dc.Phone_Number  and dc.Phone_Number is not null
		and cp.reason is not null
		and dc.Note_Added=0
		group by m.number, right(m.homephone,10), cp.reason
	) a

	left join 
	(
		select distinct m.number, max(dc.Delivery_Date) as delivery_date--, right(m.homephone,10) as homephone--, cp.reason
		from Custom_SBT_PhoneNumbers_DeliveryCodes dc
		--left join [Collect2000SIMM].dbo.master m on m.homephone=dc.Phone_Number
		left join master m on m.homephone=dc.Phone_Number
		--left join Custom_Phones_NoSMS cp on right(dc.Phone_Number,10)=cp.phone_number
		where m.homephone=dc.Phone_Number  and dc.Phone_Number is not null
		--and cp.reason is not null
		group by m.number
	) b on a.number=b.number and a.delivery_date=b.delivery_date 
	where b.delivery_date is not null

)


GO
