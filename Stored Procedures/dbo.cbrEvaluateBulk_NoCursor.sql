SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[cbrEvaluateBulk_NoCursor]
    @accountid INT = NULL,
    @initializationrun CHAR(1) = 'N',
    @initialdeletesonly CHAR(1) = 'Y',
    @ReEvaluate bit = 1
    AS 
    BEGIN

	--
	--@AccountID = Null				- evaluate all configured accounts for reporting to Credit Bureau
	--@AccountID = Master.Number	- evaluate specific account
	--@Initialization = 'I'			- force previously unreported 'DA' and '62' evaluated accounts to report
	--@InitialDeletesOnly = 'Y'		- when Initialization parameter is specified this additional condition
	--								  will prevent '62's from being generated
	--@ReEvaluate					- Used for initial execution after install to pick up all cycle updates and reeveluate based on new rules
	--Default Behavior				- delete previously reported 'DA' and '62' statused accounts from pending cbr_accounts							
	
        SET nocount ON ; 

		declare @ExportExists int;

		select @ExportExists = IntValue1 from GlobalSettings
		where NameSpace = 'Credit Reporting' and SettingName = 'Defer CBR Export Post Processing'

		if @ExportExists is not null
		begin
			RAISERROR ('Cannot run [cbrEvaluateBulk_NoCursor] because an export exists that has not been fully processed.  Please run cbrPostHistoryDeferCleanup to finish processing the prior Export.', 16, 1) WITH LOG	
		end
		
		
		IF NOT OBJECT_ID('tempcbrAccountRestricted') IS NULL DROP TABLE tempcbrAccountRestricted
		
		/* Assuming that if an account record exists in ValidationNotice table and that accoutn has ValidationPeriodCompleted=0 then we need to block the cbr for all those accounts */
		SELECT DISTINCT a.number INTO tempcbrAccountRestricted FROM validationNotice AS VN
		RIGHT JOIN master a ON a.number = VN.AccountID
		INNER JOIN AppliedPermissions ap ON ap.ClassCode = a.ClassOfBusiness OR ap.CustomerCode = a.customer OR ap.CustomGroupID IN (SELECT CustomGroupID FROM Customer WHERE customer = ap.CustomerCode) OR 
		(ap.CustomGroupID IS NULL AND ap.CustomerCode IS NULL AND ap.ClassCode IS NULL)
		INNER JOIN Permissions p ON p.ID = ap.PermissionID
		LEFT OUTER JOIN cbr_metro2_accounts cbr (NOLOCK) ON cbr.accountID = a.Number
		WHERE p.ModuleName = 'Compliance\Validation Notice' AND p.PermissionName = 'Prevent Credit Bureau Reporting'
		AND ap.Configured = 1 AND (VN.ValidationPeriodCompleted = 0 OR VN.ValidationPeriodCompleted IS NULL) AND a.number IN
		(SELECT DISTINCT a.number FROM validationNotice AS VN
		RIGHT JOIN master a ON a.number = VN.AccountID
		INNER JOIN AppliedPermissions ap ON ap.ClassCode = a.ClassOfBusiness OR ap.CustomerCode = a.customer OR ap.CustomGroupID IN (SELECT CustomGroupID FROM Customer WHERE customer = ap.CustomerCode) OR 
		(ap.CustomGroupID IS NULL AND ap.CustomerCode IS NULL AND ap.ClassCode IS NULL)
		INNER JOIN Permissions p ON p.ID = ap.PermissionID
		LEFT OUTER JOIN cbr_metro2_accounts cbr (NOLOCK) ON cbr.accountID = a.Number
		WHERE p.ModuleName = 'Compliance\Validation Notice' AND p.PermissionName = 'Validation Notice Tracking'
		AND ap.Configured = 1 AND (VN.ValidationPeriodCompleted = 0 OR VN.ValidationPeriodCompleted IS NULL))
		AND (a.number = @accountid OR @accountid IS NULL)
		--check to see if the account was reported or not before (Luke Searcy 2022-04-04)
        AND cbr.accountID IS NULL

		/* Not restricting those accounts that are already reported */
		DELETE FROM tempcbrAccountRestricted 
		FROM cbr_accounts AS CA INNER JOIN tempcbrAccountRestricted AS TAR ON CA.accountID=TAR.number
		WHERE CA.lastReported IS NOT NULL;

		/* If activated at account level and that account belongs to restricted queue then quit the process*/
		IF EXISTS(SELECT number from tempcbrAccountRestricted where number in (@accountid))
		BEGIN
			RAISERROR ('Cannot run [cbrEvaluateBulk_NoCursor] because this account is restricted', 16, 1) WITH LOG
			Return 0;
		END
		

		if @accountid is null
			BEGIN
				if not object_id('tempcbrAccountHistory') is null drop table tempcbrAccountHistory

				if not object_id('tempcbrDebtorHistory') is null drop table tempcbrDebtorHistory
				
				if not object_id('tempcbrAccountHistorykeys') is null drop table tempcbrAccountHistorykeys

				--populate tempcbrAccountHistory
				select * into dbo.tempcbrAccountHistory
				from cbrAccountHistory(null)

				--populate tempcbrDebtorHistory
				select * into dbo.tempcbrDebtorHistory
				from cbrDebtorHistory(null)

				--populate tempcbrAccountHistorykeys
				select Accountid, fileid into dbo.tempcbrAccountHistorykeys
				from cbrAccountHistory(null)
				group by accountid, fileid

				CREATE CLUSTERED INDEX [IX_tempCBRAccountHistory] ON [dbo].[tempCBRAccountHistory]
				(
					[AccountId] ASC, 
					[FileId] ASC)
				WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

				CREATE CLUSTERED INDEX [IX_tempCBRDebtorHistory] ON [dbo].[tempCBRDebtorHistory]
				(
					[RecordId] ASC, 
					[DebtorId] ASC)
				WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

				CREATE NONCLUSTERED INDEX [IX_tempcbrDebtorHistory_AccountID] ON [dbo].[tempcbrDebtorHistory]
				(
					[accountID] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

				CREATE NONCLUSTERED INDEX [IX_tempcbrAccountHistorykeys_AccountId] ON [dbo].[tempcbrAccountHistorykeys]
				(
					[Accountid] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


			END
		ELSE
			BEGIN
			
				delete from tempcbrAccountHistory where accountID = @accountID
				delete from tempcbrDebtorHistory where accountID = @accountID
				delete from tempcbrAccountHistorykeys where accountID = @accountID
				
				insert into tempcbrAccountHistory ([recordID],[fileID],[dateReported],[accountID],[customerID],[primaryDebtorID],[portfolioType],[accountType],[accountStatus],[originalLoan],[actualPayment],[currentBalance],[amountPastDue],[termsDuration],[specialComment],[openDate],[billingDate],[delinquencyDate],[closedDate],[lastPaymentDate],[originalCreditor],[creditorClassification],[ConsumerAccountNumber],[ChargeOffAmount],[PaymentHistoryProfile],[PaymentHistoryDate],[CreditLimit],[SecondaryAgencyIdenitifier],[SecondaryAccountNumber],[MortgageIdentificationNumber],[PortfolioIndicator],[SoldToPurchasedFrom],[complianceCondition],[PendingComplianceCondition])
				select [recordID],[fileID],[dateReported],[accountID],[customerID],[primaryDebtorID],[portfolioType],[accountType],[accountStatus],[originalLoan],[actualPayment],[currentBalance],[amountPastDue],[termsDuration],[specialComment],[openDate],[billingDate],[delinquencyDate],[closedDate],[lastPaymentDate],[originalCreditor],[creditorClassification],[ConsumerAccountNumber],[ChargeOffAmount],[PaymentHistoryProfile],[PaymentHistoryDate],[CreditLimit],[SecondaryAgencyIdenitifier],[SecondaryAccountNumber],[MortgageIdentificationNumber],[PortfolioIndicator],[SoldToPurchasedFrom],[complianceCondition],[PendingComplianceCondition]
				from cbrAccountHistory(@accountID)
				
				insert into tempcbrDebtorHistory ([id],[recordID],[dateReported],[debtorID],[debtorSeq],[accountID],[transactionType],[name],[surname],[firstName],[middleName],[suffix],[generationCode],[ssn],[dob],[phone],[ecoaCode],[informationIndicator],[countryCode],[address1],[address2],[city],[state],[zipcode],[addressIndicator],[residenceCode])
				select [id],[recordID],[dateReported],[debtorID],[debtorSeq],[accountID],[transactionType],[name],[surname],[firstName],[middleName],[suffix],[generationCode],[ssn],[dob],[phone],[ecoaCode],[informationIndicator],[countryCode],[address1],[address2],[city],[state],[zipcode],[addressIndicator],[residenceCode]
				from cbrDebtorHistory(@accountID)
				
				insert into tempcbrAccountHistorykeys ([Accountid],[fileid])
				select Accountid, fileid 
				from cbrAccountHistory(@accountID)
				group by accountid, fileid
				
			END
		
		DECLARE @is1stparty BIT;
		SET @is1stparty = (SELECT TOP (1) CAST(CASE WHEN ENABLED=1 AND IndustryCode <> 'DEBTCOLL' THEN 'TRUE' ELSE 'FALSE' END AS BIT) AS is1stparty FROM cbr_config);

		DECLARE @CurrentPaymentHistoryDate DATETIME;
		SELECT @CurrentPaymentHistoryDate = DATEADD(d,-1,CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR(2)),2) + '01' AS DATETIME));

		DECLARE @Context_Info VARBINARY(30);
		SET @Context_Info = cast('cbrevaluatebulk' AS VARBINARY(30));
		SET CONTEXT_INFO @Context_Info;

		--Internal Testing of Future Open Date
		DECLARE @TestOpenDate Datetime;
		SELECT @TestOpenDate = dbo.cbr2017EffectiveDate()

		DECLARE @SoftwareVersion VARCHAR(5);
        DECLARE @action CHAR(6);
        DECLARE @ccustomer VARCHAR(7);
        DECLARE @rowcount INT;
		DECLARE @TEXT_DELETE_FROM_BUREAUS [varchar](75);
        DECLARE @debtorid INT;
        DECLARE @portfolioid INT;
		
		SELECT @SoftwareVersion = softwareversion FROM dbo.controlfile;

		-- if this is called for more than one account, then update all the cbr_config lastEvaluated values.
		IF @accountid IS NULL
			UPDATE cbr_config SET lastEvaluated = GETDATE();
			
        IF @accountid IS NOT NULL 
            SELECT  @ccustomer = c.customer
            FROM    master m
                    INNER JOIN customer c ON c.customer = m.customer
            WHERE   m.number = @accountid;

 		if not object_id('tempdb..#cbrwork') IS NULL drop table #cbrwork;		  
		if not object_id('tempdb..#cbrmetrowork') IS NULL drop table #cbrmetrowork;	
		
		      CREATE TABLE #cbrwork
            (
              CbrEnabled BIT,
              PortfolioType CHAR(1),
              AccountType CHAR(2),
              MinBalance MONEY,
              WaitDays INT,
              DefaultCreditorClass VARCHAR(2),
              DefaultOriginalCreditor VARCHAR(50),
              UseAccountOriginalCreditor BIT,
              UseCustomerOriginalCreditor BIT,
              PrincipalOnly BIT,
              IncludeCodebtors BIT,
              DeleteReturns BIT,
              Customer VARCHAR(7),
              CustomerID INT,
              CustomerName VARCHAR(100),
              CustomerOriginalCreditor VARCHAR(50),
              CustomerCreditorClass VARCHAR(2),
              [IsChargeOffData] [BIT],
              [cdd_abbrev] varchar(155),
              [cdd_lookup] varchar(155),
              [IsValidAccountType] [BIT],
              OriginalCreditor VARCHAR(50),
              Number INT NOT NULL,
              Status VARCHAR(5),
              QLevel VARCHAR(3),
              ReceivedDate DATETIME,
              DelinquencyDate DATETIME,
              OriginalPrincipal MONEY,
              OriginalBalance MONEY,
              CurrentPrincipal MONEY,
              CurrentBalance MONEY,
              LastPaymentDate DATETIME,
              CliDlp datetime,
              CbrPrevent BIT,
			  CbrOutofStatute BIT,
              CbrOverride BIT,
              ExtendDays INT,
              StatusCbrReport BIT,
              StatusCbrDelete BIT,
              StatusIsBankruptcy BIT,
              StatusIsDeceased BIT,
              StatusIsDisputed BIT,
              StatusIsPIF BIT,
              StatusIsSIF BIT,
              StatusIsActive BIT,
              ReportableDate DATETIME,
              PrvCbrException INT,
              NextOriginalCreditor varchar(50),
              NextCreditorClass varchar(2),
              [ContractDate] [datetime],
              CbrValidContractToPay int,
              [ConsumerAccountNumber] [VARCHAR](30),
              StatusIsFraud BIT,
              [SettlementArrangement] [BIT],
              NextCurrentBalance MONEY,
			  [PortfolioIndicator] [int],
			  [lastpaidamt] MONEY,
			  [ActualPaymentAmount] MONEY,
			  [specialnote] [varchar](3),			-- used by first party to Force DA and DF on accounts that have and have not been reported.
              [PersonalReceivership_Amortization] [bit],
              [ChargeOffDate] DATETIME,
              NextAccountStatus CHAR(2),
              NextSpecialComment CHAR(75),
			  [SoldToPurchasedFrom] [varchar](30),
              [PortfolioSoldDate] DATETIME,
              [HasChargeOffRecord] [BIT],
              [ChargeOffAmount] [money],
			  -- Paymenthistory date compared with end of last cycle used to replace or append the profile string
              [PaymentHistoryProfile] varchar(24), --profile
              [PaymentHistoryDate] datetime,
              [PaymentHistoryDateEOM] datetime,
              [HighestCredit] [money],
              [CreditLimit] [money],
              [SecondaryAgencyIdenitifier] [char](2),
			  [SecondaryAccountNumber] [varchar](18),
			  [MortgageIdentificationNumber] [varchar](18),
			  [TermsDuration] [char] (3),
			  [ClosedDate] [datetime],
			  [ChargeOffStatus] [char](2),  
			  [mcoClosedDate] [datetime],           
			  [mcoSpecialComment] [char](2),		--from 1st party MasterChargeOff loaded as Override
			  [mcoComplianceCondition] [char](2),	--from 1st party MasterChargeOff loaded as Override	,
              PrimaryDebtorID INT NOT NULL,
              DebtorID INT NOT NULL,
              DebtorSeq INT,
              Debtorname VARCHAR(300),
              DebtorLastName VARCHAR(50),
              DebtorFirstName VARCHAR(50),
              DebtorMiddleName VARCHAR(50),
              Responsible BIT,
              CbrExclude BIT,
              PrvDebtorExceptions INT,
              DebtorExceptions INT,
              PrimaryDebtorException INT,
              IsBusiness BIT,
              JointDebtors INT,
              DebtorSSN VARCHAR(15),
              DebtorStreet1 VARCHAR(128),
              DebtorStreet2 VARCHAR(128),
              DebtorCity VARCHAR(30),
              DebtorState VARCHAR(3),
              DebtorZipCode VARCHAR(10),
              NextTransactionType CHAR(1),
			  [IsAuthorizedAccountUser] [bit],		--debtor relation defined by 1st party using the workform.  Represents an authorized user on the account living at the same address/no address
              NextComplianceCondition CHAR(2),
              NextEcoaCode CHAR(1),
              AuditCommentKey TINYINT,
              Reportable BIT,
              DebtorsAuditCommentKey TINYINT,
              [CCCS] [BIT],
              [PrimaryDebtorDispute] [BIT],
              datedeceased DATETIME,
              bankruptcychapter TINYINT,
              nextinformationindicator CHAR(2),
              --disconfiguredAccountid int,
              homephone varchar(30),
              DateFiledEoM DATETIME,
              DischargeDateEoM DATETIME,
              DismissalDateEoM DATETIME,
              cbrException INT,
              DebtorDOB DATETIME,
              Returned DATETIME,
              cbrECOACode char(1),
               PRIMARY KEY ( number, debtorid )
            );	  
						
			--if new parameter = true then inner join work table else cbrdatafex() only			
			if not exists (select top 1 * from cbrCustomGroup)
				INSERT INTO #cbrwork select x.* from dbo.cbrdatafex(@accountid) x 
			else 
				INSERT INTO #cbrwork select x.* from dbo.cbrdatafex(@accountid) x inner join dbo.cbrCustomGroup c on x.Number = c.number
			;						      
			
			DELETE FROM #cbrwork where number in (select number from tempcbrAccountRestricted)
			
--print '________dbo.cbrdatafex(null); ______________'     
	        CREATE TABLE #cbrmetrowork
            (
              Number INT NOT NULL,
              uid INT IDENTITY(1, 1),
              DebtorID INT NOT NULL,
              PrimaryDebtorID INT NOT NULL,
              AccountStatus CHAR(2),
              SpecialComment CHAR(2),
              ComplianceCondition CHAR(2),
              OpenBalance MONEY,
              FileID INT,
              RecordID INT,
              LastAccountStatus CHAR(2),
              LastSpecialComment CHAR(2),
              LastComplianceCondition CHAR(2),
              LastEcoaCode CHAR(1),
              EcoaCode CHAR(1),
              LastInformationIndicator CHAR(2),
              InformationIndicator CHAR(2),
              PndgDebtorName VARCHAR(300),
              PndgDebtorSSN VARCHAR(30),
              PndgDebtorStreet1 VARCHAR(128),
              PndgDebtorStreet2 VARCHAR(128),
              PndgDebtorCity VARCHAR(30),
              PndgDebtorState VARCHAR(3),
              PndgDebtorZipCode VARCHAR(10),
              RptdDebtorName VARCHAR(300),
              RptdDebtorLastName VARCHAR(50),
              RptdDebtorFirstName VARCHAR(50),
              RptdDebtorMiddleName VARCHAR(50),
              RptdDebtorSSN VARCHAR(30),
              RptdDebtorStreet1 VARCHAR(128),
              RptdDebtorStreet2 VARCHAR(128),
              RptdDebtorCity VARCHAR(30),
              RptdDebtorState VARCHAR(3),
              RptdDebtorZipCode VARCHAR(10),
              TransactionType CHAR(1),
              CurrentTransactionType CHAR(1),
              OriginalCreditor VARCHAR(30),
              CreditorClassification CHAR(2),
              TransactionTypeOverride BIT,
              EcoaCodeOverride BIT,
              InformationIndicatorOverride BIT, 
              AddressIndicatorOverride BIT,
              ResidenceCodeOverride BIT,
              DateReported DATETIME,
              specialCommentOverride BIT,
              SoldToPurchasedFrom VARCHAR(30),	
			  LastPortfolioIndicator INTEGER,
			  RptdLastPaymentDate Datetime,
			  AuthorizedUserAddress Varchar(8),	
			  RptdPaymentHistoryProfile varchar(24),
			  RptdDebtorGenerationCode char(1),
			  RptdDebtorSuffix varchar(50)
			  ,	
                PRIMARY KEY ( number, uid )
            ) ;


                  
            INSERT INTO #cbrmetrowork SELECT m.* FROM dbo.cbrdatametrofex(@accountid) m;
     
			  --select m.* into #cbrmetrowork from dbo.cbrdatametrofex(@accountid) m;
			
			DELETE FROM #cbrmetrowork where number in (select number from tempcbrAccountRestricted)
			
			  
			CREATE NONCLUSTERED INDEX [ix_cbrwork] ON #cbrwork 
			(
				number ASC
			)
			INCLUDE ( debtorid, primarydebtorid ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY];

			CREATE NONCLUSTERED INDEX [ix_cbrmetrowork] ON #cbrmetrowork 
			(
				number ASC
			)
			INCLUDE ( debtorid, primarydebtorid, uid ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY];

            
            
--print '________dbo.cbrdatametrofex(null); ______________' ;    
                              
            WITH Payments as ( 
            select  #cbrwork.number as number,
					MAX(coalesce( P.datepaid ,m.CLIDLP, m.lastpaid))  as LastPaymentDate,																									
					SUM(CASE WHEN (CASE WHEN @is1stparty = 'TRUE' THEN isnull(P.DateTimeEntered,'19000101') ELSE isnull(P.datepaid,'19000101') END) > isnull(dt.dateReported,'19000101') THEN COALESCE(CASE WHEN ISNULL(DATEDIFF(d,P.DateTimeEntered,GETDATE()),0) < 39 THEN P.totalpaid ELSE 0 END,(CASE WHEN m.lastpaid > isnull(dt.dateReported,'19000101')  AND ISNULL(DATEDIFF(d,m.lastpaid,GETDATE()),0) < 39 THEN m.lastpaidamt ELSE 0 END)) 
					ELSE 0 END) as ActualPaymentAmount
			FROM 
			#cbrwork
			LEFT OUTER JOIN (select #cbrmetrowork.Number,max(isnull(CONVERT(VARCHAR(8),#cbrmetrowork.dateReported,112),'19000101')) as dateReported from #cbrmetrowork group by #cbrmetrowork.Number) dt ON  dt.Number = #cbrwork.Number
			LEFT OUTER JOIN payhistory p ON #cbrwork.number = p.number AND p.uid not in (select isnull(reverseofuid,0) from payhistory) AND p.batchtype IN ('PU','PA','PC')
			INNER JOIN dbo.master m ON #cbrwork.number = m.number
			WHERE isnull(#cbrwork.primarydebtorid,0) > 0 
			GROUP BY 
				 #cbrwork.number
				 )
				                 
			UPDATE  #cbrwork
			SET LastPaymentDate = ISNULL(Payments.LastPaymentDate,null),
			 ActualPaymentAmount = ISNULL(Payments.ActualPaymentAmount,0)
			FROM Payments
			JOIN #cbrwork ON #cbrwork.Number = Payments.number;
			
--print '________last payment; ______________'     


        IF @accountid IS NOT NULL 
            BEGIN

      ----          IF ( SELECT TOP 1 ISNULL (cw.cbrenabled, - 1) FROM #cbrwork cw WHERE cw.number = @accountid ) = -1 
      ----              BEGIN
      ----                  RAISERROR('Credit reporting has not been configured for Customer or Bad Account Number passed.', 16, 1) -- may not be configured
      ----             		SET @Context_Info = cast('' AS VARBINARY(30))
						----SET CONTEXT_INFO @Context_Info
      ----                  RETURN 1
      ----              END

                IF ( SELECT TOP 1
                            ISNULL(cw.primarydebtorid, 0)
                     FROM   #cbrwork cw
                     WHERE  cw.number = @accountid
                            AND cw.primarydebtorid > 0 ) = 0 
                    BEGIN
                        RAISERROR('Account number @%d does not have a primary debtor record.', 16, 1, @AccountID)
                   		SET @Context_Info = cast('' AS VARBINARY(30))
						SET CONTEXT_INFO @Context_Info
						RETURN 1
                    END
            END;

--		Begin CBR Account Status Update
   
		IF @accountid IS NOT NULL 
		BEGIN
		   SET @action = CASE WHEN NOT EXISTS ( SELECT accountid FROM   cbr_accounts WHERE  accountid = @accountid ) 
								THEN 'insert'
								ELSE 'update' END
		END;
         
        --IF NOT OBJECT_ID('temp_db..#cbrDataFilter1ex') IS NULL DROP TABLE #cbrDataFilter1ex;
                             
		WITH --update for ssn - dob error here
			cbrDataFilter1ex as (
			
			SELECT	cw.number,
			--cw.cbrException,
			cw.qlevel,
			cw.PrimaryDebtorID,
			--cmw.PrimaryDebtorID,
			cw.DebtorID,
			case when cwx.primarydebtorexception = 0 then cw.PrimaryDebtorException else cwx.primarydebtorexception  end  as PrimaryDebtorException,
			case when cw.PrimaryDebtorID > 0 and cwx.primarydebtorexception + cw.PrimaryDebtorException <> 0 then 1 Else 0 end AS primaryexception,
			cmw.LastAccountStatus,
			--cw.StatusCbrReport,
			case when isnull(cw.chargeoffdate,'19000101') > isnull(cmw.DateReported,'19000101') then COALESCE(cw.ChargeOffStatus,cmw.AccountStatus) else COALESCE(cmw.AccountStatus,cw.ChargeOffStatus) end as accountstatus,
			cw.StatusCbrDelete,
			cw.CbrEnabled,
			cw.Responsible,
			cw.CbrExclude,
			cw.NextCreditorClass,
			--cw.AccountType,
			--cw.ReportableDate,
			--cw.OriginalPrincipal,
			--cw.MinBalance,
			--cw.DelinquencyDate,
			cw.CbrOutofStatute,
			--cw.StatusIsPIF,
			cmw.SpecialComment,
			--cw.StatusIsSIF,
			--cw.StatusIsDisputed,
			cmw.LastComplianceCondition,
			cw.DeleteReturns,
			isnull(cw.CbrOverride,0) as cbroverride,
	        
			CASE --WHEN cmw.EcoaCodeOverride = 1 THEN cmw.ecoacode
											 --cbrECOACode
											 WHEN @is1stparty = 'TRUE' AND isnull(cw.IsAuthorizedAccountUser,0) = 1 AND isnull(cw.cbrECOACode,'') IN ('Z','T')  THEN cw.cbrECOACode
											 WHEN @is1stparty = 'TRUE' AND isnull(cw.IsAuthorizedAccountUser,0) = 1 AND isnull(cw.Responsible,0) = 0 AND isnull(cw.PrimaryDebtorID,0) = 0 THEN '3'
											 WHEN @is1stparty = 'TRUE' AND isnull(cw.cbrexclude,0) = 0 and isnull(cmw.lastecoacode,'') = '3' AND isnull(cw.Responsible,0) = 0 AND isnull(cw.IsAuthorizedAccountUser,0) = 0 AND isnull(cw.PrimaryDebtorID,0) = 0  THEN 'T'  
											 WHEN isnull(cw.Responsible,0) = 0  AND isnull(cw.IsAuthorizedAccountUser,0) = 0  AND isnull(cw.PrimaryDebtorID,0) = 0 THEN 'Z' -- debtor no longer responsible  or has been excluded
											 WHEN isnull(cw.cbrexclude,0)=1 AND isnull(cw.PrimaryDebtorID,0) = 0 THEN 'Z'											 
											 WHEN cw.datedeceased IS NOT NULL THEN 'X'
											 WHEN isnull(cw.PrimaryDebtorID,0) > 0
												  AND isnull(cw.IsBusiness,0) = 0
												  AND isnull(cw.JointDebtors,0) <= 1 THEN '1' --see count for jointdebtors
											 WHEN isnull(cw.PrimaryDebtorID,0) > 0
												  AND isnull(cw.IsBusiness,0) = 0
												  AND isnull(cw.JointDebtors,0) > 1 THEN '2'
											 WHEN isnull(cw.PrimaryDebtorID,0) = 0
												  AND isnull(cw.IsBusiness,0) = 0
												  AND isnull(cw.JointDebtors,0) > 1 THEN '2'
											 ELSE '1'
										END as NextEcoaCode,
	        
	        

			CASE --WHEN cmw.InformationIndicatorOverride = 1 THEN isnull(cmw.informationindicator,'')
							 WHEN isnull(cw.PersonalReceivership_Amortization,'') = 'TRUE' THEN '1A'
							 WHEN isnull(cmw.LastInformationIndicator,'') = 'Q' AND isnull(cw.nextinformationindicator,'') NOT IN ( 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Z','R' ) 
								  THEN ''
							 WHEN isnull(cw.nextinformationindicator,'') NOT IN ( 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Z','R' ) 
								AND isnull(cmw.LastInformationIndicator,'') IN ( 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Z','R' )  THEN 'Q'
							 WHEN isnull(cmw.LastInformationIndicator,'') <> 'Q' and isnull(cw.nextinformationindicator,'') <> isnull(cmw.LastInformationIndicator,'') THEN cw.nextinformationindicator
							 WHEN isnull(cw.nextinformationindicator,'') = isnull(cmw.LastInformationIndicator,'') THEN isnull(cw.nextinformationindicator,'') 
							 ELSE ''
						END as NextInformationIndicator,

                                                	                                                
			--cw.nextinformationindicator,
	                       
			--cw.datedeceased ,
			--cw.bankruptcychapter,
			cmw.lastinformationindicator,
			--cw.auditcommentkey,
			--cw.statusisactive,
			cw.cbrprevent,
			cw.reportable,
			--cmw.debtorid,
			cmw.lastecoacode,
			cmw.ecoacode,
			case when isnull(cwx.debtorexceptions,0) <> 0 then  cwx.debtorexceptions else isnull(cw.debtorexceptions,0) end as debtorexceptions,
			cmw.informationindicator,
			cw.DebtorsAuditCommentKey,
			cw.IsBusiness,
			cw.JointDebtors,
	        
			CASE WHEN @is1stparty = 'TRUE' AND ISNULL(cmw.RptdDebtorName,'') = ''
					 AND cw.DebtorName IS NOT NULL THEN ''
				WHEN @is1stparty = 'FALSE' AND ISNULL(cmw.RptdDebtorName,'') = ''
					 AND cw.DebtorName IS NOT NULL THEN '1'  
				--WHEN ISNULL(cmw.RptdDebtorName,'') = '' THEN ''   
				WHEN cmw.RptdDebtorName <> cw.DebtorName
					 AND cmw.RptdDebtorSsn <> ISNULL(cw.DebtorSsn,'')
					 AND ( cmw.RptdDebtorStreet1 <> cw.DebtorStreet1
						   OR cmw.RptdDebtorStreet2 <> cw.DebtorStreet2
						   OR cmw.RptdDebtorCity <> cw.DebtorCity
						   OR cmw.RptdDebtorState <> cw.DebtorState
						   OR cmw.RptdDebtorZipCode <> ISNULL(cw.DebtorZipcode, '') ) THEN 'A'
				WHEN cmw.RptdDebtorSsn <> ISNULL(cw.DebtorSsn,'')
					 AND ( cmw.RptdDebtorStreet1 <> cw.DebtorStreet1
						   OR cmw.RptdDebtorStreet2 <> cw.DebtorStreet2
						   OR cmw.RptdDebtorCity <>  cw.DebtorCity
						   OR cmw.RptdDebtorState <> cw.DebtorState
						   OR cmw.RptdDebtorZipCode <> ISNULL(cw.DebtorZipcode, '') ) THEN '9'
				WHEN cmw.RptdDebtorSsn <> ISNULL(cw.DebtorSsn,'')
					 AND cmw.RptdDebtorName <> cw.DebtorName THEN '8'
				WHEN cmw.RptdDebtorName <> cw.DebtorName
					 AND ( cmw.RptdDebtorStreet1 <> cw.DebtorStreet1
						   OR cmw.RptdDebtorStreet2 <> cw.DebtorStreet2
						   OR cmw.RptdDebtorCity <> cw.DebtorCity
						   OR cmw.RptdDebtorState <> cw.DebtorState
						   OR cmw.RptdDebtorZipCode <> ISNULL(cw.DebtorZipcode, '') ) THEN '6'
				WHEN cmw.RptdDebtorSsn <> ISNULL(cw.DebtorSsn,'') THEN '5'
				WHEN ( cmw.RptdDebtorStreet1 <> cw.DebtorStreet1
					   OR cmw.RptdDebtorStreet2 <> cw.DebtorStreet2
					   OR cmw.RptdDebtorCity <> cw.DebtorCity
					   OR cmw.RptdDebtorState <> cw.DebtorState
					   OR cmw.RptdDebtorZipCode <> ISNULL(cw.DebtorZipcode, '')  ) THEN '3'
				WHEN cmw.RptdDebtorName <> cw.DebtorName THEN '2'
				ELSE ''
		   END as nexttransactiontype,

			--cmw.RptdDebtorName,
			--cw.DebtorName, 
			--cmw.RptdDebtorSsn,
			cw.DebtorSsn,
			--cmw.RptdDebtorStreet1,
			--cw.DebtorStreet1,
			--cmw.RptdDebtorStreet2,
			--cw.DebtorStreet2,
			--cmw.RptdDebtorCity,
			--cw.DebtorCity,
			--cmw.RptdDebtorState,
			--cw.DebtorState,
			--cmw.RptdDebtorZipCode,
			--cw.DebtorZipcode,
			--cw.nexttransactiontype,
			cmw.ComplianceCondition,
			cw.StatusIsFraud,
			cw.IsChargeOffData,
			cw.IsValidAccountType,
			cmw.TransactionTypeOverride,
			cmw.EcoaCodeOverride,
			cmw.InformationIndicatorOverride,
			cmw.AddressIndicatorOverride,
			cmw.ResidenceCodeOverride,
			cmw.SpecialCommentOverride,
			cw.settlementArrangement,
			cw.CCCS,
			cw.PrimaryDebtorDispute,
			CASE WHEN ISNULL(cmw.LastPortfolioIndicator,0) > 0 AND ISNULL(cw.PortfolioIndicator,0) = 0 THEN 9  ELSE cw.PortfolioIndicator END as PortfolioIndicator,
			cmw.LastPortfolioIndicator,          
			--cw.PortfolioIndicator,
			cw.SoldToPurchasedFrom,
			cw.specialnote ,
			cw.mcoSpecialComment ,
			cw.mcoComplianceCondition ,
			cw.IsAuthorizedAccountUser ,
			cw.PersonalReceivership_Amortization,
--if account is returned...payments cannot be entered on them....until they are marked not returned...
--any accont that is reported final and returned cannot be reported until account marked as not returned
--however...current logic allows account to be reported as re-opened active.....	        
			Case when 
					 cw.StatusCbrReport = 1				-- Status configured to report.
						AND cw.CbrEnabled = 1				-- effective configuration enabled.
						 AND ( cw.Responsible = 1	OR (@is1stparty = 'TRUE' AND isnull(cw.IsAuthorizedAccountUser,'False') = 'TRUE' AND cw.Responsible = 'FALSE')) 		-- debtor is responsible (debtors.responsible).
						AND cw.cbrprevent = 0				-- account not prevented from reporting (master.cbrPrevent).
						--AND cw.CbrExclude = 0				-- debtor is not excluded from reporting (debtors.cbrExclude).
						AND (cw.IsChargeOffData = 1 OR cw.NextCreditorClass NOT LIKE '00%') -- Not Charge-off data or Creditor Class is valid.
						AND cw.IsValidAccountType = 1		-- The account type is valid for both Industry and Portfolio type?
						AND cw.ReportableDate <= GETDATE() -- ReceivedDate + WaitDays + ExtendDays is in past. (master.received, effectiveconfiguration.waitdays, master.extenddays)
						 AND ((cw.CurrentPrincipal >= cw.minbalance AND ISDATE(cmw.DateReported)=0 ) OR (ISDATE(cmw.DateReported)=1)) --AND (cmw.LastAccountStatus NOT IN ('DF') OR cw.StatusIsDisputed = 1)) )--'DA',
						 -- at a minum must remove the check on DA
						 
						AND cw.CbrOutofStatute = 0		-- 7 years have not passed since either the delinquency date or the received date (master table).
						AND isnull(cw.cbrException,0) = 0			-- Account data is valid (See cbrException field on #cbrWork table).
						AND cw.DebtorExceptions = 0		-- Debtor data is valid (see debtorexceptions in insert into #cbrWork).
						--AND cw.PrimaryDebtorID > 0 
						AND ISNULL(cw.PrimaryDebtorException,0) = 0  -- This is not the primary debtor OR primary debtor is valid (see debtorexceptions)
						AND cw.IsBusiness = 0				-- debtor is not a business (debtors.IsBusiness)
						--AND cw.StatusCbrDelete = 0		--deprecated in favor of master.specialnote to be removed in post cider versions
						--AND cw.StatusIsFraud = 0
						--AND NOT (cw.DeleteReturns = 1 AND cw.qlevel = '999')	--Delete Returns
						--AND cw.specialnote NOT IN ('DA','DF') --Forced DA DF for first party non previously reported or previously reported
					THEN 'True' Else 'False' END as CanReportActive,
					 cw.StatusIsPIF,
					 cw.StatusIsSIF,
	                 
			CASE WHEN ISNULL(lastcompliancecondition,'') = 'XR' AND ISNULL(compliancecondition,'') IN ('','XR') THEN '' 
										 --WHEN ISNULL(COALESCE(mcoComplianceCondition,compliancecondition),'') <> ISNULL(lastcompliancecondition,'') THEN ISNULL(COALESCE(mcoComplianceCondition,compliancecondition),'')
										 --WHEN ISNULL(lastcompliancecondition,'') = ISNULL(compliancecondition,'') THEN ''
										 ELSE compliancecondition			
									END as nextcompliancecondition,
			cmw.DateReported,
			cw.returned,
			cw.DebtorDOB,
			CASE WHEN [cw].[IsChargeOffData] = 0 THEN [cw].[receiveddate] ELSE coalesce([cw].[ContractDate],[cw].[receiveddate]) END as OpenDate
											
			FROM	 
			#cbrwork cw
			left outer join #cbrmetrowork cmw 
			ON cmw.number = cw.number and cmw.debtorid = cw.debtorid
			outer apply cbrDataMetroExceptionex(cw.debtorid, CASE WHEN [cw].[IsChargeOffData] = 0 THEN [cw].[receiveddate] ELSE coalesce([cw].[ContractDate],[cw].[receiveddate]) END , cw.DebtorDOB, cw.DebtorSSN, cw.IsAuthorizedAccountUser, cw.debtorseq, cw.DebtorStreet1, cw.DebtorCity, cw.DebtorState , @TestOpenDate) cwx 
			)	
			select * into #cbrDataFilter1ex from cbrDataFilter1ex;
			--,

	         				
		--updateresultset as (
			select 	

						cw.Number, cw.primarydebtorid,
						coalesce(ax.debtorid,ad.debtorid,ap.debtorid,da.debtorid,cw.debtorid) as debtorid, --order of precedence
						coalesce(ax.cbroverride,cw.cbroverride) as cbroverride,
						coalesce(da.NextAccountStatus,ap.NextAccountStatus,cw.accountstatus) as NextAccountStatus,
						ap.NextSpecialComment,
						cw.NextComplianceCondition,
						cw.NextEcoaCode,
						cw.nextinformationindicator,
						ax.AuditCommentKey,
						ax.debtorsauditcommentkey,
						cw.NextTransactionType,
						cw.PortfolioIndicator,
						cw.CanReportActive,
						cw.DateReported,
						isnull(cw.debtorexceptions,0) as debtorexceptions,
						isnull(cw.primarydebtorexception,0) as primarydebtorexception		
		into #updateresultset 
			from #cbrDataFilter1ex cw --applied functions will be consolidated - duplicity and uneccessary work removed
						outer apply [dbo].[cbrDataActiveOrPaidex] ( cw.number , cw.debtorid , cw.IsChargeOffData , cw.accountstatus , cw.specialcomment , cw.CanReportActive , 
												cw.StatusIsPIF  , cw.nextinformationindicator , cw.PortfolioIndicator ,
												cw.SettlementArrangement , cw.CCCS , cw.mcoSpecialComment , cw.StatusIsSIF , cw.SpecialCommentOverride, cw.deletereturns, 
												cw.qlevel, cw.nextcreditorclass, cw.specialnote ) ap
						outer apply [dbo].[cbrDataActiveOrPaidDbtrsex] ( cw.number, cw.debtorid , cw.accountstatus  , ap.nextaccountstatus, cw.CanReportActive , 
												cw.nextcompliancecondition , cw.compliancecondition, cw.lastcompliancecondition) ad
						outer apply [dbo].[cbrDataDeletedAcctsex] ( cw.number , cw.debtorid , cw.CbrOutofStatute , cw.statusisfraud , cw.CanReportActive , 
												cw.specialnote , cw.statuscbrdelete  ) da
						outer apply [dbo].[cbrDataAuditKeysex] ( cw.number, cw.debtorid , cw.CbrOutofStatute , cw.statusisfraud , cw.CanReportActive , 
												cw.specialcomment , ap.nextspecialcomment , cw.cbrenabled , cw.accountstatus  , ap.nextaccountstatus , cw.deletereturns , cw.cbroverride ,
												cw.qlevel , cw.cbrexclude , cw.primarydebtorid , cw.responsible  , cw.cbrprevent , cw.NextEcoaCode ,
												cw.lastecoacode , cw.ecoacode , cw.informationindicator , cw.nextinformationindicator , cw.lastinformationindicator, cw.LastComplianceCondition,
												cw.NextComplianceCondition , cw.IsAuthorizedAccountUser , cw.StatusIsPIF , cw.StatusIsSIF ,
												cw.compliancecondition, cw.lastaccountstatus, cw.specialnote, cw.returned ) ax
				;
				--)
	
				UPDATE  #cbrwork
				SET     cbroverride = u.cbroverride,
						NextAccountStatus = u.NextAccountStatus,
						NextSpecialComment = u.NextSpecialComment,
						NextComplianceCondition = u.NextComplianceCondition,
						NextEcoaCode = case when bx.accountid is not null and cw.IsAuthorizedAccountUser = 1 then 'T' else u.NextEcoaCode end,
						nextinformationindicator = u.nextinformationindicator,
						AuditCommentKey = ISNULL(u.AuditCommentKey,0),
						Reportable = CASE WHEN u.CanReportActive = 'True' Then 1 Else 0 END,
						debtorsauditcommentkey = ISNULL(u.debtorsauditcommentkey,0),
						NextTransactionType = u.NextTransactionType,
						PortfolioIndicator = u.PortfolioIndicator,
						DebtorExceptions = u.debtorexceptions + u.primarydebtorexception,
						cbrexception = u.primarydebtorexception + cbrexception
	                    
				FROM #updateresultset u INNER JOIN #cbrwork cw ON U.Number = cw.Number
				and cw.DebtorID = u.DebtorID left outer join cbrDataBankruptcyex(null) bx on u.number = bx.accountid;

--print '________status account; ______________'  ;   

				--account for bankruptcies in a filed status  --need default load rule defined in table

		WITH PaymentProfile AS (
		SELECT cw.number as number,cw.primarydebtorid,
						
			CASE WHEN cw.nextinformationindicator IN ('A','B','C','D') AND DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) >=0 and DATEDIFF(m,cw.[PaymentHistoryDateEoM], @CurrentPaymentHistoryDate)-DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) > 0
				 THEN		
					SUBSTRING(REPLICATE('D', CASE WHEN DATEDIFF(m,cw.[DateFiledEoM], cw.[PaymentHistoryDateEOM]) >=24 THEN 24 ELSE case when DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) = 0 then 1 else DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate)+1 end  END)
							+ REPLICATE('L', ABS(DATEDIFF(m,cw.[PaymentHistoryDateEOM], @CurrentPaymentHistoryDate)-(DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate)+1))) + SUBSTRING( [mco].[PaymentHistoryProfile], case when datediff(m,@CurrentPaymentHistoryDate ,cw.[PaymentHistoryDateEoM])>=0 then DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) else 1 end, 24) ,1,24) 
							
				 WHEN cw.nextinformationindicator IN ('A','B','C','D') AND DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) >= 0 and DATEDIFF(m,cw.[PaymentHistoryDateEOM], @CurrentPaymentHistoryDate)-DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) <= 0
				 THEN
				 	SUBSTRING(REPLICATE('D', CASE WHEN DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate)+1 >=24 THEN 24 ELSE case when DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate) = 0 then 1 else DATEDIFF(m,cw.[DateFiledEoM], @CurrentPaymentHistoryDate)+1 end  END)
				 			+ SUBSTRING([mco].[PaymentHistoryProfile],DATEDIFF(m,cw.[DateFiledEoM], [PaymentHistoryDateEOM])+2,24) ,1,24) 
				 											
				 WHEN cw.nextinformationindicator IN ('E','F','G','H')  AND DATEDIFF(m,cw.[DischargeDateEoM], @CurrentPaymentHistoryDate) >= -1 
					AND cw.[DateFiledEoM] IS Not NULL  
				 THEN		--keepng discharges as D and not reverting to L chargeoff	
					SUBSTRING(REPLICATE('D', CASE WHEN DATEDIFF(m,cw.DischargeDateEoM, @CurrentPaymentHistoryDate)+1 >=24 THEN 24 ELSE DATEDIFF(m,cw.DischargeDateEoM, @CurrentPaymentHistoryDate)+1   END)
						+ REPLICATE('D', CASE WHEN DATEDIFF(m,cw.DateFiledEoM, cw.DischargeDateEoM) > 0 THEN  DATEDIFF(m,cw.DateFiledEoM, cw.DischargeDateEoM) ELSE 1 END)
						+ CASE WHEN DATEDIFF(m,cw.PaymentHistoryDateEoM, @CurrentPaymentHistoryDate)+1 < 24 THEN  REPLICATE('L',Case when  cw.DateFiledEoM > cw.PaymentHistoryDateEoM then DATEDIFF(m,cw.PaymentHistoryDateEoM,cw.DateFiledEoM )-1 else 0 End) 
						+ SUBSTRING(mco.PaymentHistoryProfile,case when @CurrentPaymentHistoryDate >= cw.PaymentHistoryDateEoM then DATEDIFF(m,cw.DateFiledEoM, cw.PaymentHistoryDateEoM )+2 else 1 end,24-(case when DATEDIFF(m,cw.DateFiledEoM,cw.PaymentHistoryDateEoM) >=24 THEN 0 ELSE DATEDIFF(m,cw.DateFiledEoM,cw.PaymentHistoryDateEoM) End ))  	ELSE REPLICATE('L',24) END ,1,24)
				 
				 WHEN cw.nextinformationindicator IN ('I','J','K','L') AND DATEDIFF(m,cw.[DismissalDateEom], @CurrentPaymentHistoryDate) >= -1
				 THEN
					SUBSTRING(REPLICATE('L', CASE WHEN DATEDIFF(m,cw.DismissalDateEom, @CurrentPaymentHistoryDate)+1 >=24 THEN 24 ELSE DATEDIFF(m,cw.DismissalDateEom, @CurrentPaymentHistoryDate)+1   END)
						+ REPLICATE('D', CASE WHEN DATEDIFF(m,cw.DateFiledEoM, cw.DismissalDateEom) > 0 THEN  DATEDIFF(m,cw.DateFiledEoM, cw.DismissalDateEom) ELSE 0 END)
						+ REPLICATE('L',Case when  cw.DateFiledEoM > cw.PaymentHistoryDateEoM then DATEDIFF(m,cw.PaymentHistoryDateEoM,cw.DateFiledEOM )-1 else 0 End) 
						+ SUBSTRING(mco.PaymentHistoryProfile,case when @CurrentPaymentHistoryDate >= cw.PaymentHistoryDateEoM then DATEDIFF(m,cw.DateFiledEoM, cw.PaymentHistoryDateEoM)+2 else 1 end,24-(case when DATEDIFF(m,cw.DateFiledEoM,cw.PaymentHistoryDateEoM) >=24 THEN 0 ELSE DATEDIFF(m,cw.DateFiledEoM,cw.PaymentHistoryDateEoM) End ))  ,1,24)
			ELSE
				 cw.PaymentHistoryProfile
		END
				AS PaymentHistoryProfile
			
				FROM 
				#cbrwork cw
				INNER JOIN [MasterChargeOff] AS [mco] ON cw.[number] = [mco].[number]
				INNER JOIN Debtors d ON cw.PrimaryDebtorID = d.DebtorID
				LEFT OUTER JOIN [dbo].[bankruptcy] b ON d.debtorid = b.debtorid
				WHERE d.seq = 0 
				)
				UPDATE  #cbrwork
				SET PaymentHistoryProfile = PaymentProfile.PaymentHistoryProfile
				FROM PaymentProfile
				JOIN #cbrwork ON #cbrwork.PrimaryDebtorID = PaymentProfile.PrimaryDebtorID;
	
--print '________payment profile; ______________'     

		-- Define Audit Messages


        Create Table #CbrAuditComments 
            (
              AuditType TINYINT NOT NULL
                                PRIMARY KEY CLUSTERED,
              AuditText VARCHAR(255)
            );

		SET @TEXT_DELETE_FROM_BUREAUS = Case @is1stparty WHEN 0 THEN '' ELSE ' Account will be deleted from credit bureaus in next update.' END;
 	
       INSERT  INTO #CbrAuditComments
                SELECT  1,
                        'Account update will be sent to credit bureaus in next update.'
                UNION ALL
                SELECT  2,
                        'Account balance update will be sent to credit bureaus in next update.'
                UNION ALL
                SELECT  3,
                        'Account dispute will be sent to credit bureaus in next update.'
                UNION ALL
                SELECT  4,
                        'Account dispute will be removed from credit bureaus in next update.'
                UNION ALL
                SELECT  5,
                        'Account dispute removed prior to being sent to credit bureaus in next update.'
                UNION ALL
                SELECT  6,
                        'Account placed in pending for the next credit bureau report. AccountType - '
                UNION ALL
                SELECT  7,
                        'Configuration changed to exclude account.' + @TEXT_DELETE_FROM_BUREAUS
                UNION ALL
                SELECT  8,
                        'Statute of limitations exceeded.' + @TEXT_DELETE_FROM_BUREAUS
                UNION ALL
                SELECT  9,
                        'Status code set to send delete.' + @TEXT_DELETE_FROM_BUREAUS
                UNION ALL
                SELECT  10,
                        'Account has been returned.' + @TEXT_DELETE_FROM_BUREAUS
                UNION ALL
                SELECT  11,
                        'Primary debtor has been excluded from reporting.' + @TEXT_DELETE_FROM_BUREAUS
                UNION ALL
                SELECT  12,
                        'Primary debtor has been set as not responsible.' + @TEXT_DELETE_FROM_BUREAUS
                UNION ALL
                SELECT  13,
                        'Account in PIF status. PIF will be sent to credit bureaus in next update.'
                UNION ALL
                SELECT  14,
                        'Account in SIF status. SIF will be sent to credit bureaus in next update.'
                UNION ALL
                SELECT  15,
                        'Account in open status. Open will be sent to credit bureaus in next update.'
                UNION ALL
                SELECT  16,
                        'Account removed from pending - Previously Reported Paid(62) or Deleted(DA) or Fraud(DF) or NonReported Pending (DA)'--'for the next credit bureau report.'
                UNION ALL
                SELECT  17,
                        'Account prevent flag set - ' + @TEXT_DELETE_FROM_BUREAUS
                UNION ALL
                SELECT  18,
                        'Account confirmed fraudulent - Account will be deleted from credit bureaus in next update.'
                UNION ALL
                SELECT  19,
                        'Account removed from pending - Exception raised on account. See Cbr_Exceptions.'				--debtor messages
                UNION ALL
                SELECT  30,
                        ' deleted prior to being sent to credit bureaus in next update.'
                UNION ALL
                SELECT  31,
                        @TEXT_DELETE_FROM_BUREAUS
                UNION ALL
                SELECT  32,
                        ' deceased removed prior to being sent to credit bureaus in next update.'
                UNION ALL
                SELECT  33,
                        ' deceased will be removed from credit bureaus in next update.'
                UNION ALL
                SELECT  34,
                        ' deceased will be sent to credit bureaus in next update.'
                UNION ALL
                SELECT  35,
                        ' bankruptcy will be sent to credit bureaus in next update.'
                UNION ALL
                SELECT  36,
                        ' bankruptcy will be removed from credit bureaus in next update.'
                UNION ALL
                SELECT  37,
                        ' bankruptcy removed prior to being sent to credit bureaus in next update.'
                UNION ALL
                SELECT  38,
                        ' medical account paid by insurance - ' + @TEXT_DELETE_FROM_BUREAUS
                UNION ALL
                SELECT  39,
                        ' account previously reported as delete reset and allowed to report in next cycle. ' 
                UNION ALL
                SELECT  40,
                        ' account previously reported as paid in full reset and allowed to report delete in next cycle. ' ;
                           
		INSERT INTO cbr_audit ( accountid, debtorid, datecreated, [user],comment )
                                SELECT  cw.number, cw.DebtorID, GETDATE(), 'SYSTEM', cac.audittext
                                FROM    #cbrwork cw
                                INNER JOIN #CbrAuditComments cac ON cw.AuditCommentKey = cac.AuditType;
                         

        DECLARE @CbrAcctCreated BIT;
        DECLARE @CbrAcctUpdated BIT;

        SET @CbrAcctCreated = 0;
        SET @CbrAcctUpdated = 0;

        DECLARE @batchid UNIQUEIDENTIFIER;
        SET @batchid = NEWID();

        CBRUPDATES_SECTION:
       
        -- j1/j2 segment identification
		--  additional codes have been added to the evaluation for the j1 and j2 segments
		--	CbrDebtors.AuthorizedUserSegment varchar(8) -- j1 = auth user same address, -- j2 = auth user diff address 
        
		  with cbrupdates as     
				(
				SELECT	cw.number,
				cw.PrimaryDebtorID,
				--cw.CbrEnabled,
				isnull(cw.Responsible,0) as Responsible,
				--cw.CbrExclude,
				--cw.CbrOutofStatute,
				--cmw.NextEcoaCode,
				cw.debtorid,
				cw.debtorseq,
				--cmw.lastecoacode,
				--cmw.ecoacode,
				 --cw.IsChargeOffData,
				isnull(cw.IsAuthorizedAccountUser,0) as IsAuthorizedAccountUser ,
				cw.DebtorStreet1,
				cw.DebtorStreet2,
				cw.DebtorCity,
				cw.DebtorState, 
				cw.DebtorZipcode,
				isnull(cw.NextEcoaCode,'') AS NextEcoaCode 
				
				  FROM	#cbrwork cw
				LEFT OUTER JOIN #cbrmetrowork cmw
				ON cmw.number = cw.number and cmw.debtorid = cw.debtorid
				),      
			cbrprimary as 
			(
				select number,
				primarydebtorid,
				debtorid,    
				debtorseq,   
				case when  PrimaryDebtorID = debtorid   THEN DebtorStreet1 ELSE '' END as PrimaryDebtorStreet1,
				case when  PrimaryDebtorID = debtorid   THEN DebtorStreet2 ELSE '' END as PrimaryDebtorStreet2,
				case when  PrimaryDebtorID = debtorid   THEN DebtorCity ELSE '' END as PrimaryDebtorCity,
				case when  PrimaryDebtorID = debtorid   THEN DebtorState ELSE '' END as PrimaryDebtorState,
				case when  PrimaryDebtorID = debtorid   THEN DebtorZipcode ELSE '' END as PrimaryDebtorZipcode
				FROM	cbrupdates
				WHERE  PrimaryDebtorID > 0 
		        
				),
				
			cbrauthorized as 
			(
				select number,
				PrimaryDebtorID,
				debtorid,
				debtorseq,   
				case when  IsAuthorizedAccountUser = 1  and responsible = 0 THEN DebtorStreet1 ELSE '' END as AuthDebtorStreet1,
				case when  IsAuthorizedAccountUser = 1  and responsible = 0 THEN DebtorStreet2 ELSE '' END as AuthDebtorStreet2,
				case when  IsAuthorizedAccountUser = 1  and responsible = 0 THEN DebtorCity ELSE '' END as AuthDebtorCity,
				case when  IsAuthorizedAccountUser = 1  and responsible = 0 THEN DebtorState ELSE '' END as AuthDebtorState,
				case when  IsAuthorizedAccountUser = 1  and responsible = 0 THEN DebtorZipcode ELSE '' END as AuthDebtorZipcode
				
				FROM	cbrupdates
				WHERE PrimaryDebtorID = 0 AND IsAuthorizedAccountUser = 1 
				),

			updateset as 
			(
			Select p.Number,p.DebtorID,p.PrimaryDebtorID,a.DebtorID as NonPrimaryDebtorID,  p.PrimaryDebtorStreet1,p.PrimaryDebtorStreet2,p.PrimaryDebtorCity,p.PrimaryDebtorState,p.PrimaryDebtorZipcode
					,a.AuthDebtorStreet1,a.AuthDebtorStreet2,a.AuthDebtorCity,a.AuthDebtorState,a.AuthDebtorZipcode,coalesce(a.debtorseq,p.debtorseq) as debtorseq
				from cbrprimary p inner join cbrauthorized a on p.number = a.number   

				)	
				,			
			SourceData
						  AS (  SELECT   Number,DebtorID,nonPrimaryDebtorId,null as AccountStatus,null as SpecialComment,null as ComplianceCondition,null as OpenBalance,null as FileID,
										  null as RecordID,null as LastAccountStatus,null as LastSpecialComment,null as LastComplianceCondition,null as LastEcoaCode,null as EcoaCode,null as LastInformationIndicator,
										  null as InformationIndicator,null as PndgDebtorName,null as PndgDebtorSSN,PrimaryDebtorStreet1 as PndgDebtorStreet1,PrimaryDebtorStreet2 as PndgDebtorStreet2,PrimaryDebtorCity as PndgDebtorCity,PrimaryDebtorState as PndgDebtorState,
										  PrimaryDebtorZipcode as PndgDebtorZipCode,null as RptdDebtorName,null as RptdDebtorSSN,AuthDebtorStreet1 as RptdDebtorStreet1,AuthDebtorStreet2 as RptdDebtorStreet2,AuthDebtorCity as RptdDebtorCity,AuthDebtorState as RptdDebtorState,
										  AuthDebtorZipcode as RptdDebtorZipCode,null as TransactionType,null as CurrentTransactionType,null as OriginalCreditor,null as CreditorClassification,null as TransactionTypeOverride,
										  null as EcoaCodeOverride,null as InformationIndicatorOverride,null as AddressIndicatorOverride,null as ResidenceCodeOverride,null as DateReported,
										  null as specialCommentOverride,null as SoldToPurchasedFrom,null as LastPortfolioIndicator,null as RptdLastPaymentDate,null as AuthorizedUserAddress,null as RptdPaymentHistoryProfile
							   FROM     updateset 
							 ),																 
			TargetData
						  AS ( SELECT   Number,DebtorID,PrimaryDebtorId,AccountStatus,SpecialComment,ComplianceCondition,OpenBalance,FileID,
										  RecordID,LastAccountStatus,LastSpecialComment,LastComplianceCondition,LastEcoaCode,EcoaCode,LastInformationIndicator,
										  InformationIndicator,PndgDebtorName,PndgDebtorSSN,PndgDebtorStreet1,PndgDebtorStreet2,PndgDebtorCity,PndgDebtorState,
										  PndgDebtorZipCode,RptdDebtorName,RptdDebtorSSN,RptdDebtorStreet1,RptdDebtorStreet2,RptdDebtorCity,RptdDebtorState,
										  RptdDebtorZipCode,TransactionType,CurrentTransactionType,OriginalCreditor,CreditorClassification,TransactionTypeOverride,
										  EcoaCodeOverride,InformationIndicatorOverride,AddressIndicatorOverride,ResidenceCodeOverride,DateReported,
										  specialCommentOverride,SoldToPurchasedFrom,LastPortfolioIndicator,RptdLastPaymentDate,AuthorizedUserAddress,RptdPaymentHistoryProfile
									
							   FROM     #cbrmetrowork
							 )
															 
							 --select * from sourcedata union all select * from targetdata;
							 --return;
							 
							 
					MERGE TargetData AS TargetTable
						USING SourceData AS SourceTable
						ON ( 
							 --ISNULL(TargetTable.debtorid,0) = SourceTable.debtorid
							 --AND 
							 ISNULL(TargetTable.number,0) = SourceTable.number
							 AND ISNULL(TargetTable.DebtorID,0) = SourceTable.NonPrimaryDebtorID
						   )
						WHEN MATCHED --and isnull(TargetTable.DebtorID,0) <> TargetTable.DebtorID
							THEN UPDATE
								set AuthorizedUserAddress = Case when ISNULL(SourceTable.PndgDebtorStreet1,'') = ISNULL(SourceTable.RptdDebtorStreet1,'') 
												and ISNULL(SourceTable.PndgDebtorStreet2,'') = ISNULL(SourceTable.RptdDebtorStreet2,'')
												and ISNULL(SourceTable.PndgDebtorCity,'') = ISNULL(SourceTable.RptdDebtorCity,'')
												and ISNULL(SourceTable.PndgDebtorState,'') = ISNULL(SourceTable.RptdDebtorState,'')
												and LEFT(ISNULL(SourceTable.PndgDebtorZipcode,''),5) = LEFT(ISNULL(SourceTable.RptdDebtorZipcode,''),5) 
											then 'J1' ELSE 'J2' end
						WHEN NOT MATCHED BY TARGET --and SourceTable.PrimaryDebtorID <> SourceTable.DebtorID
							THEN
								INSERT  
									    ( Number,DebtorID,PrimaryDebtorId,AccountStatus,SpecialComment,ComplianceCondition,OpenBalance,FileID,
										  RecordID,LastAccountStatus,LastSpecialComment,LastComplianceCondition,LastEcoaCode,EcoaCode,LastInformationIndicator,
										  InformationIndicator,PndgDebtorName,PndgDebtorSSN,PndgDebtorStreet1,PndgDebtorStreet2,PndgDebtorCity,PndgDebtorState,
										  PndgDebtorZipCode,RptdDebtorName,RptdDebtorSSN,RptdDebtorStreet1,RptdDebtorStreet2,RptdDebtorCity,RptdDebtorState,
										  RptdDebtorZipCode,TransactionType,CurrentTransactionType,OriginalCreditor,CreditorClassification,TransactionTypeOverride,
										  EcoaCodeOverride,InformationIndicatorOverride,AddressIndicatorOverride,ResidenceCodeOverride,DateReported,
										  specialCommentOverride,SoldToPurchasedFrom,LastPortfolioIndicator,RptdLastPaymentDate,AuthorizedUserAddress,RptdPaymentHistoryProfile
										)								
										VALUES
										
																		
										( SourceTable.Number,SourceTable.NonPrimaryDebtorID,0,null ,null ,null ,null ,null ,
										  null ,null ,null ,null ,null ,null ,null ,
										  null ,null ,null ,SourceTable.RptdDebtorStreet1,SourceTable.RptdDebtorStreet2,SourceTable.RptdDebtorCity,SourceTable.RptdDebtorState,
										  SourceTable.RptdDebtorZipCode,null ,null ,null ,null ,null ,null ,
										  null ,null ,null ,null ,null ,null ,
										  null ,null ,null ,null ,null ,
										  null ,null ,null ,null ,
										  Case when ISNULL(SourceTable.PndgDebtorStreet1,'') = ISNULL(SourceTable.RptdDebtorStreet1,'') 
												and ISNULL(SourceTable.PndgDebtorStreet2,'') = ISNULL(SourceTable.RptdDebtorStreet2,'')
												and ISNULL(SourceTable.PndgDebtorCity,'') = ISNULL(SourceTable.RptdDebtorCity,'')
												and ISNULL(SourceTable.PndgDebtorState,'') = ISNULL(SourceTable.RptdDebtorState,'')
												and LEFT(ISNULL(SourceTable.PndgDebtorZipcode,''),5) = LEFT(ISNULL(SourceTable.RptdDebtorZipcode,''),5) 
											then 'J1' ELSE 'J2' end,
											null 
										);    
  

--print '________cbrupdates j1 j2; ______________'     

		
		-- Update remaining cbr_accounts that had a status change.

		If Not Object_ID('tmpdb..#OutParms1') Is Null Drop Table #OutParms1;
		If Not Object_ID('tmpdb..#OutParms2') Is Null Drop Table #OutParms2;
		If Not Object_ID('tmpdb..#OutParms3') Is Null Drop Table #OutParms3;
		If Not Object_ID('tmpdb..#OutParms4') Is Null Drop Table #OutParms4;
		If Not Object_ID('tmpdb..#OutParms5') Is Null Drop Table #OutParms5;

		Create Table #OutParms1 (AccountID INT Primary Key);
		Create Table #OutParms2 (AccountID INT Primary Key);
		Create Table #OutParms3 (AccountID INT Primary Key);
		Create Table #OutParms4 (AccountID INT);
		Create Table #OutParms5 (AccountID INT);

        IF @action = 'update'
            OR @accountid IS NULL 
            BEGIN

                UPDATE  dbo.cbr_accounts
                SET     accountstatus = cw.nextaccountstatus,
                        specialcomment = cw.NextSpecialComment,
                        complianceCondition = CASE WHEN cw.NextComplianceCondition IS NULL THEN ca.complianceCondition ELSE cw.NextComplianceCondition END,
                        currentBalance = CASE WHEN cw.NextAccountStatus IN ('62','64') THEN 0
											  WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator = 2 THEN 0
											  WHEN cw.IsChargeOffData = 1 AND cw.nextinformationindicator in ('E','F','G','H') THEN 0
											  WHEN cw.nextcurrentbalance > 0 THEN cw.nextcurrentbalance
                                              ELSE 0
                                         END,
                        originalcreditor = cw.nextoriginalcreditor,
                        creditorclassification = cw.NextCreditorClass,
                        accounttype = cw.accounttype,
                        paymenthistoryprofile = cw.paymenthistoryprofile,
						paymenthistorydate = @CurrentPaymentHistoryDate,
                        lastpaymentdate = cw.lastpaymentdate,
                        actualPayment = CASE WHEN ISNULL(DATEDIFF(d,cw.lastpaymentdate,GETDATE()),0) < 39 THEN  ISNULL(cw.actualpaymentamount,0) ELSE 0 END,
                        lastupdated = CASE WHEN ( (cw.NextAccountStatus <> ISNULL(cmw.AccountStatus,'') OR  cw.NextAccountStatus <> COALESCE(cmw.LastAccountStatus,cmw.AccountStatus,''))
													OR (ISNULL(cw.NextSpecialComment, '') <> ISNULL(cmw.SpecialComment, '')  OR ISNULL(cw.NextSpecialComment, '') <> ISNULL(cmw.LastSpecialComment,''))
													OR cw.nextoriginalcreditor <> ISNULL(cmw.originalcreditor,'')
													OR cw.NextCreditorClass <> ISNULL(cmw.creditorclassification,'')
													OR cw.accounttype <> ca.accounttype
													OR (cw.IsChargeOffData = 1 AND cw.SoldToPurchasedFrom <> ISNULL(cmw.SoldToPurchasedFrom,''))
												) 
												OR (  (ISNULL(cw.NextComplianceCondition,'') <> ISNULL(cmw.ComplianceCondition,'') OR ISNULL(cw.NextComplianceCondition,'') <> ISNULL(cmw.LastComplianceCondition,''))  AND ISNULL(cw.NextComplianceCondition,'') <> '')	
												
											THEN GETDATE() 
										WHEN cw.IsChargeOffData = 1 AND ( ISNULL(ca.ConsumerAccountNumber,'') <> CAST(cw.number AS varchar(30)) 
										OR ISNULL(ca.ChargeOffAmount,0) <> cw.ChargeOffAmount  
										OR ISNULL(ca.CreditLimit,0) <> cw.CreditLimit
										OR ISNULL(ca.SecondaryAgencyIdenitifier,'') <> cw.SecondaryAgencyIdenitifier
										OR ISNULL(ca.SecondaryAccountNumber,'') <> cw.SecondaryAccountNumber
										OR ISNULL(ca.MortgageIdentificationNumber,'')<> cw.MortgageIdentificationNumber )
											THEN GETDATE()
										ELSE lastupdated END,
                        billingdate = CASE  WHEN @is1stparty = 'TRUE' AND cw.NextAccountStatus IN ('62','64') AND  cw.specialnote = 'IDT' THEN GETDATE() --LAT-10392 Premier Bankcard - Custom Credit Bureau Request
								            WHEN  cw.NextAccountStatus IN ('62','64') THEN ISNULL(cw.lastpaymentdate,GETDATE())
											WHEN cw.IsChargeOffData = 1 AND  cw.PortfolioIndicator = 2 THEN ISNULL(cw.PortfolioSoldDate,GETDATE())  
											WHEN (cw.NextAccountStatus <> cmw.AccountStatus OR  cw.NextAccountStatus <> ISNULL(cmw.LastAccountStatus,cmw.AccountStatus)) THEN GETDATE() 
											ELSE GETDATE() END,
                        amountpastdue = CASE WHEN cw.NextAccountStatus IN ('11','62','64') THEN 0 
											 WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator = 2 THEN 0
											 WHEN cw.nextinformationindicator in ('E','F','G','H','C','D') THEN 0
                        					 WHEN cw.nextcurrentbalance > 0 THEN cw.nextcurrentbalance
											 ELSE 0 END,
											 
                        SoldToPurchasedFrom = CASE WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator IS NOT NULL THEN cw.SoldToPurchasedFrom
												   ELSE '' END,
						PortfolioIndicator = CASE WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator IS NOT NULL THEN cw.PortfolioIndicator
												   ELSE 0 END,						   
                        ConsumerAccountNumber = CASE WHEN cw.IsChargeOffData = 1 AND ISNULL(ca.ConsumerAccountNumber,'') = '' THEN CAST(cw.number AS varchar(30)) ELSE ca.ConsumerAccountNumber END,   
                        ChargeOffAmount = CASE WHEN cw.NextAccountStatus NOT IN ('64','97') THEN 0.00 ELSE cw.ChargeOffAmount END, 
                        CreditLimit = CASE WHEN cw.IsChargeOffData = 1 AND ISNULL(ca.CreditLimit,0) = 0 THEN cw.CreditLimit ELSE ca.CreditLimit END,
                        SecondaryAgencyIdenitifier = CASE WHEN cw.IsChargeOffData = 1 AND ISNULL(ca.SecondaryAgencyIdenitifier,'') = '' THEN cw.SecondaryAgencyIdenitifier ELSE ca.SecondaryAgencyIdenitifier END,
						SecondaryAccountNumber = CASE WHEN cw.IsChargeOffData = 1 AND ISNULL(ca.SecondaryAccountNumber,'') = '' THEN cw.SecondaryAccountNumber ELSE ca.SecondaryAccountNumber END,
						MortgageIdentificationNumber = CASE WHEN cw.IsChargeOffData = 1 AND ISNULL(ca.MortgageIdentificationNumber,'') = '' THEN cw.MortgageIdentificationNumber ELSE ca.MortgageIdentificationNumber END

						OUTPUT INSERTED.accountID INTO #OutParms1

                FROM    #cbrwork cw
                        INNER JOIN dbo.cbr_accounts ca ON ca.accountid = cw.number
                        LEFT OUTER JOIN #cbrmetrowork cmw ON cmw.number = cw.number
                                                          
                WHERE   ca.primarydebtorid = cw.primarydebtorid and cw.debtorid = cw.primarydebtorid 
						--AND cw.reportable = 1
						AND	( 
						          (
								    ISNULL(cw.NextAccountStatus,'') <> ISNULL(cmw.AccountStatus,'') OR  ISNULL(cw.NextAccountStatus,'') <> COALESCE(cmw.LastAccountStatus,cmw.AccountStatus,'')
								  )
								  OR (ISNULL(cw.NextSpecialComment, '') <> ISNULL(cmw.SpecialComment, '') OR ISNULL(cw.NextSpecialComment, '') <> ISNULL(cmw.LastSpecialComment,''))
								  OR (ISNULL(cw.NextComplianceCondition,'') <> ISNULL(cmw.ComplianceCondition,'') OR ISNULL(cw.NextComplianceCondition,'') <> ISNULL(cmw.LastComplianceCondition,''))
								  OR ISNULL(cw.nextoriginalcreditor,'') <> ISNULL(cmw.originalcreditor,'')
								  OR ISNULL(cw.NextCreditorClass,'') <> ISNULL(cmw.creditorclassification,'')
								  OR cw.accounttype <> ca.accounttype
								  OR ISNULL(cw.NextInformationIndicator,'') <> ISNULL(cmw.InformationIndicator,'') 
										--OR ISNULL(cmw.InformationIndicatorOverride,0) = 1
								  OR ISNULL(cw.PortfolioIndicator,0) <> ISNULL(cmw.LastPortfolioIndicator,0)
							)	
						OR ISNULL(ca.PaymentHistoryDate,'') <> ISNULL(@CurrentPaymentHistoryDate,'')
					    OR ISNULL(ca.PaymentHistoryProfile,'') <> ISNULL(cw.PaymentHistoryProfile,'')
						-- LAT-10172 Premier - Incorrect Amount Past Due	
						OR  (ISNULL(cw.NextAccountStatus,'') = '11' AND ISNULL(ca.amountpastdue,'') <> 0)
						AND NOT (ca.accountstatus IN ( 'DA', 'DF' ) AND ISNULL(cmw.LastAccountStatus,'') IN ( 'DA', 'DF' ));
                
				--'_____________________closed date update_________________'
				UPDATE  dbo.cbr_accounts
				SET     ClosedDate = CASE WHEN cw.IsChargeOffData = 0 THEN cw.ClosedDate ELSE cw.mcoClosedDate END
				FROM    #cbrwork cw
                INNER JOIN dbo.cbr_accounts ca ON ca.accountid = cw.number         


--print '________1st cbr accounts update; ______________'     
                                                          
                                                                             
                  
                IF EXISTS (select top 1 * from #OutParms1)
                    BEGIN	
                        SET @CbrAcctUpdated = 1
                        INSERT  INTO dbo.cbr_audit
                                ( accountid,
                                  debtorid,
                                  datecreated,
                                  [user],
                                  comment )
                                SELECT  op.AccountID,
                                        NULL,
                                        GETDATE(),
                                        'SYSTEM',
                                        cac.audittext
                                FROM    #OutParms1 op
                                        CROSS JOIN #CbrAuditComments cac 
                                WHERE   cac.audittype = 1 ;             
                    END
                    
--print '________1st cbr accounts audit; ______________'     

                IF NOT EXISTS (select top 1 * from #OutParms1)
                    OR @accountid IS NULL 
                    BEGIN
	
						-- existing account that did not have a status change but received a payment
					
                        UPDATE  dbo.cbr_accounts
                        SET     currentbalance = CASE WHEN cw.NextAccountStatus IN ('62','64') THEN 0
													WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator = 2 THEN 0
													WHEN cw.IsChargeOffData = 1 AND cw.nextinformationindicator in ('E','F','G','H') THEN 0
													WHEN cw.nextcurrentbalance > 0 THEN cw.nextcurrentbalance
													ELSE 0
                                         END,
                                amountpastdue = CASE WHEN cw.NextAccountStatus IN ('11','62','64') THEN 0 
													WHEN cw.IsChargeOffData = 1 AND cw.PortfolioIndicator = 2 THEN 0
													WHEN cw.nextinformationindicator in ('E','F','G','H','C','D') THEN 0
                        							WHEN cw.nextcurrentbalance > 0 THEN cw.nextcurrentbalance
													ELSE 0 END,
								paymenthistoryprofile = cw.paymenthistoryprofile,
								paymenthistorydate = @CurrentPaymentHistoryDate,
								lastpaymentdate = cw.lastpaymentdate,
								actualPayment = CASE WHEN ISNULL(DATEDIFF(d,cw.lastpaymentdate,GETDATE()),0) < 39 THEN  ISNULL(cw.actualpaymentamount,0) ELSE 0 END,
								lastupdated = CASE WHEN (ROUND(ca.currentbalance,0,1) <> ROUND(coalesce(cmw.openbalance,cw.nextcurrentbalance),0,1)) then GETDATE() 
													WHEN cw.IsChargeOffData = 1 AND ( ISNULL(ca.ConsumerAccountNumber,'') <> CAST(cw.number AS varchar(30)) 
																						OR ISNULL(ca.ChargeOffAmount,0) <> cw.ChargeOffAmount  
																						OR ISNULL(ca.CreditLimit,0) <> cw.CreditLimit
																						OR ISNULL(ca.SecondaryAgencyIdenitifier,'') <> cw.SecondaryAgencyIdenitifier
																						OR ISNULL(ca.SecondaryAccountNumber,'') <> cw.SecondaryAccountNumber
																						OR ISNULL(ca.MortgageIdentificationNumber,'')<> cw.MortgageIdentificationNumber )
														 THEN GETDATE()
													else lastupdated END,
                                
                                billingdate = CASE WHEN @is1stparty = 'TRUE' AND cw.NextAccountStatus IN ('62','64') AND  cw.specialnote = 'IDT' THEN GETDATE() --LAT-10392 Premier Bankcard - Custom Credit Bureau Request
								                WHEN cw.NextAccountStatus IN ('62','64') THEN ISNULL(cw.lastpaymentdate,GETDATE())
												WHEN cw.IsChargeOffData = 1 AND  cw.PortfolioIndicator = 2 THEN ISNULL(cw.PortfolioSoldDate,GETDATE())  
												ELSE GETDATE() END,
                                
                                ConsumerAccountNumber = CASE WHEN cw.IsChargeOffData = 1 AND ISNULL(ca.ConsumerAccountNumber,'') = '' THEN CAST(cw.number AS varchar(30)) ELSE ca.ConsumerAccountNumber END,   
                                ChargeOffAmount = CASE WHEN cw.NextAccountStatus NOT IN ('64','97') THEN 0.00 ELSE cw.ChargeOffAmount END, 
                                CreditLimit = CASE WHEN cw.IsChargeOffData = 1 AND ISNULL(ca.CreditLimit,0) = 0 THEN cw.CreditLimit ELSE ca.CreditLimit END,
                                SecondaryAgencyIdenitifier = CASE WHEN cw.IsChargeOffData = 1 AND ISNULL(ca.SecondaryAgencyIdenitifier,'') = '' THEN cw.SecondaryAgencyIdenitifier ELSE ca.SecondaryAgencyIdenitifier END,
								SecondaryAccountNumber = CASE WHEN cw.IsChargeOffData = 1 AND ISNULL(ca.SecondaryAccountNumber,'') = '' THEN cw.SecondaryAccountNumber ELSE ca.SecondaryAccountNumber END,
								MortgageIdentificationNumber = CASE WHEN cw.IsChargeOffData = 1 AND ISNULL(ca.MortgageIdentificationNumber,'') = '' THEN cw.MortgageIdentificationNumber ELSE ca.MortgageIdentificationNumber END
												
								OUTPUT INSERTED.accountID INTO #OutParms2				 		  	  					   
				FROM    #cbrwork cw
                        INNER JOIN dbo.cbr_accounts ca ON ca.accountid = cw.number
                        LEFT OUTER JOIN #cbrmetrowork cmw ON cmw.number = cw.number
                                                        
                WHERE   ca.primarydebtorid = cw.primarydebtorid AND cw.debtorid = cw.primarydebtorid
                                AND (
										(
										    ROUND(ca.currentbalance,0,1) <> ROUND(coalesce(cmw.openbalance,cw.nextcurrentbalance),0,1)
										)
									    OR  (cw.IsChargeOffData = 1 AND cw.nextinformationindicator in ('E','F','G','H'))
									    OR	(ISNULL(ca.lastpaymentdate,'19000101') <> ISNULL(cw.lastpaymentdate,'19000101')) 
									    OR	(ROUND(ISNULL(ca.actualPayment,0),0,1) <> ROUND(ISNULL(cw.actualpaymentamount,0),0,1))
									    OR  (@CurrentPaymentHistoryDate <> ISNULL(ca.paymenthistorydate,''))
									)
								-- LAT-10172 Premier - Incorrect Amount Past Due
								OR  (ISNULL(cw.NextAccountStatus,'') = '11' AND ISNULL(ca.amountpastdue,'') <> 0)
                                AND NOT (ca.accountstatus IN ( 'DA', 'DF' ) AND ISNULL(cmw.LastAccountStatus,'') IN ( 'DA', 'DF' ))
								
--print '________2nd cbr accounts update; ______________'     

                        IF EXISTS (select top 1 * from #OutParms2) 
                            BEGIN
                                SET @CbrAcctUpdated = 1
                                INSERT  INTO dbo.cbr_audit
                                        ( accountid,
                                          debtorid,
                                          datecreated,
                                          [user],
                                          comment )
                                        SELECT  op.AccountID,
                                                NULL,
                                                GETDATE(),
                                                'SYSTEM',
                                                cac.audittext
                                        FROM   #OutParms2 op				  
                                                CROSS JOIN #CbrAuditComments cac 																								  
                                        WHERE   cac.audittype = 2;
                            END
                            
--print '________2nd cbr accounts audit; ______________'     

                    END

            END ;--If @action


		--Delete DA and 62 accts that have last been reported as such, default behavior for 3rd party--should be moved to post history?
		IF @initializationrun <> 'I'  --and @is1stparty = 'False'--(LAT-10202 Premier Bankcard - Credit Bureau re-reporting)
		BEGIN

			--cascading delete on foreign key for cbr_debtors
	        DELETE  FROM dbo.cbr_accounts
	        FROM    dbo.cbr_accounts ca
	                INNER JOIN #cbrwork cw ON cw.number = ca.accountid
	                LEFT OUTER JOIN #cbrmetrowork cmw ON cmw.number = cw.number
	        WHERE   (      
			             ca.accountid = @accountid
	                     OR @accountid IS NULL
				    )
	                AND  cw.primarydebtorid > 0
	                AND (
					         ( 
							    cmw.lastaccountstatus IN ( '62', '64', 'DA' )
	                            AND cw.nextaccountstatus IN ('62', '64')
	                            AND cmw.accountstatus IN ( '62', '64', 'DA' )
						     )
	                       OR 
						     ( 
							     ( 
								    cmw.lastaccountstatus IS NULL
	                                OR cmw.lastaccountstatus IN ( 'DA', 'DF' ) 
								 )
	                             AND cw.nextaccountstatus IN ( 'DA', 'DF' )
	                             AND cmw.accountstatus IN ( 'DA', 'DF' ) 
	                             AND @is1stparty = 'FALSE'
							 )
						)
	                 OR ( 
					         cmw.lastaccountstatus IS NULL
	                         AND cw.nextaccountstatus IN ( 'DA', 'DF' )
	                         AND cmw.accountstatus IN ('93', '11', '71', '78', '80', '82', '83', '84', '97') 
	                         AND @is1stparty = 'FALSE'
						) 

		END;
		
--print '________DELETE Rpt Pif/Sif; ______________'     

		-- New accounts to report

        DECLARE @updatedate DATETIME;
        SELECT  @updatedate = GETDATE();

        IF @action = 'insert'
            OR @accountid IS NULL 
            BEGIN
			
                INSERT  INTO dbo.cbr_accounts
                        ( accountid,
                          customerid,
                          primarydebtorid,
                          portfoliotype,
                          accounttype,
                          accountstatus,
                          originalloan,
                          actualpayment,
                          currentbalance,
                          amountpastdue,
                          termsduration,
                          specialcomment,
                          compliancecondition,
                          opendate,
                          billingdate,
                          delinquencydate,
                          closeddate,
                          lastpaymentdate,
                          originalcreditor,
                          creditorclassification,
                          lastupdated,
                          lastreported,
                          batchid,
                          [ConsumerAccountNumber],
                          [ChargeOffAmount],
                          [PaymentHistoryProfile],
                          [PaymentHistoryDate],
                          [CreditLimit],
                          [SecondaryAgencyIdenitifier],
						  [SecondaryAccountNumber],
						  [MortgageIdentificationNumber],
						  [PortfolioIndicator],
						  [SoldToPurchasedFrom])
						  OUTPUT INSERTED.accountID INTO #OutParms3				 		  	  					   
                SELECT	DISTINCT
                                cw.number,					--as [accountid]
                                cw.customerid,				--as [customerid]
                                cw.primarydebtorid, 		--as [primarydebtorid]
                                cw.portfoliotype,			--as [portfoliotype],
                                cw.accounttype,				--as [accounttype],
                                cw.nextaccountstatus,		--as [accountstatus],
                                CASE WHEN [cw].[IsChargeOffData] = 0 THEN [cw].[originalprincipal] ELSE [cw].[HighestCredit] END,		--as [originalloan] or Highest Credit,
                                CASE WHEN ISNULL(DATEDIFF(d,cw.lastpaymentdate,cmw.DateReported),-1) < 0 AND ISNULL(DATEDIFF(d,cw.lastpaymentdate,GETDATE()),0) < 39 THEN  ISNULL(cw.actualpaymentamount,0) ELSE 0 END,	--as [actualpayment], 
                                CASE WHEN cw.nextaccountstatus IN ('62','64') THEN 0
									 WHEN [cw].[IsChargeOffData] = 1 AND cw.nextinformationindicator in ('E','F','G','H') THEN 0
									 WHEN cw.IsChargeOffData = 1 AND  cw.PortfolioIndicator = 2 THEN 0
									 WHEN cw.nextcurrentbalance > 0 THEN cw.nextcurrentbalance
                                     ELSE 0
                                END, --as [currentbalance],
                                CASE WHEN cw.nextaccountstatus IN ('11','62','64') THEN 0
									 WHEN cw.nextinformationindicator in ('E','F','G','H','C','D') THEN 0
									 WHEN cw.IsChargeOffData = 1 AND  cw.PortfolioIndicator = 2 THEN 0
									 WHEN cw.nextcurrentbalance > 0 THEN cw.nextcurrentbalance
                                     ELSE 0
                                END, --as [amountpastdue],
                                CASE [cw].[portfoliotype] WHEN 'O' THEN '001' WHEN 'R' THEN 'REV' WHEN 'M' THEN [cw].[TermsDuration] WHEN 'I' THEN [cw].[TermsDuration] WHEN 'C' THEN 'LOC' ELSE '001' END,						--as [termsduration],
                                cw.nextspecialcomment,		--as [specialcomment],
                                CASE WHEN cw.StatusIsDisputed = 1 AND ISNULL(cw.nextcompliancecondition,'') = '' THEN 'XB'
									 ELSE cw.nextcompliancecondition END, --as [compliancecondition
                                CASE WHEN [cw].[IsChargeOffData] = 0 THEN [cw].[receiveddate] ELSE ISNULL([cw].[ContractDate],[cw].[receiveddate]) END,			--as [opendate],
                                CASE WHEN @is1stparty = 'TRUE' AND cw.NextAccountStatus IN ('62','64') AND  cw.specialnote = 'IDT' THEN GETDATE() -- LAT-10392 Premier Bankcard - Custom Credit Bureau Request
								     WHEN cw.nextaccountstatus IN ('62','64') THEN isnull(cw.lastpaymentdate,GETDATE()) 
									 WHEN cw.IsChargeOffData = 1 AND  cw.PortfolioIndicator = 2 THEN ISNULL(cw.PortfolioSoldDate,GETDATE()) 
                                 ELSE GETDATE() END,		--as [billingdate], 
                                ISNULL(cw.delinquencydate,'1900-01-01'),			--as [delinquencydate],
                                CASE WHEN [cw].[IsChargeOffData] = 0 THEN [cw].[ClosedDate] ELSE [cw].[mcoClosedDate] END,	--as [closeddate],
                                cw.lastpaymentdate,			--as [lastpaymentdate], 
                                cw.nextoriginalcreditor,	--as [originalcreditor]
                                cw.nextcreditorclass,		--as [creditorclassification]
                                @updatedate,				--as [lastupdated]
                                CASE WHEN @initializationrun = 'I' THEN '01/01/1900'
                                     ELSE cmw.datereported
                                END,	--as [lastreported]  --need metro2 date here
                                @batchid,					--as [batchid]
                                CASE WHEN [cw].[IsChargeOffData] = 0 THEN CAST([cw].[number] AS varchar(30)) ELSE [cw].[ConsumerAccountNumber] END,   -- ConsumerAccountNumber
                                CASE WHEN cw.NextAccountStatus NOT IN ('64','97') THEN 0.00 ELSE cw.ChargeOffAmount END, -- OriginalChargeOffAmount
                                CASE WHEN [cw].[IsChargeOffData] = 0 THEN '  ' ELSE [cw].[PaymentHistoryProfile] END,
                                CASE WHEN [cw].[IsChargeOffData] = 0 THEN null ELSE @CurrentPaymentHistoryDate END,
                                CASE WHEN [cw].[IsChargeOffData] = 0 THEN 0.00 ELSE [cw].[CreditLimit] END,
                                CASE WHEN [cw].[IsChargeOffData] = 0 THEN '' ELSE [cw].[SecondaryAgencyIdenitifier] END,
								CASE WHEN [cw].[IsChargeOffData] = 0 THEN '' ELSE [cw].[SecondaryAccountNumber] END,
								CASE WHEN [cw].[IsChargeOffData] = 0 THEN '' ELSE [cw].[MortgageIdentificationNumber] END,
								CASE WHEN [cw].[IsChargeOffData] = 0 THEN NULL ELSE [cw].[PortfolioIndicator] END,
								CASE WHEN [cw].[IsChargeOffData] = 0 THEN NULL ELSE [cw].[SoldToPurchasedFrom] END

                        FROM    #cbrwork cw
                                LEFT OUTER JOIN #cbrmetrowork cmw ON cmw.number = cw.number
                                                                     AND cmw.primarydebtorid = cw.primarydebtorid --
                                LEFT OUTER JOIN cbr_accounts ca ON ca.accountid = cw.number
                                
                        WHERE   cw.reportable = 1
                                AND ca.accountid IS NULL
                                AND cw.primarydebtorID > 0
                                AND cw.delinquencydate IS NOT NULL  -- occurs when previously reported account has delinquencydate nulled
                                AND (
									    cw.NextAccountStatus  IN ('93', '11', '71', '78', '80', '82', '83', '84', '97')
									OR  cmw.lastaccountstatus IN ('93', '11', '71', '78', '80', '82', '83', '84', '97') 
									OR (cw.NextAccountStatus  IN ('62', '64', 'DA','DF' ) AND (@initializationrun = 'I')) -- OR @is1stparty = 'TRUE'))--(LAT-10202 Premier Bankcard - Credit Bureau re-reporting)
									OR (cmw.lastaccountstatus IN ('62', '64') AND cw.NextAccountStatus IN ('DA','DF') AND (cw.deletereturns = 1 OR cw.nextcreditorclass = '02'))
									OR (cmw.lastaccountstatus IN ('93', '11', '71', '78', '80', '82', '83', '84', '97') AND cw.CbrOutofStatute = 1)
									OR (cw.cbrenabled = 0 AND cmw.lastaccountstatus IN ('93', '11', '71', '78', '80', '82', '83', '84', '97'))
                                    )  
                                
--print '________insert cbr accounts ; ______________'    
 
						IF EXISTS (select top 1 * from #OutParms3)
							BEGIN
								SET @CbrAcctCreated = 1
								INSERT  INTO dbo.cbr_audit
										( accountid,
										  debtorid,
										  datecreated,
										  [user],
										  comment )
										SELECT  Distinct 
												op.AccountID,
												NULL,
												GETDATE(),
												'SYSTEM',
												CASE WHEN @initializationrun <> 'I' THEN cac.audittext
													 ELSE '(I)nitial ' + ca.accountstatus + 'generated - '
												END + ' ' + ca.accounttype AS audittext
										FROM    #OutParms3 op
												LEFT OUTER JOIN cbr_accounts ca ON ca.accountid = op.AccountID
												CROSS JOIN #CbrAuditComments cac 
										WHERE   cac.audittype = 6 

							END
							
--print '________insert cbr accounts audit; ______________'     

            END ;--If @action

		-- When P1=AccountID - If the account has never been reported and the next action is to delete then don't bother evaluating debtors
        IF @accountid IS NOT NULL
            AND @initializationrun <> 'I'
            AND ( SELECT TOP 1 cmw.lastaccountstatus FROM #cbrmetrowork cmw ) IS NULL
            AND ( SELECT TOP 1 cw.nextaccountstatus FROM #cbrwork cw WHERE cw.primarydebtorid > 0 ) IN ('DA','DF') 
            BEGIN 
	       		SET @Context_Info = cast('' AS VARBINARY(30))
				SET CONTEXT_INFO @Context_Info
				RETURN 0 
			END; 

 
		--remove cbr debtors that are no longer responsible or have been excluded and have a Z/delete next ecoacode 
		--and not previously reported
 
        DELETE  FROM dbo.cbr_debtors
        FROM    dbo.cbr_debtors cd
                INNER JOIN #cbrwork AS cw ON cw.debtorid = cd.debtorid
                LEFT OUTER JOIN #cbrmetrowork cmw ON cmw.number = cw.number
        WHERE   cw.nextecoacode = 'Z'
                AND cmw.debtorid <> cw.primarydebtorid
                AND @initializationrun <> 'I'
                AND ISNULL(cmw.lastecoacode,'') IN ('','Z');
                
--print '________DELETE excluded debtors; ______________'     


		--update existing debtors
        UPDATE  cbr_debtors
        SET     ecoacode = cw.nextecoacode,
                informationindicator = cw.nextinformationindicator,
                transactiontype = cw.NextTransactionType, 
                [name] = LEFT(ISNULL(d.[name],''),30),
                surname = LEFT(ISNULL(d.[lastname],''),50),
                firstname = LEFT(ISNULL(d.firstname,''),50),
                middlename = LEFT(ISNULL(d.middlename,''),50),
                suffix = LEFT(ISNULL(d.suffix,''),50),
                generationcode = CASE WHEN UPPER(d.suffix) = 'SENIOR'
                                           OR d.suffix = 'SR.'
                                           OR d.suffix = 'SR' THEN 'S'
                                      WHEN UPPER(d.suffix) = 'JUNIOR'
                                           OR d.suffix = 'JR.'
                                           OR d.suffix = 'JR' THEN 'J'
                                      WHEN UPPER(d.suffix) = 'II' THEN '2'
                                      WHEN UPPER(d.suffix) = 'III' THEN '3'
                                      WHEN UPPER(d.suffix) = 'IV' THEN '4'
                                      WHEN UPPER(d.suffix) = 'V' THEN '5'
                                      WHEN UPPER(d.suffix) = 'VI' THEN '6'
                                      WHEN UPPER(d.suffix) = 'VII' THEN '7'
                                      WHEN UPPER(d.suffix) = 'VIII' THEN '8'
                                      WHEN UPPER(d.suffix) = 'IX' THEN '9'
                                      ELSE ''
                                 END,
                --ssn = ISNULL(dbo.validatessn(d.ssn), ''),--tech debt
                ssn = LEFT(ISNULL(d.ssn, ''),15),
                
                
                address1 = LEFT(ISNULL(d.street1,''),50),
                address2 = LEFT(ISNULL(d.street2,''),50),
                city = LEFT(ISNULL(d.city,''),50),
                [state] = ISNULL(d.state,''),
                zipcode = d.zipcode,
                dob = CASE WHEN d.dob > '1900-01-01' and d.dob <> ISNULL(cd.dob,'') THEN d.dob
                                 ELSE cd.dob
                            END,
                lastupdated = CASE WHEN cw.nextecoacode <> ISNULL(cmw.ecoacode, '') THEN GETDATE()
								   WHEN cw.nextinformationindicator <> ISNULL(cmw.informationindicator,  '') THEN GETDATE() 
								   WHEN (cw.NextTransactionType <> ISNULL(cmw.TransactionType,'')) AND cw.NextTransactionType <> '' THEN GETDATE()
								   WHEN ISNULL(cd.dob,'19000101') <> ISNULL(d.dob,'19000101') THEN GETDATE()
								   WHEN ISNULL(cmw.AuthorizedUserAddress,'') <> ISNULL(AuthorizedUserSegment,'') THEN GETDATE()
							  ELSE lastupdated END,
				AuthorizedUserSegment = CASE WHEN cw.nextecoacode = 'T' then '' ELSE cmw.AuthorizedUserAddress END,
				Phone = cw.homephone,
				AddressIndicator = CASE WHEN d.mr = 'Y' THEN 'U' ELSE 'N' END
							
		OUTPUT INSERTED.accountID INTO #OutParms4
        FROM    #cbrwork cw
                LEFT OUTER JOIN #cbrmetrowork cmw ON cmw.number = cw.number
                                                AND cmw.debtorid = cw.debtorid
                INNER JOIN dbo.cbr_debtors cd ON cd.accountid = cw.number
                                                 AND cd.debtorid = cw.debtorid
                INNER JOIN debtors d ON d.debtorid = cw.debtorid
        WHERE   
				cw.nextecoacode <> ISNULL(cmw.ecoacode, '')
                OR cw.nextinformationindicator <> ISNULL(cmw.informationindicator, '')
                OR cw.NextTransactionType <> ISNULL(cmw.TransactionType,'')  
				OR ISNULL(cd.dob,'19000101') <> ISNULL(d.dob,'19000101')
				OR ISNULL(cmw.AuthorizedUserAddress,'') <> ISNULL(AuthorizedUserSegment,'')
				OR ISNULL(cmw.RptdDebtorSSN,'') <> isnull(d.ssn,'')
				OR ISNULL(cmw.RptdDebtorLastName,'') <> LEFT(ISNULL(d.LastName,''),30)
				OR ISNULL(cmw.RptdDebtorFirstName,'') <> LEFT(ISNULL(d.FirstName,''),30)
				OR ISNULL(cmw.RptdDebtorMiddleName,'') <> LEFT(ISNULL(d.MiddleName,''),30)
				OR ISNULL(cmw.RptdDebtorSuffix,'') <> LEFT(ISNULL(d.Suffix,''),30)
				OR ISNULL(cmw.RptdDebtorGenerationCode,'') <> LEFT(ISNULL(d.prefix,''),30)
				OR cmw.RptdDebtorStreet1 <> cw.DebtorStreet1
			    OR cmw.RptdDebtorStreet2 <> cw.DebtorStreet2
			    OR cmw.RptdDebtorCity <> cw.DebtorCity
			    OR cmw.RptdDebtorState <> cw.DebtorState
			    OR cmw.RptdDebtorZipCode <> ISNULL(cw.DebtorZipcode, '')
			    OR cd.AddressIndicator <> ISNULL(d.mr,'')
			    ;

--print '________1st cbr debtors update ; ______________'     
			
        BEGIN TRY

            INSERT  INTO dbo.cbr_debtors
                    ( debtorid,
                      debtorseq,
                      accountid,
                      transactionType,
                      [name],
                      surname,
                      firstName,
                      middleName,
                      suffix,
                      generationCode,
                      ssn,
                      dob,
                      phone,
                      ecoaCode,
                      informationIndicator,
                      countryCode,
                      address1,
                      address2,
                      city,
                      state,
                      zipcode,
                      addressIndicator,
                      residenceCode,
                      lastUpdated,
                      AuthorizedUserSegment  ) OUTPUT INSERTED.accountID INTO #OutParms5
                    SELECT	DISTINCT
                            cw.DebtorID AS debtorID,
                            d.seq AS debtorseq,
                            cw.number AS accountid,
                            cw.NextTransactionType AS transactiontype,--'' AS transactiontype,
                            LEFT(ISNULL(LTRIM(d.[name]), ''),30) AS [name],
                            LEFT(d.lastname,50) AS surname,
                            LEFT(d.firstname,50) AS firstname,
                            LEFT(d.middlename,50)AS middleName,
                            LEFT(d.suffix,50)AS suffix,
                            CASE WHEN UPPER(d.suffix) = 'SENIOR'
                                      OR d.suffix = 'SR.'
                                      OR d.suffix = 'SR' THEN 'S'
                                 WHEN UPPER(d.suffix) = 'JUNIOR'
                                      OR d.suffix = 'JR.'
                                      OR d.suffix = 'JR' THEN 'J'
                                 WHEN UPPER(d.suffix) = 'II' THEN '2'
                                 WHEN UPPER(d.suffix) = 'III' THEN '3'
                                 WHEN UPPER(d.suffix) = 'IV' THEN '4'
                                 WHEN UPPER(d.suffix) = 'V' THEN '5'
                                 WHEN UPPER(d.suffix) = 'VI' THEN '6'
                                 WHEN UPPER(d.suffix) = 'VII' THEN '7'
                                 WHEN UPPER(d.suffix) = 'VIII' THEN '8'
                                 WHEN UPPER(d.suffix) = 'IX' THEN '9'
                                 ELSE ''
                            END AS generationcode,
                            
                            --ISNULL(dbo.validatessn(d.ssn), '') AS ssn,
                            LEFT(ISNULL(d.ssn, ''),15) AS ssn,
                            
                            CASE WHEN d.dob > '1900-01-01' THEN d.dob
                                 ELSE NULL
                            END AS dob,
                            LEFT(COALESCE(cw.homephone,d.homephone,''),30) AS phone,
                            cw.NextEcoaCode AS ecoacode,
                            cw.NextInformationIndicator AS informationIndicator,
                            'US' AS countrycode,
                            LEFT(ISNULL(d.street1, ''),50) AS address1,
                            LEFT(ISNULL(d.street2, ''),50) AS address2,
                            LEFT(ISNULL(d.city, ''),50) AS city,
                            ISNULL(d.state, '') AS state,
                            
                            --ISNULL(dbo.stripnondigits(d.zipcode), '') AS zipcode,
                            ISNULL(d.zipcode, '') AS zipcode,

                            CASE d.mr
                              WHEN 'Y' THEN 'U'
                              ELSE 'N'
                            END AS addressindicator,
                            ' ' AS residencecode,
                            GETDATE() AS lastupdated,
                            ISNULL(cmw.AuthorizedUserAddress,'') 

                    
                    FROM    #cbrwork cw
                            INNER JOIN cbr_accounts ca ON ca.accountid = cw.number
                            INNER JOIN dbo.debtors d ON d.DebtorID = cw.DebtorID
                            LEFT OUTER JOIN #cbrmetrowork cmw ON cmw.number = cw.number
                                                                 AND cmw.debtorid = cw.debtorid
                            LEFT OUTER JOIN cbr_debtors cd ON cd.debtorid = cw.debtorid

                    WHERE   cd.debtorid IS NULL
                            AND d.cbrExclude = 0
                            AND cw.debtorexceptions = 0 
							AND (cw.reportable = 1 OR cw.IsAuthorizedAccountUser = 'True')
        END TRY
        BEGIN CATCH
            SELECT * FROM  dbo.fnGetErrorInfo()
            SET @Context_Info = cast('' AS VARBINARY(30))
			SET CONTEXT_INFO @Context_Info
			RETURN 1
        END CATCH;
        
--print '________cbr debtors insert ; ______________'     


		--pending updates required for passage of time when implementing mid cycle
		
		IF @ReEvaluate = 1 BEGIN
		
				Create Table #PendingNonEvaluated  (AccountID INT);
		
				With pendingAccts as
					(Select Accountid From #Outparms1
					Union 
					Select Accountid from #OutParms2),
					AcctUpdates as 
					(Select Distinct Accountid from #OutParms4
					EXCEPT
					Select Accountid from pendingAccts)
					
				Insert Into #PendingNonEvaluated (AccountID)  
				Select Accountid From AcctUpdates 
				Union select a.Accountid from cbr_accounts a 
					Where a.lastUpdated between ISNULL(DATEADD(hh,1,a.lastReported),DATEADD(m,-1,a.lastupdated)) and convert(varchar(8),dateadd(hh,-1,GETDATE()),112) 
				Union select d.accountid from cbr_debtors d inner join cbr_accounts a on d.accountID = a.accountid
					Where d.lastUpdated between ISNULL(DATEADD(hh,1,a.lastReported),DATEADD(m,-1,d.lastupdated)) and convert(varchar(8),DATEADD(hh,-1,GETDATE()),112)
					;
				EXECUTE cbrUpdatePendingNonEvaluated_NoCursor;
					
		END;

--print '________pending updates execution ; ______________'     
		

        CBRUPDATES_EXIT:


		--master and debtors exceptions update


        UPDATE  dbo.master
        SET     dbo.master.cbrexception32 = cw.cbrexception
        FROM    #cbrwork cw
                INNER JOIN  dbo.master m ON cw.number = m.number
        WHERE  
					cw.primarydebtorid > 0
                AND cw.cbrenabled = 1
                AND cw.cbrexception <> cw.prvcbrexception
                AND cw.cbrprevent = 0;

--print '________master updates ; ______________'     

        UPDATE  dbo.debtors
        SET     dbo.debtors.cbrexception32 = cw.debtorexceptions
        FROM    #cbrwork cw
                INNER JOIN  dbo.debtors d ON cw.number = d.number
                                          AND cw.debtorid = d.debtorid
        WHERE   d.debtorid = cw.debtorid
                AND cw.cbrenabled = 1
                AND cw.cbrprevent = 0
                AND ( cw.prvdebtorexceptions <> cw.debtorexceptions );
		
--print '________debtor updates ; ______________'     

        StatuteTest:

		--may not be necessary since cbrprevent is now set...customer preference
        UPDATE  dbo.cbr_accounts
        SET     accountstatus = 'DA',
                specialcomment = NULL,
                compliancecondition = NULL,
                paymenthistoryprofile = cw.paymenthistoryprofile,
                paymenthistorydate = cw.[PaymentHistoryDateEoM]
                --lastupdated = GETDATE() --prevent reporting DA on outofstatute
        FROM    #cbrwork cw
                INNER JOIN #cbrmetrowork cmw ON cmw.number = cw.number
                INNER JOIN dbo.cbr_accounts ca ON ca.accountid = cmw.number
        WHERE   cw.CbrOutofStatute = 1
                AND cmw.accountStatus <> 'DA'; 
                --AND cw.IsChargeOffData = 0 

       --LAT-10739 user to alter DelinquencyDate when it gets changed in master table
       UPDATE  dbo.cbr_accounts
       SET delinquencydate = cw.delinquencydate
	   FROM    #cbrwork cw
                INNER JOIN #cbrmetrowork cmw ON cmw.number = cw.number
                INNER JOIN dbo.cbr_accounts ca ON ca.accountid = cmw.number

--print '________DA OutOfStatute cbr accounts ; ______________'     

        ERROR_REPORT:

        IF NOT OBJECT_ID('Cbr_Exceptions') IS NULL 
            BEGIN
                IF @accountid IS NULL 
                    TRUNCATE TABLE Cbr_Exceptions
            END;
 
        IF @accountid IS NOT NULL 
            DELETE  FROM cbr_exceptions
            WHERE   number = @accountid
            
		If Not Object_ID('tmpdb..#OutParms6') Is Null Drop Table #OutParms6;
		Create Table #OutParms6 (AccountID INT, DebtorID INT)
        
        INSERT  INTO [dbo].[cbr_exceptions]
                ( [Customer],
                  [Number],
                  [DebtorId],
                  [Reportable],
                  [StatusCbrReport],
                  [StatusCbrDelete],
                  [CbrEnabled],
                  [CbrExclude],
                  [Responsible],
                  [CbrException],
                  [OutOfStatute],
                  [DebtorExceptions],
                  [IsBusiness],
                  [CbrOverride],
                  [RptDtException],
                  [MinBalException] )
                  OUTPUT INSERTED.[Number],INSERTED.[DebtorId] INTO #OutParms6
                SELECT	DISTINCT
                        cw.Customer,
                        cw.Number,
                        cw.DebtorId,
                        cw.Reportable,
                        cw.StatusCbrReport,
                        cw.StatusCbrDelete,
                        cw.CbrEnabled,
                        cw.CbrExclude,
                        cw.Responsible,
                        cw.CbrException,
                        cw.CbrOutofStatute AS OutOfStatute,
                        cw.DebtorExceptions,
                        cw.IsBusiness,
                        cw.CbrOverride,
                        CASE WHEN cw.reportabledate > GETDATE() THEN 1
                             ELSE 0
                        END AS RptDtException,
                        CASE WHEN (cw.CurrentPrincipal < cw.minbalance  ) AND ISDATE(cmw.DateReported) = 0  AND cw.statusIsSIF =0 AND cw.statusISPIF =0 THEN 1
                             ELSE 0
                        END AS MinBalException
                FROM    #cbrwork cw
                        LEFT OUTER JOIN #cbrmetrowork cmw ON cmw.number = cw.number and cmw.DebtorID = cw.DebtorID
                WHERE   (cw.reportable = 0
                        AND cw.CbrEnabled = 1)
                        
                        OR (cw.cbrexception <> 0
                               OR cw.debtorexceptions <> 0)
                        OR isnull(cw.isbusiness,0) = 1
                        ;
                              
                INSERT  INTO dbo.cbr_audit
				( accountid,
				  debtorid,
				  datecreated,
				  [user],
				  comment )
				SELECT  AccountID,
						DebtorID,
						GETDATE(),
						'SYSTEM',
						cac.audittext
				FROM #OutParms6 
				CROSS JOIN #CbrAuditComments cac 
				WHERE cac.AuditType = 19;
                              
--print '________debtor exceptions ; ______________'     

		--	if the primary debtor has an exception or is prevented, remove the cbr_account/debtors entry
		
			IF @AccountID IS NULL BEGIN		
					DELETE  cbr_accounts 
					FROM cbr_accounts c
					INNER JOIN master m ON c.accountid = m.number
					LEFT OUTER JOIN cbr_exceptions x ON c.accountid = x.number AND c.primarydebtorID = x.debtorid
					WHERE   
					    m.cbrPrevent = 1 
						OR (
						        ISNULL(x.Number,0) = c.accountID  
						        AND (    
								         x.cbrexception <> 0 
										 OR x.Reportable = 0 
										 OR x.CbrEnabled = 0 
										 OR x.OutOfStatute = 1 
										 OR x.IsBusiness = 1 
										 OR x.RptDtException = 1 
										 OR x.MinBalException = 1 
								    )
						   )
					    OR PrimaryDebtorID IN (SELECT x.debtorID FROM cbr_exceptions x WHERE  x.debtorexceptions <> 0 ) ;

					DELETE FROM cbr_debtors WHERE debtorID IN  (SELECT x.debtorID FROM cbr_exceptions x WHERE x.debtorexceptions <> 0 ) ;
					
				   END
	        
			IF @AccountID IS NOT NULL BEGIN
					DELETE FROM cbr_accounts  
					WHERE 
					    accountid IN (select number from  master m where  m.number = @AccountID AND m.cbrprevent = 1)
					    OR PrimaryDebtorID IN (
						                         select x.debtorID from  cbr_exceptions x WHERE @AccountID = x.number 
												 and (
												        x.cbrexception <> 0 
														OR x.Reportable = 0 
														OR x.CbrEnabled = 0 
														OR x.OutOfStatute = 1 
														OR x.IsBusiness = 1 
														OR x.RptDtException = 1 
														OR x.MinBalException = 1
													 )
										      )
					   OR PrimaryDebtorID IN (SELECT x.debtorID FROM cbr_exceptions x WHERE x.number = @AccountID AND x.debtorexceptions <> 0 ) ;
					
					DELETE FROM cbr_debtors WHERE debtorID IN  (SELECT x.debtorID FROM cbr_exceptions x WHERE x.number = @AccountID AND x.debtorexceptions <> 0 ) ;

 				   END
            
 

 			--Cleanup non previously reported pending DA, DF, 62, 64 
			IF  @is1stparty = 'FALSE'
				BEGIN
				DELETE  FROM cbr_accounts
				WHERE   accountstatus IN ('62', '64','DA','DF')
						AND accountid NOT IN ( SELECT   accountid
											   FROM     cbr_metro2_accounts ) 
				END
				
				
			--Cleanup previously reported and pending DA, DF, 62, 64 
			--Depricated, if configured for delete returns and account closed by close returns report...paid in full may be deleted
 			--IF @initializationrun <> 'I' 
 			--	BEGIN
				--DELETE  FROM cbr_accounts
				--WHERE   accountstatus IN ('DA','DF','62','64')
				--		AND accountid IN ( SELECT   c1.accountid
				--						   FROM     cbr_metro2_accounts AS c1
				--									INNER JOIN ( SELECT c2.accountid,
				--														MAX(c2.fileid) AS fileid
				--												 FROM   cbr_metro2_accounts c2
				--												 GROUP BY c2.accountid ) AS c3 ON c1.accountid = c3.accountid
				--																				  AND c1.fileid = c3.fileid
				--																				  AND c1.accountstatus IN ('DA','DF','62','64')
				--									INNER JOIN master m ON m.number = c3.accountid)
																		   
				--END
				
				
				INSERT INTO cbr_audit ( accountid, debtorid, datecreated, [user],comment )
                                SELECT  cw.number, cw.DebtorID, GETDATE(), 'SYSTEM', 'Account Evaluated'
                                FROM    #cbrwork cw
                                LEFT OUTER JOIN #OutParms1 o1 ON cw.number = o1.accountid
                                LEFT OUTER JOIN #OutParms2 o2 ON cw.number = o2.accountid
                                LEFT OUTER JOIN #OutParms3 o3 ON cw.number = o3.accountid
                                LEFT OUTER JOIN #OutParms6 o6 ON cw.number = o6.accountid
                                WHERE ISNULL(cw.AuditCommentKey,0) = 0 
									AND o1.accountid IS NULL AND o2.accountid IS NULL AND o3.accountid IS NULL AND o6.accountid IS NULL;				


		SET @Context_Info = cast('' AS VARBINARY(30));
		SET CONTEXT_INFO @Context_Info;
		
--print '________clean up ; ______________'     

        RETURN 0;

    END; -- Procedure

GO
