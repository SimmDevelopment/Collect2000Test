SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[Custom_IDT_Report_Recon]

AS

SELECT account, Street1 addr1, Street2 addr2, City, State, ZipCode zip, 
	dbo.StripNonDigits(homephone) homeph, dbo.StripNonDigits(workphone) workph, 
	current1 balance, 
	CASE 	
		WHEN status = 'DSP' THEN 'DSP'
		WHEN status = 'FWD' THEN 'PLC'
		WHEN status = 'NSF' THEN 'NSF'
		WHEN status IN ('PCC', 'PDC') THEN 'PDP'
		WHEN status = 'PPA' THEN 'PPA'
		WHEN status = 'SKP' THEN 'SKI'
		ELSE 'NBA'
	END status,
	id2 origacct
FROM master with (nolock)
WHERE customer = '0000915' AND status IN ('ACT', 'CCC', 'DSP', 'FWD', 'HLD', 'HOT',
	'JDG', 'LET', 'LOP', 'NEW', 'NPC', 'NSF', 'PCC', 'PDC', 'PND', 'PPA',
	'SKP', 'TEN', 'INA', 'LGL', 'STL', 'REF', 'SPA', 'REV')
GO
