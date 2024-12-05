SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE FUNCTION [dbo].[cbrDataMetroExceptionex]
    ( @debtorID int, @OpenDate Datetime, @DOB Datetime, @DebtorSSN varchar(15), @IsAuthorizedAccountUser bit, @Seq int,
		@DebtorStreet1 varchar(128), @DebtorCity varchar(30), @DebtorState varchar(3), @TestOpenDate Datetime
		)
RETURNS TABLE
AS 
    RETURN  with dx as(
			SELECT  cast(SUM(isnull(dx.dbtrx,0)) as int) as DebtorExceptions  FROM (
						
						SELECT  CASE WHEN ISDATE(@DOB ) = 0 AND @IsAuthorizedAccountUser = 'TRUE' AND @OpenDate > coalesce(@TestOpenDate,'2017-09-15') THEN -4194304 ELSE 0 END AS dbtrx where @Seq <> 0 
						  UNION ALL
						SELECT  CASE WHEN ISDATE(@DOB ) = 0 AND @DebtorSSN = '' AND @OpenDate > coalesce(@TestOpenDate,'2017-09-15')  THEN -8388608 ELSE 0 END AS dbtrx where @Seq <> 0  
						  UNION ALL
						SELECT  CASE WHEN isnull(@DebtorState,'') not in (select s.Code FROM States s ) AND @OpenDate > coalesce(@TestOpenDate,'2017-09-15') THEN -16777216 ELSE 0 END AS dbtrx where @Seq <> 0 
						  UNION ALL
						SELECT  CASE WHEN ISNULL(@DebtorStreet1,'') = ''  AND @OpenDate > coalesce(@TestOpenDate,'2017-09-15') THEN -33554432 ELSE 0 END AS dbtrx where @Seq <> 0
						  UNION ALL
						SELECT  CASE WHEN ISNULL(@DebtorCity,'') = ''  AND @OpenDate > coalesce(@TestOpenDate,'2017-09-15') THEN -67108864 ELSE 0 END AS dbtrx where @Seq <> 0						  
						 UNION ALL
						SELECT CASE WHEN  ISNULL(@DebtorSSN,'')='' THEN 0
                                    WHEN ISNULL(dbo.[ValidateSSN] (@DebtorSSN),'') = ''  THEN -134217728 ELSE 0 END AS dbtrx where @Seq <> 0 --LAT-10713 Adding InvalidSSN exception for CBR
						) dx ),
			d1x as ( 
			(SELECT	cast(SUM(isnull(dx.dbtrx,0)) as int) as PrimaryDebtorException FROM (
						SELECT  CASE WHEN ISDATE(@DOB ) = 0 AND @DebtorSSN = ''  AND @OpenDate > coalesce(@TestOpenDate,'2017-09-15') THEN -8388608 ELSE 0 END AS dbtrx where @Seq = 0
						  UNION ALL
						SELECT  CASE WHEN isnull(@DebtorState,'') not in (select s.Code FROM States s ) AND @OpenDate > coalesce(@TestOpenDate,'2017-09-15') THEN -16777216 ELSE 0 END AS dbtrx where @Seq = 0 
						  UNION ALL
						SELECT  CASE WHEN ISNULL(@DebtorStreet1,'') = ''  AND @OpenDate > coalesce(@TestOpenDate,'2017-09-15') THEN -33554432 ELSE 0 END AS dbtrx where @Seq = 0
						  UNION ALL
						SELECT  CASE WHEN ISNULL(@DebtorCity,'') = ''  AND @OpenDate > coalesce(@TestOpenDate,'2017-09-15') THEN -67108864 ELSE 0 END AS dbtrx where @Seq = 0
						UNION ALL
						SELECT CASE WHEN  ISNULL(@DebtorSSN,'')='' THEN 0
                                    WHEN ISNULL(dbo.[ValidateSSN] (@DebtorSSN),'') = ''  THEN -134217728 ELSE 0 END AS dbtrx where @Seq = 0 --LAT-10713 Adding InvalidSSN exception for CBR
						 ) dx ) )
			select @debtorID as debtorid, dx.*,d1x.* from dx cross join d1x; 
           
GO
