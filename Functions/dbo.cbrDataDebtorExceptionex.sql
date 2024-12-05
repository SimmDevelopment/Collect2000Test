SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE FUNCTION [dbo].[cbrDataDebtorExceptionex]
    ( @debtorlastname varchar(50), @debtorfirstname varchar(50), @IsAuthorizedAccountUser bit, @DebtorZipCode varchar(10), @Seq int, @DOB Datetime, @DebtorSSN varchar(9)
    )
RETURNS TABLE
AS 
    RETURN  with dx as(
			SELECT  cast(SUM(isnull(dx.dbtrx,0)) as int) as DebtorExceptions  FROM (
						SELECT  CASE WHEN @debtorlastname IS NULL OR @debtorfirstname IS NULL THEN -65536  ELSE 0 End AS dbtrx where @Seq <> 0
						  UNION ALL 
						SELECT  CASE WHEN @debtorlastname = '' OR @debtorfirstname = '' THEN -131072 ELSE 0 END AS dbtrx where @Seq <> 0
						 
						  UNION ALL
						SELECT  CASE WHEN @DebtorZipCode IS NULL THEN -262144 ELSE 0 END AS dbtrx where @Seq <> 0  
						  UNION ALL
						SELECT  CASE WHEN LEN(LTRIM(RTRIM(ISNULL(@DebtorZipCode,'')))) < 5  THEN -524288 ELSE 0 END AS dbtrx where @Seq <> 0  
						  UNION ALL
						SELECT  CASE WHEN SUBSTRING(ISNULL(@DebtorZipCode,''), 1, 5) = '00000' THEN -1048576 ELSE 0 END AS dbtrx where @Seq <> 0   

						 ) dx ),
			d1x as ( 
			(SELECT	cast(SUM(isnull(dx.dbtrx,0)) as int) as PrimaryDebtorException FROM (
						SELECT CASE WHEN (@debtorlastname IS NULL OR @debtorfirstname IS NULL) AND @Seq = 0 THEN -65536  ELSE 0 End AS dbtrx where @Seq = 0 
						  UNION ALL 
						SELECT CASE WHEN (@debtorlastname = '' OR @debtorfirstname = '' )  AND @Seq = 0 THEN -131072 ELSE 0 END AS dbtrx where @Seq = 0  
						  UNION ALL
						SELECT CASE WHEN @DebtorZipCode IS NULL AND NOT @IsAuthorizedAccountUser = 'TRUE' AND @Seq = 0 THEN -262144 ELSE 0 END AS dbtrx where @Seq = 0  
						  UNION ALL
						SELECT CASE WHEN LEN(LTRIM(RTRIM(ISNULL(@DebtorZipCode,'')))) < 5 AND NOT @IsAuthorizedAccountUser = 'TRUE'  AND @Seq = 0 THEN -524288 ELSE 0 END AS dbtrx where @Seq = 0  
						  UNION ALL
						SELECT CASE WHEN SUBSTRING(ISNULL(@DebtorZipCode,''), 1, 5) = '00000' AND NOT @IsAuthorizedAccountUser = 'TRUE'  AND @Seq = 0 THEN -1048576 ELSE 0 END AS dbtrx where @Seq = 0  

						 ) dx ) )
			select dx.*,d1x.* from dx cross join d1x; 
            
GO
