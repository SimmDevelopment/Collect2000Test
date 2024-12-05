SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[AIM_SellerAccountExport]

  @portfolioID varchar(30)
  ,@mask bit
   AS
  SELECT
   
  m.number
  ,id1 =
  case -- is mask?
   when @mask = 1 then left(m.id1,12)+'XXXX'
   when @mask = 0 then m.id1 
  end
  ,ssn = 
  case -- is mask?
   when @mask = 1 then left(m.ssn,5)+'XXXX' 
   when @mask = 0 then m.ssn 
  end
  ,m.id2
  ,m.account
  ,m.name
  ,ssn = 
  case -- is mask?
   when @mask = 1 then left(m.ssn,5)+'XXXX' 
   when @mask = 0 then m.ssn
   
  end
  ,d0.spouse
  ,m.street1
  ,m.street2
  ,m.city
  ,m.state
  ,m.zipcode
  ,m.homephone
  ,m.workphone
  ,d0.jobName
  ,m.originalCreditor
  ,m.current1
  ,m.current2
   ,m.current3 
  ,m.current4 
  ,m.current5
  ,m.current6
  ,m.current7
  ,m.current8
  ,m.current9
  ,m.contractDate     -- a.OpenDate
  ,m.delinquencyDate          -- a.DelinquentDate
  ,m.chargeOffDate  -- a.ChargeOffDate
  ,m.original                       -- a.ChargeOffAmt
  ,m.clidlp 
  ,m.lastpaid   -- a.OriginalLastPaidDate
  ,m.lastPaidAmt   --  Is this original? a.OriginalLastPaidAmt
  ,d1.name as co_name
  ,co_ssn = 
  case --is mask ?
   when @mask = 1 then left(d1.ssn,5)+'XXXX' 
   when @mask = 0 then d1.ssn
  end
  ,d1.spouse as co_spouse
  ,d1.street1 as co_street1
  ,d1.street2 as co_street2
  ,d1.city as co_city
  ,d1.state as co_state
  ,d1.zipcode as co_zipcode
  ,d1.homephone as co_homephone
  ,d1.workphone as co_workphone
  ,d1.JobName as co_jobName
  ,da.name as atty_name
  ,da.phone as atty_phone
  ,da.addr1 as atty_street1
  ,da.addr2 as atty_street2
  ,da.city as atty_city
  ,da.state as atty_state
  ,da.zipcode as atty_zipcode
  ,b.chapter as bkp_chapter
  ,b.dateFiled as bkp_dateFiled
  ,b.caseNumber as bkp_caseNumber
  ,b.status as bkp_status

 FROM master m
 JOIN Debtors d0 ON m.number = d0.number AND d0.seq = 0
 Left Outer JOIN Bankruptcy b ON m.number = b.accountID
 Left Outer JOIN DebtorAttorneys da on m.number = da.accountID
 Left Outer JOIN Debtors d1 on m.number = d1.number AND d1.seq = 1
 
 WHERE m.soldPortfolio = @portfolioID
 

GO
