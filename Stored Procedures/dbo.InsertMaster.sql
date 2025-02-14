SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[InsertMaster] AS

INSERT INTO [dbo].[master]
           ([number]
           ,[link]
           ,[desk]
           ,[Name]
           ,[Street1]
           ,[Street2]
           ,[City]
           ,[State]
           ,[Zipcode]
           ,[ctl]
           ,[other]
           ,[MR]
           ,[account]
           ,[homephone]
           ,[workphone]
           ,[specialnote]
           ,[received]
           ,[closed]
           ,[returned]
           ,[lastpaid]
           ,[lastpaidamt]
           ,[lastinterest]
           ,[interestrate]
           ,[worked]
           ,[userdate1]
           ,[userdate2]
           ,[userdate3]
           ,[contacted]
           ,[status]
           ,[customer]
           ,[SSN]
           ,[original]
           ,[original1]
           ,[original2]
           ,[original3]
           ,[original4]
           ,[original5]
           ,[original6]
           ,[original7]
           ,[original8]
           ,[original9]
           ,[original10]
           ,[Accrued2]
           ,[Accrued10]
           ,[paid]
           ,[paid1]
           ,[paid2]
           ,[paid3]
           ,[paid4]
           ,[paid5]
           ,[paid6]
           ,[paid7]
           ,[paid8]
           ,[paid9]
           ,[paid10]
           ,[current0]
           ,[current1]
           ,[current2]
           ,[current3]
           ,[current4]
           ,[current5]
           ,[current6]
           ,[current7]
           ,[current8]
           ,[current9]
           ,[current10]
           ,[attorney]
           ,[assignedattorney]
           ,[promamt]
           ,[promdue]
           ,[sifpct]
           ,[queue]
           ,[qflag]
           ,[qdate]
           ,[qlevel]
           ,[qtime]
           ,[extracodes]
           ,[Salary]
           ,[feecode]
           ,[clidlc]
           ,[clidlp]
           ,[seq]
           ,[Pseq]
           ,[Branch]
           ,[Finders]
           ,[COMPLETE1]
           ,[Complete2]
           ,[DESK1]
           ,[DESK2]
           ,[Full0]
           ,[TotalViewed]
           ,[TotalWorked]
           ,[TotalContacted]
           ,[nsf]
           ,[HasBigNote]
           ,[FirstDesk]
           ,[FirstReceived]
           ,[AgencyFlag]
           ,[AgencyCode]
           ,[FeeSchedule]
           ,[CustDivision]
           ,[CustDistrict]
           ,[CustBranch]
           ,[Delinquencydate]
           ,[CurrencyType]
           ,[DOB]
           ,[sysmonth]
           ,[SysYear]
           ,[DMDateStamp]
           ,[id1]
           ,[id2]
           ,[PurchasedPortfolio]
           ,[SoldPortfolio]
           ,[OriginalCreditor]
           ,[AttorneyID]
           ,[BPDate]
           ,[NSFDate]
           ,[ContractDate]
           ,[ChargeOffDate]
           ,[ShouldQueue]
           ,[RestrictedAccess]
           ,[LinkDriver]
           ,[Score]
           ,[Salesman1ID]
           ,[Salesman2ID]
           ,[Salesman3ID]
           ,[AIMAgency]
           ,[AIMAssigned]
           ,[cbrPrevent]
           ,[cbrException]
           ,[cbrExtendDays]
           ,[clialp]
           ,[clialc]
           ,[cbrOverride]
           ,[viewed]
           ,[QueueHold]
           ,[Secured]
           ,[PreviousCreditor]
           ,[StatuteDate]
           ,[AttorneyLawList]
           ,[AttorneyStatus]
           ,[ClassOfBusiness]
           ,[ClaimType]
           ,[AttorneyAccountID]
           ,[InterestBuckets]
           ,[BlanketSIFOverride]
           ,[Archived]
           ,[PreventLinking]
           ,[IsInterestDeferred]
           ,[DeferredInterest]
           ,[SettlementID])
     SELECT
           [number]
           ,[link]
           ,[desk]
           ,[Name]
           ,[Street1]
           ,[Street2]
           ,[City]
           ,[State]
           ,[Zipcode]
           ,[ctl]
           ,[other]
           ,[MR]
           ,[account]
           ,[homephone]
           ,[workphone]
           ,[specialnote]
           ,[received]
           ,[closed]
           ,[returned]
           ,[lastpaid]
           ,[lastpaidamt]
           ,[lastinterest]
           ,[interestrate]
           ,[worked]
           ,[userdate1]
           ,[userdate2]
           ,[userdate3]
           ,[contacted]
           ,[status]
           ,[customer]
           ,[SSN]
           ,[original]
           ,[original1]
           ,[original2]
           ,[original3]
           ,[original4]
           ,[original5]
           ,[original6]
           ,[original7]
           ,[original8]
           ,[original9]
           ,[original10]
           ,[Accrued2]
           ,[Accrued10]
           ,[paid]
           ,[paid1]
           ,[paid2]
           ,[paid3]
           ,[paid4]
           ,[paid5]
           ,[paid6]
           ,[paid7]
           ,[paid8]
           ,[paid9]
           ,[paid10]
           ,[current0]
           ,[current1]
           ,[current2]
           ,[current3]
           ,[current4]
           ,[current5]
           ,[current6]
           ,[current7]
           ,[current8]
           ,[current9]
           ,[current10]
           ,[attorney]
           ,[assignedattorney]
           ,[promamt]
           ,[promdue]
           ,[sifpct]
           ,[queue]
           ,[qflag]
           ,[qdate]
           ,[qlevel]
           ,[qtime]
           ,[extracodes]
           ,[Salary]
           ,[feecode]
           ,[clidlc]
           ,[clidlp]
           ,[seq]
           ,[Pseq]
           ,[Branch]
           ,[Finders]
           ,[COMPLETE1]
           ,[Complete2]
           ,[DESK1]
           ,[DESK2]
           ,[Full0]
           ,[TotalViewed]
           ,[TotalWorked]
           ,[TotalContacted]
           ,[nsf]
           ,[HasBigNote]
           ,[FirstDesk]
           ,[FirstReceived]
           ,[AgencyFlag]
           ,[AgencyCode]
           ,[FeeSchedule]
           ,[CustDivision]
           ,[CustDistrict]
           ,[CustBranch]
           ,[Delinquencydate]
           ,[CurrencyType]
           ,[DOB]
           ,[sysmonth]
           ,[SysYear]
           ,[DMDateStamp]
           ,[id1]
           ,[id2]
           ,[PurchasedPortfolio]
           ,[SoldPortfolio]
           ,[OriginalCreditor]
           ,[AttorneyID]
           ,[BPDate]
           ,[NSFDate]
           ,[ContractDate]
           ,[ChargeOffDate]
           ,[ShouldQueue]
           ,[RestrictedAccess]
           ,[LinkDriver]
           ,[Score]
           ,[Salesman1ID]
           ,[Salesman2ID]
           ,[Salesman3ID]
           ,[AIMAgency]
           ,[AIMAssigned]
           ,[cbrPrevent]
           ,[cbrException]
           ,[cbrExtendDays]
           ,[clialp]
           ,[clialc]
           ,[cbrOverride]
           ,[viewed]
           ,[QueueHold]
           ,[Secured]
           ,[PreviousCreditor]
           ,[StatuteDate]
           ,[AttorneyLawList]
           ,[AttorneyStatus]
           ,[ClassOfBusiness]
           ,[ClaimType]
           ,[AttorneyAccountID]
           ,[InterestBuckets]
           ,[BlanketSIFOverride]
           ,[Archived]
           ,[PreventLinking]
           ,[IsInterestDeferred]
           ,[DeferredInterest]
           ,[SettlementID] from dbo.NewBizBMaster

GO
