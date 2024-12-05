SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Custom_SBT_Step_06_Mark_Note_As_Written]
as

-------------------------------------------------------------------------------------------------------------------------------------
-- Step 6: Mark Note As Written
-- This query toggles the Notes_Added field to keep track of whether or not a note has already been written for this phone number.
-------------------------------------------------------------------------------------------------------------------------------------
UPDATE Custom_SBT_PhoneNumbers_DeliveryCodes 
set note_added=1 
where phone_number in 
(
	--list of phone numbers added to the notes table
	select distinct  homephone
	from Custom_SBT_PhoneNumbers_DeliveryCodes dc
	left join master m on m.homephone=dc.Phone_Number
	left join Custom_Phones_NoSMS cp on right(dc.Phone_Number,10)=cp.phone_number
	where m.homephone=dc.Phone_Number  
	and dc.Phone_Number is not null
	and cp.reason is not null
	and dc.Note_Added=0 --important because the code only looks for records that are not yet added
)


GO
