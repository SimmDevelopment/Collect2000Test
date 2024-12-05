SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Account_GetLinkedAccounts] @Link INTEGER
AS
SET NOCOUNT ON;
DECLARE @Accounts TABLE (
	[ID] INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	[AccountID] INTEGER NOT NULL
);
CREATE TABLE #ResultMasterNotePatient  (
	[ID] INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	[number] [int] NOT NULL,
	[link] [int] NULL,
	[desk] [varchar](10) NOT NULL,
	[Name] [varchar](30) NULL,
	[Street1] [varchar](30) NULL,
	[Street2] [varchar](30) NULL,
	[City] [varchar](30) NULL,
	[State] [varchar](3) NULL,
	[Zipcode] [varchar](10) NULL,
	[ctl] [varchar](3) NULL,
	[other] [varchar](30) NULL,
	[MR] [varchar](1) NULL,
	[account] [varchar](30) NULL,
	[homephone] [varchar](30) NULL,
	[workphone] [varchar](30) NULL,
	[specialnote] [varchar](75) NULL,
	[received] [datetime] NULL,
	[closed] [datetime] NULL,
	[returned] [datetime] NULL,
	[lastpaid] [datetime] NULL,
	[lastpaidamt] [money] NULL,
	[lastinterest] [datetime] NULL,
	[interestrate] [money] NULL,
	[worked] [datetime] NULL,
	[userdate1] [datetime] NULL,
	[userdate2] [datetime] NULL,
	[userdate3] [datetime] NULL,
	[contacted] [datetime] NULL,
	[status] [varchar](5) NULL,
	[customer] [varchar](7) NULL,
	[SSN] [varchar](15) NULL,
	[original] [money] NOT NULL,
	[original1] [money] NOT NULL,
	[original2] [money] NOT NULL,
	[original3] [money] NOT NULL,
	[original4] [money] NOT NULL,
	[original5] [money] NOT NULL,
	[original6] [money] NOT NULL,
	[original7] [money] NOT NULL,
	[original8] [money] NOT NULL,
	[original9] [money] NOT NULL,
	[original10] [money] NOT NULL,
	[Accrued2] [money] NOT NULL,
	[Accrued10] [money] NOT NULL,
	[paid] [money] NOT NULL,
	[paid1] [money] NOT NULL,
	[paid2] [money] NOT NULL,
	[paid3] [money] NOT NULL,
	[paid4] [money] NOT NULL,
	[paid5] [money] NOT NULL,
	[paid6] [money] NOT NULL,
	[paid7] [money] NOT NULL,
	[paid8] [money] NOT NULL,
	[paid9] [money] NOT NULL,
	[paid10] [money] NOT NULL,
	[current0] [money] NOT NULL,
	[current1] [money] NOT NULL,
	[current2] [money] NOT NULL,
	[current3] [money] NOT NULL,
	[current4] [money] NOT NULL,
	[current5] [money] NOT NULL,
	[current6] [money] NOT NULL,
	[current7] [money] NOT NULL,
	[current8] [money] NOT NULL,
	[current9] [money] NOT NULL,
	[current10] [money] NOT NULL,
	[attorney] [varchar](5) NULL,
	[assignedattorney] [datetime] NULL,
	[promamt] [money] NULL,
	[promdue] [datetime] NULL,
	[sifpct] [money] NULL,
	[queue] [varchar](26) NULL,
	[qflag] [varchar](1) NULL,
	[qdate] [varchar](8) NULL,
	[qlevel] [varchar](3) NULL,
	[qtime] [varchar](4) NULL,
	[extracodes] [varchar](40) NULL,
	[Salary] [money] NULL,
	[feecode] [varchar](30) NULL,
	[clidlc] [datetime] NULL,
	[clidlp] [datetime] NULL,
	[seq] [int] NULL,
	[Pseq] [int] NOT NULL,
	[Branch] [varchar](5) NOT NULL,
	[Finders] [datetime] NULL,
	[COMPLETE1] [datetime] NULL,
	[Complete2] [datetime] NULL,
	[DESK1] [varchar](10) NULL,
	[DESK2] [varchar](10) NULL,
	[Full0] [datetime] NULL,
	[TotalViewed] [int] NOT NULL,
	[TotalWorked] [int] NOT NULL,
	[TotalContacted] [int] NOT NULL,
	[nsf] [varchar](1) NULL,
	[HasBigNote] [varchar](1) NULL,
	[FirstDesk] [varchar](10) NULL,
	[FirstReceived] [datetime] NULL,
	[AgencyFlag] [tinyint] NULL,
	[AgencyCode] [varchar](5) NULL,
	[FeeSchedule] [varchar](5) NULL,
	[CustDivision] [varchar](15) NULL,
	[CustDistrict] [varchar](15) NULL,
	[CustBranch] [varchar](15) NULL,
	[Delinquencydate] [datetime] NULL,
	[CurrencyType] [varchar](20) NULL,
	[DOB] [datetime] NULL,
	[sysmonth] [tinyint] NULL,
	[SysYear] [smallint] NULL,
	[DMDateStamp] [varchar](10) NULL,
	[id1] [varchar](40) NULL,
	[id2] [varchar](40) NULL,
	[PurchasedPortfolio] [varchar](7) NULL,
	[SoldPortfolio] [varchar](7) NULL,
	[OriginalCreditor] [varchar](50) NULL,
	[AttorneyID] [int] NULL,
	[BPDate] [datetime] NULL,
	[NSFDate] [datetime] NULL,
	[ContractDate] [datetime] NULL,
	[ChargeOffDate] [datetime] NULL,
	[ShouldQueue] [bit] NOT NULL,
	[RestrictedAccess] [bit] NOT NULL,
	[LinkDriver] [bit] NOT NULL,
	[Score] [smallint] NULL,
	[Salesman1ID] [int] NOT NULL,
	[Salesman2ID] [int] NOT NULL,
	[Salesman3ID] [int] NOT NULL,
	[AIMAgency] [int] NULL,
	[AIMAssigned] [datetime] NULL,
	[cbrPrevent] [bit] NOT NULL,
	[cbrException] [smallint] NOT NULL,
	[cbrExtendDays] [int] NULL,
	[clialp] [money] NULL,
	[clialc] [money] NULL,
	[cbrOverride] [bit] NOT NULL,
	[viewed] [datetime] NULL,
	[QueueHold] [datetime] NULL,
	[Secured] [bit] NOT NULL,
	[PreviousCreditor] [varchar](50) NULL,
	[StatuteDate] [datetime] NULL,
	[AttorneyLawList] [varchar](5) NULL,
	[AttorneyStatus] [varchar](15) NULL,
	[ClassOfBusiness] [varchar](5) NULL,
	[ClaimType] [varchar](5) NULL,
	[AttorneyAccountID] [varchar](30) NULL,
	[InterestBuckets] [smallint] NULL,
	[BlanketSIFOverride] [float] NULL,
	[Archived] [datetime] NULL,
	[PreventLinking] [bit] NOT NULL,
	[IsInterestDeferred] [bit] NOT NULL,
	[DeferredInterest] [money] NULL,
	[SettlementID] [int] NULL,
	[PersonalReceivership_Amortization] [bit] NULL,
	[ExchangeBatchID] [int] NULL,
	[ChargedOff] [bit] NULL,
	[cbrException32] [int] NOT NULL,
	[HotNote] [Text] NULL,
	[ServiceDate] [Datetime] NULL
);
DECLARE @AccountID INTEGER;
DECLARE @Index INTEGER;
DECLARE @Records INTEGER;



INSERT INTO #ResultMasterNotePatient(
 [master].[number]
,[master].[link]
,[master].[desk]
,[master].[Name]
,[master].[Street1]
,[master].[Street2]
,[master].[City]
,[master].[State]
,[master].[Zipcode]
,[master].[ctl]
,[master].[other]
,[master].[MR]
,[master].[account]
,[master].[homephone]
,[master].[workphone]
,[master].[specialnote]
,[master].[received]
,[master].[closed]
,[master].[returned]
,[master].[lastpaid]
,[master].[lastpaidamt]
,[master].[lastinterest]
,[master].[interestrate]
,[master].[worked]
,[master].[userdate1]
,[master].[userdate2]
,[master].[userdate3]
,[master].[contacted]
,[master].[status]
,[master].[customer]
,[master].[SSN]
,[master].[original]
,[master].[original1]
,[master].[original2]
,[master].[original3]
,[master].[original4]
,[master].[original5]
,[master].[original6]
,[master].[original7]
,[master].[original8]
,[master].[original9]
,[master].[original10]
,[master].[Accrued2]
,[master].[Accrued10]
,[master].[paid]
,[master].[paid1]
,[master].[paid2]
,[master].[paid3]
,[master].[paid4]
,[master].[paid5]
,[master].[paid6]
,[master].[paid7]
,[master].[paid8]
,[master].[paid9]
,[master].[paid10]
,[master].[current0]
,[master].[current1]
,[master].[current2]
,[master].[current3]
,[master].[current4]
,[master].[current5]
,[master].[current6]
,[master].[current7]
,[master].[current8]
,[master].[current9]
,[master].[current10]
,[master].[attorney]
,[master].[assignedattorney]
,[master].[promamt]
,[master].[promdue]
,[master].[sifpct]
,[master].[queue]
,[master].[qflag]
,[master].[qdate]
,[master].[qlevel]
,[master].[qtime]
,[master].[extracodes]
,[master].[Salary]
,[master].[feecode]
,[master].[clidlc]
,[master].[clidlp]
,[master].[seq]
,[master].[Pseq]
,[master].[Branch]
,[master].[Finders]
,[master].[COMPLETE1]
,[master].[Complete2]
,[master].[DESK1]
,[master].[DESK2]
,[master].[Full0]
,[master].[TotalViewed]
,[master].[TotalWorked]
,[master].[TotalContacted]
,[master].[nsf]
,[master].[HasBigNote]
,[master].[FirstDesk]
,[master].[FirstReceived]
,[master].[AgencyFlag]
,[master].[AgencyCode]
,[master].[FeeSchedule]
,[master].[CustDivision]
,[master].[CustDistrict]
,[master].[CustBranch]
,[master].[Delinquencydate]
,[master].[CurrencyType]
,[master].[DOB]
,[master].[sysmonth]
,[master].[SysYear]
,[master].[DMDateStamp]
,[master].[id1]
,[master].[id2]
,[master].[PurchasedPortfolio]
,[master].[SoldPortfolio]
,[master].[OriginalCreditor]
,[master].[AttorneyID]
,[master].[BPDate]
,[master].[NSFDate]
,[master].[ContractDate]
,[master].[ChargeOffDate]
,[master].[ShouldQueue]
,[master].[RestrictedAccess]
,[master].[LinkDriver]
,[master].[Score]
,[master].[Salesman1ID]
,[master].[Salesman2ID]
,[master].[Salesman3ID]
,[master].[AIMAgency]
,[master].[AIMAssigned]
,[master].[cbrPrevent]
,[master].[cbrException]
,[master].[cbrExtendDays]
,[master].[clialp]
,[master].[clialc]
,[master].[cbrOverride]
,[master].[viewed]
,[master].[QueueHold]
,[master].[Secured]
,[master].[PreviousCreditor]
,[master].[StatuteDate]
,[master].[AttorneyLawList]
,[master].[AttorneyStatus]
,[master].[ClassOfBusiness]
,[master].[ClaimType]
,[master].[AttorneyAccountID]
,[master].[InterestBuckets]
,[master].[BlanketSIFOverride]
,[master].[Archived]
,[master].[PreventLinking]
,[master].[IsInterestDeferred]
,[master].[DeferredInterest]
,[master].[SettlementID]
,[master].[PersonalReceivership_Amortization]
,[master].[ExchangeBatchID]
,[master].[ChargedOff]
,[master].[cbrException32]
,[HotNotes].[HotNote] -- from hot notes
,[PatientInfo].[ServiceDate]) --from patientInfo
SELECT [master].[number]
,[master].[link]
,[master].[desk]
,[master].[Name]
,[master].[Street1]
,[master].[Street2]
,[master].[City]
,[master].[State]
,[master].[Zipcode]
,[master].[ctl]
,[master].[other]
,[master].[MR]
,[master].[account]
,[master].[homephone]
,[master].[workphone]
,[master].[specialnote]
,[master].[received]
,[master].[closed]
,[master].[returned]
,[master].[lastpaid]
,[master].[lastpaidamt]
,[master].[lastinterest]
,[master].[interestrate]
,[master].[worked]
,[master].[userdate1]
,[master].[userdate2]
,[master].[userdate3]
,[master].[contacted]
,[master].[status]
,[master].[customer]
,[master].[SSN]
,[master].[original]
,[master].[original1]
,[master].[original2]
,[master].[original3]
,[master].[original4]
,[master].[original5]
,[master].[original6]
,[master].[original7]
,[master].[original8]
,[master].[original9]
,[master].[original10]
,[master].[Accrued2]
,[master].[Accrued10]
,[master].[paid]
,[master].[paid1]
,[master].[paid2]
,[master].[paid3]
,[master].[paid4]
,[master].[paid5]
,[master].[paid6]
,[master].[paid7]
,[master].[paid8]
,[master].[paid9]
,[master].[paid10]
,[master].[current0]
,[master].[current1]
,[master].[current2]
,[master].[current3]
,[master].[current4]
,[master].[current5]
,[master].[current6]
,[master].[current7]
,[master].[current8]
,[master].[current9]
,[master].[current10]
,[master].[attorney]
,[master].[assignedattorney]
,[master].[promamt]
,[master].[promdue]
,[master].[sifpct]
,[master].[queue]
,[master].[qflag]
,[master].[qdate]
,[master].[qlevel]
,[master].[qtime]
,[master].[extracodes]
,[master].[Salary]
,[master].[feecode]
,[master].[clidlc]
,[master].[clidlp]
,[master].[seq]
,[master].[Pseq]
,[master].[Branch]
,[master].[Finders]
,[master].[COMPLETE1]
,[master].[Complete2]
,[master].[DESK1]
,[master].[DESK2]
,[master].[Full0]
,[master].[TotalViewed]
,[master].[TotalWorked]
,[master].[TotalContacted]
,[master].[nsf]
,[master].[HasBigNote]
,[master].[FirstDesk]
,[master].[FirstReceived]
,[master].[AgencyFlag]
,[master].[AgencyCode]
,[master].[FeeSchedule]
,[master].[CustDivision]
,[master].[CustDistrict]
,[master].[CustBranch]
,[master].[Delinquencydate]
,[master].[CurrencyType]
,[master].[DOB]
,[master].[sysmonth]
,[master].[SysYear]
,[master].[DMDateStamp]
,[master].[id1]
,[master].[id2]
,[master].[PurchasedPortfolio]
,[master].[SoldPortfolio]
,[master].[OriginalCreditor]
,[master].[AttorneyID]
,[master].[BPDate]
,[master].[NSFDate]
,[master].[ContractDate]
,[master].[ChargeOffDate]
,[master].[ShouldQueue]
,[master].[RestrictedAccess]
,[master].[LinkDriver]
,[master].[Score]
,[master].[Salesman1ID]
,[master].[Salesman2ID]
,[master].[Salesman3ID]
,[master].[AIMAgency]
,[master].[AIMAssigned]
,[master].[cbrPrevent]
,[master].[cbrException]
,[master].[cbrExtendDays]
,[master].[clialp]
,[master].[clialc]
,[master].[cbrOverride]
,[master].[viewed]
,[master].[QueueHold]
,[master].[Secured]
,[master].[PreviousCreditor]
,[master].[StatuteDate]
,[master].[AttorneyLawList]
,[master].[AttorneyStatus]
,[master].[ClassOfBusiness]
,[master].[ClaimType]
,[master].[AttorneyAccountID]
,[master].[InterestBuckets]
,[master].[BlanketSIFOverride]
,[master].[Archived]
,[master].[PreventLinking]
,[master].[IsInterestDeferred]
,[master].[DeferredInterest]
,[master].[SettlementID]
,[master].[PersonalReceivership_Amortization]
,[master].[ExchangeBatchID]
,[master].[ChargedOff]
,[master].[cbrException32]
,[HotNotes].[HotNote] AS [HotNote],
	[PatientInfo].[ServiceDate] AS [ServiceDate]
	FROM [dbo].[master] WITH (NOLOCK)
LEFT OUTER JOIN [dbo].[HotNotes] WITH (NOLOCK)
ON [master].[number] = [HotNotes].[number]
LEFT OUTER JOIN [dbo].[PatientInfo] AS [PatientInfo]
ON [master].[number] = [PatientInfo].[AccountID]
WHERE [master].link = @Link
ORDER BY [LinkDriver] ASC
; 

SELECT @Records=@@ROWCOUNT 

WHILE @Records>0
BEGIN

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
	,[SettlementID]
	,[PersonalReceivership_Amortization]
	,[ExchangeBatchID]
	,[ChargedOff]
	,[cbrException32]
	,[HotNote] 
	,[ServiceDate]
FROM #ResultMasterNotePatient as RMN
WHERE ID=@Records;
	SET @Records=@Records-1;
END;

DROP TABLE #ResultMasterNotePatient
RETURN 0;
GO
