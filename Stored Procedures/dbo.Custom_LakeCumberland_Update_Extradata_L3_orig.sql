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
-- Usage:		EXEC Custom_LakeCumberland_Update_Extradata_L3 '3191200'
-- =============================================
CREATE PROCEDURE [dbo].[Custom_LakeCumberland_Update_Extradata_L3_orig]
	-- Add the parameters for the stored procedure here
	@number varchar(24)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--do this one account at a time.
	--this will prevent that issue of the query slowing over time.

	--In order to get only one L3 record, I mapped the data to an M1 version of the extradata, 
	--did the processing, and set the single value back into L3.
	--DMA 9/12/2022
	update extradata
	set extradata.line5=m.L3_Line5
	from (select * from extradata where extracode='M1' and number=@number) e
	inner join 
	(
		select number, 'M1' as extracode, sum(cast(TheData as numeric(18,2))) as [L3_Line5]
		from miscextra  
		where (title like 'credit:%' or title like 'payment:%')
		and title not like '%SIMM Transfer%'
		and number=@number
		group by number
	) m
	on m.number=e.number 

	where extradata.extracode='L3' 
	and extradata.number=@number

	--In order to get only one L1 record, I mapped the data to an M2 version of the extradata, 
	--did the processing, and set the single value back into L1.
	--DMA 9/12/2022
	update extradata
	set extradata.line5=m.L1_Line5
	from (select * from extradata where extracode='M2' and number=@number) e
	inner join 
	(
		select number, 'M2' as extracode, convert(varchar,  min(cast(TheData as date)) , 1) as [L1_Line5]
		from miscextra
		where number=@number
		and title like 'Cha.%.Date_of_Service'
		group by number
	) m
	on m.number=e.number 

	where extradata.extracode='L1' 
	and extradata.number=@number


	--now, remove the M1 and M2 records, and everything is done.
	delete from extradata where extracode in ('M1', 'M2') and number=@number
END
GO
