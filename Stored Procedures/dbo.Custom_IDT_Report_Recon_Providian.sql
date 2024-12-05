SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE   PROCEDURE [dbo].[Custom_IDT_Report_Recon_Providian]

AS

SELECT ACCOUNT CFG_ACCOUNT, Street1 ADDRESS1, Street2 ADDRESS2, CITY, STATE, ZipCode ZIP, 
	dbo.StripNonDigits(homephone) PHONEHOME, dbo.StripNonDigits(workphone) PHONEWORK, 
	current1 BALANCE, 
	CASE 	
		WHEN status = 'DSP' THEN 'DSP'
		WHEN status = 'FWD' THEN 'OPLC'
		WHEN status = 'NSF' THEN 'NSF'
		WHEN status IN ('PCC', 'PDC') THEN 'OPDP'
		WHEN status = 'PPA' THEN 'OPPA'
		WHEN status = 'SKP' THEN 'OSKI'
		ELSE 'ONBA'
	END STATUS,
	id1 ORIGINALACCOUNT, '1' as RELATIONSHIPID
FROM master with (nolock)
WHERE customer = '0000976' AND status IN ('ACT', 'CCC', 'DSP', 'FWD', 'HLD', 'HOT',
	'JDG', 'LET', 'LOP', 'NEW', 'NPC', 'NSF', 'PCC', 'PDC', 'PND', 'PPA',
	'SKP', 'TEN', 'INA', 'LGL', 'STL', 'REF', 'SPA', 'REV')
GO
