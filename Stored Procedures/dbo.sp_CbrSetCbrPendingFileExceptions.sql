SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_CbrSetCbrPendingFileExceptions*/
CREATE     PROCEDURE [dbo].[sp_CbrSetCbrPendingFileExceptions]
	@ErrNum	INT OUTPUT
-- Name:	sp_CbrSetCbrPendingFileExceptions
-- Function:	This procedure will update records in the CbrPendingFile table
-- 		if not FCRA compliat. An exception type will be set.
--		0 or Null = No Exception
--		1 = Demographic - Invalid Zip Code
--		2 = FCRACompliance - Delinquency date cannot be > received date
--		3 = FCRACompliance - Delinquency date cannot be >= 30 days of the received date
--		4 = FCRACompliance - Clidlc date cannot be > received date
--		5 = FCRACompliance - Clidlc date cannot be >= 30 days of the received date
--		6 = FCRACompliance - Invalid Account Type (Valid AccountTypes are '48','77','0C')
--		This sp should only be called from sp_CbrPrepareFullReport
-- Creation:	03/26/2003 (jcc)    
-- Change History: 
--		04/14/2003 (jcc) added exception 6
--             
AS
	SET @ErrNum = 0
	
	--Sequential exception updates

	-- #1 Demographic - Invalid Zip Code records
	UPDATE CbrPendingFile
		SET ExceptionType = 1
	FROM CbrPendingFile p
	INNER JOIN master m ON p.Number = m.number
	WHERE ((m.zipcode is null) OR (m.zipcode = '') OR (m.zipcode = '00000') OR (m.zipcode = '00000-0000'))
	AND ((ExceptionType is null) OR (ExceptionType = 0))

	-- #2 FCRACompliance - Delinquency date cannot be > received date records	
	UPDATE CbrPendingFile
		SET ExceptionType = 2
	FROM CbrPendingFile p
	INNER JOIN master m ON p.Number = m.number
	WHERE (m.delinquencydate is not null) 
	AND (m.delinquencydate > m.received) 
	AND ((ExceptionType is null) OR (ExceptionType = 0))

	-- #3 FCRACompliance - Delinquency date cannot be >= 30 days of the received date records	
	UPDATE CbrPendingFile
		SET ExceptionType = 3
	FROM CbrPendingFile p
	INNER JOIN master m ON p.Number = m.number
	WHERE (m.delinquencydate is not null) 
	AND (m.delinquencydate >= dateadd(d,-30,m.received)) 
	AND ((ExceptionType is null) OR (ExceptionType = 0))

	-- #4 FCRACompliance - Clidlc date cannot be > received date records	
	UPDATE CbrPendingFile
		SET ExceptionType = 4
	FROM CbrPendingFile p
	INNER JOIN master m ON p.Number = m.number
	WHERE (m.delinquencydate is null) 
	AND (m.clidlc is not null) 
	AND (m.clidlc > m.received) 
	AND ((ExceptionType is null) OR (ExceptionType = 0))

	-- #5 FCRACompliance - Clidlc date cannot be >= 30 days of the received date records	
	UPDATE CbrPendingFile
		SET ExceptionType = 5
	FROM CbrPendingFile p
	INNER JOIN master m ON p.Number = m.number
	WHERE (m.delinquencydate is null) 
	AND (m.clidlc is not null) 
	AND (m.clidlc >= dateadd(d,-30,m.received)) 
	AND ((ExceptionType is null) OR (ExceptionType = 0))

	-- #6 FCRACompliance - Invalid Account Type
	UPDATE CbrPendingFile
		SET ExceptionType = 6
	FROM CbrPendingFile p
	INNER JOIN master m ON p.Number = m.number
	INNER JOIN customer c ON m.customer = c.customer
	WHERE (c.cbrrpttype is null) 
	OR (c.cbrrpttype not in ('48','77','0C'))


	IF (@@Error!=0)
	BEGIN
    	SET @ErrNum = @@Error
    	RAISERROR  ('20000',16,1,'Error encountered in sp_CbrSetCbrPendingFileExceptions.')
    	RETURN(1)
	END	

	SET @ErrNum = 0
GO
