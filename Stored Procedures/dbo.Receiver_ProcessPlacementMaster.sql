SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Receiver_ProcessPlacementMaster]
(@clientId int,
@file_number int,
@account as varchar(30),
@principle as money,
@interest as money,
@other3 as money,
@other4 as money,
@other5 as money,
@other6 as money,
@other7 as money,
@other8 as money,
@other9 as money,
@last_charge datetime, --clidlc
@last_paid datetime, --lastpaid
@userdate1 datetime,
@userdate2 datetime,
@userdate3 datetime,
@original_creditor varchar(50), 
@last_interest datetime,
@interestrate money,
@customer_division varchar(30),
@customer_district varchar(30),
@customer_branch varchar(30),
@id1 varchar(30),
@id2 varchar(30),
@desk varchar(10), 
@customer varchar(10),
@chargeoffdate datetime,
@delinquencydate datetime,
@last_paid_amount money,
@contractdate datetime,
@clidlp datetime,
@clidlc datetime = null,
@clialp money,
@clialc money,
@received datetime,
@previous_creditor  varchar(50) = null, -- From here to below may not be present certain versions of AIM
@purchaseddate datetime = NULL,
@customer_alphacode varchar(50) = null,
@customer_company varchar(50) = null,
@customer_name varchar(100) = null,
@AIM_InvestorGroupName varchar(50) = null,
@AIM_SellerGroupName varchar(50) = null,
@ItemizationDate datetime=null,
@ItemizationDateType varchar(30)=null,
@ItemizationBalance money=null,
@ItemizationPrincipal money=null,
@ItemizationInterest money=null,
@ItemizationFeesCharges money=null,
@ItemizationPaymentsCredits money=null,
@ItemizationOther money=null
)
AS

declare @accountcount int
set @accountcount = 0
select @accountcount = count(*) from receiver_reference r with (nolock) join master m with (nolock)
		on m.number = r.receivernumber where r.sendernumber = @file_number and r.clientId = @clientId
		and m.qlevel < '999'

if(@accountcount > 0)
BEGIN
		RAISERROR ('This account already exists for this client and has not been returned', 16, 1)
		RETURN
END
declare @sysmonth1 int, @sysyear1 int,@qmonth varchar(2),@qday varchar(2)
select @sysmonth1 = currentmonth, @sysyear1 = currentyear from controlfile
declare @currentqTime varchar(4), @currentqdate varchar(8)
select @currentqTime = cast(datepart(hh,getdate()) as char(2))+cast(datepart(mi,getdate()) as char(2))

select @qmonth = case len(cast(month(getdate()) as char(2))) 
when 1 then '0'+cast(month(getdate()) as char(2)) 
when 2 then cast(month(getdate()) as char(2)) 
end
select @qday = case len(cast(day(getdate()) as char(2)))
when 1 then '0' + cast(day(getdate()) as char(2))
when 2 then cast(day(getdate()) as char(2))
end

select @currentqdate = cast(year(getdate()) as char(4))+@qmonth+@qday
declare @nextdebtor int
exec @nextdebtor = sp_NextAcctID
insert into 
master
(
number
,desk
,interestrate
,originalcreditor
,delinquencydate
,original
,chargeoffdate
,lastpaidamt
,lastpaid
,clidlp
,clidlc
,current0
,current1
,account
,id1
,id2
,totalcontacted
,totalviewed
,totalworked
,seq
,pseq
,shouldqueue
,restrictedaccess
,customer
,received
,status
,qlevel
,qflag
,qtime
,other
,mr
,branch
,qdate
,feecode
,sysmonth
,sysyear
,current2
,current3
,current4
,current5
,current6
,current7
,current8
,current9
,current10
,original1
,original2
,original3
,original4 
,original5
,original6
,original7
,original8
,original9
,original10
,paid 
,paid1
,paid2
,paid3
,paid4
,paid5
,paid6
,paid7
,paid8
,paid9
,paid10
,userdate1
,userdate2
,userdate3
,lastinterest
,contractdate
,clialp
,clialc
,previouscreditor
)
values
(
@nextdebtor
,@desk 
,@interestrate
,@original_creditor
,@delinquencydate
,isnull(@principle + @interest+@other3+@other4+@other5+@other6+@other7+@other8+@other9,0) -- original
,@chargeOffDate
,isnull(@last_paid_amount,0) -- last paid amount
,@last_Paid -- lastpaid
,@clidlp --clidlp
,@last_charge -- clidlc
,isnull(@principle + @interest+@other3+@other4+@other5+@other6+@other7+@other8+@other9,0)
,isnull(@principle,0)
,@account
,@id1 --@ID1
,@id2 -- used later when sending back to client
,0 -- totalcontacted
,0 -- total viewed
,0 -- total worked
,0 -- seq
,0 -- pseq
,1 -- should queue
,0 -- restricted access
,@customer
,@received -- @received
,'NEW'
,'015'
,'1'
,'0000'
,''
,'N'
,'00000'
,@currentqdate
,null
,@sysmonth1
,@sysyear1
,isnull(@interest,0)
,@other3 
,@other4
,@other5
,@other6
,@other7
,@other8 
,@other9
,0
,isnull(@principle,0)
,isnull(@interest,0) -- original2
,@other3
,@other4
,@other5
,@other6
,@other7
,@other8
,@other9
,0
,0
,0
,0
,0
,0
,0
,0
,0
,0
,0
,0
-- ,@attyCode
,@userdate1
,@userdate2
,@userdate3
,@last_interest
,@contractdate
,@clialp
,@clialc
,@previous_creditor -- Added by KAR 03/19/2010
)
 
IF @ItemizationDate IS NOT NULL
BEGIN

/*Update Itemization data */
INSERT INTO [dbo].[ItemizationBalance](AccountID,ItemizationDateType,ItemizationDate,ItemizationBalance0,ItemizationBalance1,ItemizationBalance2,ItemizationBalance3,ItemizationBalance4,ItemizationBalance5) VALUES(@nextdebtor,@ItemizationDateType,@ItemizationDate,@ItemizationBalance,@ItemizationPrincipal,@ItemizationInterest,@ItemizationFeesCharges,@ItemizationPaymentsCredits,@ItemizationOther)
INSERT INTO NOTES(number,created,user0,action,result,comment)
VALUES(@nextdebtor,GETUTCDATE(),'AIM','AIM','AIM','Account received from client has itemization data inserted')
END 
 
INSERT INTO NOTES(number,created,user0,action,result,comment)
VALUES(@nextdebtor,getdate(),'AIM','AIM','AIM','Account received from client')

insert into receiver_reference (sendernumber, receivernumber, clientid) values (@file_number,@nextdebtor, @clientId)

insert into miscextra (number,title,thedata)
values (@nextdebtor,'OriginalAccountNumber',@account)

insert into miscextra (number,title,thedata)
SELECT @nextdebtor,'AIMAlphaCode',rc.alphacode
FROM Receiver_Client rc where ClientId = @clientId

insert into miscextra (number,title,thedata)
SELECT @nextdebtor,'AIMClientAccountID',@file_number

-- New additions KAR 03/26/2010
insert into miscextra (number,title,thedata)
SELECT @nextdebtor,'PurchasedDate',@purchaseddate

insert into miscextra (number,title,thedata)
SELECT @nextdebtor,'CustomerAlphaCode',@customer_alphacode

insert into miscextra (number,title,thedata)
SELECT @nextdebtor,'CustomerAlphaCode',@customer_alphacode

insert into miscextra (number,title,thedata)
SELECT @nextdebtor,'CustomerCompany',@customer_company

insert into miscextra (number,title,thedata)
SELECT @nextdebtor,'CustomerName',@customer_name

insert into miscextra (number,title,thedata)
SELECT @nextdebtor,'AIMInvestorGroupName',@AIM_InvestorGroupName

insert into miscextra (number,title,thedata)
SELECT @nextdebtor,'AIMSellerGroupName',@AIM_SellerGroupName

SELECT @nextdebtor
GO
