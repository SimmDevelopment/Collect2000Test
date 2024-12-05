SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Denise M. Atkinson
-- Create date: 11/3/2022
-- Description:	This stored procedure determines if there are any invalid mailing addresses (bad zip codes) in a given date range,
--				creates notes in the Notes table and sets the Mail Return flag in the Debtors table for each invalid mailing address 
-- Changes:		
-- Usage:		Custom_Power_Automate_Write_Bad_Address_Notes '2022-11-03','2022-11-03' - for a given date
--				Custom_Power_Automate_Write_Bad_Address_Notes '2022-10-01','2022-10-31'	- for a range of dates
--				Custom_Power_Automate_Write_Bad_Address_Notes							- for today's date
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Power_Automate_Write_Bad_Address_Notes]
	 @datFrom	datetime	=null,
	 @datTo		datetime	=null
AS
BEGIN

	declare @datCreated		datetime=	getdate()
	declare @datUTCCreated	datetime=	getUTCDate()
	declare @tblZipData table
	(
		mr			varchar(1),	
		number		varchar(16),
		ctl			varchar(1) null,
		created		datetime,
		user0		varchar(16),
		action		varchar(16),
		result		varchar(16),
		comment		text,
		seq			int,
		isPrivate	varchar(16),
		UTCCreated	datetime
	)

	--default date is today.
	--This stored procedure was written to do data for today, 
	--but has the ability to do a range if necessary.
	--DMA 11/3/2022
	if @datFrom is null 
		set @datFrom=getdate()

	if @datTo is null 
		set @datTo=dateadd(millisecond,-1,dateadd(day,1,getdate()))


	insert into @tblZipData (mr,  number, ctl, created, user0, action, result, comment, seq, IsPrivate, UTCCreated)
			select mr, number, null, @datCreated, 'SYSTEM', 'ADDR', 'BAD', 'Mail Return Set on Debtor(' + cast(seq+1 as varchar(3)) + ') - Address appears invalid ', seq, null, @datUTCCreated 
			from debtors 
			where number in 
			(
				select m.number 
				from master m
				where 1=1 AND
				(
					   0=1
					   or m.state in ('NJ','CT','RI','MA','VT','NH','ME') and left(m.zipcode,1)<>'0'
					   or m.state in ('NY','PA','DE') and left(m.zipcode,1)<>'1'
					   or m.state in ('DC','MD','VA','WV','NC','SC') and left(m.zipcode,1)<>'2'
					   or m.state in ('GA','FL','AL','TN','MS') and left(m.zipcode,1)<>'3'
					   or m.state in ('KY','OH','IN','MI') and left(m.zipcode,1)<>'4'
					   or m.state in ('IA','WI','MN','SD','ND','MT') and left(m.zipcode,1)<>'5'
					   or m.state in ('MO','KS','NE','IL') and left(m.zipcode,1)<>'6'
					   or m.state in ('LA','AR','OK','TX') and left(m.zipcode,1)<>'7'
					   or m.state in ('CO','WY','ID','UT','AZ','NM') and left(m.zipcode,1)<>'8'
					   or m.state in ('CA','OR','WA','AK','HI') and left(m.zipcode,1)<>'9'
				)
				and received between @datFrom and @datTo
				and closed is NULL
			) 


	--per Jeff, set mail return flag in debtors table for each bad address
	update debtors set mr='Y' where number in (select number from @tblZipData)

	--per Jeff, add note in collection notes
	insert into notes 
		select number,ctl,created,user0,action,result,comment,Seq,IsPrivate,UtcCreated from @tblZipData

	select * from @tblZipData

end





GO
