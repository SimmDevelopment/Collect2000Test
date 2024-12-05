SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Denise M. Atkinson
-- Create date: 9/1/2022
-- Description:	Updates the L3_Line5 value for Lake Cumberland 
-- Changes:		9/12/2022 DMA: Updated code to get the sum of the transactions.  Do the calculations in the L4 field, populate the L3 field with the results, then delete the L4 field.
--         		9/13/2022 DMA: Updated code to get earliest service date.  Do the calculations in the L5 field, populate the L1 field with the results, then delete the L5 field.
--         		9/20/2022 DMA: Rewrote code to work with miscextra table.  No need for L4 or L5 tables.
--         		9/21/2022 DMA:	1) Update L3_Line5 with Sum of Payments/Credits
--								2) Insert Early Stage Data Statement 180 with total Charges
--								3) Update Contract Date with Oldest Charge Date
--								4) Update L1_Line5 and Chargeoff Date with most recent Simm Transfer Credit Transaction date
--

-- Usage:		EXEC Custom_LakeCumberland_Update_Extradata_L3 '3191200'
-- =============================================
CREATE PROCEDURE [dbo].[Custom_LakeCumberland_Update_Extradata_L3]
	-- Add the parameters for the stored procedure here
	@number varchar(24)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--do this one account at a time.
	--this will prevent that issue of the query slowing over time.

	--1) L3_Line5 contains credits and payments
	update extradata
	set extradata.line5=m.L3_Line5
	from (select number from extradata where extracode='L3' and number=@number) e
	inner join 
	(
		select number, 'L3' as extracode, sum(cast(TheData as numeric(18,2))) as [L3_Line5]
		from miscextra  
		where (title like 'credit:%' or title like 'payment:%')
		and title not like '%SIMM Transfer%'
		and number=@number
		group by number
	) m
	on m.number=e.number 

	where extradata.extracode='L3' 
	and extradata.number=@number

	--2) Early Stage Data Statement 180 contains total charges
	if exists (select statement180 from earlystagedata where accountid=@number)
		BEGIN
			--The earlystagedata record is already there (this really shouldn't happen)
			--update the existing record
			update earlystagedata
			set earlystagedata.statement180=m.Charges
			from (select AccountID from earlystagedata where accountid=@number) e
			inner join 
			(
				--sum of charges
				select number, cast(sum(cast(TheData as numeric(18,2)))/100.0 as numeric(18,2)) as [Charges]
				from miscextra  
				where (title like '%Cha.%.Charge_Amount%')
				and number=@number
				group by number
			) m
			on m.number=e.accountid 
		END
	ELSE
		BEGIN
			--The earlystagedata record has to be completed (way more likely)
			--create a new record
			insert into earlystagedata (accountid, statement180) 
			values (@number, 
							(
							  select me.charges from 
							  (
								--sum of charges
								select number, cast(sum(cast(TheData as numeric(18,2)))/100.0 as numeric(18,2)) as [Charges]
								from miscextra  
								where (title like '%Cha.%.Charge_Amount%')
								and number=@number
								group by number
							  ) me
							) 
					)
		END

	--3) Contract Date contains oldest charge date
	update master 
	set master.contractdate=me.ContractDate
	from (select number from master where number=@number) m
	inner join 
	(
		select number, 
				convert(varchar,  min(cast(TheData as date)) , 1) as [ContractDate]
		from miscextra
		where number=@number
		and title like '%Cha.%.Date_of_Service%'
		group by number
	) me
	on m.number=me.number
	and m.number=@number

	where master.number=@number 

	--4a) L1_Line5 contains most recent Simm Transfer Credit 
	update extradata
	set extradata.line5=me.SimmTransferCredit
	from (select number from extradata where extracode='L1' and number=@number) e
	inner join 
	(
		select number, convert(varchar,  max(cast(TheData as date)) , 1) as [SimmTransferCredit]
		from miscextra
		where number=@number
		and title = 'TransferDate'
		group by number
	) me
	on e.number=me.number 
	and me.number=@number

	where extradata.extracode='L1' 
	and extradata.number=@number  

	--4b) Chargeoff Date contains most recent Simm Transfer Credit 
	update master
	set master.chargeoffdate=me.SimmTransferCredit
	from (select number from master where number=@number) m
	inner join 
	(
		select number, convert(varchar,  max(cast(TheData as date)) , 1) as [SimmTransferCredit]
		from miscextra
		where number=@number
		and title = 'TransferDate'
		group by number
	) me
	on m.number=me.number 
	and m.number=@number

	where master.number=@number

END
GO
