SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_LetterRequest_GetForVendor*/
CREATE PROCEDURE [dbo].[sp_LetterRequest_GetForVendor_Linked]
(
	@LetterID int,
	@ThroughDate datetime
)
AS
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

--declare control file variables
SET NOCOUNT ON;
declare @CompanyName varchar(30)
declare @CompanyStreet1 varchar(30)
declare @CompanyStreet2 varchar(30)
declare @CompanyCity varchar(20)
declare @CompanyState varchar(3)
declare @CompanyZipcode varchar(10)
declare @CompanyFax varchar(20)
declare @CompanyPhone varchar(20)
declare @CompanyPhone800 varchar(20)

--assign control file variables
select @CompanyName = isnull(Company,''),
@CompanyStreet1 = isnull(Street1,''),
@CompanyStreet2 = isnull(Street2,''),
@CompanyCity = isnull(City,''),
@CompanyState = isnull(State,''),
@CompanyZipcode = isnull(Zipcode,''),
@CompanyFax = isnull(Fax,''),
@CompanyPhone = isnull(Phone,''),
@CompanyPhone800 = isnull(Phone800,'')
from controlFile

if (@@error != 0) goto ErrHandler

IF OBJECT_ID('tempdb..#customers') IS NOT NULL DROP TABLE #customers

create table #customers(rownum int, customer varchar(7), ValidationPeriodExpiration date)

EXEC [dbo].[sp_LetterRequest_GetValidationExpirationForAllCustomers]
		@LetterID = @LetterID,
		@ThroughDate = @ThroughDate,
		@IncludeErrors  =1 

	--query letter requests
	select 
	case m.number
		when rm.number then 1
		else 0
	end as [IsRootAccount],
	lr.lettercode as [LetterCode], 
	isnull(d.debtorid, 0) as [DebtorID], 
	isnull(d.Name,'') as [Name], 
	isnull(isnull(d.firstName, dbo.GetFirstName(d.Name)) + ' ' + isnull(d.lastName, dbo.GetLastName(d.Name)),'') as [FirstNameFirst], 
	isnull(isnull(d.lastName, dbo.GetLastName(d.Name)),'') as [LastName], 
	isnull(isnull(d.firstName, dbo.GetFirstName(d.name)),'') as [FirstName], 
	isnull(d.OtherName,'') as [Other],
	isnull(d.Street1,'') as [Street1], 
	isnull(d.Street2,'') as [Street2], 
	isnull(d.City,'') as [City], 
	isnull(d.State,'') as [State], 
	isnull(d.Zipcode,'') as [Zipcode], 
	CASE
		WHEN (len(isnull(d.City,'')) > 0) THEN isnull(d.City,'') + ', ' + isnull(d.State,'') + ' ' + isnull(d.Zipcode,'')
		ELSE isnull(d.State,'') + ' ' + isnull(d.Zipcode,'')
	END as [CSZ],
	isnull(d.Email,'') as [Email], 
	isnull(d.Fax,'') as [Fax], 
	isnull(d.DLNum,'') as [DriverLicenseNumber], 
	('Login ID: ' + isnull(cast(m.Number as varchar(50)),'') + char(9) + 'Password: ' + isnull(cast(isnull(d.debtorid,0) as varchar(50)),'')) as WebPayLogin,
	rm.Number as [RootNumber],
	m.Number as [Number],
	m.Desk as [Desk],
	m.Account as [Account],
	case when m.Received is null or m.Received <= '1900-01-01' then '' else convert(varchar(10), m.Received, 101) end AS [Received],
	case when m.LastPaid is null or m.LastPaid <= '1900-01-01' then '' else convert(varchar(10), m.LastPaid, 101) end AS [LastPaid],
	CASE 
		WHEN (isnull(m.LastPaidAmt,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.LastPaidAmt,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.LastPaidAmt),0), 1) + ')'
	END as [LastPaidAmount],
	convert(varchar(50), isnull(m.InterestRate,0), 1) as [InterestRate],
	case when m.Userdate1 is null or m.Userdate1 <= '1900-01-01' then '' else convert(varchar(10), m.Userdate1, 101) end AS [Userdate1],
	case when m.Userdate2 is null or m.Userdate2 <= '1900-01-01' then '' else convert(varchar(10), m.Userdate2, 101) end AS [Userdate2],
	case when m.Userdate3 is null or m.Userdate3 <= '1900-01-01' then '' else convert(varchar(10), m.Userdate3, 101) end AS [Userdate3],
	isnull(d.SSN,'') as [SSN],
	CASE 
		WHEN (isnull(m.Original,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Original,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Original),0), 1) + ')'
	END as [Original],
	CASE 
		WHEN (isnull(m.Original1,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Original1,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Original1),0), 1) + ')'
	END as [Original1],
	CASE 
		WHEN (isnull(m.Original2,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Original2,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Original2),0), 1) + ')'
	END as [Original2],
	CASE 
		WHEN (isnull(m.Original3,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Original3,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Original3),0), 1) + ')'
	END as [Original3],
	CASE 
		WHEN (isnull(m.Original4,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Original4,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Original4),0), 1) + ')'
	END as [Original4],
	CASE 
		WHEN (isnull(m.Original5,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Original5,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Original5),0), 1) + ')'
	END as [Original5],
	CASE 
		WHEN (isnull(m.Original6,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Original6,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Original6),0), 1) + ')'
	END as [Original6],
	CASE 
		WHEN (isnull(m.Original7,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Original7,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Original7),0), 1) + ')'
	END as [Original7],
	CASE 
		WHEN (isnull(m.Original8,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Original8,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Original8),0), 1) + ')'
	END as [Original8],
	CASE 
		WHEN (isnull(m.Original9,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Original9,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Original9),0), 1) + ')'
	END as [Original9],
	CASE 
		WHEN (isnull(m.Original10,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Original10,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Original10),0), 1) + ')'
	END as [Original10],
	CASE 
		WHEN (isnull(m.Accrued2,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Accrued2,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Accrued2),0), 1) + ')'
	END as [AccruedInterest],
	CASE 
		WHEN (isnull(m.Paid,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Paid,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Paid),0), 1) + ')'
	END as [Paid],
	CASE 
		WHEN (isnull(m.Paid1,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Paid1,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Paid1),0), 1) + ')'
	END as [Paid1],
	CASE 
		WHEN (isnull(m.Paid2,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Paid2,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Paid2),0), 1) + ')'
	END as [Paid2],
	CASE 
		WHEN (isnull(m.Paid3,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Paid3,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Paid3),0), 1) + ')'
	END as [Paid3],
	CASE 
		WHEN (isnull(m.Paid4,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Paid4,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Paid4),0), 1) + ')'
	END as [Paid4],
	CASE 
		WHEN (isnull(m.Paid5,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Paid5,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Paid5),0), 1) + ')'
	END as [Paid5],
	CASE 
		WHEN (isnull(m.Paid6,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Paid6,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Paid6),0), 1) + ')'
	END as [Paid6],
	CASE 
		WHEN (isnull(m.Paid7,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Paid7,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Paid7),0), 1) + ')'
	END as [Paid7],
	CASE 
		WHEN (isnull(m.Paid8,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Paid8,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Paid8),0), 1) + ')'
	END as [Paid8],
	CASE 
		WHEN (isnull(m.Paid9,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Paid9,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Paid9),0), 1) + ')'
	END as [Paid9],
	CASE 
		WHEN (isnull(m.Paid10,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Paid10,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Paid10),0), 1) + ')'
	END as [Paid10],
	ROUND(ISNULL(M.Current0, 0),2) AS [CurrentBalance],
	CASE 
		WHEN (isnull(m.Current0,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Current0,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Current0),0), 1) + ')'
	END as [Current],
	CASE 
		WHEN (isnull(m.Current1,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Current1,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Current1),0), 1) + ')'
	END as [Current1],
	CASE 
		WHEN (isnull(m.Current2,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Current2,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Current2),0), 1) + ')'
	END as [Current2],
	CASE 
		WHEN (isnull(m.Current3,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Current3,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Current3),0), 1) + ')'
	END as [Current3],
	CASE 
		WHEN (isnull(m.Current4,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Current4,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Current4),0), 1) + ')'
	END as [Current4],
	CASE 
		WHEN (isnull(m.Current5,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Current5,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Current5),0), 1) + ')'
	END as [Current5],
	CASE 
		WHEN (isnull(m.Current6,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Current6,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Current6),0), 1) + ')'
	END as [Current6],
	CASE 
		WHEN (isnull(m.Current7,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Current7,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Current7),0), 1) + ')'
	END as [Current7],
	CASE 
		WHEN (isnull(m.Current8,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Current8,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Current8),0), 1) + ')'
	END as [Current8],
	CASE 
		WHEN (isnull(m.Current9,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Current9,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Current9),0), 1) + ')'
	END as [Current9],
	CASE 
		WHEN (isnull(m.Current10,0) >= 0) THEN '$' + convert(varchar(50), isnull(m.Current10,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(m.Current10),0), 1) + ')'
	END as [Current10],
	case when m.clidlc is null or m.clidlc <= '1900-01-01' then '' else convert(varchar(10), m.clidlc, 101) end AS [CustomerDLC],
	case when m.clidlp is null or m.clidlp <= '1900-01-01' then '' else convert(varchar(10), m.clidlp, 101) end AS [CustomerDLP],
	CASE
		WHEN isnull(cu.BlanketSif,0) = 100 or isnull(cu.BlanketSif,0) = 0 THEN '$' + convert(varchar(50), isnull(m.Current0,0), 1)
		WHEN cast((isnull(m.Current0,0) * isnull(cast(cu.BlanketSif as decimal),0)/100) as money) < 0 THEN '($' + convert(varchar(50), cast(abs((isnull(m.Current0,0) * isnull(cast(cu.BlanketSif as decimal),0)/100)) as money), 1) + ')'
		ELSE '$' + convert(varchar(50), cast((isnull(m.Current0,0) * isnull(cast(cu.BlanketSif as decimal),0)/100) as money), 1)
	END as [BlanketSifAmount],
	isnull(a.City,'') as [OurAttorney.City],
	isnull(a.Code,'') as [OurAttorney.Code],
	CASE
		WHEN len(a.City) > 0 THEN isnull(a.City + ', ' + a.State + ' ' + a.Zipcode,'')
		ELSE isnull(a.State + ' ' + a.Zipcode,'')
	END as [OurAttorney.CSZ],
	isnull(a.Email,'') as [OurAttorney.Email],
	isnull(a.Fax,'') as [OurAttorney.Fax],
	isnull(a.Firm,'') as [OurAttorney.Firm],
	isnull(a.Initials,'') as [OurAttorney.Initials],
	isnull(a.Name,'') as [OurAttorney.Name],
	isnull(a.Phone,'') as [OurAttorney.Phone],
	isnull(a.State,'') as [OurAttorney.State],
	isnull(a.Street1,'') as [OurAttorney.Street1],
	isnull(a.Street2,'') as [OurAttorney.Street2],
	isnull(a.Zipcode,'') as [OurAttorney.Zipcode],
	isnull(cu.BlanketSif,'') as [Customer.BlanketSif],
	isnull(cu.City,'') as [Customer.City],
	CASE
		WHEN cu.Name is null THEN cu.Customer
		WHEN len(cu.Name) > 0 THEN cu.Customer + ' - ' + cu.Name
		ELSE cu.Customer
	END as [Customer.Combo],
	isnull(cu.Contact,'') as [Customer.Contact],
	CASE
		WHEN len(cu.City) > 0 THEN isnull(cu.City + ', ' + cu.State + ' ' + cu.Zipcode,'')
		ELSE isnull(cu.State + ' ' + cu.Zipcode,'')
	END as [Customer.CSZ],
	isnull(cu.Customer,'') as [Customer.Customer],
	isnull(cu.Name,'') as [Customer.Name],
	isnull(cu.State,'') as [Customer.State],
	isnull(cu.Street1,'') as [Customer.Street1],
	isnull(cu.Street2,'') as [Customer.Street2],
	isnull(cu.Zipcode,'') as [Customer.Zipcode],
	CASE
		WHEN m.Link is null THEN '$0.00'
		WHEN m.Link = 0 THEN '$0.00'
		WHEN ((select sum(m2.Current0) from master m2 where m2.Link = m.Link and m2.qlevel not in ('998', '999')) < 0) THEN '($' + convert(varchar(50), (select abs(sum(m2.Current0)) from master m2 where m2.Link = m.Link and m2.qlevel not in ('998', '999')), 1) + ')'
		ELSE '$' + convert(varchar(50), (select sum(m2.Current0) from master m2 where m2.Link = m.Link and m2.qlevel not in ('998', '999')), 1) 
	END as [LinkedBalance],
	isnull(cc.AccruedInt,0) as [CourtCase.AccruedInt],
	case when cc.ArbitrationDate is null or cc.ArbitrationDate <= '1900-01-01' then '' else convert(varchar(10), cc.ArbitrationDate, 101) end AS [CourtCase.ArbitrationDate],
	isnull(cc.CaseNumber,'') as [CourtCase.CaseNumber],
	isnull(cc.Defendant,'') as [CourtCase.CaseTitle],
	isnull(co.CourtName,'') as [CourtCase.Court.CourtName],
	isnull(co.Address1,'') as [CourtCase.Court.Street1],
	isnull(co.Address2,'') as [CourtCase.Court.Street2],
	isnull(co.City,'') as [CourtCase.Court.City],
	isnull(co.State,'') as [CourtCase.Court.State],
	isnull(co.Zipcode,'') as [CourtCase.Court.Zipcode],
	isnull(co.County,'') as [CourtCase.Court.County],
	CASE
		WHEN len(co.City) > 0 THEN isnull(co.City + ', ' + co.State + ' ' + co.Zipcode,'')
		ELSE isnull(co.State + ' ' + co.Zipcode,'')
	END as [CourtCase.Court.CSZ],
	isnull(co.Phone,'') as [CourtCase.Court.Phone],
	isnull(co.Fax,'') as [CourtCase.Court.Fax],
	isnull(co.Salutation,'') as [CourtCase.Court.ClerkSalutation],
	isnull(co.ClerkFirstName,'') as [CourtCase.Court.ClerkFirstName],
	isnull(co.ClerkMiddleName,'') as [CourtCase.Court.ClerkMiddleName],
	isnull(co.ClerkLastName,'') as [CourtCase.Court.ClerkLastName],
	isnull(isnull(co.ClerkFirstName + ' ', '') + isnull(co.ClerkMiddleName + ' ', '') + co.ClerkLastName,'') as [CourtCase.Court.ClerkFullName],
	case when cc.CourtDate is null or cc.CourtDate <= '1900-01-01' then '' else convert(varchar(10), cc.CourtDate, 101) end AS [CourtCase.CourtDate],
	case when cc.DateFiled is null or cc.DateFiled <= '1900-01-01' then '' else convert(varchar(10), cc.DateFiled, 101) end AS [CourtCase.DateFiled],
	isnull(cc.Defendant,'') as [CourtCase.Defendant],
	case when cc.IntFromDate is null or cc.IntFromDate <= '1900-01-01' then '' else convert(varchar(10), cc.IntFromDate, 101) end AS [CourtCase.IntFromDate],
	isnull(cc.Judge,'') as [CourtCase.Judge],
	isnull(cc.Judgement,0) as [CourtCase.Judgement],
	CASE 
		WHEN (isnull(cc.JudgementAmt,0) >= 0) THEN '$' + convert(varchar(50), isnull(cc.JudgementAmt,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(cc.JudgementAmt),0), 1) + ')'
	END as [CourtCase.JudgementAmt],
	CASE 
		WHEN (isnull(cc.JudgementCostAward,0) >= 0) THEN '$' + convert(varchar(50), isnull(cc.JudgementCostAward,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(cc.JudgementCostAward),0), 1) + ')'
	END as [CourtCase.JudgementCostAward],
	case when cc.JudgementDate is null or cc.JudgementDate <= '1900-01-01' then '' else convert(varchar(10), cc.JudgementDate, 101) end AS [CourtCase.JudgementDate],
	CASE 
		WHEN (isnull(cc.JudgementIntAward,0) >= 0) THEN '$' + convert(varchar(50), isnull(cc.JudgementIntAward,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(cc.JudgementIntAward),0), 1) + ')'
	END as [CourtCase.JudgementIntAward],
	isnull(cc.JudgementIntRate,0) as [CourtCase.JudgementIntRate],
	CASE 
		WHEN (isnull(cc.JudgementOtherAward,0) >= 0) THEN '$' + convert(varchar(50), isnull(cc.JudgementOtherAward,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(cc.JudgementOtherAward),0), 1) + ')'
	END as [CourtCase.JudgementOtherAward],
	isnull(cc.MiscInfo1,'') as [CourtCase.MiscInfo1],
	isnull(cc.MiscInfo2,'') as [CourtCase.MiscInfo2],
	isnull(cc.Plaintiff,'') as [CourtCase.Plaintiff],
	isnull(cc.Status,'') as [CourtCase.Status],
	isnull(m.OriginalCreditor,'') as [OriginalCreditor],
	@CompanyName as [Company.Name],
	@CompanyStreet1 as [Company.Street1], 
	@CompanyStreet2 as [Company.Street2], 
	@CompanyCity as [Company.City], 
	@CompanyState as [Company.State], 
	@CompanyZipcode as [Company.Zipcode], 
	CASE
		WHEN len(@CompanyCity) > 0 THEN isnull(@CompanyCity + ', ' + @CompanyState + ' ' + @CompanyZipcode,'')
		ELSE isnull(@CompanyState + ' ' + @CompanyZipcode,'')
	END as [Company.CSZ],
	@CompanyFax as [Company.Fax], 
	@CompanyPhone as [Company.Phone], 
	@CompanyPhone800 as [Company.Phone800],
	CASE 
		WHEN (isnull(lr.AmountDue,0) >= 0) THEN '$' + convert(varchar(50), isnull(lr.AmountDue,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(lr.AmountDue),0), 1) + ')'
	END as [PromiseAmount],
	case when lr.DueDate is null or lr.DueDate <= '1900-01-01' then '' else convert(varchar(10), lr.DueDate, 101) end AS [PromiseDue],
	case when lr.DateRequested is null or lr.DateRequested <= '1900-01-01' then '' else convert(varchar(10), lr.DateRequested, 101) end AS [DateRequested],
	isnull(lr.SifPmt1,'') as [SifPmt1],
	isnull(lr.SifPmt2,'') as [SifPmt2],
	isnull(lr.SifPmt3,'') as [SifPmt3],
	isnull(lr.SifPmt4,'') as [SifPmt4],
	isnull(lr.SifPmt5,'') as [SifPmt5],
	isnull(lr.SifPmt6,'') as [SifPmt6],
	isnull(ed1.Line1,'') as [L1_Line1],
	isnull(ed1.Line2,'') as [L1_Line2],
	isnull(ed1.Line3,'') as [L1_Line3],
	isnull(ed1.Line4,'') as [L1_Line4],
	isnull(ed1.Line5,'') as [L1_Line5],
	isnull(ed2.Line1,'') as [L2_Line1],
	isnull(ed2.Line2,'') as [L2_Line2],
	isnull(ed2.Line3,'') as [L2_Line3],
	isnull(ed2.Line4,'') as [L2_Line4],
	isnull(ed2.Line5,'') as [L2_Line5],
	isnull(ed3.Line1,'') as [L3_Line1],
	isnull(ed3.Line2,'') as [L3_Line2],
	isnull(ed3.Line3,'') as [L3_Line3],
	isnull(ed3.Line4,'') as [L3_Line4],
	isnull(ed3.Line5,'') as [L3_Line5],
	isnull(ed4.Line1,'') as [L4_Line1],
	isnull(ed4.Line2,'') as [L4_Line2],
	isnull(ed4.Line3,'') as [L4_Line3],
	isnull(ed4.Line4,'') as [L4_Line4],
	isnull(ed4.Line5,'') as [L4_Line5],
	isnull(sr.Advisory,'') as [State_Legal_Advisory],
	isnull(bc.Name,'') as [BranchName],
	isnull(bc.Address1,'') as [BranchAddr1],
	isnull(bc.Address2,'') as [BranchAddr2],
	isnull(bc.City,'') as [BranchCity],
	isnull(bc.state,'') as [BranchState],
	isnull(bc.Zipcode,'') as [BranchZip],
	isnull(bc.phone,'') as [BranchPhone],
	isnull(bc.fax,'') as [BranchFax],
	isnull(sd.DebtorID,0) as [SubjDebtorID],
	isnull(sd.Name,'') as [SubjDebtorName],
	isnull(isnull(sd.firstName, dbo.GetFirstName(sd.Name)) + ' ' + isnull(sd.lastName, dbo.GetLastName(sd.Name)) ,'') as [SubjDebtorFirstNameFirst],
	isnull(isnull(sd.lastName, dbo.GetLastName(sd.Name)),'') as [SubjDebtorLastName],
	isnull(isnull(sd.firstName, dbo.GetFirstName(sd.Name)),'') as [SubjDebtorFirstName],
	isnull(sd.OtherName,'') as [SubjDebtorOther],
	isnull(sd.Street1,'') as [SubjDebtorStreet1],
	isnull(sd.Street2,'') as [SubjDebtorStreet2],
	isnull(sd.City,'') as [SubjDebtorCity],
	isnull(sd.State,'') as [SubjDebtorState],
	isnull(sd.Zipcode,'') as [SubjDebtorZipcode],
	CASE
		WHEN len(sd.City) > 0 THEN isnull(sd.City + ', ' + sd.State + ' ' + sd.Zipcode,'')
		ELSE isnull(sd.State + ' ' + sd.Zipcode,'')
	END as [SubjDebtorCSZ],
	isnull(sd.Email,'') as [SubjDebtorEmail],
	isnull(sd.Fax,'') as [SubjDebtorFax],
	isnull(d.DLNum,'') as [SubjDebtorDriverLicenseNumber], 
	CASE
		WHEN b.Chapter is null THEN ''
		ELSE cast(b.Chapter as varchar(10))
	END as [SubjDebtorBkcy.Chapter], 
	case when b.DateFiled is null or b.DateFiled <= '1900-01-01' then '' else convert(varchar(10), b.DateFiled, 101) end AS [SubjDebtorBkcy.FilesDate],
	isnull(b.CaseNumber,'') as [SubjDebtorBkcy.CaseNumber], 
	isnull(b.CourtCity,'') as [SubjDebtorBkcy.CourtCity], 
	isnull(b.CourtDistrict,'') as [SubjDebtorBkcy.CourtDistrict], 
	isnull(b.CourtDivision,'') as [SubjDebtorBkcy.CourtDivision], 
	isnull(b.CourtPhone,'') as [SubjDebtorBkcy.CourtPhone], 
	isnull(b.CourtStreet1,'') as [SubjDebtorBkcy.CourtStreet1], 
	isnull(b.CourtStreet2,'') as [SubjDebtorBkcy.CourtStreet2],
	isnull(b.CourtState,'') as [SubjDebtorBkcy.CourtState],
	isnull(b.CourtZipcode,'') as [SubjDebtorBkcy.CourtZipcode],
	CASE
		WHEN len(b.CourtCity) > 0 THEN isnull(b.CourtCity + ', ' + b.CourtState + ' ' + b.CourtZipcode,'')
		ELSE isnull(b.CourtState + ' ' + b.CourtZipcode,'')
	END as [SubjDebtorBkcy.CourtCSZ],
	isnull(b.Trustee,'') as [SubjDebtorBkcy.Trustee],
	isnull(b.TrusteeStreet1,'') as [SubjDebtorBkcy.TrusteeStreet1],
	isnull(b.TrusteeStreet2,'') as [SubjDebtorBkcy.TrusteeStreet2],
	isnull(b.TrusteeCity,'') as [SubjDebtorBkcy.TrusteeCity],
	isnull(b.TrusteeState,'') as [SubjDebtorBkcy.TrusteeState],
	isnull(b.TrusteeZipcode,'') as [SubjDebtorBkcy.TrusteeZipcode],
	CASE
		WHEN len(b.TrusteeCity) > 0 THEN isnull(b.TrusteeCity + ', ' + b.TrusteeState + ' ' + b.TrusteeZipcode,'')
		ELSE isnull(b.TrusteeState + ' ' + b.TrusteeZipcode,'')
	END as [SubjDebtorBkcy.TrusteeCSZ],
	isnull(b.TrusteePhone,'') as [SubjDebtorBkcy.TrusteePhone],
	isnull(da.Name,'') as [SubjDebtorAttorney.Name],
	isnull(da.Firm,'') as [SubjDebtorAttorney.Firm],
	isnull(da.Addr1,'') as [SubjDebtorAttorney.Street1],
	isnull(da.Addr2,'') as [SubjDebtorAttorney.Street2],
	isnull(da.City,'') as [SubjDebtorAttorney.City],
	isnull(da.State,'') as [SubjDebtorAttorney.State],
	isnull(da.Zipcode,'') as [SubjDebtorAttorney.Zipcode],
	CASE
		WHEN len(da.City) > 0 THEN isnull(da.City + ', ' + da.State + ' ' + da.Zipcode,'')
		ELSE isnull(da.State + ' ' + da.Zipcode,'')
	END as [SubjDebtorAttorney.CSZ],
	isnull(da.Phone,'') as [SubjDebtorAttorney.Phone],
	isnull(da.Fax,'') as [SubjDebtorAttorney.Fax],
	isnull(da.Email,'') as [SubjDebtorAttorney.Email],
	isnull(usend.Alias,'') as [Sender.Alias],
	isnull(usend.Email,'') as [Sender.Email],
	isnull(usend.Extension,'') as [Sender.Extension],
	isnull(usend.Phone,'') as [Sender.Phone],
	isnull(usend.UserName,'') as [Sender.UserName],
	isnull(ureq.Alias,'') as [Requester.Alias],
	isnull(ureq.Email,'') as [Requester.Email],
	isnull(ureq.Extension,'') as [Requester.Extension],
	isnull(ureq.Phone,'') as [Requester.Phone],
	isnull(ureq.UserName,'') as [Requester.UserName],
	isnull(cu.CustomText1,'') as [Customer.CustomText1],
	isnull(cu.CustomText2,'') as [Customer.CustomText2],
	isnull(cu.CustomText3,'') as [Customer.CustomText3],
	isnull(cu.CustomText4,'') as [Customer.CustomText4],
	isnull(cu.CustomText5,'') as [Customer.CustomText5],
	case when m.DelinquencyDate is null or m.DelinquencyDate <= '1900-01-01' then '' else convert(varchar(10), m.DelinquencyDate, 101) end AS [DelinquencyDate],
	isnull(g.CaseNumber,'') as [Garnishment.CaseNumber], 
	isnull(g.Company,'') as [Garnishment.Company], 
	isnull(g.Addr1,'') as [Garnishment.Addr1], 
	isnull(g.Addr2,'') as [Garnishment.Addr2], 
	isnull(g.Addr3,'') as [Garnishment.Addr3], 
	isnull(g.City,'') as [Garnishment.City], 
	isnull(g.State,'') as [Garnishment.State],
	isnull(g.Zipcode,'') as [Garnishment.Zipcode],
	isnull(g.Contact,'') as [Garnishment.Contact],
	isnull(g.Fax,'') as [Garnishment.Fax],
	isnull(g.Phone,'') as [Garnishment.Phone],
	isnull(g.Email,'') as [Garnishment.Email],
	case when g.DateFiled is null or g.DateFiled <= '1900-01-01' then '' else convert(varchar(10), g.DateFiled, 101) end AS [Garnishment.DateFiled],
	case when g.ServiceDate is null or g.ServiceDate <= '1900-01-01' then '' else convert(varchar(10), g.ServiceDate, 101) end AS [Garnishment.ServiceDate],
	case when g.[ExpireDate] is null or g.[ExpireDate] <= '1900-01-01' then '' else convert(varchar(10), g.[ExpireDate], 101) end AS [Garnishment.ExpireDate],
	CASE 
		WHEN (isnull(g.PrinAmt,0) >= 0) THEN '$' + convert(varchar(50), isnull(g.PrinAmt,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(g.PrinAmt),0), 1) + ')'
	END as [Garnishment.PrinAmt],
	CASE 
		WHEN (isnull(g.PreJmtInt,0) >= 0) THEN '$' + convert(varchar(50), isnull(g.PreJmtInt,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(g.PreJmtInt),0), 1) + ')'
	END as [Garnishment.PreJmtInt],
	CASE 
		WHEN (isnull(g.PostJmtInt,0) >= 0) THEN '$' + convert(varchar(50), isnull(g.PostJmtInt,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(g.PostJmtInt),0), 1) + ')'
	END as [Garnishment.PostJmtInt],
	CASE 
		WHEN (isnull(g.Costs,0) >= 0) THEN '$' + convert(varchar(50), isnull(g.Costs,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(g.Costs),0), 1) + ')'
	END as [Garnishment.Costs],
	CASE 
		WHEN (isnull(g.OtherAmt,0) >= 0) THEN '$' + convert(varchar(50), isnull(g.OtherAmt,0), 1)
		ELSE '($' + convert(varchar(50), isnull(abs(g.OtherAmt),0), 1) + ')'
	END as [Garnishment.OtherAmt],
	isnull(m.id1,'') as [Id1], 
	isnull(m.id2,'') as [Id2], 
	CASE
		WHEN m.Link is null THEN '$0.00'
		WHEN m.Link = 0 THEN '$0.00'
		WHEN ((select sum(m3.Current1) from master m3 where m3.Link = m.Link and m3.qlevel not in ('998', '999')) < 0) THEN '($' + convert(varchar(50), (select abs(sum(m3.Current1)) from master m3 where m3.Link = m.Link and m3.qlevel not in ('998', '999')), 1) + ')'
		ELSE '$' + convert(varchar(50), (select sum(m3.Current1) from master m3 where m3.Link = m.Link and m3.qlevel not in ('998', '999')), 1) 
	END as [LinkedPrincipal],
	CASE
		WHEN m.Link is null THEN '$0.00'
		WHEN m.Link = 0 THEN '$0.00'
		WHEN ((select sum(m4.Current2) from master m4 where m4.Link = m.Link and m4.qlevel not in ('998', '999')) < 0) THEN '($' + convert(varchar(50), (select abs(sum(m4.Current2)) from master m4 where m4.Link = m.Link and m4.qlevel not in ('998', '999')), 1) + ')'
		ELSE '$' + convert(varchar(50), (select sum(m4.Current2) from master m4 where m4.Link = m.Link and m4.qlevel not in ('998', '999')), 1) 
	END as [LinkedInterest],
	isnull(cu.Phone,'') as [Customer.Phone],

	-- NEW FOR 4.36.4+
	case when b.DateTime341 is null or b.DateTime341 <= '1900-01-01' then '' else convert(varchar(10), b.DateTime341, 101) end AS [SubjDebtorBkcy.Date341],
	isnull(b.Location341, '') AS [SubjDebtorBkcy.Location341],
	case when b.TransmittedDate is null or b.TransmittedDate <= '1900-01-01' then '' else convert(varchar(10), b.TransmittedDate, 101) end AS [SubjDebtorBkcy.DateTransmitted],
	isnull(b.ConvertedFrom, '') AS [SubjDebtorBkcy.ConvertedFrom],
	case when b.DateNotice is null or b.DateNotice <= '1900-01-01' then '' else convert(varchar(10), b.DateNotice, 101) end AS [SubjDebtorBkcy.NoticeDate],
	case when b.ProofFiled is null or b.ProofFiled <= '1900-01-01' then '' else convert(varchar(10), b.ProofFiled, 101) end AS [SubjDebtorBkcy.ProofFiledDate],
	case when b.DischargeDate is null or b.DischargeDate <= '1900-01-01' then '' else convert(varchar(10), b.DischargeDate, 101) end AS [SubjDebtorBkcy.DateDischarge],
	case when b.DismissalDate is null or b.DismissalDate <= '1900-01-01' then '' else convert(varchar(10), b.DismissalDate, 101) end AS [SubjDebtorBkcy.DateDismissal],
	case when b.ConfirmationHearingDate is null or b.ConfirmationHearingDate <= '1900-01-01' then '' else convert(varchar(10), b.ConfirmationHearingDate, 101) end AS [SubjDebtorBkcy.DateConfirmationHearing],
	case when b.ReaffirmDateFiled is null or b.ReaffirmDateFiled <= '1900-01-01' then '' else convert(varchar(10), b.ReaffirmDateFiled, 101) end AS [SubjDebtorBkcy.DateReaffirmFiled],
	isnull(b.ReaffirmTerms, '') AS [SubjDebtorBkcy.ReaffirmTerms],
	case when b.VoluntaryDate is null or b.VoluntaryDate <= '1900-01-01' then '' else convert(varchar(10), b.VoluntaryDate, 101) end AS [SubjDebtorBkcy.DateVoluntary],
	isnull(b.VoluntaryTerms, '') AS [SubjDebtorBkcy.VoluntaryTerms],
	case when b.SurrenderDate is null or b.SurrenderDate <= '1900-01-01' then '' else convert(varchar(10), b.SurrenderDate, 101) end AS [SubjDebtorBkcy.DateSurrender],
	isnull(b.SurrenderMethod, '') AS [SubjDebtorBkcy.SurrenderMethod],
	isnull(b.AuctionHouse, '') AS [SubjDebtorBkcy.AuctionHouse],
	case when b.AuctionDate is null or b.AuctionDate <= '1900-01-01' then '' else convert(varchar(10), b.AuctionDate, 101) end AS [SubjDebtorBkcy.DateAuction],
	case when isnull(b.AuctionAmount, 0) >= 0 then '$' + convert(varchar(50), isnull(b.AuctionAmount, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(b.AuctionAmount, 0)), 1) + ')'
	end AS [SubjDebtorBkcy.AuctionAmount],
	case when isnull(b.AuctionFee, 0) >= 0 then '$' + convert(varchar(50), isnull(b.AuctionFee, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(b.AuctionFee, 0)), 1) + ')'
	end AS [SubjDebtorBkcy.AuctionFee],
	case when isnull(b.AuctionAmountApplied, 0) >= 0 then '$' + convert(varchar(50), isnull(b.AuctionAmountApplied, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(b.AuctionAmountApplied, 0)), 1) + ')'
	end AS [SubjDebtorBkcy.AuctionAmountApplied],
	case when isnull(b.SecuredAmount, 0) >= 0 then '$' + convert(varchar(50), isnull(b.SecuredAmount, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(b.SecuredAmount, 0)), 1) + ')'
	end AS [SubjDebtorBkcy.SecuredAmount],
	case when isnull(b.SecuredPercentage, 0) >= 0 then '%' + convert(varchar(50), isnull(b.SecuredPercentage, 0), 1)
		else '(%' + convert(varchar(50), abs(isnull(b.SecuredPercentage, 0)), 1) + ')'
	end AS [SubjDebtorBkcy.SecuredPercentage],
	case when isnull(b.UnsecuredAmount, 0) >= 0 then '$' + convert(varchar(50), isnull(b.UnsecuredAmount, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(b.UnsecuredAmount, 0)), 1) + ')'
	end AS [SubjDebtorBkcy.UnsecuredAmount],
	case when isnull(b.UnsecuredPercentage, 0) >= 0 then '%' + convert(varchar(50), isnull(b.UnsecuredPercentage, 0), 1)
		else '(%' + convert(varchar(50), abs(isnull(b.UnsecuredPercentage, 0)), 1) + ')'
	end AS [SubjDebtorBkcy.UnsecuredPercentage],
	isnull(dc.SSN, '') AS [Deceased.SSN],
	isnull(dc.LastName, '') AS [Deceased.LastName],
	isnull(dc.FirstName, '') AS [Deceased.FirstName],
	isnull(dc.FirstName, '') + ' ' + isnull(dc.LastName, '') AS [Deceased.FirstNameFirst],
	isnull(dc.LastName, '') + ', ' + isnull(dc.FirstName, '') AS [Deceased.LastNameFirst],
	isnull(dc.State, '') AS [Deceased.State],
	isnull(dc.PostalCode, '') AS [Deceased.PostalCode],
	case when dc.DOB is null or dc.DOB <= '1900-01-01' then '' else convert(varchar(10), dc.DOB, 101) end AS [Deceased.DateOfBirth],
	case when dc.DOD is null or dc.DOD <= '1900-01-01' then '' else convert(varchar(10), dc.DOD, 101) end AS [Deceased.DateOfDeath],
	isnull(dc.MatchCode, '') AS [Deceased.MatchCode],
	case when dc.TransmittedDate is null or dc.TransmittedDate <= '1900-01-01' then '' else convert(varchar(10), dc.TransmittedDate, 101) end AS [Deceased.DateTransmitted],
	case when dc.ClaimDeadline is null or dc.ClaimDeadline <= '1900-01-01' then '' else convert(varchar(10), dc.ClaimDeadline, 101) end AS [Deceased.DateClaimDeadline],
	case when dc.DateFiled is null or dc.DateFiled <= '1900-01-01' then '' else convert(varchar(10), dc.DateFiled, 101) end AS [Deceased.FiledDate],
	isnull(dc.CaseNumber, '') AS [Deceased.CaseNumber],
	isnull(dc.Executor, '') AS [Deceased.Executor],
	isnull(dc.ExecutorPhone, '') AS [Deceased.ExecutorPhone],
	isnull(dc.ExecutorFax, '') AS [Deceased.ExecutorFax],
	isnull(dc.ExecutorStreet1, '') AS [Deceased.ExecutorStreet1],
	isnull(dc.ExecutorStreet2, '') AS [Deceased.ExecutorStreet2],
	isnull(dc.ExecutorCity, '') AS [Deceased.ExecutorCity],
	isnull(dc.ExecutorState, '') AS [Deceased.ExecutorState],
	isnull(dc.ExecutorZipCode, '') AS [Deceased.ExecutorZipCode],
	isnull(dc.ExecutorCity, '') + ', ' + isnull(dc.ExecutorState, '') + ' ' + isnull(dc.ExecutorZipcode, '') AS [Deceased.ExecutorCSZ],
	isnull(dc.CourtDistrict, '') AS [Deceased.CourtDistrict],
	isnull(dc.CourtDivision, '') AS [Deceased.CourtDivision],
	isnull(dc.CourtPhone, '') AS [Deceased.CourtPhone],
	isnull(dc.CourtStreet1, '') AS [Deceased.CourtStreet1],
	isnull(dc.CourtStreet2, '') AS [Deceased.CourtStreet2],
	isnull(dc.CourtCity, '') AS [Deceased.CourtCity],
	isnull(dc.CourtState, '') AS [Deceased.CourtState],
	isnull(dc.CourtZipcode, '') AS [Deceased.CourtZipcode],
	isnull(dc.CourtCity, '') + ', ' + isnull(dc.CourtState, '') + ' ' + isnull(dc.CourtZipCode, '') AS [Deceased.CourtCSZ],
	isnull(cs.ClientID, '') AS [CCCS.ClientID],
	isnull(cs.Contact, '') AS [CCCS.Contact],
	isnull(cs.CompanyName, '') AS [CCCS.CompanyName],
	isnull(cs.CreditorID, '') AS [CCCS.CreditorID],
	case when cs.DateCreated is null or cs.DateCreated <= '1900-01-01' then '' else convert(varchar(10), cs.DateCreated, 101) end AS [CCCS.CreatedDate],
	case when cs.DateModified is null or cs.DateModified <= '1900-01-01' then '' else convert(varchar(10), cs.DateModified, 101) end AS [CCCS.ModifiedDate],
	case when cs.DateAccepted is null or cs.DateAccepted <= '1900-01-01' then '' else convert(varchar(10), cs.DateAccepted, 101) end AS [CCCS.AcceptedDate],
	case when isnull(cs.AcceptedAmount, 0) >= 0 then '$' + convert(varchar(50), isnull(cs.AcceptedAmount, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(cs.AcceptedAmount, 0)), 1) + ')'
	end AS [CCCS.AcceptedAmount],
	isnull(cs.Comments, '') AS [CCCS.Comments],
	isnull(cs.Phone, '') AS [CCCS.Phone],
	isnull(cs.Fax, '') AS [CCCS.Fax],
	isnull(cs.Street1, '') AS [CCCS.Street1],
	isnull(cs.Street2, '') AS [CCCS.Street2],
	isnull(cs.City, '') AS [CCCS.City],
	isnull(cs.State, '') AS [CCCS.State],
	isnull(cs.ZipCode, '') AS [CCCS.Zipcode],
	isnull(cs.City, '') + ', ' + isnull(cs.State, '') + ' ' + isnull(cs.ZipCode, '') AS [CCCS.CccsCSZ],
	case when isnull(esd.CurrentDue, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.CurrentDue, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.CurrentDue, 0)), 1) + ')'
	end AS [ESD.CurrentDue],
	case when isnull(esd.CurrentMinDue, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.CurrentMinDue, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.CurrentMinDue, 0)), 1) + ')'
	end AS [ESD.CurrentMinDue],
	isnull(esd.PaymentHistory, '') AS [ESD.PaymentHistory],
	case when isnull(esd.Current30, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Current30, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Current30, 0)), 1) + ')'
	end AS [ESD.Current30],
	case when isnull(esd.Current60, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Current60, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Current60, 0)), 1) + ')'
	end AS [ESD.Current60],
	case when isnull(esd.Current90, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Current90, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Current90, 0)), 1) + ')'
	end AS [ESD.Current90],
	case when isnull(esd.Current120, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Current120, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Current120, 0)), 1) + ')'
	end AS [ESD.Current120],
	case when isnull(esd.Current150, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Current150, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Current150, 0)), 1) + ')'
	end AS [ESD.Current150],
	case when isnull(esd.Current180, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Current180, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Current180, 0)), 1) + ')'
	end AS [ESD.Current180],
	case when isnull(esd.StatementDue, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.StatementDue, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.StatementDue, 0)), 1) + ')'
	end AS [ESD.StatementDue],
	case when isnull(esd.StatementMinDue, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.StatementMinDue, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.StatementMinDue, 0)), 1) + ')'
	end AS [ESD.StatementMinDue],
	case when isnull(esd.Statement30, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Statement30, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Statement30, 0)), 1) + ')'
	end AS [ESD.Statement30],
	case when isnull(esd.Statement60, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Statement60, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Statement60, 0)), 1) + ')'
	end AS [ESD.Statement60],
	case when isnull(esd.Statement90, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Statement90, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Statement90, 0)), 1) + ')'
	end AS [ESD.Statement90],
	case when isnull(esd.Statement120, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Statement120, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Statement120, 0)), 1) + ')'
	end AS [ESD.Statement120],
	case when isnull(esd.Statement150, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Statement150, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Statement150, 0)), 1) + ')'
	end AS [ESD.Statement150],
	case when isnull(esd.Statement180, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.Statement180, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.Statement180, 0)), 1) + ')'
	end AS [ESD.Statement180],
	isnull(esd.PromoIndicator, '') AS [ESD.PromoIndicator],
	case when esd.PromoExpDate is null or esd.PromoExpDate <= '1900-01-01' then '' else convert(varchar(10), esd.PromoExpDate, 101) end AS [ESD.DatePromoExp],
	isnull(convert(varchar(10), esd.CyclePreviousBegin, 101),'')AS [ESD.CyclePreviousDateBegin],
	case when isnull(esd.InterestRate, 0) >= 0 then '%' + convert(varchar(50), isnull(esd.InterestRate, 0), 1)
		else '(%' + convert(varchar(50), abs(isnull(esd.InterestRate, 0)), 1) + ')'
	end AS [ESD.InterestRate],
	isnull(convert(varchar(10), esd.CyclePreviousDue, 101),'')AS [ESD.CyclePreviousDueDate],
	isnull(convert(varchar(10), esd.CyclePreviousLate, 101),'')AS [ESD.CyclePreviousLateDate],
	isnull(convert(varchar(10), esd.CyclePreviousEnd, 101),'')AS [ESD.CyclePreviousEndDate],
	isnull(esd.Substatuses, '') AS [ESD.SubStatuses],
	case when isnull(esd.FixedMinPayment, 0) >= 0 then '$' + convert(varchar(50), isnull(esd.FixedMinPayment, 0), 1)
		else '($' + convert(varchar(50), abs(isnull(esd.FixedMinPayment, 0)), 1) + ')'
	end AS [ESD.FixedMinPayment],
	isnull(cast(esd.MultipleAccounts as varchar(50)), '') AS [ESD.MultipleAccounts],
	isnull(esd.arowner, '') AS [ESD.AROwner],
	isnull(esd.plancode, '') AS [ESD.PlanCode],
	isnull(esd.ProviderType, '') AS [ESD.ProviderType],
	isnull(esd.LateFeeAccessed, '') AS [ESD.LateFeeAccessed],
	isnull(esd.CycleCode, '') AS [ESD.CycleCode],
	isnull(convert(varchar(10), esd.CycleCurrentBegin, 101),'')AS [ESD.CycleCurrentBeginDate],
	isnull(convert(varchar(10), esd.CycleCurrentDue, 101),'')AS [ESD.CycleCurrentDueDate],
	isnull(convert(varchar(10), esd.CycleCurrentLate, 101),'')AS [ESD.CycleCurrentLateDate],
	isnull(convert(varchar(10), esd.CycleCurrentEnd, 101),'')AS [ESD.CycleCurrentEndDate],
	isnull(convert(varchar(10), esd.CycleNextBegin, 101),'')AS [ESD.CycleNextBeginDate],
	isnull(convert(varchar(10), esd.CycleNextDue, 101),'')AS [ESD.CycleNextDueDate],
	isnull(convert(varchar(10), esd.CycleNextLate, 101),'')AS [ESD.CycleNextLateDate],
	isnull(convert(varchar(10), esd.CycleNextEnd, 101),'')AS [ESD.CycleNextEndDate],
	ISNULL(CONVERT(VARCHAR(10), ib.ItemizationDate, 101),'') AS ItemizationDate,
	ib.ItemizationDateType,
	CASE WHEN (ISNULL(ib.ItemizationBalance0, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ib.ItemizationBalance0, 0), 1)
	ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ib.ItemizationBalance0), 0), 1) + ')'
	END AS ItemizationBalance0,
	CASE WHEN (ISNULL(ib.ItemizationBalance1, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ib.ItemizationBalance1, 0), 1)
	ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ib.ItemizationBalance1), 0), 1) + ')'
	END AS ItemizationBalance1,
	CASE WHEN (ISNULL(ib.ItemizationBalance2, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ib.ItemizationBalance2, 0), 1)
	ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ib.ItemizationBalance2), 0), 1) + ')'
	END AS ItemizationBalance2,
	CASE WHEN (ISNULL(ib.ItemizationBalance3, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ib.ItemizationBalance3, 0), 1)
	ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ib.ItemizationBalance3), 0), 1) + ')'
	END AS ItemizationBalance3,
	CASE WHEN (ISNULL(ib.ItemizationBalance4, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ib.ItemizationBalance4, 0), 1)
	ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ib.ItemizationBalance4), 0), 1) + ')'
	END AS ItemizationBalance4,
	CASE WHEN (ISNULL(ib.ItemizationBalance5, 0) >= 0) THEN '$' + CONVERT(VARCHAR(50), ISNULL(ib.ItemizationBalance5, 0), 1)
	ELSE '($' + CONVERT(VARCHAR(50), ISNULL(ABS(ib.ItemizationBalance5), 0), 1) + ')'
	END AS ItemizationBalance5,
	ISNULL(CONVERT(VARCHAR(10), c.ValidationPeriodExpiration, 101),'') AS ValidationPeriodExpiration,

	-- ALWAYS AT END
	isnull(lr.ErrorDescription,'') as [ErrorDescription]
	
	from letterrequest lr with(nolock)
	inner join letterrequestrecipient lrr with(nolock) on lr.letterrequestid = lrr.letterrequestid
	inner join letter l with(nolock) on l.letterid = lr.letterid
	inner join master rm with(nolock) on rm.number = lr.accountid	
	inner join master m with (nolock) on (m.number = rm.number or (rm.link > 0 and rm.link = m.link))
	left outer join debtors d with(nolock) on d.debtorid = lrr.debtorid
	inner join #customers c with(nolock) on m.customer=c.customer
	inner join customer cu with(nolock) on cu.customer = m.customer
	left outer join restrictions r with(nolock) on r.debtorid = lrr.debtorid
	left outer join attorney a with(nolock) on a.attorneyid = m.attorneyid
	left outer join courtcases cc with(nolock) on cc.accountid = lr.accountid
	left outer join (select Top 1 * from Garnishment with(nolock) order by datefiled desc) g on g.accountid = lr.accountid
	left outer join courts co with(nolock) on co.courtid = cc.courtid
	left outer join extradata ed1 with(nolock) on ed1.number = lr.accountid and ed1.extracode = 'L1'
	left outer join extradata ed2 with(nolock) on ed2.number = lr.accountid and ed2.extracode = 'L2'
	left outer join extradata ed3 with(nolock) on ed3.number = lr.accountid and ed3.extracode = 'L3'
	left outer join extradata ed4 with(nolock) on ed4.number = lr.accountid and ed4.extracode = 'L4'
	left outer join StateRestrictions sr with(nolock) on sr.abbreviation = d.State
	inner join desk de with(nolock) on de.code = m.desk
	inner join branchcodes bc with(nolock) on bc.code = de.branch
	left outer join debtors sd with(nolock) on sd.debtorid = lr.subjdebtorid
	left outer join bankruptcy b with(nolock) on b.debtorid = lr.subjdebtorid
	left outer join deceased dc with (nolock) on dc.debtorid = lr.subjdebtorid
	left outer join cccs cs with (nolock) on cs.debtorid = lr.subjdebtorid
	left outer join earlystagedata esd with (nolock) on esd.accountid = lr.accountid
	left outer join DebtorAttorneys da with(nolock) on da.debtorid = lr.subjdebtorid
	left outer join Users usend with(nolock) on usend.id = lr.senderid
	left outer join Users ureq with(nolock) on ureq.id = lr.requesterid
	LEFT OUTER JOIN dbo.ItemizationBalance AS ib with(nolock) ON ib.AccountID = lr.accountid
	
	WHERE lr.DateRequested <= @ThroughDate AND (lr.DateProcessed IS NULL OR lr.DateProcessed = '1/1/1753 12:00:00')
	AND lr.Deleted = 0 AND lr.AddEditMode = 0 AND lr.Suspend = 0 AND lr.Edited = 0 AND lr.LetterID = @LetterID
	ORDER BY
		case m.number
			when rm.number then 1
			else 0
		end desc,
		lr.AccountID

	if (@@error != 0) goto ErrHandler
	Return(0)	
	
ErrHandler:
	RAISERROR  ('20000',16,1,'Error encountered in sp_LetterRequest_GetForVendor_Linked.')
	Return(1)
GO
