SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 

create PROCEDURE [dbo].[Custom_SIMM_Midland_A102]
(@Customers  varchar(7999),
 @DateStamp datetime,  
 @StartDate datetime,
 @EndDate datetime
)
  
  

AS

BEGIN
  
	--self clean table at 6 months to avoid unlimited data growth
	delete from Midland_Daily_A102 where datestamp <=getdate()-180

/*
	TableType Matrix
	0=Credit Card
	1=PDC
	2=Promise Table
*/ 

	--Insert the debtor credit card records entered within range
	insert into Midland_Daily_A102 (
		Number,
		Datestamp,
		TypeTable,
		TableUID,
		Amount)
	select D.Number, @DateStamp, 0, D.ID, D.Amount 
		from Master M (nolock)
		join DebtorCreditCards D (nolock) on d.Number = M.number
	Where m.Customer in (select string from dbo.CustomStringToSet(@Customers, '|'))
		and D.DateEntered between @StartDate and @EndDate
		and D.ID not in (select TableUID from Midland_Daily_A102 (nolock) where number = D.Number and TypeTable = 0)



	--Insert the debtor PDC records entered within range
	insert into Midland_Daily_A102 (
		Number,
		Datestamp,
		TypeTable,
		TableUID,
		Amount)
  	select D.Number, @DateStamp, 1, D.UID, D.Amount 
		from Master M (nolock)
		join PDC D (nolock) on d.Number = M.number
	Where m.Customer in (select string from dbo.CustomStringToSet(@Customers, '|'))
		and D.Entered between @StartDate and @EndDate
		and D.UID not in (select TableUID from Midland_Daily_A102 (nolock) where number = D.Number and TypeTable = 1)
	

    insert into Midland_Daily_A102 (
		Number,
		Datestamp,
		TypeTable,
		TableUID,
		Amount)
	--Insert the debtor promise records entered within range
	select D.AcctID, @DateStamp, 2, D.ID, D.Amount 
		from Master M (nolock)
		join Promises D (nolock) on d.acctid = M.number
	Where m.Customer in (select string from dbo.CustomStringToSet(@Customers, '|'))
		and D.Entered between @StartDate and @EndDate
		and D.ID not in (select TableUID from Midland_Daily_A102 (nolock) where number = D.acctid and TypeTable = 2)
	
END


--ROLLBACK
GO
