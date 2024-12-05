SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Simm_Discover_PreProcess]	
@number as int 

AS
BEGIN
	Create table #existing(number int, status varchar(5), qlevel varchar(3), balance money)
	Create table  #reopens(number int, status varchar(5), qlevel varchar(3), balance money)
	Declare @rundate datetime

	set @rundate = getdate()

	insert into #existing(number, status, qlevel, balance)
    select m.number, m.status, m.qlevel, m.current0
	from master m with(nolock)
	where m.number = @number and m.qlevel < '999'

	insert into #reopens(number, status, qlevel, balance)
    select m.number, m.status, m.qlevel, m.current0
	from master m with(nolock)
	where m.number = @number and m.qlevel = '999'

	-- Need to reopen accounts
	Update master 
	set qlevel='015', status='NEW', returned=@rundate, closed=null,
    current0 = balance, current1 = balance, current2 = 0, current3 = 0, current4 = 0, current5 = 0,
    current6 = 0, current7 = 0, current8 = 0, current9 = 0, current10 = 0,  
    original = 0, original1 = 0, original2 = 0, original3 = 0, original4 = 0, original5 = 0, 
    original6 = 0, original7 = 0, original8 = 0, original9 = 0, original10 = 0,
    paid = 0, paid1 = 0, paid2 = 0, paid3 = 0, paid4 = 0,  paid5 = 0, 
    paid6 = 0, paid7 = 0, paid8 = 0, paid9 = 0, paid10 = 0, 
    branch = '', desk = '', closed = null, returned = null 
	where number in (select number from #reopens)

	Insert into notes (number, created, user0, action, result, comment)
	select number, @rundate, 'Discover', '+++++', '+++++', 'Account re-opened from placement file.'
	from #reopens

	Insert into statushistory (accountid, datechanged, username, oldstatus, newstatus)
	select number, @rundate, 'Discover', status, 'ACT'
	from #reopens
                     
END
GO
