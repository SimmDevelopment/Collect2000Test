SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE           procedure [dbo].[AIM_ImportPortfolioAccount] 

	 @number int
	,@customer varchar(7)
	,@desk varchar(10)
	,@portfolioId int
	,@received datetime
	,@account varchar(30)
	,@ssn varchar(15)
	,@name varchar(30)
	,@spouse varchar(30)
	,@street1 varchar(30)
	,@street2 varchar(30)
	,@city varchar(20)
	,@state varchar(3)
	,@zipcode varchar(10)
	,@homephone varchar(30)
	,@workphone varchar(30)
	,@employment varchar(50)
	,@ID1 varchar(40)
	,@ID2 varchar(40)
	,@PRNbal money
 	,@INTbal money
	,@chargeOffDate datetime
	,@chargeOffAmt money
	,@originalCreditor varchar(50)
	,@openDate datetime
	,@delinquentDate datetime
 	,@lastPaidAmt money
	,@lastPaidDate datetime
	,@score int
	,@coDebtorName varchar(30)
	,@coStreet1 varchar(30)
	,@coStreet2 varchar(30)
	,@coCity varchar(20)
	,@coState varchar(3)
	,@coZipcode varchar(10)
	,@coHomephone varchar(30)
	,@coWorkphone varchar(30)
	,@coEmployment varchar(50)
	,@coSpouse varchar(30)
	,@coSSN varchar(15)
	,@attyCode varchar(5)
	,@attyName varchar(30)
	,@attyPhone varchar(20)	
	,@sysmonth int
	,@sysyear int
	,@userdate1 datetime
	,@userdate2 datetime
	,@userdate3 datetime
-- 	
	AS

declare @sysmonth1 int, @sysyear1 int,@qmonth varchar(2),@qday varchar(2)
select @sysmonth1 = currentmonth, @sysyear1 = currentyear from controlfile
declare @currentqTime varchar(4), @currentqdate varchar(8)
select @currentqTime = cast(datepart(hh,getdate()) as char(2))+cast(datepart(mi,getdate()) as char(2))
--select @currentqtime
select @qmonth = case len(cast(month(getdate()) as char(2))) 
		when 1 then '0'+cast(month(getdate()) as char(2)) 
		when 2 then cast(month(getdate()) as char(2)) 
		end

select @qday = case len(cast(day(getdate()) as char(2)))
		when 1 then '0' + cast(day(getdate()) as char(2))
		when 2 then cast(day(getdate()) as char(2))
		end
--select @currentqdate = cast(year(@currentdate) as char(4))+@qmonth+cast(day(@currentdate) as char(2))
select @currentqdate = cast(year(getdate()) as char(4))+@qmonth+@qday


DECLARE @ATTYID INT
SELECT 
	@ATTYID = ATTORNEYID
FROM ATTORNEY
WHERE CODE = @ATTYCODE
--select @attyid
IF (@ATTYID IS NULL and @attycode is not null and @attycode <> '')
	BEGIN

	INSERT INTO
		ATTORNEY
			(
				CODE
				,NAME
				,PHONE
			)
			VALUES
			(
			
			 @ATTYCODE
			,@ATTYNAME
			,@ATTYPHONE
			)
	END 	
		
	





	insert into 
		master
		(
			number
			,desk
			,name	
			,street1
			,street2
			,city
			,state
			,zipcode
			,homephone
			,workphone
			,interestrate
			,ssn
			,originalcreditor
			,delinquencydate
			,original
			,chargeoffdate
			,lastpaidamt
			,clidlp
			,current0
			,current1
			,account
			,id1
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
			,purchasedportfolio
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
			,attorneyID
			,score
			,contractdate
			,userdate1,userdate2,userdate3

		)
		values
		(
			@number
			,@desk 
			,@name
			,@street1
			,@street2
			,@city
			,@state
			,@zipcode
			,@homephone
			,@workphone
			,0
			,@ssn
			,@originalCreditor
			,@delinquentDate
			,isnull(@PRNbal + @INTbal,0)
			,@chargeOffDate
			,isnull(@lastPaidAmt,0)
			,@lastPaidDate
			,isnull(@PRNbal + @INTbal,0)
			,isnull(@PRNbal,0)
			,replace(@account,'''','')
			,@ID1
			,0 -- totalcontacted
			,0 -- total viewed
			,0 -- total worked
			,0 -- seq
			,0 -- pseq
			,1 -- should queue
			,0 -- restricted access
			,@customer
			,@received
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
			,@portfolioId
			,isnull(@INTbal,0)
			,0				
			,0
			,0
			,0
			,0
			,0 
			,0
			,0
			,isnull(@PRNbal,0)
			,isnull(@INTbal,0)
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
			,0
			,0
			,0
			,0
			,0
			,0
			,0
			,@attyCode
			,@score
			,@openDate
			,@userdate1,@userdate2,@userdate3

		)


	
	insert into
		Debtors
		(

			
				number
				,Seq
				,Name
				,Street1
				,Street2
				,City
				,State
				,Zipcode
				,HomePhone
				,WorkPhone
				,SSN
				,JobName
				,Spouse
				,othername
				,mr
				
			)			
			values
			(	
				 @number
				,0
				,@name
				,@street1
				,@street2
				,@city
				,@state
				,@zipcode
				,@homephone
				,@workphone
				,@ssn
				,@employment
				,@spouse
				,'    '
				,'N'
			)




IF (@coDebtorName <> ' ' and ltrim(rtrim(@codebtorname)) <> ',' )
	BEGIN
			
	insert into
		Debtors
		(

				Number
				,Seq
				,Name
				,Street1
				,Street2
				,City
				,State
				,Zipcode
				,HomePhone
				,WorkPhone
				,SSN
				,JobName
				,Spouse
				,othername
				,mr
				
			)			
			values
			(	
				
				@number
				,1
				,@coDebtorName
				,@coStreet1
				,@coStreet2
				,@coCity
				,@coState
				,@coZipcode
				,@coHomephone
				,@coWorkphone
				,@CoSSN
				,@coEmployment
				,@coSpouse
				,'   '
				,'N'
			)

	END




-- Add a placement note
	
	begin
		declare @notelogmessageid int, @filenumber int, @accountNumber varchar(30), @placementdate datetime, @totalamountplaced money
		select
			@notelogmessageid = 2001
			,@filenumber = @number
			,@accountNumber = @account
			,@placementdate = @received
			,@totalamountplaced = isnull(@PRNbal + @INTbal,0)
			
				
		exec AIM_AddAimNote @notelogmessageid, @filenumber, @accountNumber,@placementdate, @totalamountplaced
	end


            











GO
