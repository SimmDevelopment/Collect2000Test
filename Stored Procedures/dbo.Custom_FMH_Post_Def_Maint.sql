SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC Custom_FMH_Post_Def_Maint '0001032'

CREATE PROCEDURE [dbo].[Custom_FMH_Post_Def_Maint] 
	-- Add the parameters for the stored procedure here
	@customer varchar(255)
AS
BEGIN
	--Header
SELECT CONVERT(VARCHAR(8), GETDATE(), 112) AS headdate, COUNT(*) AS headtotal, 'POST-DEFAULT MAINTENANCE FILE HEADER' AS headname
FROM master WITH (NOLOCK) 
WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND returned IS null

--Body
SELECT m.account, d1.Street1, d1.Street2, d1.City, d1.State, d1.Zipcode, d1.HomePhone, d1.WorkPhone, d1.Pager, CASE WHEN d1.MR = 'Y' THEN 'N' ELSE 'Y' END AS validaddr,
	d1.Country, 'MNT' AS rectype, d1.Email, CASE WHEN d1.homephone = '' THEN 'N' ELSE 'Y' END AS borprimephoneind, CASE WHEN d1.WorkPhone = '' THEN 'N' ELSE 'Y' END AS borworkphoneind,
	CASE WHEN d1.pager = '' THEN 'N' WHEN d1.pager IS NULL THEN 'N' ELSE 'Y' END AS boraltphoneind, 'N' AS borprimephonemobind, 'N' AS borprimephoneconsind,
	'N' AS boraltphonemobind, 'N' AS boraltphoneconsind, 'N' AS borworkphonemobind, 'N' AS borworkphoneconsind, CONVERT(VARCHAR(8), worked, 112) AS lastcontact,
	b1.CaseNumber AS bkcasenum, CONVERT(VARCHAR(8), b1.DateFiled, 112) AS bkdatefile, CONVERT(VARCHAR(8), b1.DateFiled, 112) AS bkbardate, b1.CourtDistrict AS bkdistrict, b1.Chapter AS bkchapter, 
	CASE WHEN b1.dischargedate = '19000101' THEN '' ELSE CONVERT(VARCHAR(8), b1.DischargeDate, 112) END AS bkdischarge, 
	CASE WHEN b1.dismissaldate = '19000101' THEN '' ELSE CONVERT(VARCHAR(8), b1.DismissalDate, 112) END AS bkdismiss, '' AS adversaryanswer, '' AS adversarycounter,	'' AS rehabenrolldate, 'N' AS rehabenrollflag, 
	'' AS rehabepay1, '' AS rehabpay2, '' AS rehabpay3, '' AS rehabpay4, '' AS rehabpay5, '' AS rehabpay6, 'N' AS rehabcompflag,
	CASE WHEN m.STATUS = 'SIF' THEN 'Y' ELSE 'N' END AS sifflag,  CASE WHEN m.status = 'SIF' THEN CONVERT(VARCHAR(8), m.closed, 112) ELSE '' END AS sifdate, 
	CASE WHEN m.STATUS = 'SIF' THEN 'LS' ELSE '' END AS siftype, CASE WHEN m.status = 'SIF' THEN (ABS(m.paid1 + m.paid2) / m.original) ELSE '' END AS sifperc, CASE WHEN m.status = 'SIF' THEN REPLACE(REPLACE(STR(ABS(m.paid1 + m.paid2), 11, 2), ' ','0'), '.', '') ELSE '' END AS sifamount, CASE WHEN m.status = 'PIF' THEN 'Y' ELSE 'N' END AS pifflag,
	CASE WHEN m.status = 'PIF' THEN CONVERT(VARCHAR(8), m.closed, 112) ELSE '' END AS pifdate, CASE WHEN m.status IN ('CAD', 'CND') THEN 'Y' ELSE 'N' END AS agycdflag,
	CASE WHEN m.status IN ('CAD', 'CND') THEN CONVERT(VARCHAR(8), m.closed, 112) ELSE '' END AS agycddate, '' AS othercloseflag, '' AS otherclosedate,
	CASE WHEN m.status = 'DEC' THEN 'Y' ELSE 'N' END AS decflag, CASE WHEN m.status = 'DEC' THEN CONVERT(VARCHAR(8), m.closed, 112) ELSE '' END AS decdate,
	CASE WHEN m.status = 'FRD' THEN 'Y' ELSE 'N' END AS frdflag, CASE WHEN m.status = 'FRD' THEN CONVERT(VARCHAR(8), m.closed, 112) ELSE '' END AS frddate,
	CASE WHEN m.status = 'DIP' THEN 'Y' ELSE 'N' END AS incflag, CASE WHEN m.status = 'DIP' THEN CONVERT(VARCHAR(8), m.closed, 112) ELSE '' END AS incdate,
	CONVERT(varchar(8), m.worked, 112) AS lastcontactparty, (SELECT TOP 1 CONVERT(VARCHAR(8), created, 112) FROM notes WITH (NOLOCK) WHERE m.number = number AND action IN (SELECT code FROM dbo.action WITH (NOLOCK) WHERE WasAttempt = 1) ORDER BY created DESC) AS lastattempt,
	CASE WHEN m.status = 'PPA' THEN (SELECT TOP 1 CONVERT(VARCHAR(8), duedate, 112) FROM promises WITH (NOLOCK) WHERE m.number = AcctID AND Active = 1 ORDER BY DueDate DESC)
		WHEN m.status = 'PDC' THEN (SELECT TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE m.number = number AND Active = 1 ORDER BY deposit DESC)
		WHEN m.status = 'PCC' THEN (SELECT TOP 1 CONVERT(VARCHAR(8), depositdate, 112) FROM debtorcreditcards WITH (NOLOCK) WHERE m.number = Number AND IsActive = 1 ORDER BY DepositDate DESC) END AS lastpromisedate,
	CASE WHEN m.status = 'PPA' THEN (SELECT TOP 1 Amount FROM promises WITH (NOLOCK) WHERE m.number = AcctID AND Active = 1 ORDER BY DueDate DESC)
		WHEN m.status = 'PDC' THEN (SELECT TOP 1 amount FROM pdc WITH (NOLOCK) WHERE m.number = number AND Active = 1 ORDER BY deposit DESC)
		WHEN m.status = 'PCC' THEN (SELECT TOP 1 Amount FROM debtorcreditcards WITH (NOLOCK) WHERE m.number = Number AND IsActive = 1 ORDER BY DepositDate DESC) END AS lastpromiseamt,
	(SELECT COUNT(*) FROM notes WITH (NOLOCK) WHERE m.number = number AND action IN (SELECT code FROM dbo.action WITH (NOLOCK) WHERE WasAttempt = 1)) AS totalattempt,
	CASE WHEN m.status = 'MIL' THEN 'Y' ELSE 'N' END AS actdutyflag, '' AS borsummservdate, '' AS borunabtoserveflag, '' AS boraffiddate, '' AS borsuitdate,
	'' AS borsuitnum, '' AS bordocknum, '' AS borexpdate, 'N' AS borlitpayplanflag, '' AS borjudgedate, '' AS borjudgestate, '' AS borjudgeprinaward, '' AS borjudgeintaward,
	'' AS borjudgeintrate, '' AS borjudgeccaward, '' AS borjudgeatyfeeaward, 'N' AS borjudgecopysentflag, '' AS borgarndate, '' AS borliendate, 
	'' AS borwageattachdate, '' AS borbankattachdate, '' AS borothattachdate, '' AS borvacatedate,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref1address1') AS re1address1,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref1address2') AS re1address2,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref1city') AS re1city,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref1state') AS re1state,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref1zip') AS re1zip,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref1primaryphone') AS re1primaryphone,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref1workphone') AS re1workphone,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref2address1') AS re2address1,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref2address2') AS re2address2,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref2city') AS re2city,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref2state') AS re2state,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref2zip') AS re2zip,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref2primaryphone') AS re2primaryphone,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref2workphone') AS re2workphone,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref3address1') AS re3address1,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref3address2') AS re3address2,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref3city') AS re3city,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref3state') AS re3state,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref3zip') AS re3zip,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref3primaryphone') AS re3primaryphone,
	(SELECT TOP 1 thedata FROM miscextra WITH (NOLOCK) WHERE m.number = number AND title = 'pla.0.ref3workphone') AS re3workphone,
	--co borrower 1 information
	d2.Street1 AS co1street1, d2.Street2 AS co1street2, d2.City AS co1city, d2.STATE AS co1state, d2.Zipcode AS co1zip, d2.HomePhone AS co1homephone, d2.WorkPhone AS co1workphone, d2.Pager AS co1alt, 
	CASE WHEN d2.homephone = '' THEN 'N' ELSE 'Y' END AS co1primephoneind, CASE WHEN d2.WorkPhone = '' THEN 'N' ELSE 'Y' END AS co1workphoneind,
	CASE WHEN d2.pager = '' THEN 'N' WHEN d2.pager IS NULL THEN 'N' ELSE 'Y' END AS co1altphoneind, 'N' AS co1primephonemobind, 'N' AS co1primephoneconsind,
	'N' AS co1altphonemobind, 'N' AS co1altphoneconsind, 'N' AS co1workphonemobind, 'N' AS co1workphoneconsind, '' AS co1foreigncountry, CASE WHEN d2.MR = 'Y' THEN 'N' ELSE 'Y' END AS co1validaddress,
	d2.email AS co1email,
	b2.CaseNumber AS co1bkcasenum, CONVERT(VARCHAR(8), b2.DateFiled, 112) AS co1bkdatefile, '' AS co1bkbardate, b2.CourtDistrict AS co1bkdistrict, b2.Chapter AS co1bkchapter, 
	CONVERT(VARCHAR(8), b2.DischargeDate, 112) AS co1bkdischarge, 
	CONVERT(VARCHAR(8), b2.DismissalDate, 112) AS co1bkdismiss, '' AS co1adversaryanswer, '' AS co1adversarycounter,	
	'N' AS co1decflag, '' AS co1decdate, 'N' AS co1frdflag, '' AS co1frddate, 'N' AS co1incflag, '' AS co1incdate,
	'' AS co1summservdate, '' AS co1unabtoserveflag, '' AS co1affiddate, '' AS co1suitdate,
	'' AS co1suitnum, '' AS co1docknum, '' AS co1expdate, 'N' AS co1litpayplanflag, '' AS co1judgedate, '' AS co1judgestate, '' AS co1judgeprinaward, '' AS co1judgeintaward,
	'' AS co1judgeintrate, '' AS co1judgeccaward, '' AS co1judgeatyfeeaward, 'N' AS co1judgecopysentflag, '' AS co1garndate, '' AS co1liendate, 
	'' AS co1wageattachdate, '' AS co1bankattachdate, '' AS co1othattachdate, '' AS co1vacatedate,
	--co borrower 2 information
	d3.Street1 AS co2street1, d3.Street2 AS co2street2, d3.City AS co2city, d3.STATE AS co2state, d3.Zipcode AS co2zip, d3.HomePhone AS co2homephone, d3.WorkPhone AS co2workphone, d3.Pager AS co2alt, 
	CASE WHEN d3.homephone = '' THEN 'N' ELSE 'Y' END AS co2primephoneind, CASE WHEN d3.WorkPhone = '' THEN 'N' ELSE 'Y' END AS co2workphoneind,
	CASE WHEN d3.pager = '' THEN 'N' WHEN d3.pager IS NULL THEN 'N' ELSE 'Y' END AS co2altphoneind, 'N' AS co2primephonemobind, 'N' AS co2primephoneconsind,
	'N' AS co2altphonemobind, 'N' AS co2altphoneconsind, 'N' AS co2workphonemobind, 'N' AS co2workphoneconsind, '' AS co2foreigncountry, CASE WHEN d3.MR = 'Y' THEN 'N' ELSE 'Y' END AS co2validaddress,
	d3.email AS co2email,
	b3.CaseNumber AS co2bkcasenum, CONVERT(VARCHAR(8), b3.DateFiled, 112) AS co2bkdatefile, '' AS co2bkbardate, b3.CourtDistrict AS co2bkdistrict, b3.Chapter AS co2bkchapter, CONVERT(VARCHAR(8), b3.DischargeDate, 112) AS co2bkdischarge, 
	CONVERT(VARCHAR(8), b3.DismissalDate, 112) AS co2bkdismiss, '' AS co2adversaryanswer, '' AS co2adversarycounter,	
	'N' AS co2decflag, '' AS co2decdate, 'N' AS co2frdflag, '' AS co2frddate, 'N' AS co2incflag, '' AS co2incdate,
	'' AS co2summservdate, '' AS co2unabtoserveflag, '' AS co2affiddate, '' AS co2suitdate,
	'' AS co2suitnum, '' AS co2docknum, '' AS co2expdate, 'N' AS co2litpayplanflag, '' AS co2judgedate, '' AS co2judgestate, '' AS co2judgeprinaward, '' AS co2judgeintaward,
	'' AS co2judgeintrate, '' AS co2judgeccaward, '' AS co2judgeatyfeeaward, 'N' AS co2judgecopysentflag, '' AS co2garndate, '' AS co2liendate, 
	'' AS co2wageattachdate, '' AS co2bankattachdate, '' AS co2othattachdate, '' AS co2vacatedate

FROM master m WITH (NOLOCK) INNER JOIN debtors d1 WITH (NOLOCK) ON m.number = d1.number AND d1.seq = 0 left OUTER JOIN debtors d2 WITH (NOLOCK) ON m.number = d2.number AND d2.seq = 1
	LEFT OUTER JOIN debtors d3 WITH (NOLOCK) ON m.number = d3.number AND d3.seq = 2 LEFT OUTER JOIN bankruptcy b1 WITH (NOLOCK) ON d1.DebtorID = b1.DebtorID
	LEFT OUTER JOIN bankruptcy b2 WITH (NOLOCK) ON d2.DebtorID = b2.DebtorID LEFT OUTER JOIN bankruptcy b3 WITH (NOLOCK) ON d3.DebtorID = b3.DebtorID
WHERE m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND m.returned IS null




--Trailer
SELECT CONVERT(VARCHAR(8), GETDATE(), 112) AS traildate, COUNT(*) + 1 AS trailtotal, 'POST-DEFAULT MAINTENANCE FILE TRAILER' AS trailname
FROM master WITH (NOLOCK) 
WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND returned IS null

END
GO
