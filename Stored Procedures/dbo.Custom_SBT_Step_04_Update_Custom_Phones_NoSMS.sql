SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Custom_SBT_Step_04_Update_Custom_Phones_NoSMS]
as

select null as [id], null as [phone_number], null as reason

--Step 4: Build the bad phone list (NoSMS) from the delivery_codes table 

declare @intAuditCountOld int
declare @intAuditCountNew int

--save how many noSMS records were previously there
set @intAuditCountOld = (select count(*) from dbo.Custom_Phones_NoSMS) 

--remove all the records from the table and rebuild it
delete from dbo.Custom_Phones_NoSMS 
insert into dbo.Custom_Phones_NoSMS 
	select phone_number, delivery_status as reason
	from 
	(
		select  right(replace(c.phone_number,'-',''),10) as phone_number, max(c.delivery_date) as last_delivery, e.delivery_status
		from
		(
				select phone_number, delivery_status, delivery_date, bad_rec, newest_rec, score
				FROM
				(
					--These phone numbers have the latest call bad, and have more than three calls on record
					--We start here to look for warnings and red flags
					--Methodology: we are counting the status 'delivered' as the only good status.  Everything else is a bad status.
					--             then we use the rank to get the three latest records.
					--			   Then we develop a score by multiplying the status (0 is good, 1 is bad) by the ranking.  The sum of the last three records (ordered by descending record date) is the score.
					--             A score of 6 means that the three latest records were bad (1+2+3).  These are red-flagged records.
					--             A negative score means that the phone number was deactivated at one point.  These are also red-flagged records.
					--Bad statuses are as follows:  “Blocked Number”, “Deactivated Number”, “Queued to Carrier”, “Stop Fail – Inactive Subscriber”, “Undeliverable”.  
					select dc.*, 
						case 
								when lower(delivery_status)='blocked number' then 1
								when lower(delivery_status)='deactivated number' then -10  -- Per Brian, a single deactivated puts a number on the NoSMS list - DMA 12/7/2022
								when lower(delivery_status)='queued to carrier' then 1
								when lower(delivery_status)='stop fail – inactive subscriber' then 1
								when lower(delivery_status)='undeliverable' then 1
								else 0 end as bad_rec, 
						rank() over (partition by phone_number order by delivery_date desc) as newest_rec ,
						case 
								when lower(delivery_status)='blocked number' then 1
								when lower(delivery_status)='deactivated number' then -10
								when lower(delivery_status)='queued to carrier' then 1
								when lower(delivery_status)='stop fail – inactive subscriber' then 1
								when lower(delivery_status)='undeliverable' then 1
								else 0 end * rank() over (partition by phone_number order by delivery_date desc) as SCORE
					from Custom_SBT_PhoneNumbers_DeliveryCodes dc
					where dc.phone_number IN
					(
						--These numbers have multiple calls with the last status as bad
						select dc.phone_number
						from Custom_SBT_PhoneNumbers_DeliveryCodes dc
					)
				) a
		) c

		left join 
				(
					select  phone_number, delivery_status--, newest_rec, delivery_date
					from
					(
						select phone_number, delivery_status, newest_rec, delivery_date
						FROM
						(
							--These phone numbers have the latest call bad, and have more than three calls on record
							--We start here to look for warnings and red flags
							--Methodology: we are counting the status 'delivered' as the only good status.  Everything else is a bad status.
							--             then we use the rank to get the three latest records.
							--			   Then we develop a score by multiplying the status (0 is good, 1 is bad) by the ranking.  The sum of the last three records (ordered by descending record date) is the score.
							--             A score of 6 means that the three latest records were bad (1+2+3).  These are red-flagged records.
							--             A negative score means that the phone number was deactivated at one point.  These are also red-flagged records.
							--Bad statuses are as follows:  “Blocked Number”, “Deactivated Number”, “Queued to Carrier”, “Stop Fail – Inactive Subscriber”, “Undeliverable”.  
							select *, 
								case 
										when lower(delivery_status)='blocked number' then 1
										when lower(delivery_status)='deactivated number' then -10 -- Per Brian, a single deactivated puts a number on the NoSMS list - DMA 12/7/2022
										when lower(delivery_status)='queued to carrier' then 1
										when lower(delivery_status)='stop fail – inactive subscriber' then 1
										when lower(delivery_status)='undeliverable' then 1
										else 0 end as bad_rec, 
								rank() over (partition by phone_number order by delivery_date desc) as newest_rec ,
								case 
										when lower(delivery_status)='blocked number' then 1
										when lower(delivery_status)='deactivated number' then -10
										when lower(delivery_status)='queued to carrier' then 1
										when lower(delivery_status)='stop fail – inactive subscriber' then 1
										when lower(delivery_status)='undeliverable' then 1
										else 0 end * rank() over (partition by phone_number order by delivery_date desc) as SCORE
							from Custom_SBT_PhoneNumbers_DeliveryCodes dc
							where dc.phone_number IN
							(
								--These numbers have multiple calls with the last status as bad
								select dc.phone_number
								from Custom_SBT_PhoneNumbers_DeliveryCodes dc
							)
						) a2
					) c2
					--	left join Custom_SBT_PhoneNumbers_DeliveryCodes a on a.phone_number=c.phone_number and a.delivery_date=c.delivery_date 
					where newest_rec=1 --only need the last three calls
				) e
				on c.phone_number=e.phone_number 

		where c.newest_rec<=3 --only need the last three calls
		group by c.phone_number, e.delivery_status
		having sum(score)=6 or sum(score)<0   -- Per Brian, a single deactivated puts a number on the NoSMS list.  We accomplish that by accounting for a negative number - DMA 12/7/2022
	--	order by phone_number
	) f

	--display the audit counts
	set @intAuditCountNew = (select count(*) from dbo.Custom_Phones_NoSMS) 
	print 'Phone numbers previously on NoSMS list: ' + cast(@intAuditCountOld as varchar(15))
	print 'Phone numbers now on NoSMS list: ' + cast(@intAuditCountNew as varchar(15))

	--show the final work
	select * from dbo.Custom_Phones_NoSMS 



GO
