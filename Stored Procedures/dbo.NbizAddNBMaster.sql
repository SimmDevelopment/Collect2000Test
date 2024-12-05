SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[NbizAddNBMaster] 
	@number integer,			-- 0
	@desk nvarchar (10) =NULL ,		-- 1	
	@Name nvarchar (30) =NULL ,		-- 2
	@Street1 nvarchar (30) =NULL ,		-- 3
	@Street2 nvarchar (30) =NULL ,		-- 4	
	@City nvarchar (20) =NULL ,		-- 5
	@State nvarchar (3) =NULL ,		-- 6
	@Zipcode nvarchar (10) =NULL,   	-- 7
	@account nvarchar (30) =NULL ,		-- 8 
	@homephone nvarchar (20) =NULL ,	-- 9 
	@workphone nvarchar (20) =NULL ,	-- 10
	@received smalldatetime =NULL ,	-- 11
	@customer nvarchar (7) =NULL ,		-- 12
	@SSN nvarchar (15) =NULL ,		-- 13
	@original money =0 ,			-- 14
	@original1 money =0 ,			-- 15
	@Current0 money  = 0,			-- 16
	@current1 money  = 0,			-- 17
	@userdate1 smalldatetime =NULL,	-- 18
	@specialnote varchar (75) =NULL,	-- 19			-- 1/2/00 last field used by chrysler
	@original2 money =0 ,			-- 20	
	@original3 money =0 ,			-- 21
	@original4 money =0 ,			-- 22
	@paid money =0 ,			-- 23			
	@current2 money  = 0 ,			-- 24
	@current3 money  = 0 ,			-- 25
	@current4 money  = 0 ,			-- 26			
	@userdate2 smalldatetime =NULL ,	-- 27
	@userdate3 smalldatetime =NULL ,	-- 28			-- 1/14/00 last field used by Peach
	@ctl nvarchar (3) ='ctl',
	@other nvarchar (30) =NULL ,
	@MR nvarchar (1) ='N' ,
	@link int =NULL ,
	@closed smalldatetime =NULL ,
	@returned smalldatetime =NULL ,
	@lastpaid smalldatetime =NULL ,
	@lastpaidamt money  = 0 ,
	@lastinterest smalldatetime =NULL ,
	@interestrate money  = 0 ,
	@worked smalldatetime =NULL ,
	@contacted smalldatetime =NULL ,
	@status nvarchar (5) ='NEW' ,
	@original5 money =0,
	@original6 money =0 ,
	@original7 money =0 ,
	@original8 money =0 ,
	@original9 money =0 ,
	@original10 money =0 ,
	@paid1 money =0 ,
	@paid2 money =0 ,
	@paid3 money =0 ,
	@paid4 money =0 ,
	@paid5 money =0 ,
	@paid6 money  = 0 ,
	@paid7 money  = 0 ,
	@paid8 money  = 0 ,
	@paid9 money  = 0 ,
	@paid10 money  = 0 ,
	@current5 money  = 0 ,
	@current6 money  = 0 ,
	@current7 money  = 0 ,
	@current8 money  = 0 ,
	@current9 money  = 0 ,
	@current10 money  = 0 ,
	@attorney nvarchar (5)= NULL ,
	@assignedattorney smalldatetime=NULL ,
	@promamt money =0 ,
	@promdue smalldatetime=NULL ,
	@sifpct money= 0 ,
	@queue nvarchar (26) =NULL ,
	@qflag nvarchar (1) ='1' ,
	@qdate nvarchar (8) = null,
	@qlevel nvarchar (3) ='15 ' ,
	@qtime nvarchar (4) ='0000' ,
	@extracodes nvarchar (40)=' ' ,
	@Salary money  = 0 ,
	@feecode nvarchar (30)  =NULL ,
	@clidlc smalldatetime=NULL ,
	@clidlp smalldatetime =NULL ,
	@seq int =0 ,
	@Pseq int =0,
	@Branch nvarchar (5)=NULL ,
	@Finders smalldatetime=NULL ,
	@Complete1 smalldatetime=NULL ,
	@Complete2 smalldatetime =NULL ,
	@DESK1 nvarchar (10)= NULL ,
	@DESK2 nvarchar(10) = NULL 
AS
--
--	inserts data from client file into NBMaster table
--
declare @tdate as smalldatetime
declare @t1 as nvarchar(4)
declare @t2 as nvarchar(2)
declare @t3 as nvarchar(2)
set @tdate = getdate()
set @t1 = datepart(YY,@tdate)
set @t2 = datepart(MM,@tdate)
set @t3 = datepart(DD,@tdate)
if @t2 = '1'  set @t2 = '01'
if @t2 = '2'  set @t2 = '02'
if @t2 = '3'  set @t2 = '03'
if @t2 = '4'  set @t2 = '04'
if @t2 = '5'  set @t2 = '05'
if @t2 = '6'  set @t2 = '06'
if @t2 = '7'  set @t2 = '07'
if @t2 = '8'  set @t2 = '08'
if @t2 = '9'  set @t2 = '09'
if @t3 = '1'  set @t3 = '01'
if @t3 = '2'  set @t3 = '02'
if @t3 = '3'  set @t3 = '03'
if @t3 = '4'  set @t3 = '04'
if @t3 = '5'  set @t3 = '05'
if @t3 = '6'  set @t3 = '06'
if @t3 = '7'  set @t3 = '07'
if @t3 = '8'  set @t3 = '08'
if @t3 = '9'  set @t3 = '09'

set @qdate = @t1 + @t2 + @t3

if @userdate1 = 0 
    begin
        set @userdate1 = null
    end
if @userdate1 = '01/01/1900' 
    begin
        set @userdate1 = null
    end

if @userdate2 = 0 
    begin
        set @userdate2 = null
    end
if @userdate3 = 0 
    begin
        set @userdate3 = null
    end

Begin transaction
Insert NBMaster (number,link, desk, Name, Street1, Street2, City, State, Zipcode, ctl, other, MR,
	account, homephone, workphone, specialnote, received, closed, returned, lastpaid, lastpaidamt, lastinterest, interestrate, worked, userdate1, 
	userdate2, userdate3, contacted, status, customer, SSN, original,
	original1, original2, original3, original4, original5, original6, original7, original8,
	original9, original10,Current0,current1,current2,current3,current4,current5,
	current6,current7,current8,current9,current10,attorney,assignedattorney,
	promamt,promdue,sifpct,queue,qflag,qdate,qlevel,qtime,extracodes,Salary,
	feecode,clidlc,clidlp,seq,Pseq,Branch,Finders, Complete1,Complete2,
	DESK1,DESK2,paid1,paid2,paid3,paid4,paid5,paid6,paid7,paid8,paid9,paid10,paid )

Values(	@number,@link, @desk, @Name, @Street1, @Street2, @City, @State, @Zipcode, @ctl, @other, @MR,
	@account, @homephone, @workphone, @specialnote, @received, @closed, @returned, @lastpaid, @lastpaidamt, @lastinterest, 
	@interestrate, @worked, @userdate1, @userdate2, @userdate3, @contacted, @status, @customer, @SSN, @original,
	@original1, @original2, @original3, @original4, @original5, @original6, @original7, @original8,
	@original9, @original10, @Current0, @current1,@current2,@current3, @current4, @current5,
	@current6, @current7, @current8, @current9, @current10, @attorney, @assignedattorney,
	@promamt, @promdue,@sifpct, @queue, @qflag, @qdate, @qlevel, @qtime, @extracodes, @Salary,
	@feecode, @clidlc, @clidlp, @seq, @Pseq, @Branch, @Finders,  @Complete1, @Complete2,
	@DESK1, @DESK2,@paid1,@paid2,@paid3,@paid4,@paid5,@paid6,@paid7,@paid8,@paid9,@paid10,@paid )

if @@error <> 0 
    begin 
	rollback transaction
	return
    end 
Commit transaction

GO
