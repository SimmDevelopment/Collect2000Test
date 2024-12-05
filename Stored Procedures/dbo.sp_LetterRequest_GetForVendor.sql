SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_LetterRequest_GetForVendor]
       (
        @LetterID INT,
@ThroughDate DATETIME,
        @IncludeErrors BIT = 0
       )
AS

/*
exec sp_letterRequest_GetForVendor 632, '2022-09-24 12:00:00.000'
*/
-- Name:		sp_LetterRequest_GetForVendor
-- Function:		This procedure will retrieve letter requests for processing to a 
-- 			file for an outside letter vendor using input parameters.
-- Creation:		11/13/2003 jc
--			Used by Letter Console.
--			The alias's assigned correspond to the letter merge fields.
--			the following alias merge field names are used explicitly in code 
--			to format data for output to the letter vendor data file:
--			Number, FirstNameFirst, LastName, FirstName, CurrentBalance, ErrorDescription,
--			SubjDebtorFirstNameFirst, SubjDebtorLastName, SubjDebtorFirstName
-- Change History:	
--		01/23/2004 jc added new merge fields Customer.CustomText1-5
--		01/26/2004 jc modified join to debtors table from inner join to left outer join to accomodate customer type letters
--		02/06/2004 jc added new merge field DelinquencyDate from master table
--		02/06/2004 jc added new merge fields for account Garnishment
--		04/01/2004 jc added new merge fields ID1 and ID2
--		02/02/2006 js added 112 new merge fields for additional bankruptcy data, deceased data, cccs and early stage data
--		04/28/2014 BGM added code for promise amount and promise due to get the next post date information based on letter id 315 being requested.
--		08/22/2014 BGM added code to send the previous creditor field on all letters for the Cavalry customer group 207
--		08/25/2014 BGM added code to send special client name for customer 1283 NCO from miscextra table.
--		04/20/2015 BGM added code for business names to be sent in firstnamefirst field
--		04/20/2015 BGM added code to display only last 4 digits of account number for Midland accounts.
--		06/09/2015 BGM added code to include debtor name with c/o atty name
--		06/29/2015 BGM added code to send lettercount to recap email
--		07/06/2015 BGM added NY01 letter to send the preformatted value of $0.00 for the Paid1 thru paid10 fields.
--		07/08/2015 BGM added NY01 code for the amounts paid after last statement(previous quarter) using function Custom_NY_Qtrly_Paid_Since_Last_Stmt
--		07/30/2015 BGM added code to pull Early Stage EFT field into field [L4_Line5] for OOS Yes or No flag
--		09/17/2015 BGM added code to place Original Creditor address information into the L1_Line1 and Line2 fields for Illinois accounts in debt buyer customers.
--		10/02/2015 BGM added code to sent executor name and address if attorney information is not supplied for letter CLMCK
--		06/15/2016 BGM added code to display only last 4 digits of account number for Resurgent accounts.
--		01/24/2017 BGM removed code that populated L1_Line1 and 2 with MiscExtra Info on Debt Buyers, will now be direct input.
--		05/08/2017 BGM added code to display only last 4 digits of account number for Letter Code CAREC.
--		06/24/2019 BGM Modified previous creditor field to use misc extra data for Upgrade Probate due to length of characters more than 50
--		04/20/2021 BGM Modified how userdate2 is formatted when it pulls userdate3 for probate option letter OPT1
--		08/12/2021 BGM Modified bank information to pick up from the wallet table otherwise get the information from the debtor bank info table.
--		09/21/2021 BGM Mapped Resurgent CBR Negative, CBR Reportable and OOS Y/N codes to L3 Line1, 2, 3 Respectively
--		11/01/2021 BGM Added to send to the business name that is in the job name field of the debtor for PayPal Working Capital Customers
--		11/27/2021 BGM Updated with previous customizations after Reg-F updates.
--		12/07/2021 BGM Added Distinct to select code to prevent duplicate records.
--		12/15/2021 BGM Moved customer 1283 use of plaintif from misc extra from Customer.Name field to PreviousCreditor field.
--		01/05/2022 BGM Updated L4_Line4 to always send last 4 of account number for Reg F
--		03/23/2022 BGM Updated Ordering to be by original balance descending in order to get proper linked accounts to order by highest to lowest value.
--		06/06/2022 BGM Added to the code for the CLMCK Letter, letters CLMC1 and CLMUS letters to be sent with the Attorney or Executor names and addresses.
--		09/19/2022 BGM Added Case for Sallie mae to use original balance instead of Current for Reg F letters 
--		09/23/2022 BGM Changed using original balance to using L1_Line4 of ExtraData for 1BUYR for Sallie Mae Post Letters
--		10/27/2022 BGM Added letter code SLM1 to above change on 9/23/2022 for Sallie Mae
--		04/21/2023 BGM Updated L4_Line4 to check extra data then last 4 of account number
--		05/17/2023 BGM Updated account number to only show last 4 account numbers and remvoved filler characters
--		11/13/2023 BGM Added CCCS Address information to be used if it exists on account.
--		12/04/2023 BGM Updated account number to now send the last 4 digits for a credit card to BNKAG and SLMAG letters


	BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

      IF (@@ERROR != 0)
         GOTO ErrHandler;

IF OBJECT_ID('tempdb..#customers') IS NOT NULL DROP TABLE #customers

create table #customers(rownum int, customer varchar(7), ValidationPeriodExpiration date)

EXEC [dbo].[sp_LetterRequest_GetValidationExpirationForAllCustomers]
		@LetterID = @LetterID,
		@ThroughDate = @ThroughDate,
		@IncludeErrors  =1 

 ;     WITH  CTE_LetterAccountData
              AS (SELECT
                    LR.LetterRequestID,
	LR.AccountID,
	LR.LetterCode,
	LR.AmountDue,
	LR.DueDate,
	LR.DateRequested,
	LR.SifPmt1,
	LR.SifPmt2,
	LR.SifPmt3,
	LR.SifPmt4,
	LR.SifPmt5,
	LR.SifPmt6,
	LR.SifPmt7,
	LR.SifPmt8,
	LR.SifPmt9,
	LR.SifPmt10,
	LR.SifPmt11,
	LR.SifPmt12,
	LR.SifPmt13,
	LR.SifPmt14,
	LR.SifPmt15,
	LR.SifPmt16,
	LR.SifPmt17,
	LR.SifPmt18,
	LR.SifPmt19,
	LR.SifPmt20,
	LR.SifPmt21,
	LR.SifPmt22,
	LR.SifPmt23,
	LR.SifPmt24,
                    LRA.Comment AS ErrorDescription,
	LR.SubjDebtorID,
	LR.RequesterID,
	LR.SenderID,
	LRR.AltRecipient,
	LRR.AltName,
	LRR.AltStreet1,
	LRR.AltStreet2,
	LRR.AltCity,
	LRR.AltState,
	LRR.AltZipcode,
	LRR.AltEmail,
	LRR.AltFax,
	LRR.AltBusinessName,
	LRR.SecureRecipientID,
                    D.DebtorID,
	D.Name AS DebtorName,
	D.isParsed,
                    D.firstName,
                    D.lastName,
	D.OtherName,
	D.Street1,
	D.Street2,
	D.City,
	D.State,
	D.Zipcode,
	D.Email,
                    D.Fax,
	D.DLNum,
	D.SSN,
	D.prefix,
	D.middleName,
	D.suffix,
	D.businessName,
	D.USPSKeyLine,
	D.JobName,
	D.JobAddr1,
	D.Jobaddr2,
	D.JobCSZ,
	M.number,
                    M.desk,
	M.account,
	M.received,
	M.lastpaid,
	M.lastpaidamt,
	M.userdate1,
	M.userdate2,
	M.userdate3,
	M.original,
	M.original1,
	M.original2,
	M.original3,
	M.original4,
	M.original5,
	M.original6,
	M.original7,
	M.original8,
	M.original9,
	M.original10,
	M.Accrued2,
	M.paid,
	M.paid1,
	M.paid2,
	M.paid3,
	M.paid4,
	M.paid5,
	M.paid6,
	M.paid7,
	M.paid8,
	M.paid9,
	M.paid10,
	M.current0,
	M.current1,
	M.current2,
	M.current3,
	M.current4,
	M.current5,
	M.current6,
	M.current7,
	M.current8,
	M.current9,
	M.current10,
	M.clidlc,
	M.clidlp,
	M.BlanketSIFOverride,
	M.OriginalCreditor,
	M.Delinquencydate,
	M.id1,
	M.id2,
	M.ContractDate,
	M.ChargeOffDate,
	M.clialp,
	M.clialc,
	M.PreviousCreditor,
	M.customer,
                    M.AttorneyID,
                    M.link,
	M.SettlementID,
	M.Accrued10,
	M.IsInterestDeferred,
	M.DeferredInterest,
					M.interestrate,
	A.TotalPaidAmount,
	A.TotalPaid1,
	A.TotalPaid2,
	A.TotalPaid3,
	A.TotalPaid4,
	A.TotalPaid5,
	A.TotalPaid6,
	A.TotalPaid7,
	A.TotalPaid8,
	A.TotalPaid9,
	A.TotalPaid10,
	A.TotalOverPaidAmount,
	A.TotalAdjustmentAmount,
	A.TotalAdjustment1,
	A.TotalAdjustment2,
	A.TotalAdjustment3,
	A.TotalAdjustment4,
	A.TotalAdjustment5,
	A.TotalAdjustment6,
	A.TotalAdjustment7,
	A.TotalAdjustment8,
	A.TotalAdjustment9,
	A.TotalAdjustment10
                  FROM
                    dbo.letter AS L
                    INNER JOIN dbo.LetterRequest AS LR
                        ON L.LetterID = LR.LetterID
					INNER JOIN dbo.LetterRequest_Account AS LRA
					    ON LRA.AccountId = LR.AccountId AND LRA.LetterRequestId = LR.LetterRequestID
		 INNER JOIN dbo.LetterRequestRecipient AS LRR
		 --WITH (INDEX (idx_LetterRequestRecipient_LetterRequestID))
                        ON LR.LetterRequestID = LRR.LetterRequestID
                    INNER JOIN dbo.Debtors AS D 
                        ON D.DebtorID = LRR.DebtorID
                    INNER JOIN dbo.master AS M
                        ON LR.AccountID = M.number
                    LEFT JOIN (SELECT
                                number,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -totalpaid
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN totalpaid
                                         ELSE 0
                                    END) AS TotalPaidAmount,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid1
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid1
                                         ELSE 0
                                    END) AS TotalPaid1,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid2
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid2
                                         ELSE 0
                                    END) AS TotalPaid2,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid3
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid3
                                         ELSE 0
                                    END) AS TotalPaid3,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid4
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid4
                                         ELSE 0
                                    END) AS TotalPaid4,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid5
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid5
                                         ELSE 0
                                    END) AS TotalPaid5,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid6
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid6
                                         ELSE 0
                                    END) AS TotalPaid6,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid7
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid7
                                         ELSE 0
                                    END) AS TotalPaid7,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid8
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid8
                                         ELSE 0
                                    END) AS TotalPaid8,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid9
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid9
                                         ELSE 0
                                    END) AS TotalPaid9,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid10
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid10
                                         ELSE 0
                                    END) AS TotalPaid10,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -OverPaidAmt
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN OverPaidAmt
                                         ELSE 0
                                    END) AS TotalOverPaidAmount,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN totalpaid
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -totalpaid
                                         ELSE 0
                                    END) AS TotalAdjustmentAmount,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid1
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid1
                                         ELSE 0
                                    END) AS TotalAdjustment1,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid2
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid2
                                         ELSE 0
                                    END) AS TotalAdjustment2,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid3
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid3
                                         ELSE 0
                                    END) AS TotalAdjustment3,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid4
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid4
                                         ELSE 0
                                    END) AS TotalAdjustment4,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid5
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid5
                                         ELSE 0
                                    END) AS TotalAdjustment5,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid6
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid6
                                         ELSE 0
                                    END) AS TotalAdjustment6,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid7
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid7
                                         ELSE 0
                                    END) AS TotalAdjustment7,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid8
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid8
                                         ELSE 0
                                    END) AS TotalAdjustment8,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid9
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid9
                                         ELSE 0
                                    END) AS TotalAdjustment9,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid10
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid10
                                         ELSE 0
                                    END) AS TotalAdjustment10
                               FROM
                                dbo.payhistory 
                               GROUP BY
                                number) AS A
                        ON M.number = A.number
                  WHERE
                    LR.LetterID = @LetterID AND
	LR.DateRequested <= @ThroughDate AND
	(
	LR.DateProcessed IS NULL OR
	LR.DateProcessed = '1/1/1753 12:00:00'
	) AND
	LR.Deleted = 0 AND
	LR.AddEditMode = 0 AND
	LR.Suspend = 0 AND
	LR.Edited = 0 AND
	(
	LR.ErrorDescription = '' OR
	LR.ErrorDescription IS NULL OR
	@IncludeErrors = 1
	)),
            CTE_LinkedList
              AS (SELECT
                    LR.LetterRequestID,
	LR.AccountID,
	LR.LetterCode,
	LR.AmountDue,
	LR.DueDate,
	LR.DateRequested,
	LR.SifPmt1,
	LR.SifPmt2,
	LR.SifPmt3,
	LR.SifPmt4,
	LR.SifPmt5,
	LR.SifPmt6,
	LR.SifPmt7,
	LR.SifPmt8,
	LR.SifPmt9,
	LR.SifPmt10,
	LR.SifPmt11,
	LR.SifPmt12,
	LR.SifPmt13,
	LR.SifPmt14,
	LR.SifPmt15,
	LR.SifPmt16,
	LR.SifPmt17,
	LR.SifPmt18,
	LR.SifPmt19,
	LR.SifPmt20,
	LR.SifPmt21,
	LR.SifPmt22,
	LR.SifPmt23,
	LR.SifPmt24,
	LR.SubjDebtorID,
	LR.RequesterID,
	LR.SenderID,
	LRR.AltRecipient,
	LRR.AltName,
	LRR.AltStreet1,
	LRR.AltStreet2,
	LRR.AltCity,
	LRR.AltState,
	LRR.AltZipcode,
	LRR.AltEmail,
	LRR.AltFax,
	LRR.AltBusinessName,
	LRR.SecureRecipientID,
                    D.DebtorID,
	D.Name AS DebtorName,
	D.isParsed,
                    D.firstName,
                    D.lastName,
	D.OtherName,
	D.Street1,
	D.Street2,
	D.City,
	D.State,
	D.Zipcode,
	D.Email,
                    D.Fax,
	D.DLNum,
	D.SSN,
	D.prefix,
	D.middleName,
	D.suffix,
	D.businessName,
	D.USPSKeyLine,
	D.JobName,
	D.JobAddr1,
	D.Jobaddr2,
	D.JobCSZ,
                    M.link
                  FROM
                    dbo.LetterRequest AS LR
                    INNER JOIN dbo.master AS M
                        ON LR.AccountID = M.number
		 INNER JOIN dbo.LetterRequestRecipient AS LRR
		 --WITH (INDEX (idx_LetterRequestRecipient_LetterRequestID))
                        ON LR.LetterRequestID = LRR.LetterRequestID
                    INNER JOIN dbo.Debtors AS D 
                        ON D.DebtorID = LRR.DebtorID
                    INNER JOIN dbo.letter AS L
                        ON L.linkedLetter = 1 AND
		 L.LetterID = LR.LetterID
                  WHERE
                    LR.LetterID = @LetterID AND
	LR.DateRequested <= @ThroughDate AND
	COALESCE(LR.DateProcessed, '1753-01-01 12:00:00') = '1753-01-01 12:00:00' AND
	LR.Deleted = 0 AND
	LR.AddEditMode = 0 AND
	LR.Suspend = 0 AND
	LR.Edited = 0 AND
	(
	LR.ErrorDescription = '' OR
	LR.ErrorDescription IS NULL OR
	@IncludeErrors = 1
	) AND
                    M.link != 0 AND
                    M.qlevel NOT LIKE '99[89]'),
            CTE_HeaderData
              AS (SELECT
                    HD.LetterRequestID,
	HD.AccountID,
	HD.LetterCode,
	HD.AmountDue,
	HD.DueDate,
	HD.DateRequested,
	HD.SifPmt1,
	HD.SifPmt2,
	HD.SifPmt3,
	HD.SifPmt4,
	HD.SifPmt5,
	HD.SifPmt6,
	HD.SifPmt7,
	HD.SifPmt8,
	HD.SifPmt9,
	HD.SifPmt10,
	HD.SifPmt11,
	HD.SifPmt12,
	HD.SifPmt13,
	HD.SifPmt14,
	HD.SifPmt15,
	HD.SifPmt16,
	HD.SifPmt17,
	HD.SifPmt18,
	HD.SifPmt19,
	HD.SifPmt20,
	HD.SifPmt21,
	HD.SifPmt22,
	HD.SifPmt23,
	HD.SifPmt24,
	HD.ErrorDescription,
	HD.AltRecipient,
	HD.AltName,
	HD.AltStreet1,
	HD.AltStreet2,
	HD.AltCity,
	HD.AltState,
	HD.AltZipcode,
	HD.AltEmail,
	HD.AltFax,
	HD.AltBusinessName,
	HD.SecureRecipientID,
                    HD.DebtorID,
	HD.DebtorName,
	HD.isParsed,
                    HD.firstName,
                    HD.lastName,
	HD.OtherName,
	HD.Street1,
	HD.Street2,
	HD.City,
	HD.State,
	HD.Zipcode,
	HD.Email,
                    HD.Fax,
	HD.DLNum,
	HD.SSN,
	HD.prefix,
	HD.middleName,
	HD.suffix,
	HD.businessName,
	HD.USPSKeyLine,
	HD.JobName,
	HD.JobAddr1,
	HD.Jobaddr2,
	HD.JobCSZ,
	HD.number,
                    HD.desk,
	HD.account,
	HD.received,
	HD.lastpaid,
	HD.lastpaidamt,
	HD.userdate1,
	HD.userdate2,
	HD.userdate3,
	HD.original,
	HD.original1,
	HD.original2,
	HD.original3,
	HD.original4,
	HD.original5,
	HD.original6,
	HD.original7,
	HD.original8,
	HD.original9,
	HD.original10,
	HD.Accrued2,
	HD.paid,
	HD.paid1,
	HD.paid2,
	HD.paid3,
	HD.paid4,
	HD.paid5,
	HD.paid6,
	HD.paid7,
	HD.paid8,
	HD.paid9,
	HD.paid10,
	HD.current0,
	HD.current1,
	HD.current2,
	HD.current3,
	HD.current4,
	HD.current5,
	HD.current6,
	HD.current7,
	HD.current8,
	HD.current9,
	HD.current10,
	HD.clidlc,
	HD.clidlp,
	HD.BlanketSIFOverride,
	HD.OriginalCreditor,
	HD.Delinquencydate,
	HD.id1,
	HD.id2,
	HD.ContractDate,
	HD.ChargeOffDate,
	HD.clialp,
	HD.clialc,
	HD.PreviousCreditor,
	HD.customer,
                    HD.AttorneyID,
                    HD.link,
	HD.SettlementID,
	HD.Accrued10,
	HD.IsInterestDeferred,
	HD.DeferredInterest,
	HD.TotalPaidAmount,
	HD.TotalPaid1,
	HD.TotalPaid2,
	HD.TotalPaid3,
	HD.TotalPaid4,
	HD.TotalPaid5,
	HD.TotalPaid6,
	HD.TotalPaid7,
	HD.TotalPaid8,
	HD.TotalPaid9,
	HD.TotalPaid10,
	HD.TotalOverPaidAmount,
	HD.TotalAdjustmentAmount,
	HD.TotalAdjustment1,
	HD.TotalAdjustment2,
	HD.TotalAdjustment3,
	HD.TotalAdjustment4,
	HD.TotalAdjustment5,
	HD.TotalAdjustment6,
	HD.TotalAdjustment7,
	HD.TotalAdjustment8,
	HD.TotalAdjustment9,
	HD.TotalAdjustment10,
	HD.SubjDebtorID,
	HD.RequesterID,
	HD.SenderID,
					HD.interestrate
                  FROM
                    CTE_LetterAccountData AS HD
	UNION ALL
                  SELECT
                    LL.LetterRequestID,
	LL.AccountID,
	LL.LetterCode,
	LL.AmountDue,
	LL.DueDate,
	LL.DateRequested,
	LL.SifPmt1,
	LL.SifPmt2,
	LL.SifPmt3,
	LL.SifPmt4,
	LL.SifPmt5,
	LL.SifPmt6,
	LL.SifPmt7,
	LL.SifPmt8,
	LL.SifPmt9,
	LL.SifPmt10,
	LL.SifPmt11,
	LL.SifPmt12,
	LL.SifPmt13,
	LL.SifPmt14,
	LL.SifPmt15,
	LL.SifPmt16,
	LL.SifPmt17,
	LL.SifPmt18,
	LL.SifPmt19,
	LL.SifPmt20,
	LL.SifPmt21,
	LL.SifPmt22,
	LL.SifPmt23,
	LL.SifPmt24,
                    LRA.Comment AS ErrorDescription,
	LL.AltRecipient,
	LL.AltName,
	LL.AltStreet1,
	LL.AltStreet2,
	LL.AltCity,
	LL.AltState,
	LL.AltZipcode,
	LL.AltEmail,
	LL.AltFax,
	LL.AltBusinessName,
	LL.SecureRecipientID,
                    LL.DebtorID,
	LL.DebtorName,
	LL.isParsed,
                    LL.firstName,
                    LL.lastName,
	LL.OtherName,
	LL.Street1,
	LL.Street2,
	LL.City,
	LL.State,
	LL.Zipcode,
	LL.Email,
                    LL.Fax,
	LL.DLNum,
	LL.SSN,
	LL.prefix,
	LL.middleName,
	LL.suffix,
	LL.businessName,
	LL.USPSKeyLine,
	LL.JobName,
	LL.JobAddr1,
	LL.Jobaddr2,
	LL.JobCSZ,
	M.number,
                    M.desk,
	M.account,
	M.received,
	M.lastpaid,
	M.lastpaidamt,
	M.userdate1,
	M.userdate2,
	M.userdate3,
	M.original,
	M.original1,
	M.original2,
	M.original3,
	M.original4,
	M.original5,
	M.original6,
	M.original7,
	M.original8,
	M.original9,
	M.original10,
	M.Accrued2,
	M.paid,
	M.paid1,
	M.paid2,
	M.paid3,
	M.paid4,
	M.paid5,
	M.paid6,
	M.paid7,
	M.paid8,
	M.paid9,
	M.paid10,
	M.current0,
	M.current1,
	M.current2,
	M.current3,
	M.current4,
	M.current5,
	M.current6,
	M.current7,
	M.current8,
	M.current9,
	M.current10,
	M.clidlc,
	M.clidlp,
	M.BlanketSIFOverride,
	M.OriginalCreditor,
	M.Delinquencydate,
	M.id1,
	M.id2,
	M.ContractDate,
	M.ChargeOffDate,
	M.clialp,
	M.clialc,
	M.PreviousCreditor,
	M.customer,
                    M.AttorneyID,
                    M.link,
	M.SettlementID,
	M.Accrued10,
	M.IsInterestDeferred,
	M.DeferredInterest,
	A.TotalPaidAmount,
	A.TotalPaid1,
	A.TotalPaid2,
	A.TotalPaid3,
	A.TotalPaid4,
	A.TotalPaid5,
	A.TotalPaid6,
	A.TotalPaid7,
	A.TotalPaid8,
	A.TotalPaid9,
	A.TotalPaid10,
	A.TotalOverPaidAmount,
	A.TotalAdjustmentAmount,
	A.TotalAdjustment1,
	A.TotalAdjustment2,
	A.TotalAdjustment3,
	A.TotalAdjustment4,
	A.TotalAdjustment5,
	A.TotalAdjustment6,
	A.TotalAdjustment7,
	A.TotalAdjustment8,
	A.TotalAdjustment9,
	A.TotalAdjustment10,
	LL.SubjDebtorID,
	LL.RequesterID,
	LL.SenderID,
					M.interestrate
                  FROM
                    CTE_LinkedList AS LL
                    INNER JOIN dbo.master AS M
                        ON M.link = LL.link AND
		 LL.AccountID != M.number
					INNER JOIN dbo.LetterRequest_Account AS LRA
					    ON LRA.LetterRequestId = LL.LetterRequestID AND LRA.AccountId = M.Number
                    LEFT JOIN (SELECT
                                number,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -totalpaid
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN totalpaid
                                         ELSE 0
                                    END) AS TotalPaidAmount,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid1
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid1
                                         ELSE 0
                                    END) AS TotalPaid1,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid2
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid2
                                         ELSE 0
                                    END) AS TotalPaid2,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid3
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid3
                                         ELSE 0
                                    END) AS TotalPaid3,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid4
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid4
                                         ELSE 0
                                    END) AS TotalPaid4,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid5
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid5
                                         ELSE 0
                                    END) AS TotalPaid5,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid6
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid6
                                         ELSE 0
                                    END) AS TotalPaid6,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid7
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid7
                                         ELSE 0
                                    END) AS TotalPaid7,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid8
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid8
                                         ELSE 0
                                    END) AS TotalPaid8,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid9
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid9
                                         ELSE 0
                                    END) AS TotalPaid9,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -paid10
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN paid10
                                         ELSE 0
                                    END) AS TotalPaid10,
		 SUM(CASE WHEN batchtype LIKE 'p%' AND
                                              batchtype LIKE '%r' THEN -OverPaidAmt
                                         WHEN batchtype LIKE 'p%' AND
                                              batchtype NOT LIKE '%r' THEN OverPaidAmt
                                         ELSE 0
                                    END) AS TotalOverPaidAmount,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN totalpaid
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -totalpaid
                                         ELSE 0
                                    END) AS TotalAdjustmentAmount,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid1
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid1
                                         ELSE 0
                                    END) AS TotalAdjustment1,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid2
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid2
                                         ELSE 0
                                    END) AS TotalAdjustment2,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid3
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid3
                                         ELSE 0
                                    END) AS TotalAdjustment3,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid4
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid4
                                         ELSE 0
                                    END) AS TotalAdjustment4,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid5
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid5
                                         ELSE 0
                                    END) AS TotalAdjustment5,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid6
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid6
                                         ELSE 0
                                    END) AS TotalAdjustment6,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid7
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid7
                                         ELSE 0
                                    END) AS TotalAdjustment7,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid8
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid8
                                         ELSE 0
                                    END) AS TotalAdjustment8,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid9
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid9
                                         ELSE 0
                                    END) AS TotalAdjustment9,
		 SUM(CASE WHEN batchtype LIKE 'd%' AND
                                              batchtype LIKE '%r' THEN paid10
                                         WHEN batchtype LIKE 'd%' AND
                                              batchtype NOT LIKE '%r' THEN -paid10
                                         ELSE 0
                                    END) AS TotalAdjustment10
                               FROM
                                dbo.payhistory 
                               GROUP BY
                                number) AS A
                        ON M.number = A.number
                  WHERE
                    M.qlevel NOT LIKE '99[89]'),
            CTE_ExtraData
              AS (SELECT
                    ED.number,
                    MAX(CASE ED.extracode
                          WHEN 'L1' THEN ED.line1
                          ELSE ''
                        END) AS L1_Line1,
                    MAX(CASE ED.extracode
                          WHEN 'L1' THEN ED.line2
                          ELSE ''
                        END) AS L1_Line2,
                    MAX(CASE ED.extracode
                          WHEN 'L1' THEN ED.line3
                          ELSE ''
                        END) AS L1_Line3,
                    MAX(CASE ED.extracode
                          WHEN 'L1' THEN ED.line4
                          ELSE ''
                        END) AS L1_Line4,
                    MAX(CASE ED.extracode
                          WHEN 'L1' THEN ED.line5
                          ELSE ''
                        END) AS L1_Line5,
                    MAX(CASE ED.extracode
                          WHEN 'L2' THEN ED.line1
                          ELSE ''
                        END) AS L2_Line1,
                    MAX(CASE ED.extracode
                          WHEN 'L2' THEN ED.line2
                          ELSE ''
                        END) AS L2_Line2,
                    MAX(CASE ED.extracode
                          WHEN 'L2' THEN ED.line3
                          ELSE ''
                        END) AS L2_Line3,
                    MAX(CASE ED.extracode
                          WHEN 'L2' THEN ED.line4
                          ELSE ''
                        END) AS L2_Line4,
                    MAX(CASE ED.extracode
                          WHEN 'L2' THEN ED.line5
                          ELSE ''
                        END) AS L2_Line5,
                    MAX(CASE ED.extracode
                          WHEN 'L3' THEN ED.line1
                          ELSE ''
                        END) AS L3_Line1,
                    MAX(CASE ED.extracode
                          WHEN 'L3' THEN ED.line2
                          ELSE ''
                        END) AS L3_Line2,
                    MAX(CASE ED.extracode
                          WHEN 'L3' THEN ED.line3
                          ELSE ''
                        END) AS L3_Line3,
                    MAX(CASE ED.extracode
                          WHEN 'L3' THEN ED.line4
                          ELSE ''
                        END) AS L3_Line4,
                    MAX(CASE ED.extracode
                          WHEN 'L3' THEN ED.line5
                          ELSE ''
                        END) AS L3_Line5,
                    MAX(CASE ED.extracode
                          WHEN 'L4' THEN ED.line1
                          ELSE ''
                        END) AS L4_Line1,
                    MAX(CASE ED.extracode
                          WHEN 'L4' THEN ED.line2
                          ELSE ''
                        END) AS L4_Line2,
                    MAX(CASE ED.extracode
                          WHEN 'L4' THEN ED.line3
                          ELSE ''
                        END) AS L4_Line3,
                    MAX(CASE ED.extracode
                          WHEN 'L4' THEN ED.line4
                          ELSE ''
                        END) AS L4_Line4,
                    MAX(CASE ED.extracode
                          WHEN 'L4' THEN ED.line5
                          ELSE ''
                        END) AS L4_Line5,
                    MAX(CASE ED.extracode
                          WHEN 'L5' THEN ED.line1
                          ELSE ''
                        END) AS L5_Line1,
                    MAX(CASE ED.extracode
                          WHEN 'L5' THEN ED.line2
                          ELSE ''
                        END) AS L5_Line2,
                    MAX(CASE ED.extracode
                          WHEN 'L5' THEN ED.line3
                          ELSE ''
                        END) AS L5_Line3,
                    MAX(CASE ED.extracode
                          WHEN 'L5' THEN ED.line4
                          ELSE ''
                        END) AS L5_Line4,
                    MAX(CASE ED.extracode
                          WHEN 'L5' THEN ED.line5
                          ELSE ''
                        END) AS L5_Line5
                  FROM
                    dbo.extradata AS ED
                  WHERE
                    ED.extracode IN ('L1', 'L2', 'L3', 'L4', 'L5')
                  GROUP BY
                    ED.number)


	--query letter requests
	SELECT DISTINCT M.LetterRequestId AS [.LetterRequestID],
	CF.SoftwareVersion,
	CASE WHEN M.AccountID = M.number THEN 0 ELSE 1 END AS LinkRecord,
	M.lettercode AS LetterCode,
	ISNULL(M.debtorid, 0) AS DebtorID,
--Added CCCS Contact Info
--Alt Recipient, then Attorney, if Equabli Customer then CCCS Contact or Company, then Debtorname
	CASE WHEN M.AltRecipient = 1 THEN ISNULL(M.AltName, '') WHEN r.letterstoatty = 1 THEN ISNULL(da.Name, '') WHEN m.customer IN (3100) AND cs.CompanyName IS NOT NULL THEN ISNULL(cs.Contact, cs.CompanyName)
	ELSE ISNULL(M.DebtorName, '') END AS Name,
	--CASE WHEN M.AltRecipient = 1 THEN LTRIM(ISNULL(dbo.GetFirstName(M.AltName) + ' ' + dbo.GetLastName(M.AltName), '')) WHEN r.letterstoatty = 1 THEN LTRIM(ISNULL(da.Name + ' ' + da.Name, '')) ELSE LTRIM(ISNULL(CASE M.isParsed WHEN 1 THEN M.firstName + ' ' + m.lastName ELSE dbo.GetFirstName(M.DebtorName) + ' ' + dbo.GetLastName(M.DebtorName) END, '')) END AS FirstNameFirst,
--Added CCCS Contact Info
--Alt Recipient, then Attorney, if Equabli Customer then CCCS Contact or Company, then Debtorname
	CASE WHEN M.AltRecipient = 1 THEN LTRIM(ISNULL(dbo.GetFirstName(M.AltName) + ' ' + dbo.GetLastName(M.AltName), ''))
	--changed to include debtor name with c/o atty name
	WHEN r.letterstoatty = 1 THEN 
	CASE WHEN sd.isBusiness = 1 THEN M.businessname + ' C/O ' + LTRIM(ISNULL(dbo.GetFirstName(da.Name) + ' ' + dbo.GetLastName(da.Name), ''))  
		ELSE LTRIM(ISNULL(CASE M.isParsed WHEN 1 THEN M.firstName ELSE dbo.GetFirstName(sd.Name) END + ' ' + CASE sd.isParsed WHEN 1 THEN sd.lastName ELSE dbo.GetLastName(sd.Name) END, ''))
	+ ' C/O ' + LTRIM(ISNULL(dbo.GetFirstName(da.Name) + ' ' + dbo.GetLastName(da.Name), '')) END
	WHEN m.customer IN (3100) AND cs.CompanyName IS NOT NULL THEN 
	CASE WHEN sd.isBusiness = 1 THEN M.businessname + ' C/O ' + ISNULL(cs.Contact, cs.CompanyName) ELSE LTRIM(ISNULL(CASE M.isParsed WHEN 1 THEN M.firstName ELSE dbo.GetFirstName(sd.Name) END + ' ' + CASE sd.isParsed WHEN 1 THEN sd.lastName ELSE dbo.GetLastName(sd.Name) END, ''))
	+ ' C/O ' + ISNULL(cs.Contact, cs.CompanyName) END
--Added in so that business names will be placed on letters instead of being blank.
WHEN sd.isBusiness = 1 THEN M.businessname
--Added to send to the business name that is in the job name field of the debtor for PayPal Working Capital Customers
WHEN m.customer IN ('0002468', '0002469') AND M.lettercode = 'PPWC1' AND M.JobName <> '' THEN M.JobName ELSE LTRIM(ISNULL(CASE sd.isParsed WHEN 1 THEN sd.firstName ELSE dbo.GetFirstName(sd.Name) END + ' ' + CASE sd.isParsed WHEN 1 THEN sd.lastName ELSE dbo.GetLastName(sd.Name) END, '')) END AS [FirstNameFirst],
--Added CCCS Contact Info
	CASE WHEN M.AltRecipient = 1 THEN ISNULL(dbo.GetLastName(M.AltName), '') WHEN r.letterstoatty = 1 THEN ISNULL(da.Name, '') WHEN m.customer IN (3100) AND cs.CompanyName IS NOT NULL THEN dbo.GetLastName(ISNULL(cs.Contact, cs.CompanyName))
	ELSE ISNULL(CASE M.isParsed WHEN 1 THEN M.lastName ELSE dbo.GetLastName(M.DebtorName) END, '') END AS LastName,
--Added CCCS Contact Info
	CASE WHEN M.AltRecipient = 1 THEN ISNULL(dbo.GetFirstName(M.AltName), '') WHEN r.letterstoatty = 1 THEN ISNULL(da.Name, '') WHEN m.customer IN (3100) AND cs.CompanyName IS NOT NULL THEN dbo.GetFirstName(ISNULL(cs.Contact, cs.CompanyName))
	ELSE ISNULL(CASE M.isParsed WHEN 1 THEN M.firstName ELSE dbo.GetFirstName(M.DebtorName) END, '') END AS FirstName,
	ISNULL(M.OtherName, '') AS Other,
--Added CCCS Contact Info
	CASE WHEN M.AltRecipient = 1 THEN ISNULL(M.AltStreet1, '') WHEN r.letterstoatty = 1 THEN ISNULL(da.Addr1, '') WHEN m.customer IN (3100) AND cs.CompanyName IS NOT NULL AND cs.Street1 IS NOT NULL THEN isnull(cs.street1, '')	
	ELSE ISNULL(M.Street1, '') END AS Street1,
--Added CCCS Contact Info
	CASE WHEN M.AltRecipient = 1 THEN ISNULL(M.AltStreet2, '') WHEN r.letterstoatty = 1 THEN ISNULL(da.Addr2, '') WHEN m.customer IN (3100) AND cs.CompanyName IS NOT NULL AND cs.Street2 IS NOT NULL THEN isnull(cs.street2, '')	
	ELSE ISNULL(M.Street2, '') END AS Street2,
--Added CCCS Contact Info
	CASE WHEN M.AltRecipient = 1 THEN ISNULL(M.AltCity, '') WHEN r.letterstoatty = 1 THEN ISNULL(da.City, '')  WHEN m.customer IN (3100) AND cs.CompanyName IS NOT NULL AND cs.City IS NOT NULL THEN isnull(cs.City, '')	
	ELSE ISNULL(M.City, '') END AS City,
--Added CCCS Contact Info
	CASE WHEN M.AltRecipient = 1 THEN ISNULL(M.AltState, '') WHEN r.letterstoatty = 1 THEN ISNULL(da.State, '')  WHEN m.customer IN (3100) AND cs.CompanyName IS NOT NULL AND cs.State IS NOT NULL THEN isnull(cs.State, '')	
	ELSE ISNULL(M.State, '') END AS State,
--Added CCCS Contact Info
	CASE WHEN M.AltRecipient = 1 THEN ISNULL(M.AltZipcode, '') WHEN r.letterstoatty = 1 THEN ISNULL(da.Zipcode, '')  WHEN m.customer IN (3100) AND cs.CompanyName IS NOT NULL AND cs.ZipCode IS NOT NULL THEN isnull(cs.ZipCode, '')	
	ELSE ISNULL(M.Zipcode, '') END AS Zipcode,
--Added CCCS Contact Info
	CASE WHEN M.AltRecipient = 1 THEN CASE WHEN (LEN(ISNULL(M.AltCity, '')) > 0) THEN ISNULL(M.AltCity, '') + ', ' + ISNULL(M.AltState, '') + ' ' + ISNULL(M.AltZipcode, '') ELSE ISNULL(M.AltState, '') + ' ' + ISNULL(M.AltZipcode, '') END WHEN r.letterstoatty = 1 THEN CASE WHEN (LEN(ISNULL(da.City, '')) > 0) THEN ISNULL(da.City, '') + ', ' + ISNULL(da.State, '') + ' ' + ISNULL(da.Zipcode, '') ELSE ISNULL(da.State, '') + ' ' + ISNULL(da.Zipcode, '') END
	WHEN m.customer IN (3100) AND cs.CompanyName IS NOT NULL THEN CASE WHEN (LEN(ISNULL(cs.City, '')) > 0) THEN ISNULL(cs.City, '') + ', ' + ISNULL(cs.State, '') + ' ' + ISNULL(cs.Zipcode, '') ELSE ISNULL(cs.State, '') + ' ' + ISNULL(cs.Zipcode, '') END
	ELSE CASE WHEN (LEN(ISNULL(M.City, '')) > 0) THEN ISNULL(M.City, '') + ', ' + ISNULL(M.State, '') + ' ' + ISNULL(M.Zipcode, '') ELSE ISNULL(M.State, '') + ' ' + ISNULL(M.Zipcode, '') END END AS CSZ,
	CASE WHEN M.AltRecipient = 1 THEN ISNULL(M.AltEmail, '') WHEN r.letterstoatty = 1 THEN ISNULL(da.Email, '') ELSE ISNULL(M.Email, '') END AS Email,
--Added CCCS Contact Info
	CASE WHEN M.AltRecipient = 1 THEN ISNULL(M.AltFax, '') WHEN r.letterstoatty = 1 THEN ISNULL(da.Fax, '')  WHEN m.customer IN (3100) AND cs.CompanyName IS NOT NULL AND cs.Fax IS NOT NULL THEN isnull(cs.Fax, '') ELSE ISNULL(M.Fax, '') END AS Fax,
	ISNULL(M.DLNum, '') AS DriverLicenseNumber,
	('Login ID: ' + ISNULL(CAST(M.Number AS VARCHAR(50)), '') + CHAR(9) + 'Password: ' +         ISNULL(CAST(ISNULL(M.debtorid, 0) AS VARCHAR(50)), '')) AS WebPayLogin,
	M.Number AS Number,
	M.Number AS LinkNumber,
	M.Desk AS Desk,
	--M.Account AS Account,
	--Added case for NY accounts to only show last 4 digits of account number for Midland. and all Resurgent customers and Letter Code CAREC
CASE WHEN m.STATE = 'NY' AND m.customer = '0000954' THEN 'Ending in ' + RIGHT(m.account, 4) WHEN M.lettercode = 'CAREC' THEN 'Ending in ' + RIGHT(m.account, 4) WHEN m.customer IN (SELECT customerid
FROM Fact f WITH (NOLOCK)
WHERE CustomGroupID = 24) THEN 'Ending in ' + RIGHT(m.account, 4) ELSE m.Account END AS [Account],

	CASE WHEN M.Received IS NULL OR
	M.Received <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.Received, 101) END AS Received,
	CASE WHEN M.LastPaid IS NULL OR
	M.LastPaid <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.LastPaid, 101) END AS LastPaid,
	CASE WHEN (ISNULL(M.lastpaidamt, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.lastpaidamt, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.lastpaidamt), 0), 1) + ')' END AS LastPaidAmount,
	CONVERT(VARCHAR(50), ISNULL(M.InterestRate, 0), 1) AS InterestRate,
	CASE WHEN M.Userdate1 IS NULL OR
	M.Userdate1 <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.Userdate1, 101) END AS Userdate1,
	--CASE WHEN M.Userdate2 IS NULL OR
	--M.Userdate2 <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.Userdate2, 101) END AS Userdate2,
	CASE WHEN M.lettercode = 'usopt' AND m.customer = '0001749' THEN CONVERT(VARCHAR(10), m.Userdate3, 101) WHEN m.Userdate2 IS NULL OR m.Userdate2 <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), m.Userdate2, 101) END AS [Userdate2],

	CASE WHEN M.Userdate3 IS NULL OR
	M.Userdate3 <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.Userdate3, 101) END AS Userdate3,
	ISNULL(M.SSN, '') AS SSN,
	CASE WHEN (ISNULL(M.Original, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Original, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Original), 0), 1) + ')' END AS Original,
	CASE WHEN (ISNULL(M.Original1, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Original1, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Original1), 0), 1) + ')' END AS Original1,
	CASE WHEN (ISNULL(M.Original2, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Original2, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Original2), 0), 1) + ')' END AS Original2,
	CASE WHEN (ISNULL(M.Original3, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Original3, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Original3), 0), 1) + ')' END AS Original3,
	CASE WHEN (ISNULL(M.Original4, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Original4, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Original4), 0), 1) + ')' END AS Original4,
	CASE WHEN (ISNULL(M.Original5, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Original5, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Original5), 0), 1) + ')' END AS Original5,
	CASE WHEN (ISNULL(M.Original6, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Original6, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Original6), 0), 1) + ')' END AS Original6,
	CASE WHEN (ISNULL(M.Original7, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Original7, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Original7), 0), 1) + ')' END AS Original7,
	CASE WHEN (ISNULL(M.Original8, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Original8, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Original8), 0), 1) + ')' END AS Original8,
	CASE WHEN (ISNULL(M.Original9, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Original9, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Original9), 0), 1) + ')' END AS Original9,
	CASE WHEN (ISNULL(M.Original10, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Original10, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Original10), 0), 1) + ')' END AS Original10,
	CASE WHEN (ISNULL(M.Accrued2, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Accrued2, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Accrued2), 0), 1) + ')' END AS AccruedInterest,
	
	--CASE WHEN (ISNULL(M.Paid, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Paid, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Paid), 0), 1) + ')' END AS Paid,
	--CASE WHEN (ISNULL(M.Paid1, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Paid1, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Paid1), 0), 1) + ')' END AS Paid1,
	--CASE WHEN (ISNULL(M.Paid2, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Paid2, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Paid2), 0), 1) + ')' END AS Paid2,
	--CASE WHEN (ISNULL(M.Paid3, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Paid3, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Paid3), 0), 1) + ')' END AS Paid3,
	--CASE WHEN (ISNULL(M.Paid4, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Paid4, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Paid4), 0), 1) + ')' END AS Paid4,
	--CASE WHEN (ISNULL(M.Paid5, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Paid5, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Paid5), 0), 1) + ')' END AS Paid5,
	--CASE WHEN (ISNULL(M.Paid6, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Paid6, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Paid6), 0), 1) + ')' END AS Paid6,
	--CASE WHEN (ISNULL(M.Paid7, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Paid7, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Paid7), 0), 1) + ')' END AS Paid7,
	--CASE WHEN (ISNULL(M.Paid8, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Paid8, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Paid8), 0), 1) + ')' END AS Paid8,
	--CASE WHEN (ISNULL(M.Paid9, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Paid9, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Paid9), 0), 1) + ')' END AS Paid9,
	--CASE WHEN (ISNULL(M.Paid10, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Paid10, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Paid10), 0), 1) + ')' END AS Paid10,
	CASE WHEN M.lettercode IN ('mosta', 'mostp', 'ny01') THEN '$' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid), 0), 1) WHEN (ISNULL(m.Paid, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(m.Paid, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid), 0), 1) + ')' END AS [Paid],
CASE WHEN M.lettercode IN ('mosta', 'mostp', 'ny01') THEN '$' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid1), 0), 1) WHEN (ISNULL(m.Paid1, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(m.Paid1, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid1), 0), 1) + ')' END AS [Paid1],
CASE WHEN M.lettercode IN ('mosta', 'mostp', 'ny01') THEN '$' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid2), 0), 1) WHEN (ISNULL(m.Paid2, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(m.Paid2, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid2), 0), 1) + ')' END AS [Paid2],
CASE WHEN M.lettercode IN ('mosta', 'mostp', 'ny01') THEN '$' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid3), 0), 1) WHEN (ISNULL(m.Paid3, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(m.Paid3, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid3), 0), 1) + ')' END AS [Paid3],
CASE WHEN M.lettercode IN ('mosta', 'mostp', 'ny01') THEN '$' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid4), 0), 1) WHEN (ISNULL(m.Paid4, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(m.Paid4, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid4), 0), 1) + ')' END AS [Paid4],
CASE WHEN M.lettercode IN ('mosta', 'mostp', 'ny01') THEN '$' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid5), 0), 1) WHEN (ISNULL(m.Paid5, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(m.Paid5, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid5), 0), 1) + ')' END AS [Paid5],
CASE WHEN M.lettercode IN ('mosta', 'mostp', 'ny01') THEN '$' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid6), 0), 1) WHEN (ISNULL(m.Paid6, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(m.Paid6, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid6), 0), 1) + ')' END AS [Paid6],
CASE WHEN M.lettercode IN ('mosta', 'mostp', 'ny01') THEN '$' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid7), 0), 1) WHEN (ISNULL(m.Paid7, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(m.Paid7, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid7), 0), 1) + ')' END AS [Paid7],
CASE WHEN M.lettercode IN ('mosta', 'mostp', 'ny01') THEN '$' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid8), 0), 1) WHEN (ISNULL(m.Paid8, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(m.Paid8, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid8), 0), 1) + ')' END AS [Paid8],
CASE WHEN M.lettercode IN ('mosta', 'mostp', 'ny01') THEN '$' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid9), 0), 1) WHEN (ISNULL(m.Paid9, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(m.Paid9, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid9), 0), 1) + ')' END AS [Paid9],
CASE WHEN M.lettercode IN ('mosta', 'mostp', 'ny01') THEN '$' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid10), 0), 1) WHEN (ISNULL(m.Paid10, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(m.Paid10, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(m.Paid10), 0), 1) + ')' END AS [Paid10],

--09/19/2022 BGM Added Case for Sallie mae to use original balance instead of Current for Reg F letters
--09/23/2022 BGM Changed using original balance to using L1_Line4 of ExtraData for 1BUYR for Sallie Mae Post Letters
--10/27/2022 BGM Added letter code SLM1 to lettercode check
CASE WHEN M.customer IN ('0002877') AND M.LetterCode IN ('1BUYR', 'SLM1') THEN ROUND(ISNULL(CAST(ed1.line4 as MONEY), 0), 2) ELSE	ROUND(ISNULL(M.current0, 0), 2) END AS CurrentBalance,
--09/19/2022 BGM Added Case for Sallie mae to use original balance instead of Current for Reg F letters
--09/23/2022 BGM Changed using original balance to using L1_Line4 of ExtraData for 1BUYR for Sallie Mae Post Letters
--10/27/2022 BGM Added letter code SLM1 to lettercode check
CASE WHEN M.customer IN ('0002877') AND M.LetterCode IN ('1BUYR', 'SLM1') THEN CASE WHEN (ISNULL(CAST(ed1.line4 as MONEY), 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(CAST(ed1.line4 as MONEY), 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(CAST(ed1.line4 as MONEY), 0), 1) + ')' END
ELSE
	CASE WHEN (ISNULL(M.current0, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.current0, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.current0), 0), 1) + ')' END END AS [Current],
	CASE WHEN (ISNULL(M.Current1, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Current1, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Current1), 0), 1) + ')' END AS Current1,
	CASE WHEN (ISNULL(M.Current2, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Current2, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Current2), 0), 1) + ')' END AS Current2,
	CASE WHEN (ISNULL(M.Current3, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Current3, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Current3), 0), 1) + ')' END AS Current3,
	CASE WHEN (ISNULL(M.Current4, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Current4, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Current4), 0), 1) + ')' END AS Current4,
	CASE WHEN (ISNULL(M.Current5, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Current5, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Current5), 0), 1) + ')' END AS Current5,
	CASE WHEN (ISNULL(M.Current6, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Current6, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Current6), 0), 1) + ')' END AS Current6,
	CASE WHEN (ISNULL(M.Current7, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Current7, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Current7), 0), 1) + ')' END AS Current7,
	CASE WHEN (ISNULL(M.Current8, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Current8, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Current8), 0), 1) + ')' END AS Current8,
	CASE WHEN (ISNULL(M.Current9, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Current9, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Current9), 0), 1) + ')' END AS Current9,
	CASE WHEN (ISNULL(M.Current10, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.Current10, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.Current10), 0), 1) + ')' END AS Current10,
	CASE WHEN M.clidlc IS NULL OR M.clidlc <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.clidlc, 101) END AS CustomerDLC,
	CASE WHEN M.clidlp IS NULL OR M.clidlp <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.clidlp, 101) END AS CustomerDLP,
	CASE WHEN COALESCE(M.BlanketSIFOverride, cu.BlanketSif, 100) <= 0 OR COALESCE(M.BlanketSIFOverride, cu.BlanketSif, 100) >= 100 THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.current0, 0), 1) WHEN M.current0 * (CAST(COALESCE(M.BlanketSIFOverride, cu.BlanketSif) AS MONEY) / 100) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(M.current0 * (CAST(COALESCE(M.BlanketSIFOverride, cu.BlanketSif) AS MONEY) / 100)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), ABS(M.current0 * (CAST(COALESCE(M.BlanketSIFOverride, cu.BlanketSif) AS MONEY) / 100)), 1) END AS BlanketSifAmount,
	ISNULL(a.City, '') AS [OurAttorney.City],
	ISNULL(a.code, '') AS [OurAttorney.Code],
	CASE WHEN LEN(a.City) > 0 THEN ISNULL(a.City + ', ' + a.State + ' ' + a.Zipcode, '') ELSE ISNULL(a.State + ' ' + a.Zipcode, '') END AS [OurAttorney.CSZ],
	ISNULL(a.Email, '') AS [OurAttorney.Email],
	ISNULL(a.Fax, '') AS [OurAttorney.Fax],
	ISNULL(a.Firm, '') AS [OurAttorney.Firm],
	ISNULL(a.Initials, '') AS [OurAttorney.Initials],
	ISNULL(a.Name, '') AS [OurAttorney.Name],
	ISNULL(a.phone, '') AS [OurAttorney.Phone],
	ISNULL(a.State, '') AS [OurAttorney.State],
	ISNULL(a.Street1, '') AS [OurAttorney.Street1],
	ISNULL(a.Street2, '') AS [OurAttorney.Street2],
	ISNULL(a.Zipcode, '') AS [OurAttorney.Zipcode],
	ISNULL(cu.BlanketSif, '') AS [Customer.BlanketSif],
	ISNULL(cu.City, '') AS [Customer.City],
	CASE WHEN cu.Name IS NULL THEN cu.customer WHEN LEN(cu.Name) > 0 THEN cu.customer + ' - ' + cu.Name ELSE cu.customer END AS [Customer.Combo],
	ISNULL(cu.Contact, '') AS [Customer.Contact],
	CASE WHEN LEN(cu.City) > 0 THEN ISNULL(cu.City + ', ' + cu.State + ' ' + cu.Zipcode, '') ELSE ISNULL(cu.State + ' ' + cu.Zipcode, '') END AS [Customer.CSZ],
	ISNULL(cu.customer, '') AS [Customer.Customer],
	--ISNULL(cu.Name, '') AS [Customer.Name],
	--Changed to pickup previous creditor for Cavalry debt buyer regulations
CASE WHEN cu.customer IN (SELECT customerid
FROM Fact WITH (NOLOCK)
WHERE CustomGroupID = 207) THEN m.previouscreditor ELSE ISNULL(cu.Name, '')  END AS [Customer.Name],

	ISNULL(cu.State, '') AS [Customer.State],
	ISNULL(cu.Street1, '') AS [Customer.Street1],
	ISNULL(cu.Street2, '') AS [Customer.Street2],
	ISNULL(cu.Zipcode, '') AS [Customer.Zipcode],

--09/19/2022 BGM Added Case for Sallie mae to use original balance instead of Current for Reg F letters
--09/23/2022 BGM Changed using original balance to using L1_Line4 of ExtraData for 1BUYR for Sallie Mae Post Letters
--10/27/2022 BGM Added letter code SLM1 to lettercode check
CASE WHEN M.customer IN ('0002877') AND M.LetterCode IN ('1BUYR', 'SLM1') THEN CASE WHEN COALESCE(ISNULL(CAST(ed1.line4 as MONEY), 0), 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(ISNULL(CAST(ed1.line4 as MONEY), 0), 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(ISNULL(CAST(ed1.line4 as MONEY), 0), 0), 1) END
ELSE
	CASE WHEN COALESCE(lb.current0, M.current0, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current0, M.current0, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current0, M.current0, 0), 1) END END AS LinkedBalance,
	ISNULL(cc.AccruedInt, 0) AS [CourtCase.AccruedInt],
	CASE WHEN cc.ArbitrationDate IS NULL OR	cc.ArbitrationDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.ArbitrationDate, 101) END AS [CourtCase.ArbitrationDate],
	ISNULL(cc.CaseNumber, '') AS [CourtCase.CaseNumber],
	ISNULL(cc.Defendant, '') AS [CourtCase.CaseTitle],
	ISNULL(co.CourtName, '') AS [CourtCase.Court.CourtName],
	ISNULL(co.Address1, '') AS [CourtCase.Court.Street1],
	ISNULL(co.Address2, '') AS [CourtCase.Court.Street2],
	ISNULL(co.City, '') AS [CourtCase.Court.City],
	ISNULL(co.State, '') AS [CourtCase.Court.State],
	ISNULL(co.Zipcode, '') AS [CourtCase.Court.Zipcode],
	ISNULL(co.County, '') AS [CourtCase.Court.County],
	CASE WHEN LEN(co.City) > 0 THEN ISNULL(co.City + ', ' + co.State + ' ' + co.Zipcode, '') ELSE ISNULL(co.State + ' ' + co.Zipcode, '') END AS [CourtCase.Court.CSZ],
	ISNULL(co.phone, '') AS [CourtCase.Court.Phone],
	ISNULL(co.Fax, '') AS [CourtCase.Court.Fax],
	ISNULL(co.Salutation, '') AS [CourtCase.Court.ClerkSalutation],
	ISNULL(co.ClerkFirstName, '') AS [CourtCase.Court.ClerkFirstName],
	ISNULL(co.ClerkMiddleName, '') AS [CourtCase.Court.ClerkMiddleName],
	ISNULL(co.ClerkLastName, '') AS [CourtCase.Court.ClerkLastName],
	ISNULL(ISNULL(co.ClerkFirstName + ' ', '') + ISNULL(co.ClerkMiddleName + ' ', '') + co.ClerkLastName, '') AS [CourtCase.Court.ClerkFullName],
	CASE WHEN cc.CourtDate IS NULL OR cc.CourtDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.CourtDate, 101) END AS [CourtCase.CourtDate],
	CASE WHEN cc.DateFiled IS NULL OR cc.DateFiled <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.DateFiled, 101) END AS [CourtCase.DateFiled],
	ISNULL(cc.Defendant, '') AS [CourtCase.Defendant],
	CASE WHEN cc.IntFromDate IS NULL OR	cc.IntFromDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.IntFromDate, 101) END AS [CourtCase.IntFromDate],
	ISNULL(cc.Judge, '') AS [CourtCase.Judge],
	ISNULL(cc.Judgement, 0) AS [CourtCase.Judgement],
	CASE WHEN (ISNULL(cc.JudgementAmt, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(cc.JudgementAmt, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(cc.JudgementAmt), 0), 1) + ')' END AS [CourtCase.JudgementAmt],
	CASE WHEN (ISNULL(cc.JudgementCostAward, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(cc.JudgementCostAward, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(cc.JudgementCostAward), 0), 1) + ')' END AS [CourtCase.JudgementCostAward],
	CASE WHEN cc.JudgementDate IS NULL OR cc.JudgementDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.JudgementDate, 101) END AS [CourtCase.JudgementDate],
	CASE WHEN (ISNULL(cc.JudgementIntAward, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(cc.JudgementIntAward, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(cc.JudgementIntAward), 0), 1) + ')' END AS [CourtCase.JudgementIntAward],
	ISNULL(cc.JudgementIntRate, 0) AS [CourtCase.JudgementIntRate],
	CASE WHEN (ISNULL(cc.JudgementOtherAward, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(cc.JudgementOtherAward, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(cc.JudgementOtherAward), 0), 1) + ')' END AS [CourtCase.JudgementOtherAward],
	ISNULL(cc.MiscInfo1, '') AS [CourtCase.MiscInfo1],
	ISNULL(cc.MiscInfo2, '') AS [CourtCase.MiscInfo2],
	ISNULL(cc.Plaintiff, '') AS [CourtCase.Plaintiff],
	ISNULL(cc.status, '') AS [CourtCase.Status],
	ISNULL(M.OriginalCreditor, '') AS OriginalCreditor,
	CF.Company AS [Company.Name],
	CF.Street1 AS [Company.Street1],
	CF.Street2 AS [Company.Street2],
	CF.City AS [Company.City],
	CF.State AS [Company.State],
	CF.Zipcode AS [Company.Zipcode],
	CASE WHEN LEN(CF.City) > 0 THEN ISNULL(CF.City + ', ' + CF.State + ' ' + CF.Zipcode, '') ELSE ISNULL(CF.State + ' ' + CF.Zipcode, '') END AS [Company.CSZ],
	CF.Fax AS [Company.Fax],
	CF.phone AS [Company.Phone],
	CF.phone800 AS [Company.Phone800],
	--CASE WHEN (ISNULL(M.AmountDue, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.AmountDue, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.AmountDue), 0), 1) + ')' END AS PromiseAmount,
	
	--Added below letterid condition to setup next pdc for caliber mortgage letters  BGM 4/28/2014
CASE WHEN @LetterID = 315 THEN '$' + CONVERT(VARCHAR(50), ISNULL((SELECT TOP 1 amount
FROM promises WITH (NOLOCK)
WHERE AcctID = m.number AND Active = 1
ORDER BY DueDate ASC),
ISNULL((SELECT TOP 1 amount
FROM pdc WITH (NOLOCK)
WHERE Number = m.number AND Active = 1
ORDER BY deposit ASC),
ISNULL((SELECT TOP 1 amount
FROM debtorcreditcards WITH (NOLOCK)
WHERE Number = m.number AND IsActive = 1
ORDER BY DepositDate ASC), 0))), 1) ELSE CASE WHEN (ISNULL(M.AmountDue, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.AmountDue, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.AmountDue), 0), 1) + ')' END END AS [PromiseAmount],

	--CASE WHEN M.DueDate IS NULL OR M.DueDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.DueDate, 101) END AS PromiseDue,
	--Added below letterid condition to setup next pdc for caliber mortgage letters  BGM 4/28/2014
CASE WHEN @LetterID = 315 THEN CONVERT(VARCHAR(10), ISNULL((SELECT TOP 1 DueDate
FROM promises WITH (NOLOCK)
WHERE AcctID = m.number AND Active = 1
ORDER BY DueDate ASC),
ISNULL((SELECT TOP 1 deposit
FROM pdc WITH (NOLOCK)
WHERE Number = m.number AND Active = 1
ORDER BY deposit ASC),
ISNULL((SELECT TOP 1 DepositDate
FROM debtorcreditcards WITH (NOLOCK)
WHERE Number = m.number AND IsActive = 1
ORDER BY DepositDate ASC), ''))), 101) ELSE CASE WHEN M.DueDate IS NULL OR M.DueDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.DueDate, 101) END END AS [PromiseDue],

	CASE WHEN M.DateRequested IS NULL OR M.DateRequested <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.DateRequested, 101) END AS DateRequested,
	ISNULL(M.SifPmt1, '') AS SifPmt1,
	ISNULL(M.SifPmt2, '') AS SifPmt2,
	ISNULL(M.SifPmt3, '') AS SifPmt3,
	ISNULL(M.SifPmt4, '') AS SifPmt4,
	ISNULL(M.SifPmt5, '') AS SifPmt5,
	ISNULL(M.SifPmt6, '') AS SifPmt6,
	ISNULL(ed1.line1, '') AS L1_Line1,
	ISNULL(ed1.line2, '') AS L1_Line2,
	ISNULL(ed1.line3, '') AS L1_Line3,
	ISNULL(ed1.line4, '') AS L1_Line4,
	ISNULL(ed1.line5, '') AS L1_Line5,
	ISNULL(ed2.line1, '') AS L2_Line1,
	ISNULL(ed2.line2, '') AS L2_Line2,
	ISNULL(ed2.line3, '') AS L2_Line3,
	ISNULL(ed2.line4, '') AS L2_Line4,
	ISNULL(ed2.line5, '') AS L2_Line5,

	--ISNULL(ed3.line1, '') AS L3_Line1,
	--ISNULL(ed3.line2, '') AS L3_Line2,
	--ISNULL(ed3.line3, '') AS L3_Line3,
	--Sending CBR Negative, CBR reportable, OOS for resurgent accounts in L3 lines 1,2,3 added 9/21/2021
CASE WHEN m.customer IN (SELECT customerid
FROM Fact
WHERE customgroupid = 24) THEN CASE esd.ForceCBFlag WHEN 1 THEN 'Y' ELSE 'N' END ELSE ISNULL(ed3.line1, '') END AS [L3_Line1],
CASE WHEN m.customer IN (SELECT customerid
FROM Fact
WHERE customgroupid = 24) THEN CASE esd.MultipleProviders WHEN 1 THEN 'Y' ELSE 'N' END ELSE ISNULL(ed3.line2, '') END AS [L3_Line2],
CASE WHEN m.customer IN (SELECT customerid
FROM Fact
WHERE customgroupid = 24) THEN CASE esd.EFT WHEN 1 THEN 'Y' ELSE 'N' END ELSE ISNULL(ed3.line3, '') END AS [L3_Line3],

	ISNULL(ed3.line4, '') AS L3_Line4,
	ISNULL(ed3.line5, '') AS L3_Line5,
	ISNULL(ed4.line1, '') AS L4_Line1,
	ISNULL(ed4.line2, '') AS L4_Line2,
	ISNULL(ed4.line3, '') AS L4_Line3,
	--Updated L4_Line4 to always send last 4 of account number for Reg F
	--Update L4_Line4 to check extra data then last 4 of account number
	--ISNULL(ed4.line4, '') AS L4_Line4,
	ISNULL(ISNULL(ed4.line4, RIGHT(m.account, 4)), '') AS L4_Line4,

	--ISNULL(ed4.line5, '') AS L4_Line5,
	--using Early Stage Data field EFT to send bit for account being OOS or not OOS
ISNULL(esd.EFT, '') AS [L4_Line5],

	ISNULL(CONVERT(VARCHAR(255), sr.Advisory), '') AS State_Legal_Advisory,
	ISNULL(bc.Name, '') AS BranchName,
	ISNULL(bc.Address1, '') AS BranchAddr1,
	ISNULL(bc.Address2, '') AS BranchAddr2,
	ISNULL(bc.City, '') AS BranchCity,
	ISNULL(bc.state, '') AS BranchState,
	ISNULL(bc.Zipcode, '') AS BranchZip,
	ISNULL(bc.phone, '') AS BranchPhone,
	ISNULL(bc.fax, '') AS BranchFax,
	ISNULL(sd.DebtorID, 0) AS SubjDebtorID,
	ISNULL(sd.Name, '') AS SubjDebtorName,
	LTRIM(ISNULL(CASE sd.isParsed WHEN 1 THEN sd.firstName ELSE sd.Name END + ' ' + CASE sd.isParsed WHEN 1 THEN sd.lastName ELSE sd.Name END, '')) AS SubjDebtorFirstNameFirst,
	ISNULL(CASE sd.isParsed WHEN 1 THEN sd.lastName ELSE sd.Name END, '') AS SubjDebtorLastName,
	ISNULL(CASE sd.isParsed WHEN 1 THEN sd.firstName ELSE sd.Name END, '') AS SubjDebtorFirstName,
	ISNULL(sd.OtherName, '') AS SubjDebtorOther,
	ISNULL(sd.Street1, '') AS SubjDebtorStreet1,
	ISNULL(sd.Street2, '') AS SubjDebtorStreet2,
	ISNULL(sd.City, '') AS SubjDebtorCity,
	ISNULL(sd.State, '') AS SubjDebtorState,
	ISNULL(sd.Zipcode, '') AS SubjDebtorZipcode,
	CASE WHEN LEN(sd.City) > 0 THEN ISNULL(sd.City + ', ' + sd.State + ' ' + sd.Zipcode, '') ELSE ISNULL(sd.State + ' ' + sd.Zipcode, '') END AS SubjDebtorCSZ,
	ISNULL(sd.Email, '') AS SubjDebtorEmail,
	ISNULL(sd.Fax, '') AS SubjDebtorFax,
	ISNULL(M.DLNum, '') AS SubjDebtorDriverLicenseNumber,
	CASE WHEN b.Chapter IS NULL THEN '' ELSE CAST(b.Chapter AS VARCHAR(10)) END AS [SubjDebtorBkcy.Chapter],
	CASE WHEN b.DateFiled IS NULL OR b.DateFiled <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.DateFiled, 101) END AS [SubjDebtorBkcy.FilesDate],
	ISNULL(b.CaseNumber, '') AS [SubjDebtorBkcy.CaseNumber],
	ISNULL(b.CourtCity, '') AS [SubjDebtorBkcy.CourtCity],
	ISNULL(b.CourtDistrict, '') AS [SubjDebtorBkcy.CourtDistrict],
	ISNULL(b.CourtDivision, '') AS [SubjDebtorBkcy.CourtDivision],
	ISNULL(b.CourtPhone, '') AS [SubjDebtorBkcy.CourtPhone],
	ISNULL(b.CourtStreet1, '') AS [SubjDebtorBkcy.CourtStreet1],
	ISNULL(b.CourtStreet2, '') AS [SubjDebtorBkcy.CourtStreet2],
	ISNULL(b.CourtState, '') AS [SubjDebtorBkcy.CourtState],
	ISNULL(b.CourtZipcode, '') AS [SubjDebtorBkcy.CourtZipcode],
	CASE WHEN LEN(b.CourtCity) > 0 THEN ISNULL(b.CourtCity + ', ' + b.CourtState + ' ' + b.CourtZipcode, '') ELSE ISNULL(b.CourtState + ' ' + b.CourtZipcode, '') END AS [SubjDebtorBkcy.CourtCSZ],
	ISNULL(b.Trustee, '') AS [SubjDebtorBkcy.Trustee],
	ISNULL(b.TrusteeStreet1, '') AS [SubjDebtorBkcy.TrusteeStreet1],
	ISNULL(b.TrusteeStreet2, '') AS [SubjDebtorBkcy.TrusteeStreet2],
	ISNULL(b.TrusteeCity, '') AS [SubjDebtorBkcy.TrusteeCity],
	ISNULL(b.TrusteeState, '') AS [SubjDebtorBkcy.TrusteeState],
	ISNULL(b.TrusteeZipcode, '') AS [SubjDebtorBkcy.TrusteeZipcode],
	CASE WHEN LEN(b.TrusteeCity) > 0 THEN ISNULL(b.TrusteeCity + ', ' + b.TrusteeState + ' ' + b.TrusteeZipcode, '') ELSE ISNULL(b.TrusteeState + ' ' + b.TrusteeZipcode, '') END AS [SubjDebtorBkcy.TrusteeCSZ],
	ISNULL(b.TrusteePhone, '') AS [SubjDebtorBkcy.TrusteePhone],

	--ISNULL(da.Name, '') AS [SubjDebtorAttorney.Name],
	--ISNULL(da.Firm, '') AS [SubjDebtorAttorney.Firm],
	--ISNULL(da.Addr1, '') AS [SubjDebtorAttorney.Street1],
	--ISNULL(da.Addr2, '') AS [SubjDebtorAttorney.Street2],
	--ISNULL(da.City, '') AS [SubjDebtorAttorney.City],
	--ISNULL(da.State, '') AS [SubjDebtorAttorney.State],
	--ISNULL(da.Zipcode, '') AS [SubjDebtorAttorney.Zipcode],
	--CASE WHEN LEN(da.City) > 0 THEN ISNULL(da.City + ', ' + da.State + ' ' + da.Zipcode, '') ELSE ISNULL(da.State + ' ' + da.Zipcode, '') END AS [SubjDebtorAttorney.CSZ],
--Updated BGM 06/07/2022 to apply the attorney information first if available and then the executor information if available
	CASE WHEN M.lettercode IN ('CLMCK', 'CLMC1', 'CLMUS') AND (da.Addr1 IS NULL OR da.Addr1 = '') THEN ISNULL(dc.Executor, '') ELSE ISNULL(da.Name, '') END AS [SubjDebtorAttorney.Name],
	CASE WHEN M.lettercode IN ('CLMCK', 'CLMC1', 'CLMUS') AND (da.Addr1 IS NULL OR da.Addr1 = '') THEN '' ELSE ISNULL(da.Firm, '') END AS [SubjDebtorAttorney.Firm],
	CASE WHEN M.lettercode IN ('CLMCK', 'CLMC1', 'CLMUS') AND (da.Addr1 IS NULL OR da.Addr1 = '') THEN ISNULL(dc.ExecutorStreet1, '') ELSE ISNULL(da.Addr1, '') END AS [SubjDebtorAttorney.Street1],
	CASE WHEN M.lettercode IN ('CLMCK', 'CLMC1', 'CLMUS') AND (da.Addr1 IS NULL OR da.Addr1 = '') THEN ISNULL(dc.ExecutorStreet2, '') ELSE ISNULL(da.Addr2, '') END AS [SubjDebtorAttorney.Street2],
	CASE WHEN M.lettercode IN ('CLMCK', 'CLMC1', 'CLMUS') AND (da.Addr1 IS NULL OR da.Addr1 = '') THEN ISNULL(dc.ExecutorCity, '') ELSE ISNULL(da.City, '') END AS [SubjDebtorAttorney.City],
	CASE WHEN M.lettercode IN ('CLMCK', 'CLMC1', 'CLMUS') AND (da.Addr1 IS NULL OR da.Addr1 = '') THEN ISNULL(dc.ExecutorState, '') ELSE ISNULL(da.State, '') END AS [SubjDebtorAttorney.State],
	CASE WHEN M.lettercode IN ('CLMCK', 'CLMC1', 'CLMUS') AND (da.Addr1 IS NULL OR da.Addr1 = '') THEN ISNULL(dc.ExecutorZipcode, '') ELSE ISNULL(da.Zipcode, '') END AS [SubjDebtorAttorney.Zipcode],
	CASE WHEN M.lettercode IN ('CLMCK', 'CLMC1', 'CLMUS') AND ((da.Addr1 IS NULL OR da.Addr1 = '') AND LEN(dc.ExecutorCity) > 0) THEN ISNULL(dc.ExecutorCity + ', ' + dc.ExecutorState + ' ' + dc.ExecutorZipcode, '') ELSE CASE WHEN LEN(da.City) > 0 THEN ISNULL(da.City + ', ' + da.State + ' ' + da.Zipcode, '') ELSE ISNULL(da.State + ' ' + da.Zipcode, '') END END AS [SubjDebtorAttorney.CSZ],

	ISNULL(da.phone, '') AS [SubjDebtorAttorney.Phone],
	ISNULL(da.Fax, '') AS [SubjDebtorAttorney.Fax],
	ISNULL(da.Email, '') AS [SubjDebtorAttorney.Email],
	ISNULL(usend.Alias, '') AS [Sender.Alias],
	ISNULL(usend.Email, '') AS [Sender.Email],
	ISNULL(usend.Extension, '') AS [Sender.Extension],
	ISNULL(usend.phone, '') AS [Sender.Phone],
	ISNULL(usend.UserName, '') AS [Sender.UserName],
	ISNULL(ureq.Alias, '') AS [Requester.Alias],
	ISNULL(ureq.Email, '') AS [Requester.Email],
	ISNULL(ureq.Extension, '') AS [Requester.Extension],
	ISNULL(ureq.phone, '') AS [Requester.Phone],
	ISNULL(ureq.UserName, '') AS [Requester.UserName],
	ISNULL(cu.CustomText1, '') AS [Customer.CustomText1],
	ISNULL(cu.CustomText2, '') AS [Customer.CustomText2],
	ISNULL(cu.CustomText3, '') AS [Customer.CustomText3],
	ISNULL(cu.CustomText4, '') AS [Customer.CustomText4],
	ISNULL(cu.CustomText5, '') AS [Customer.CustomText5],
	CASE WHEN M.DelinquencyDate IS NULL OR M.DelinquencyDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.DelinquencyDate, 101) END AS DelinquencyDate,
	ISNULL(g.CaseNumber, '') AS [Garnishment.CaseNumber],
	ISNULL(g.Company, '') AS [Garnishment.Company],
	ISNULL(g.Addr1, '') AS [Garnishment.Addr1],
	ISNULL(g.Addr2, '') AS [Garnishment.Addr2],
	ISNULL(g.Addr3, '') AS [Garnishment.Addr3],
	ISNULL(g.City, '') AS [Garnishment.City],
	ISNULL(g.State, '') AS [Garnishment.State],
	ISNULL(g.Zipcode, '') AS [Garnishment.Zipcode],
	ISNULL(g.Contact, '') AS [Garnishment.Contact],
	ISNULL(g.Fax, '') AS [Garnishment.Fax],
	ISNULL(g.phone, '') AS [Garnishment.Phone],
	ISNULL(g.Email, '') AS [Garnishment.Email],
	CASE WHEN g.DateFiled IS NULL OR g.DateFiled <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), g.DateFiled, 101) END AS [Garnishment.DateFiled],
	CASE WHEN g.ServiceDate IS NULL OR g.ServiceDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), g.ServiceDate, 101) END AS [Garnishment.ServiceDate],
	CASE WHEN g.ExpireDate IS NULL OR g.ExpireDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), g.ExpireDate, 101) END AS [Garnishment.ExpireDate],
	CASE WHEN (ISNULL(g.PrinAmt, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(g.PrinAmt, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(g.PrinAmt), 0), 1) + ')' END AS [Garnishment.PrinAmt],
	CASE WHEN (ISNULL(g.PreJmtInt, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(g.PreJmtInt, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(g.PreJmtInt), 0), 1) + ')' END AS [Garnishment.PreJmtInt],
	CASE WHEN (ISNULL(g.PostJmtInt, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(g.PostJmtInt, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(g.PostJmtInt), 0), 1) + ')' END AS [Garnishment.PostJmtInt],
	CASE WHEN (ISNULL(g.Costs, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(g.Costs, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(g.Costs), 0), 1) + ')' END AS [Garnishment.Costs],
	CASE WHEN (ISNULL(g.OtherAmt, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(g.OtherAmt, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(g.OtherAmt), 0), 1) + ')' END AS [Garnishment.OtherAmt],
	ISNULL(M.id1, '') AS Id1,
	ISNULL(M.id2, '') AS Id2,
	CASE WHEN COALESCE(lb.current1, M.current1, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current1, M.current1, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current1, M.current1, 0), 1) END AS LinkedPrincipal,
	CASE WHEN COALESCE(lb.current2, M.current2, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current2, M.current2, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current2, M.current2, 0), 1) END AS LinkedInterest,
	ISNULL(cu.phone, '') AS [Customer.Phone],

	-- NEW FOR 4.36.4+
	CASE WHEN b.DateTime341 IS NULL OR b.DateTime341 <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.DateTime341, 101) END AS [SubjDebtorBkcy.Date341],
	ISNULL(b.Location341, '') AS [SubjDebtorBkcy.Location341],
	CASE WHEN b.TransmittedDate IS NULL OR b.TransmittedDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.TransmittedDate, 101) END AS [SubjDebtorBkcy.DateTransmitted],
	ISNULL(b.ConvertedFrom, '') AS [SubjDebtorBkcy.ConvertedFrom],
	CASE WHEN b.DateNotice IS NULL OR b.DateNotice <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.DateNotice, 101) END AS [SubjDebtorBkcy.NoticeDate],
	CASE WHEN b.ProofFiled IS NULL OR b.ProofFiled <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.ProofFiled, 101) END AS [SubjDebtorBkcy.ProofFiledDate],
	CASE WHEN b.DischargeDate IS NULL OR b.DischargeDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.DischargeDate, 101) END AS [SubjDebtorBkcy.DateDischarge],
	CASE WHEN b.DismissalDate IS NULL OR b.DismissalDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.DismissalDate, 101) END AS [SubjDebtorBkcy.DateDismissal],
	CASE WHEN b.ConfirmationHearingDate IS NULL OR b.ConfirmationHearingDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.ConfirmationHearingDate, 101) END AS [SubjDebtorBkcy.DateConfirmationHearing],
	CASE WHEN b.ReaffirmDateFiled IS NULL OR b.ReaffirmDateFiled <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.ReaffirmDateFiled, 101) END AS [SubjDebtorBkcy.DateReaffirmFiled],
	ISNULL(b.ReaffirmTerms, '') AS [SubjDebtorBkcy.ReaffirmTerms],
	CASE WHEN b.VoluntaryDate IS NULL OR b.VoluntaryDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.VoluntaryDate, 101) END AS [SubjDebtorBkcy.DateVoluntary],
	ISNULL(b.VoluntaryTerms, '') AS [SubjDebtorBkcy.VoluntaryTerms],
	CASE WHEN b.SurrenderDate IS NULL OR b.SurrenderDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.SurrenderDate, 101) END AS [SubjDebtorBkcy.DateSurrender],
	ISNULL(b.SurrenderMethod, '') AS [SubjDebtorBkcy.SurrenderMethod],
	ISNULL(b.AuctionHouse, '') AS [SubjDebtorBkcy.AuctionHouse],
	CASE WHEN b.AuctionDate IS NULL OR b.AuctionDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), b.AuctionDate, 101) END AS [SubjDebtorBkcy.DateAuction],
	CASE WHEN ISNULL(b.AuctionAmount, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(b.AuctionAmount, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(b.AuctionAmount, 0)), 1) + ')' END AS [SubjDebtorBkcy.AuctionAmount],
	CASE WHEN ISNULL(b.AuctionFee, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(b.AuctionFee, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(b.AuctionFee, 0)), 1) + ')' END AS [SubjDebtorBkcy.AuctionFee],
	CASE WHEN ISNULL(b.AuctionAmountApplied, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(b.AuctionAmountApplied, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(b.AuctionAmountApplied, 0)), 1) + ')' END AS [SubjDebtorBkcy.AuctionAmountApplied],
	CASE WHEN ISNULL(b.SecuredAmount, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(b.SecuredAmount, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(b.SecuredAmount, 0)), 1) + ')' END AS [SubjDebtorBkcy.SecuredAmount],
	CASE WHEN ISNULL(b.SecuredPercentage, 0) >= 0 THEN '%' + CONVERT(VARCHAR(50), ISNULL(b.SecuredPercentage, 0), 1) ELSE '(%' + CONVERT(VARCHAR(50), ABS(ISNULL(b.SecuredPercentage, 0)), 1) + ')' END AS [SubjDebtorBkcy.SecuredPercentage],
	CASE WHEN ISNULL(b.UnsecuredAmount, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(b.UnsecuredAmount, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(b.UnsecuredAmount, 0)), 1) + ')' END AS [SubjDebtorBkcy.UnsecuredAmount],
	CASE WHEN ISNULL(b.UnsecuredPercentage, 0) >= 0 THEN '%' + CONVERT(VARCHAR(50), ISNULL(b.UnsecuredPercentage, 0), 1) ELSE '(%' + CONVERT(VARCHAR(50), ABS(ISNULL(b.UnsecuredPercentage, 0)), 1) + ')' END AS [SubjDebtorBkcy.UnsecuredPercentage],
	ISNULL(dc.SSN, '') AS [Deceased.SSN],
	ISNULL(dc.LastName, '') AS [Deceased.LastName],
	ISNULL(dc.FirstName, '') AS [Deceased.FirstName],
	ISNULL(dc.FirstName, '') + ' ' + ISNULL(dc.LastName, '') AS [Deceased.FirstNameFirst],
	ISNULL(dc.LastName, '') + ', ' + ISNULL(dc.FirstName, '') AS [Deceased.LastNameFirst],
	ISNULL(dc.State, '') AS [Deceased.State],
	ISNULL(dc.PostalCode, '') AS [Deceased.PostalCode],
	CASE WHEN dc.DOB IS NULL OR	dc.DOB <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), dc.DOB, 101) END AS [Deceased.DateOfBirth],
	CASE WHEN dc.DOD IS NULL OR	dc.DOD <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), dc.DOD, 101) END AS [Deceased.DateOfDeath],
	ISNULL(dc.MatchCode, '') AS [Deceased.MatchCode],
	CASE WHEN dc.TransmittedDate IS NULL OR	dc.TransmittedDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), dc.TransmittedDate, 101) END AS [Deceased.DateTransmitted],
	CASE WHEN dc.ClaimDeadline IS NULL OR dc.ClaimDeadline <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), dc.ClaimDeadline, 101) END AS [Deceased.DateClaimDeadline],
	CASE WHEN dc.DateFiled IS NULL OR dc.DateFiled <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), dc.DateFiled, 101) END AS [Deceased.FiledDate],
	ISNULL(dc.CaseNumber, '') AS [Deceased.CaseNumber],
	ISNULL(dc.Executor, '') AS [Deceased.Executor],
	ISNULL(dc.ExecutorPhone, '') AS [Deceased.ExecutorPhone],
	ISNULL(dc.ExecutorFax, '') AS [Deceased.ExecutorFax],
	ISNULL(dc.ExecutorStreet1, '') AS [Deceased.ExecutorStreet1],
	ISNULL(dc.ExecutorStreet2, '') AS [Deceased.ExecutorStreet2],
	ISNULL(dc.ExecutorCity, '') AS [Deceased.ExecutorCity],
	ISNULL(dc.ExecutorState, '') AS [Deceased.ExecutorState],
	ISNULL(dc.ExecutorZipcode, '') AS [Deceased.ExecutorZipCode],
	ISNULL(dc.ExecutorCity, '') + ', ' + ISNULL(dc.ExecutorState, '') + ' ' + ISNULL(dc.ExecutorZipcode, '') AS [Deceased.ExecutorCSZ],
	ISNULL(dc.CourtDistrict, '') AS [Deceased.CourtDistrict],
	ISNULL(dc.CourtDivision, '') AS [Deceased.CourtDivision],
	ISNULL(dc.CourtPhone, '') AS [Deceased.CourtPhone],
	ISNULL(dc.CourtStreet1, '') AS [Deceased.CourtStreet1],
	ISNULL(dc.CourtStreet2, '') AS [Deceased.CourtStreet2],
	ISNULL(dc.CourtCity, '') AS [Deceased.CourtCity],
	ISNULL(dc.CourtState, '') AS [Deceased.CourtState],
	ISNULL(dc.CourtZipcode, '') AS [Deceased.CourtZipcode],
	ISNULL(dc.CourtCity, '') + ', ' + ISNULL(dc.CourtState, '') + ' ' + ISNULL(dc.CourtZipcode, '') AS [Deceased.CourtCSZ],
	ISNULL(cs.ClientID, '') AS [CCCS.ClientID],
	ISNULL(cs.Contact, '') AS [CCCS.Contact],
	ISNULL(cs.CompanyName, '') AS [CCCS.CompanyName],
	ISNULL(cs.CreditorID, '') AS [CCCS.CreditorID],
	CASE WHEN cs.DateCreated IS NULL OR	cs.DateCreated <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cs.DateCreated, 101) END AS [CCCS.CreatedDate],
	CASE WHEN cs.DateModified IS NULL OR cs.DateModified <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cs.DateModified, 101) END AS [CCCS.ModifiedDate],
	CASE WHEN cs.DateAccepted IS NULL OR cs.DateAccepted <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cs.DateAccepted, 101) END AS [CCCS.AcceptedDate],
	CASE WHEN ISNULL(cs.AcceptedAmount, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(cs.AcceptedAmount, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(cs.AcceptedAmount, 0)), 1) + ')' END AS [CCCS.AcceptedAmount],
	ISNULL(cs.Comments, '') AS [CCCS.Comments],
	ISNULL(cs.phone, '') AS [CCCS.Phone],
	ISNULL(cs.Fax, '') AS [CCCS.Fax],
	ISNULL(cs.Street1, '') AS [CCCS.Street1],
	ISNULL(cs.Street2, '') AS [CCCS.Street2],
	ISNULL(cs.City, '') AS [CCCS.City],
	ISNULL(cs.State, '') AS [CCCS.State],
	ISNULL(cs.ZipCode, '') AS [CCCS.Zipcode],
	ISNULL(cs.City, '') + ', ' + ISNULL(cs.State, '') + ' ' + ISNULL(cs.ZipCode, '') AS [CCCS.CccsCSZ],
	CASE WHEN ISNULL(esd.CurrentDue, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.CurrentDue, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.CurrentDue, 0)), 1) + ')' END AS [ESD.CurrentDue],
	CASE WHEN ISNULL(esd.CurrentMinDue, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.CurrentMinDue, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.CurrentMinDue, 0)), 1) + ')' END AS [ESD.CurrentMinDue],
	ISNULL(esd.PaymentHistory, '') AS [ESD.PaymentHistory],

	--CASE WHEN ISNULL(esd.Current30, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current30, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current30, 0)), 1) + ')' END AS [ESD.Current30],
	--CASE WHEN ISNULL(esd.Current60, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current60, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current60, 0)), 1) + ')' END AS [ESD.Current60],
	--CASE WHEN ISNULL(esd.Current90, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current90, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current90, 0)), 1) + ')' END AS [ESD.Current90],
	--CASE WHEN ISNULL(esd.Current120, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current120, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current120, 0)), 1) + ')' END AS [ESD.Current120],
	--CASE WHEN ISNULL(esd.Current150, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current150, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current150, 0)), 1) + ')' END AS [ESD.Current150],
	--CASE WHEN ISNULL(esd.Current180, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current180, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current180, 0)), 1) + ')' END AS [ESD.Current180],
	CASE WHEN M.lettercode = 'NY01' THEN CASE WHEN ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 1), 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 1), 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 1), 0)), 1) + ')' END ELSE CASE WHEN ISNULL(esd.Current30, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current30, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current30, 0)), 1) + ')' END END AS [ESD.Current30],

CASE WHEN M.lettercode = 'NY01' THEN CASE WHEN ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 2), 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 2), 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 2), 0)), 1) + ')' END ELSE CASE WHEN ISNULL(esd.Current60, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current60, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current60, 0)), 1) + ')' END END AS [ESD.Current60],

CASE WHEN M.lettercode = 'NY01' THEN CASE WHEN ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 3), 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 3), 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 3), 0)), 1) + ')' END ELSE CASE WHEN ISNULL(esd.Current90, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current90, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current90, 0)), 1) + ')' END END AS [ESD.Current90],

CASE WHEN M.lettercode = 'NY01' THEN CASE WHEN ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 4), 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 4), 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 4), 0)), 1) + ')' END ELSE CASE WHEN ISNULL(esd.Current120, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current120, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current120, 0)), 1) + ')' END END AS [ESD.Current120],

CASE WHEN M.lettercode = 'NY01' THEN CASE WHEN ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 5), 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 5), 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 5), 0)), 1) + ')' END ELSE CASE WHEN ISNULL(esd.Current150, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current150, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current150, 0)), 1) + ')' END END AS [ESD.Current150],

CASE WHEN M.lettercode = 'NY01' THEN CASE WHEN ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 6), 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 6), 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 6), 0)), 1) + ')' END ELSE CASE WHEN ISNULL(esd.Current180, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Current180, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Current180, 0)), 1) + ')' END END AS [ESD.Current180],

	
	CASE WHEN ISNULL(esd.StatementDue, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.StatementDue, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.StatementDue, 0)), 1) + ')' END AS [ESD.StatementDue],
	CASE WHEN ISNULL(esd.StatementMinDue, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.StatementMinDue, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.StatementMinDue, 0)), 1) + ')' END AS [ESD.StatementMinDue],
	CASE WHEN ISNULL(esd.Statement30, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Statement30, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Statement30, 0)), 1) + ')' END AS [ESD.Statement30],
	CASE WHEN ISNULL(esd.Statement60, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Statement60, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Statement60, 0)), 1) + ')' END AS [ESD.Statement60],
	CASE WHEN ISNULL(esd.Statement90, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Statement90, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Statement90, 0)), 1) + ')' END AS [ESD.Statement90],

	--CASE WHEN ISNULL(esd.Statement120, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Statement120, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Statement120, 0)), 1) + ')' END AS [ESD.Statement120],
	CASE WHEN M.lettercode = 'NY01' THEN CASE WHEN ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 10), 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 10), 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 10), 0)), 1) + ')' END ELSE CASE WHEN ISNULL(esd.Statement120, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Statement120, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Statement120, 0)), 1) + ')' END END AS [ESD.Statement120],

	CASE WHEN ISNULL(esd.Statement150, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Statement150, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Statement150, 0)), 1) + ')' END AS [ESD.Statement150],
	CASE WHEN ISNULL(esd.Statement180, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.Statement180, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.Statement180, 0)), 1) + ')' END AS [ESD.Statement180],
	ISNULL(esd.PromoIndicator, '') AS [ESD.PromoIndicator],
	CASE WHEN esd.PromoExpDate IS NULL OR esd.PromoExpDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), esd.PromoExpDate, 101) END AS [ESD.DatePromoExp],
	ISNULL(CONVERT(VARCHAR(10), esd.CyclePreviousBegin, 101), '') AS [ESD.CyclePreviousDateBegin],
	--CASE WHEN ISNULL(esd.InterestRate, 0) >= 0 THEN '%' + CONVERT(VARCHAR(50), ISNULL(esd.InterestRate, 0), 1) ELSE '(%' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.InterestRate, 0)), 1) + ')' END AS [ESD.InterestRate],
	--5/7/2014 removed % sign from front of number  BGM
CASE WHEN ISNULL(esd.InterestRate, 0) >= 0 THEN CONVERT(VARCHAR(50), ISNULL(esd.InterestRate, 0), 1) ELSE '(' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.InterestRate, 0)), 1) + ')' END AS [ESD.InterestRate],

	ISNULL(CONVERT(VARCHAR(10), esd.CyclePreviousDue, 101), '') AS [ESD.CyclePreviousDueDate],
	ISNULL(CONVERT(VARCHAR(10), esd.CyclePreviousLate, 101), '') AS [ESD.CyclePreviousLateDate],
	ISNULL(CONVERT(VARCHAR(10), esd.CyclePreviousEnd, 101), '') AS [ESD.CyclePreviousEndDate],
	ISNULL(esd.SubStatuses, '') AS [ESD.SubStatuses],
	
	--CASE WHEN ISNULL(esd.FixedMinPayment, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.FixedMinPayment, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.FixedMinPayment, 0)), 1) + ')' END AS [ESD.FixedMinPayment],
	CASE WHEN M.lettercode = 'NY01' THEN CASE WHEN ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 12), 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 12), 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(dbo.Custom_NY_Qtrly_Paid_Since_Last_Stmt(m.number, 12), 0)), 1) + ')' END ELSE CASE WHEN ISNULL(esd.FixedMinPayment, 0) >= 0 THEN '$' + CONVERT(VARCHAR(50), ISNULL(esd.FixedMinPayment, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ABS(ISNULL(esd.FixedMinPayment, 0)), 1) + ')' END END AS [ESD.FixedMinPayment],

	ISNULL(CAST(esd.MultipleAccounts AS VARCHAR(50)), '') AS [ESD.MultipleAccounts],
	ISNULL(esd.AROwner, '') AS [ESD.AROwner],
	ISNULL(esd.PlanCode, '') AS [ESD.PlanCode],
	ISNULL(esd.ProviderType, '') AS [ESD.ProviderType],
	ISNULL(esd.LateFeeAccessed, '') AS [ESD.LateFeeAccessed],
	ISNULL(esd.CycleCode, '') AS [ESD.CycleCode],
	ISNULL(CONVERT(VARCHAR(10), esd.CycleCurrentBegin, 101), '') AS [ESD.CycleCurrentBeginDate],
	ISNULL(CONVERT(VARCHAR(10), esd.CycleCurrentDue, 101), '') AS [ESD.CycleCurrentDueDate],
	ISNULL(CONVERT(VARCHAR(10), esd.CycleCurrentLate, 101), '') AS [ESD.CycleCurrentLateDate],
	ISNULL(CONVERT(VARCHAR(10), esd.CycleCurrentEnd, 101), '') AS [ESD.CycleCurrentEndDate],
	ISNULL(CONVERT(VARCHAR(10), esd.CycleNextBegin, 101), '') AS [ESD.CycleNextBeginDate],
	ISNULL(CONVERT(VARCHAR(10), esd.CycleNextDue, 101), '') AS [ESD.CycleNextDueDate],
	ISNULL(CONVERT(VARCHAR(10), esd.CycleNextLate, 101), '') AS [ESD.CycleNextLateDate],
	ISNULL(CONVERT(VARCHAR(10), esd.CycleNextEnd, 101), '') AS [ESD.CycleNextEndDate],

	-- Added in Latitude 6.1.5
	ISNULL(pati.Name, '') AS [PatientInfo.Name],
	ISNULL(pati.Street1, '') AS [PatientInfo.Street1],
	ISNULL(pati.Street2, '') AS [PatientInfo.Street2],
	ISNULL(pati.City, '') AS [PatientInfo.City],
	ISNULL(pati.State, '') AS [PatientInfo.State],
	ISNULL(pati.ZipCode, '') AS [PatientInfo.ZipCode],
	ISNULL(pati.Country, '') AS [PatientInfo.Country],
	ISNULL(pati.phone, '') AS [PatientInfo.HomePhone],
	ISNULL(pati.SSN, '') AS [PatientInfo.SSN],
	ISNULL(pati.Sex, '') AS [PatientInfo.Sex],
	ISNULL(CAST(pati.Age AS VARCHAR(3)), '') AS [PatientInfo.Age],
	CASE WHEN pati.DOB IS NULL OR pati.DOB <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), pati.DOB, 101) END AS [PatientInfo.DOB],
	ISNULL(pati.EmployerName, '') AS [PatientInfo.EmployerName],
	ISNULL(pati.WorkPhone, '') AS [PatientInfo.WorkPhone],
	ISNULL(pati.PatientRecNumber, '') AS [PatientInfo.RecNum],
	ISNULL(pati.GuarantorRecNumber, '') AS [PatientInfo.GarNum],
	CASE WHEN pati.AdmissionDate IS NULL OR	pati.AdmissionDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), pati.AdmissionDate, 101) END AS [PatientInfo.AdmissionDate],
	CASE WHEN pati.ServiceDate IS NULL OR pati.ServiceDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), pati.ServiceDate, 101) END AS [PatientInfo.ServiceDate],
	CASE WHEN pati.DischargeDate IS NULL OR	pati.DischargeDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), pati.DischargeDate, 101) END AS [PatientInfo.DischargeDate],
	ISNULL(pati.FacilityName, '') AS [PatientInfo.FacilityName],
	ISNULL(pati.FacilityStreet1, '') AS [PatientInfo.FacilityStreet1],
	ISNULL(pati.FacilityStreet2, '') AS [PatientInfo.FacilityStreet2],
	ISNULL(pati.FacilityCity, '') AS [PatientInfo.FacilityCity],
	ISNULL(pati.FacilityState, '') AS [PatientInfo.FacilityState],
	ISNULL(pati.FacilityZipCode, '') AS [PatientInfo.FacilityZipCode],
	ISNULL(pati.FacilityCountry, '') AS [PatientInfo.FacilityCountry],
	ISNULL(pati.FacilityPhone, '') AS [PatientInfo.FacilityPhone],
	ISNULL(pati.FacilityFax, '') AS [PatientInfo.FacilityFax],
	ISNULL(pati.DoctorName, '') AS [PatientInfo.DoctorName],
	ISNULL(pati.DoctorPhone, '') AS [PatientInfo.DoctorPhone],
	ISNULL(pati.DoctorFax, '') AS [PatientInfo.DoctorFax],
	ISNULL(pati.KinName, '') AS [PatientInfo.KinName],
	ISNULL(pati.KinStreet1, '') AS [PatientInfo.KinStreet1],
	ISNULL(pati.KinStreet2, '') AS [PatientInfo.KinStreet2],
	ISNULL(pati.KinCity, '') AS [PatientInfo.KinCity],
	ISNULL(pati.KinState, '') AS [PatientInfo.KinState],
	ISNULL(pati.KinZipCode, '') AS [PatientInfo.KinZipCode],
	ISNULL(pati.KinCountry, '') AS [PatientInfo.KinCountry],
	ISNULL(pati.KinPhone, '') AS [PatientInfo.KinPhone],
	ISNULL(cc.CourtRoom, '') AS [CourtCase.CourtRoom],
	CASE WHEN cc.ServiceDate IS NULL OR	cc.ServiceDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.ServiceDate, 101) END AS [CourtCase.ServiceDate],
	ISNULL(cc.ServiceType, '') AS [CourtCase.ServiceType],
	CASE WHEN cc.DiscoveryReplyDate IS NULL OR cc.DiscoveryReplyDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.DiscoveryReplyDate, 101) END AS [CourtCase.DiscReplyDate],
	CASE WHEN (ISNULL(cc.JudgementAttorneyCostAward, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(cc.JudgementAttorneyCostAward, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(cc.JudgementAttorneyCostAward), 0), 1) + ')' END AS [CourtCase.JudgementAttorneyCostAward],
	CASE WHEN (ISNULL(cc.JudgementAmt, 0) + ISNULL(cc.JudgementIntAward, 0) + ISNULL(cc.JudgementCostAward, 0) + ISNULL(cc.JudgementOtherAward, 0) + ISNULL(cc.JudgementAttorneyCostAward, 0)) >= 0 THEN '$' + CONVERT(VARCHAR(50), (ISNULL(cc.JudgementAmt, 0) + ISNULL(cc.JudgementIntAward, 0) + ISNULL(cc.JudgementCostAward, 0) + ISNULL(cc.JudgementOtherAward, 0) + ISNULL(cc.JudgementAttorneyCostAward, 0)), 1) ELSE '($' + CONVERT(VARCHAR(50), (ISNULL(cc.JudgementAmt, 0) + ISNULL(cc.JudgementIntAward, 0) + ISNULL(cc.JudgementCostAward, 0) + ISNULL(cc.JudgementOtherAward, 0) + ISNULL(cc.JudgementAttorneyCostAward, 0)), 1) + ')' END AS [CourtCase.JudgementTotalAmt],
	ISNULL(cc.JudgementBook, '') AS [CourtCase.JudgementBook],
	ISNULL(cc.JudgementPage, '') AS [CourtCase.JudgementPage],
	CASE WHEN cc.JudgementRecordedDate IS NULL OR cc.JudgementRecordedDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.JudgementRecordedDate, 101) END AS [CourtCase.JudgementRecordedDate],
	ISNULL(cc.AttorneyAccountID, '') AS [CourtCase.AttorneyAccountID],
	CASE WHEN cc.ArbitrationDate IS NULL OR	cc.ArbitrationDate <= '1900-01-01' THEN '' ELSE LTRIM(RIGHT(CONVERT(VARCHAR(20), cc.ArbitrationDate, 100), 7)) END AS [CourtCase.ArbitrationTime],
	CASE WHEN cc.ArbitrationDate IS NULL OR	cc.ArbitrationDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(50), cc.ArbitrationDate, 101) + ' ' +                  LTRIM(RIGHT(CONVERT(VARCHAR(50), cc.ArbitrationDate, 100), 7)) END AS [CourtCase.ArbitrationDateTime],
	CASE WHEN cc.CourtDate IS NULL OR cc.CourtDate <= '1900-01-01' THEN '' ELSE LTRIM(RIGHT(CONVERT(VARCHAR(20), cc.CourtDate, 100), 7)) END AS [CourtCase.CourtTime],
	CASE WHEN cc.CourtDate IS NULL OR cc.CourtDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(50), cc.CourtDate, 101) + ' ' + LTRIM(RIGHT(CONVERT(VARCHAR(50), cc.CourtDate, 100), 7)) END AS [CourtCase.CourtDateTime],
	CASE WHEN cc.DateAnswered IS NULL OR cc.DateAnswered <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.DateAnswered, 101) END AS [CourtCase.DateAnswered],
	CASE WHEN cc.StatuteDeadline IS NULL OR	cc.StatuteDeadline <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.StatuteDeadline, 101) END AS [CourtCase.StatuteDeadlineDate],
	CASE WHEN cc.MotionCutoff IS NULL OR cc.MotionCutoff <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.MotionCutoff, 101) END AS [CourtCase.MotionCutOffDate],
	CASE WHEN cc.DiscoveryCutoff IS NULL OR	cc.DiscoveryCutoff <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.DiscoveryCutoff, 101) END AS [CourtCase.DiscoveryCutOffDate],
	CASE WHEN cc.LastSummaryJudgementDate IS NULL OR cc.LastSummaryJudgementDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), cc.LastSummaryJudgementDate, 101) END AS [CourtCase.LastSummaryJdgDate],
	ISNULL(jco.CourtName, '') AS [CourtCase.JudgementCourt.CourtName],
	ISNULL(jco.Address1, '') AS [CourtCase.JudgementCourt.Street1],
	ISNULL(jco.Address2, '') AS [CourtCase.JudgementCourt.Street2],
	ISNULL(jco.City, '') AS [CourtCase.JudgementCourt.City],
	ISNULL(jco.State, '') AS [CourtCase.JudgementCourt.State],
	ISNULL(jco.Zipcode, '') AS [CourtCase.JudgementCourt.Zipcode],
	ISNULL(jco.County, '') AS [CourtCase.JudgementCourt.County],
	CASE WHEN LEN(jco.City) > 0 THEN ISNULL(jco.City + ', ' + jco.State + ' ' + jco.Zipcode, '') ELSE ISNULL(jco.State + ' ' + jco.Zipcode, '') END AS [CourtCase.JudgementCourt.CSZ],
	ISNULL(jco.phone, '') AS [CourtCase.JudgementCourt.Phone],
	ISNULL(jco.Fax, '') AS [CourtCase.JudgementCourt.Fax],
	ISNULL(jco.Salutation, '') AS [CourtCase.JudgementCourt.ClerkSalutation],
	ISNULL(jco.ClerkFirstName, '') AS [CourtCase.JudgementCourt.ClerkFirstName],
	ISNULL(jco.ClerkMiddleName, '') AS [CourtCase.JudgementCourt.ClerkMiddleName],
	ISNULL(jco.ClerkLastName, '') AS [CourtCase.JudgementCourt.ClerkLastName],
	ISNULL(ISNULL(jco.ClerkFirstName + ' ', '') + ISNULL(jco.ClerkMiddleName + ' ', '') + jco.ClerkLastName, '') AS [CourtCase.JudgementCourt.ClerkFullName],
	CASE WHEN M.ContractDate IS NULL OR	M.ContractDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.ContractDate, 101) END AS ContractDate,
	CASE WHEN M.ChargeOffDate IS NULL OR M.ChargeOffDate <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), M.ChargeOffDate, 101) END AS ChargeOffDate,
	CASE WHEN (ISNULL(M.clialp, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.clialp, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.clialp), 0), 1) + ')' END AS AmountLastPaid,
	CASE WHEN (ISNULL(M.clialc, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(M.clialc, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(M.clialc), 0), 1) + ')' END AS AmountLastCharge,
	--ISNULL(M.PreviousCreditor, '') AS PreviousCreditor,
	--Updated to use miscextra for Upgrade Probate customer 2043 due to length of data
CASE WHEN m.customer IN ('0002043') THEN ISNULL((SELECT TOP 1 TheData
FROM MiscExtra WITH (NOLOCK)
WHERE Number = m.number AND Title = 'acc.0.investor_name'), '') 
--Added in to pull special client name for customer 1283
WHEN m.customer = '0001283' THEN (SELECT TOP 1 TheData
FROM dbo.MiscExtra WITH (NOLOCK)
WHERE Number = m.number AND Title = '08.0.plaintiff_1')	+ (SELECT TOP 1 TheData
FROM dbo.MiscExtra WITH (NOLOCK)
WHERE Number = m.number AND Title = '08.0.plaintiff_2') ELSE ISNULL(m.PreviousCreditor, '') END AS [PreviousCreditor],

	--ISNULL(dbi.ABANumber, '') AS [BankInfo.ABANumber],
	--ISNULL(dbi.AccountNumber, '') AS [BankInfo.AccountNumber],
	--ISNULL(dbi.AccountName, '') AS [BankInfo.AccountName],
	--ISNULL(dbi.AccountAddress1, '') AS [BankInfo.AccountAddr1],
	--ISNULL(dbi.AccountAddress2, '') AS [BankInfo.AccountAddr2],
	--ISNULL(dbi.AccountCity, '') AS [BankInfo.AccountCity],
	--ISNULL(dbi.AccountState, '') AS [BankInfo.AccountState],
	--ISNULL(dbi.AccountZipcode, '') AS [BankInfo.AccountZipCode],
	--CASE WHEN LEN(dbi.AccountCity) > 0 THEN ISNULL(dbi.AccountCity + ', ' + dbi.AccountState + ' ' + dbi.AccountZipcode, '') ELSE ISNULL(dbi.AccountState + ' ' + dbi.AccountZipcode, '') END AS [BankInfo.AccountCSZ],
	--ISNULL(dbi.BankName, '') AS [BankInfo.BankName],
	--ISNULL(dbi.BankAddress, '') AS [BankInfo.BankAddr1],
	--ISNULL(dbi.BankCity, '') AS [BankInfo.BankCity],
	--ISNULL(dbi.BankState, '') AS [BankInfo.BankState],
	--ISNULL(dbi.BankZipcode, '') AS [BankInfo.BankZipCode],
	--CASE WHEN LEN(dbi.BankCity) > 0 THEN ISNULL(dbi.BankCity + ', ' + dbi.BankState + ' ' + dbi.BankZipcode, '') ELSE ISNULL(dbi.BankState + ' ' + dbi.BankZipcode, '') END AS [BankInfo.BankCSZ],
	--ISNULL(dbi.BankPhone, '') AS [BankInfo.Phone],
	-- Updated 08/13/2021 BGM changed bankinfo and bankaccount info to pull from wallet table or debtorbankinfo table
ISNULL((SELECT TOP 1 w.InstitutionCode
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.ABANumber, '')) AS [BankInfo.ABANumber],
--05/17/2023 BGM Updated account number to only show last 4 account numbers and remvoved filler characters
--ISNULL((SELECT TOP 1 RIGHT(REPLACE(w.AccountNumber, '*', ''), 4)
--FROM Wallet w WITH (NOLOCK)
--	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
--WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
--ORDER BY w.ID DESC), ISNULL(RIGHT(dbi.AccountNumber, 4), ''))
--12/04/2023 BGM Updated account number to now send the last 4 digits for a credit card to BNKAG and SLMAG letters
CASE WHEN M.LetterCode IN ('BNKAG', 'SLMAG')
THEN ISNULL((SELECT TOP 1 RIGHT(REPLACE(w.AccountNumber, '*', ''), 4)
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType = 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL((SELECT TOP 1 RIGHT(dcc.CardNumber, 4) 
FROM DebtorCreditCards dcc WITH (NOLOCK) 
WHERE dcc.DebtorID = sd.DebtorID order BY dcc.ID DESC), ''))
ELSE
ISNULL((SELECT TOP 1 RIGHT(REPLACE(w.AccountNumber, '*', ''), 4)
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(RIGHT(dbi.AccountNumber, 4), ''))
END AS [BankInfo.AccountNumber],
ISNULL((SELECT TOP 1 w.PayorName
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.AccountName, '')) AS [BankInfo.AccountName],
ISNULL((SELECT TOP 1 wc.AccountAddress1
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.AccountAddress1, '')) AS [BankInfo.AccountAddr1],
ISNULL((SELECT TOP 1 wc.AccountAddress2
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.AccountAddress2, '')) AS [BankInfo.AccountAddr2],
ISNULL((SELECT TOP 1 wc.AccountCity
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.AccountCity, '')) AS [BankInfo.AccountCity],
ISNULL((SELECT TOP 1 wc.AccountState
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.AccountState, '')) AS [BankInfo.AccountState],
ISNULL((SELECT TOP 1 wc.AccountZipcode
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.AccountZipcode, '')) AS [BankInfo.AccountZipCode],
CASE WHEN (SELECT TOP 1 ISNULL(wc.AccountCity, '') + ISNULL(wc.AccountState, '') + ISNULL(wc.AccountZipcode, '')
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC) <> '' THEN CASE WHEN LEN((SELECT TOP 1 wc.AccountCity
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC)) > 0 THEN ISNULL((SELECT TOP 1 ISNULL(wc.AccountCity + ', ' + wc.AccountState + ' ' + wc.AccountZipcode, '')
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), '') ELSE ISNULL((SELECT TOP 1 ISNULL(wc.AccountState + ' ' + wc.AccountZipcode, '')
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), '') END ELSE CASE WHEN LEN(dbi.AccountCity) > 0 THEN ISNULL(dbi.AccountCity + ', ' + dbi.AccountState + ' ' + dbi.AccountZipcode, '') ELSE ISNULL(dbi.AccountState + ' ' + dbi.AccountZipcode, '') END END AS [BankInfo.AccountCSZ],
ISNULL((SELECT TOP 1 wc.BankName
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.BankName, '')) AS [BankInfo.BankName],
ISNULL((SELECT TOP 1 wc.BankAddress
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.BankAddress, '')) AS [BankInfo.BankAddr1],
ISNULL((SELECT TOP 1 wc.BankCity
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.BankCity, '')) AS [BankInfo.BankCity],
ISNULL((SELECT TOP 1 wc.BankState
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.BankState, '')) AS [BankInfo.BankState],
ISNULL((SELECT TOP 1 wc.BankZipcode
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.BankZipcode, '')) AS [BankInfo.BankZipCode],
CASE WHEN (SELECT TOP 1 ISNULL(wc.BankCity, '') + ISNULL(wc.BankState, '') + ISNULL(wc.BankZipcode, '')
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC) <> '' THEN CASE WHEN LEN((SELECT TOP 1 wc.BankCity
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC)) > 0 THEN ISNULL((SELECT TOP 1 ISNULL(wc.BankCity + ', ' + wc.BankState + ' ' + wc.BankZipcode, '')
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), '') ELSE ISNULL((SELECT TOP 1 ISNULL(wc.BankState + ' ' + wc.BankZipcode, '')
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), '') END ELSE CASE WHEN LEN(dbi.BankCity) > 0 THEN ISNULL(dbi.BankCity + ', ' + dbi.BankState + ' ' + dbi.BankZipcode, '') ELSE ISNULL(dbi.BankState + ' ' + dbi.BankZipcode, '') END END AS [BankInfo.BankCSZ],
ISNULL((SELECT TOP 1 wc.BankPhone
FROM Wallet w WITH (NOLOCK)
	 INNER JOIN WalletContact wc WITH (NOLOCK) ON w.ID = wc.WalletId
WHERE w.AccountType <> 'credit' AND w.DebtorId = sd.DebtorID
ORDER BY w.ID DESC), ISNULL(dbi.BankPhone, '')) AS [BankInfo.Phone],

	CASE WHEN sd.DOB IS NULL OR	sd.DOB <= '1900-01-01' THEN '' ELSE CONVERT(VARCHAR(10), sd.DOB, 101) END AS SubjDebtorDOB,
	ISNULL(sd.HomePhone, '') AS SubjDebtorHomePhone,
	ISNULL(sd.WorkPhone, '') AS SubjDebtorWorkPhone,
	ISNULL(sd.Pager, '') AS SubjDebtorPager,
	ISNULL(sd.JobName, '') AS SubjDebtorJobName,
	ISNULL(sd.JobAddr1, '') AS SubjDebtorJobAddr1,
	ISNULL(sd.Jobaddr2, '') AS SubjDebtorJobAddr2,
	ISNULL(sd.JobCSZ, '') AS SubjDebtorJobCSZ,
	REPLACE(REPLACE(REPLACE(ISNULL(CAST(SUBSTRING(sd.JobMemo, 1, 8000) AS VARCHAR(8000)), ''), CHAR(10), ' '), CHAR(13), ''), '"', '') AS SubjDebtorJobMemo,
	ISNULL(sd.Spouse, '') AS SubjDebtorSpouse,
	ISNULL(sd.SpouseHomePhone, '') AS SubjDebtorSpouseHomePhone,
	ISNULL(sd.SpouseWorkPhone, '') AS SubjDebtorSpouseWorkPhone,
	ISNULL(sd.SpouseJobName, '') AS SubjDebtorSpouseJobName,
	ISNULL(sd.SpouseJobAddr1, '') AS SubjDebtorSpouseJobAddr1,
	ISNULL(sd.SpouseJobAddr2, '') AS SubjDebtorSpouseJobAddr2,
	ISNULL(sd.SpouseJobCSZ, '') AS SubjDebtorSpouseJobCSZ,
	REPLACE(REPLACE(REPLACE(ISNULL(CAST(SUBSTRING(sd.SpouseJobMemo, 1, 8000) AS VARCHAR(8000)), ''), CHAR(10), ' '), CHAR(13), ''), '"', '') AS SubjDebtorSpouseJobMemo,
	CASE WHEN ISNULL(M.original + M.paid - M.current0, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(ISNULL(M.original + M.paid - M.current0, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), ISNULL(M.original + M.paid - M.current0, 0), 1) END AS Accrued,
	CASE WHEN ISNULL(M.original1 + M.paid1 - M.current1, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(ISNULL(M.original1 + M.paid1 - M.current1, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), ISNULL(M.original1 + M.paid1 - M.current1, 0), 1) END AS Accrued1,
	CASE WHEN ISNULL(M.original3 + M.paid3 - M.current3, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(ISNULL(M.original3 + M.paid3 - M.current3, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), ISNULL(M.original3 + M.paid3 - M.current3, 0), 1) END AS Accrued3,
	CASE WHEN ISNULL(M.original4 + M.paid4 - M.current4, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(ISNULL(M.original4 + M.paid4 - M.current4, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), ISNULL(M.original4 + M.paid4 - M.current4, 0), 1) END AS Accrued4,
	CASE WHEN ISNULL(M.original5 + M.paid5 - M.current5, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(ISNULL(M.original5 + M.paid5 - M.current5, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), ISNULL(M.original5 + M.paid5 - M.current5, 0), 1) END AS Accrued5,
	CASE WHEN ISNULL(M.original6 + M.paid6 - M.current6, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(ISNULL(M.original6 + M.paid6 - M.current6, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), ISNULL(M.original6 + M.paid6 - M.current6, 0), 1) END AS Accrued6,
	CASE WHEN ISNULL(M.original7 + M.paid7 - M.current7, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(ISNULL(M.original7 + M.paid7 - M.current7, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), ISNULL(M.original7 + M.paid7 - M.current7, 0), 1) END AS Accrued7,
	CASE WHEN ISNULL(M.original8 + M.paid8 - M.current8, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(ISNULL(M.original8 + M.paid8 - M.current8, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), ISNULL(M.original8 + M.paid8 - M.current8, 0), 1) END AS Accrued8,
	CASE WHEN ISNULL(M.original9 + M.paid9 - M.current9, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(ISNULL(M.original9 + M.paid9 - M.current9, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), ISNULL(M.original9 + M.paid9 - M.current9, 0), 1) END AS Accrued9,
	CASE WHEN ISNULL(M.original10 + M.paid10 - M.current10, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(ISNULL(M.original10 + M.paid10 - M.current10, 0)), 1) +                  ')' ELSE '$' + CONVERT(VARCHAR(50), ISNULL(M.original10 + M.paid10 - M.current10, 0), 1) END AS Accrued10,

--09/19/2022 BGM Added Case for Sallie mae to use original balance instead of Current for Reg F letters
--09/23/2022 BGM Changed using original balance to using L1_Line4 of ExtraData for 1BUYR for Sallie Mae Post Letters
--10/27/2022 BGM Added letter code SLM1 to lettercode check
CASE WHEN M.customer IN ('0002877') AND M.LetterCode IN ('1BUYR', 'SLM1') THEN CASE WHEN COALESCE(ISNULL(CAST(ed1.line4 as MONEY), 0), 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(ISNULL(CAST(ed1.line4 as MONEY), 0), 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(ISNULL(CAST(ed1.line4 as MONEY), 0), 0), 1) END 
ELSE	
	CASE WHEN COALESCE(lb.current0, M.current0, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current0, M.current0, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current0, M.current0, 0), 1) END END AS LinkedCurrentBalance,
	CASE WHEN COALESCE(lb.original, M.original, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.original, M.original, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.original, M.original, 0), 1) END AS LinkedOriginal,
	CASE WHEN COALESCE(lb.original1, M.original1, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.original1, M.original1, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.original1, M.original1, 0), 1) END AS LinkedOriginalPrincipal,
	CASE WHEN COALESCE(lb.original2, M.original2, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.original2, M.original2, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.original2, M.original2, 0), 1) END AS LinkedOriginalInterest,
	CASE WHEN COALESCE(lb.original3, M.original3, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.original3, M.original3, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.original3, M.original3, 0), 1) END AS LinkedOriginal3,
	CASE WHEN COALESCE(lb.original4, M.original4, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.original4, M.original4, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.original4, M.original4, 0), 1) END AS LinkedOriginal4,
	CASE WHEN COALESCE(lb.original5, M.original5, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.original5, M.original5, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.original5, M.original5, 0), 1) END AS LinkedOriginal5,
	CASE WHEN COALESCE(lb.original6, M.original6, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.original6, M.original6, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.original6, M.original6, 0), 1) END AS LinkedOriginal6,
	CASE WHEN COALESCE(lb.original7, M.original7, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.original7, M.original7, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.original7, M.original7, 0), 1) END AS LinkedOriginal7,
	CASE WHEN COALESCE(lb.original8, M.original8, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.original8, M.original8, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.original8, M.original8, 0), 1) END AS LinkedOriginal8,
	CASE WHEN COALESCE(lb.original9, M.original9, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.original9, M.original9, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.original9, M.original9, 0), 1) END AS LinkedOriginal9,
	CASE WHEN COALESCE(lb.original10, M.original10, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.original10, M.original10, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.original10, M.original10, 0), 1) END AS LinkedOriginal10,
	CASE WHEN COALESCE(lb.paid, M.paid, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.paid, M.paid, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.paid, M.paid, 0), 1) END AS LinkedPaid,
	CASE WHEN COALESCE(lb.paid1, M.paid1, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.paid1, M.paid1, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.paid1, M.paid1, 0), 1) END AS LinkedPaid1,
	CASE WHEN COALESCE(lb.paid2, M.paid2, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.paid2, M.paid2, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.paid2, M.paid2, 0), 1) END AS LinkedPaid2,
	CASE WHEN COALESCE(lb.paid3, M.paid3, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.paid3, M.paid3, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.paid3, M.paid3, 0), 1) END AS LinkedPaid3,
	CASE WHEN COALESCE(lb.paid4, M.paid4, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.paid4, M.paid4, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.paid4, M.paid4, 0), 1) END AS LinkedPaid4,
	CASE WHEN COALESCE(lb.paid5, M.paid5, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.paid5, M.paid5, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.paid5, M.paid5, 0), 1) END AS LinkedPaid5,
	CASE WHEN COALESCE(lb.paid6, M.paid6, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.paid6, M.paid6, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.paid6, M.paid6, 0), 1) END AS LinkedPaid6,
	CASE WHEN COALESCE(lb.paid7, M.paid7, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.paid7, M.paid7, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.paid7, M.paid7, 0), 1) END AS LinkedPaid7,
	CASE WHEN COALESCE(lb.paid8, M.paid8, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.paid8, M.paid8, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.paid8, M.paid8, 0), 1) END AS LinkedPaid8,
	CASE WHEN COALESCE(lb.paid9, M.paid9, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.paid9, M.paid9, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.paid9, M.paid9, 0), 1) END AS LinkedPaid9,
	CASE WHEN COALESCE(lb.paid10, M.paid10, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.paid10, M.paid10, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.paid10, M.paid10, 0), 1) END AS LinkedPaid10,
	CASE WHEN COALESCE(lb.accrued, M.original + M.paid - M.current0, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.accrued, M.original + M.paid - M.current0,	0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.accrued, M.original + M.paid - M.current0, 0), 1) END AS LinkedAccrued,
	CASE WHEN COALESCE(lb.accrued1, M.original1 + M.paid1 - M.current1, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.accrued1, M.original1 + M.paid1 - M.current1, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.accrued1, M.original1 + M.paid1 - M.current1, 0), 1) END AS LinkedAccruedPrincipal,
	CASE WHEN COALESCE(lb.Accrued2, M.Accrued2, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.Accrued2, M.Accrued2, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.Accrued2, M.Accrued2, 0), 1) END AS LinkedAccruedInterest,
	CASE WHEN COALESCE(lb.accrued3, M.original3 + M.paid3 - M.current3, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.accrued3, M.original3 + M.paid3 - M.current3, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.accrued3, M.original3 + M.paid3 - M.current3, 0), 1) END AS LinkedAccrued3,
	CASE WHEN COALESCE(lb.accrued4, M.original4 + M.paid4 - M.current4, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.accrued4, M.original4 + M.paid4 - M.current4, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.accrued4, M.original4 + M.paid4 - M.current4, 0), 1) END AS LinkedAccrued4,
	CASE WHEN COALESCE(lb.accrued5, M.original5 + M.paid5 - M.current5, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.accrued5, M.original5 + M.paid5 - M.current5, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.accrued5, M.original5 + M.paid5 - M.current5, 0), 1) END AS LinkedAccrued5,
	CASE WHEN COALESCE(lb.accrued6, M.original6 + M.paid6 - M.current6, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.accrued6, M.original6 + M.paid6 - M.current6, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.accrued6, M.original6 + M.paid6 - M.current6, 0), 1) END AS LinkedAccrued6,
	CASE WHEN COALESCE(lb.accrued7, M.original7 + M.paid7 - M.current7, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.accrued7, M.original7 + M.paid7 - M.current7, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.accrued7, M.original7 + M.paid7 - M.current7, 0), 1) END AS LinkedAccrued7,
	CASE WHEN COALESCE(lb.accrued8, M.original8 + M.paid8 - M.current8, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.accrued8, M.original8 + M.paid8 - M.current8, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.accrued8, M.original8 + M.paid8 - M.current8, 0), 1) END AS LinkedAccrued8,
	CASE WHEN COALESCE(lb.accrued9, M.original9 + M.paid9 - M.current9, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.accrued9, M.original9 + M.paid9 - M.current9, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.accrued9, M.original9 + M.paid9 - M.current9, 0), 1) END AS LinkedAccrued9,
	CASE WHEN COALESCE(lb.accrued10, M.accrued10, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.accrued10, M.accrued10, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.accrued10, M.accrued10, 0), 1) END AS LinkedAccrued10,
	CASE WHEN COALESCE(lb.current3, M.current3, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current3, M.current3, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current3, M.current3, 0), 1) END AS LinkedCurrent3,
	CASE WHEN COALESCE(lb.current4, M.current4, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current4, M.current4, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current4, M.current4, 0), 1) END AS LinkedCurrent4,
	CASE WHEN COALESCE(lb.current5, M.current5, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current5, M.current5, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current5, M.current5, 0), 1) END AS LinkedCurrent5,
	CASE WHEN COALESCE(lb.current6, M.current6, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current6, M.current6, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current6, M.current6, 0), 1) END AS LinkedCurrent6,
	CASE WHEN COALESCE(lb.current7, M.current7, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current7, M.current7, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current7, M.current7, 0), 1) END AS LinkedCurrent7,
	CASE WHEN COALESCE(lb.current8, M.current8, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current8, M.current8, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current8, M.current8, 0), 1) END AS LinkedCurrent8,
	CASE WHEN COALESCE(lb.current9, M.current9, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current9, M.current9, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current9, M.current9, 0), 1) END AS LinkedCurrent9,
	CASE WHEN COALESCE(lb.current10, M.current10, 0) < 0 THEN '($' + CONVERT(VARCHAR(50), ABS(COALESCE(lb.current10, M.current10, 0)), 1) + ')' ELSE '$' + CONVERT(VARCHAR(50), COALESCE(lb.current10, M.current10, 0), 1) END AS LinkedCurrent10,
	Promises.PromiseEntered AS PromiseEntered,
	Pdc.PDCEntered AS PDCEntered,
	DebtorCreditCards.PCCEntered AS PCCEntered,
	CASE WHEN r.letterstoatty = 1 THEN '' ELSE ISNULL(M.prefix, '') END AS Prefix,
	CASE WHEN r.letterstoatty = 1 THEN '' ELSE ISNULL(M.middleName, '') END AS MiddleName,
	CASE WHEN r.letterstoatty = 1 THEN '' ELSE ISNULL(SUBSTRING(M.middleName, 1, 1), '') END AS MiddleInitial,
	ISNULL(M.suffix, '') AS Suffix,
	CASE WHEN M.AltRecipient = 1 THEN ISNULL(M.AltBusinessName, '') WHEN r.letterstoatty = 1 THEN ISNULL(da.Firm, '') ELSE ISNULL(CASE M.isParsed WHEN 1 THEN M.BusinessName ELSE M.DebtorName END, '') END AS BusinessName,
	CASE WHEN M.AltRecipient = 1 THEN CASE WHEN M.AltBusinessName IS NOT NULL AND LEN(M.AltBusinessName) > 0 THEN M.AltBusinessName ELSE LTRIM(ISNULL(M.AltName + ' ' + M.AltName, '')) END WHEN r.letterstoatty = 1 THEN CASE WHEN da.Firm IS NOT NULL AND	LEN(da.Firm) > 0 THEN da.Firm ELSE LTRIM(ISNULL(da.Name + ' ' + da.Name, '')) END ELSE ISNULL(CASE M.isParsed WHEN 1 THEN CASE WHEN LEN(RTRIM(M.businessName)) > 0 THEN M.businessName ELSE ISNULL(M.firstName, '') + ' ' + ISNULL(M.lastName, '') END ELSE CASE WHEN LEN(RTRIM(M.DebtorName)) > 0 THEN M.DebtorName ELSE LTRIM(ISNULL(CASE M.isParsed WHEN 1 THEN M.firstName ELSE M.DebtorName END + ' ' + CASE M.isParsed WHEN 1 THEN M.lastName ELSE M.DebtorName END, '')) END END, '') END AS FormattedName,
	ISNULL(de.name, '') AS [Desk.Name],
	ISNULL(de.CAlias, '') AS [Desk.Alias],
	ISNULL(de.Extension, '') AS [Desk.Extension],
	ISNULL(de.Email, '') AS [Desk.Email],
	ISNULL(de.Special1, '') AS [Desk.Special1],
	ISNULL(de.Special2, '') AS [Desk.Special2],
	ISNULL(de.Special3, '') AS [Desk.Special3],
	ISNULL(M.SifPmt7, '') AS SifPmt7,
	ISNULL(M.SifPmt8, '') AS SifPmt8,
	ISNULL(M.SifPmt9, '') AS SifPmt9,
	ISNULL(M.SifPmt10, '') AS SifPmt10,
	ISNULL(M.SifPmt11, '') AS SifPmt11,
	ISNULL(M.SifPmt12, '') AS SifPmt12,
	ISNULL(M.SifPmt13, '') AS SifPmt13,
	ISNULL(M.SifPmt14, '') AS SifPmt14,
	ISNULL(M.SifPmt15, '') AS SifPmt15,
	ISNULL(M.SifPmt16, '') AS SifPmt16,
	ISNULL(M.SifPmt17, '') AS SifPmt17,
	ISNULL(M.SifPmt18, '') AS SifPmt18,
	ISNULL(M.SifPmt19, '') AS SifPmt19,
	ISNULL(M.SifPmt20, '') AS SifPmt20,
	ISNULL(M.SifPmt21, '') AS SifPmt21,
	ISNULL(M.SifPmt22, '') AS SifPmt22,
	ISNULL(M.SifPmt23, '') AS SifPmt23,
	ISNULL(M.SifPmt24, '') AS SifPmt24,
	ISNULL(M.USPSKeyLine, dbo.fnCalculateUSPSKeyLine(M.DebtorID)) AS USPSKeyLine,
	ISNULL(cu.AlphaCode, '') AS [Customer.AlphaCode],
	'$' + CONVERT(VARCHAR(50), CASE ISNULL(M.IsInterestDeferred, 0) WHEN 0 THEN 0 ELSE ISNULL(M.DeferredInterest, 0) END, 0) AS DeferredInterest,
	'$' + CONVERT(VARCHAR(50), CASE ISNULL(M.IsInterestDeferred, 0) WHEN 0 THEN 0 ELSE ISNULL(M.DeferredInterest, 0) END + ISNULL(M.Accrued2, 0), 0) AS AccruedAndDeferredInterest,
	'$' + CONVERT(VARCHAR(50), COALESCE(sa.SettlementAmount, ISNULL(M.TotalAdjustmentAmount, 0) + M.Accrued2, 0), 0) AS SettlementOrNonSettlementAmount,
	'$' + CONVERT(VARCHAR(50), COALESCE(sa.SettlementTotalAmount, ISNULL(M.TotalAdjustmentAmount, 0) + M.Accrued2, 0), 0) AS SettlementOrNonSettlementTotalAmount,
	'$' + CONVERT(VARCHAR(50), COALESCE(sa.SettlementTotalAmount + M.Paid - M.Paid10, M.current0, 0), 0) AS SettlementOrNonSettlementRemainingAmount,
	'$' + CONVERT(VARCHAR(50), COALESCE(lb.DeferredInterest, CASE ISNULL(M.IsInterestDeferred, 0) WHEN 0 THEN 0 ELSE ISNULL(M.DeferredInterest, 0) END, 0), 0) AS LinkedDeferredInterest,
	'$' + CONVERT(VARCHAR(50), COALESCE(lb.AccruedAndDeferredInterest, CASE ISNULL(M.IsInterestDeferred, 0) WHEN 0 THEN 0 ELSE ISNULL(M.DeferredInterest, 0) END + ISNULL(M.Accrued2, 0), 0), 0) AS LinkedAccruedAndDeferredInterest,
	'$' + CONVERT(VARCHAR(50), COALESCE(lb.SettlementAmount, sa.SettlementAmount, ISNULL(M.TotalAdjustmentAmount, 0) + M.Accrued2, 0), 0) AS LinkedSettlementOrNonSettlementAmount,
	'$' + CONVERT(VARCHAR(50), COALESCE(lb.SettlementTotalAmount, sa.SettlementTotalAmount, ISNULL(M.TotalAdjustmentAmount, 0) + M.Accrued2, 0), 0) AS LinkedSettlementOrNonSettlementTotalAmount,
	'$' + CONVERT(VARCHAR(50), COALESCE(lb.SettlementTotalAmount + M.Paid - M.Paid10, sa.SettlementTotalAmount + M.Paid - M.Paid10, M.current0, 0), 0) AS LinkedSettlementOrNonSettlementRemainingAmount,



	--CASE WHEN (ISNULL(ChargedOffBalanceDetailTotal.ChargedOffAmount, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ChargedOffBalanceDetailTotal.ChargedOffAmount, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ChargedOffBalanceDetailTotal.ChargedOffAmount), 0), 1) + ')' END AS NYComplianceChargedOffAmount,

	--CASE WHEN (ISNULL(ChargedOffBalanceDetailTotal.Interest, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ChargedOffBalanceDetailTotal.Interest, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ChargedOffBalanceDetailTotal.Interest), 0), 1) + ')' END AS NYComplianceInterestPrior,

	--CASE WHEN (ISNULL(ChargedOffBalanceDetailTotal.TotalInterest, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ChargedOffBalanceDetailTotal.TotalInterest, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ChargedOffBalanceDetailTotal.TotalInterest), 0), 1) + ')' END AS NYComplianceInterestTotal,

	--CASE WHEN (ISNULL(ChargedOffBalanceDetailTotal.fees, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ChargedOffBalanceDetailTotal.fees, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ChargedOffBalanceDetailTotal.fees), 0), 1) + ')' END AS NYComplianceFeesPrior,

	--CASE WHEN (ISNULL(ChargedOffBalanceDetailTotal.TotalFees, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ChargedOffBalanceDetailTotal.TotalFees, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ChargedOffBalanceDetailTotal.TotalFees), 0), 1) + ')' END AS NYComplianceFeesTotal,

	--CASE WHEN (ISNULL(ChargedOffBalanceDetailTotal.Payments, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ChargedOffBalanceDetailTotal.Payments, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ChargedOffBalanceDetailTotal.Payments), 0), 1) + ')' END AS NYCompliancePaymentsPrior,

	--CASE WHEN (ISNULL(ChargedOffBalanceDetailTotal.TotalPayments, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ChargedOffBalanceDetailTotal.TotalPayments, 0), 1) ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ChargedOffBalanceDetailTotal.TotalPayments), 0), 1) + ')' END AS NYCompliancePaymentsTotal,
	'' AS NYComplianceChargedOffAmount,
'' AS NYComplianceInterestPrior,
'' AS NYComplianceInterestTotal,
'' AS NYComplianceFeesPrior,
'' AS NYComplianceFeesTotal,
'' AS NYCompliancePaymentsPrior,
'' AS NYCompliancePaymentsTotal,

--commented out until tested with letter vendor
	--ib.ItemizationDate,
	--ib.ItemizationDateType,
	--ib.ItemizationBalance0,
	--ib.ItemizationBalance1,
	--ib.ItemizationBalance2,
	--ib.ItemizationBalance3,
	--ib.ItemizationBalance4,
	--ib.ItemizationBalance5,
	--ISNULL(CONVERT(VARCHAR(10), vn.ValidationPeriodExpiration, 101), '') AS ValidationPeriodExpiration,

	-- ALWAYS AT END
	ISNULL(M.SecureRecipientID, '00000000-0000-0000-0000-000000000000') AS [.SecureRecipientID],
	ISNULL(M.ErrorDescription, '') AS ErrorDescription

    FROM
        CTE_HeaderData AS M
        LEFT JOIN CTE_ExtraData AS ED
            ON M.number = ED.number
        INNER JOIN customer cu 
            ON cu.customer = M.customer
        LEFT OUTER JOIN restrictions r 
            ON r.debtorid = M.debtorid
        LEFT OUTER JOIN attorney a 
            ON a.attorneyid = M.attorneyid
        LEFT OUTER JOIN courtcases cc 
            ON cc.accountid = M.number
        LEFT OUTER JOIN Garnishment g 
            ON M.number = g.accountID
        LEFT OUTER JOIN courts co 
            ON co.courtid = cc.courtid
        LEFT OUTER JOIN courts jco 
            ON (
		 (
		 cc.JudgementCourtID IS NOT NULL AND
                 jco.courtid = cc.JudgementCourtID
		 ) OR
		 (
		 cc.JudgementCourtID IS NULL AND
                 jco.courtid = cc.CourtID
                )
               )
        LEFT OUTER JOIN extradata ed1 
            ON ed1.number = M.number AND
		 ed1.extracode = 'L1'
        LEFT OUTER JOIN extradata ed2 
            ON ed2.number = M.number AND
		 ed2.extracode = 'L2'
        LEFT OUTER JOIN extradata ed3 
            ON ed3.number = M.number AND
		 ed3.extracode = 'L3'
        LEFT OUTER JOIN extradata ed4 
            ON ed4.number = M.number AND
		 ed4.extracode = 'L4'
        LEFT OUTER JOIN StateRestrictions sr 
            ON sr.abbreviation = M.State
        INNER JOIN desk de 
            ON de.code = M.desk
        INNER JOIN branchcodes bc 
            ON bc.code = de.branch
        LEFT OUTER JOIN debtors sd 
            ON sd.debtorid = M.subjdebtorid
        LEFT OUTER JOIN bankruptcy b 
            ON b.debtorid = M.subjdebtorid
        LEFT OUTER JOIN deceased dc 
            ON dc.debtorid = M.subjdebtorid
        LEFT OUTER JOIN cccs cs 
            ON cs.debtorid = M.subjdebtorid
        LEFT OUTER JOIN earlystagedata esd 
            ON esd.accountid = M.number
        LEFT OUTER JOIN PatientInfo pati 
            ON pati.AccountID = M.number
        LEFT OUTER JOIN DebtorAttorneys da 
            ON da.debtorid = M.subjdebtorid
        LEFT OUTER JOIN Users usend 
            ON usend.id = M.senderid
        LEFT OUTER JOIN Users ureq 
            ON ureq.id = M.requesterid
        LEFT OUTER JOIN DebtorBankInfo dbi 
            ON dbi.acctid = sd.number AND
               dbi.debtorid = sd.seq
        LEFT OUTER JOIN LinkedBalances lb 
            ON M.link = lb.link
        LEFT OUTER JOIN Settlement sa 
            ON M.number = sa.AccountID AND
		 M.SettlementID = sa.ID
        LEFT OUTER JOIN (SELECT
                            AcctID,
                            MIN(CONVERT(VARCHAR(20), Promises.Entered, 101)) AS PromiseEntered
                         FROM
                            dbo.Promises
                         WHERE
                            Promises.Active = 1
                         GROUP BY
                            AcctID) Promises
            ON Promises.AcctID = M.number
        LEFT OUTER JOIN (SELECT
                            number,
		 MIN(CONVERT(VARCHAR(20), Pdc.entered, 101)) AS PDCEntered
                         FROM
                            dbo.pdc
                         WHERE
                            Pdc.Active = 1
                         GROUP BY
                            number) Pdc
            ON Pdc.number = M.number
        LEFT OUTER JOIN (SELECT
                            Number,
		 MIN(CONVERT(VARCHAR(20), DebtorCreditCards.DateEntered, 101)) AS PCCEntered
                         FROM
                            dbo.DebtorCreditCards
                         WHERE
                            DebtorCreditCards.IsActive = 1
                         GROUP BY
                            Number) DebtorCreditCards
            ON DebtorCreditCards.Number = M.number

	    LEFT OUTER JOIN dbo.ChargedOffBalanceDetailTotal 
			ON M.Number = ChargedOffBalanceDetailTotal.AccountId            
		 LEFT OUTER JOIN dbo.ItemizationBalance AS ib ON ib.AccountID = M.number
--  BGM 06/17/2022 Patch is the below needed now?		 
--LEFT OUTER JOIN dbo.ValidationNotice AS vn ON vn.DebtorID = M.debtorid

		 INNER JOIN dbo.controlFile AS CF ON 1 = 1
	WHERE g.GarnishmentID IS NULL OR
	g.GarnishmentID IN (SELECT TOP 1 gi.GarnishmentID
	FROM dbo.Garnishment AS gi
	WHERE gi.AccountID = M.number
	ORDER BY gi.DateFiled DESC)
	ORDER BY original DESC, M.LetterRequestId,
	LinkRecord;
	
--DECLARE @rowcount INT;
--DECLARE @lettername VARCHAR(50)
--DECLARE @lettercode VARCHAR(5)

--	SET @rowcount = @@rowcount

--IF (@rowcount != 0) BEGIN

--	SELECT @lettername = [DESCRIPTION], @lettercode = code
--	FROM letter
--	WHERE LetterID = @LetterID


--	INSERT INTO Custom_Letters_Prepared_For_Revspring(LetterCode, LetterCount, FileCreated)
--	SELECT @lettercode	, CONVERT(VARCHAR, @rowcount), GETDATE()


--	PRINT (CONVERT(VARCHAR, @lettercode) + ' ' + CONVERT(VARCHAR, @lettercode) + ' - ' + @lettername + ' letters sent.')
--END

	IF (@@error != 0) GOTO ErrHandler;

	RETURN (0);

	ErrHandler:
	RAISERROR ('20000', 16, 1, 'Error encountered in sp_LetterRequest_GetForVendor.');
	RETURN (1);

	END;
GO
