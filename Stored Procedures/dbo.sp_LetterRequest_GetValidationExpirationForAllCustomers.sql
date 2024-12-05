SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[sp_LetterRequest_GetValidationExpirationForAllCustomers](
        @LetterID INT,  
        @ThroughDate DATETIME,  
        @IncludeErrors BIT,
		@ValidationNoticeType varchar (25) ='Letter',
		@ProcessedDate datetime = NULL
		
)AS
BEGIN
SET NOCOUNT ON;

Declare @i int, @custcode varchar(7);

insert into #customers(rownum, customer)
select row_number() over(order by customer)rownum, customer
from (
select distinct customer
FROM  
                    dbo.letter AS L  
                    INNER JOIN dbo.LetterRequest AS LR  
                        ON L.LetterID = LR.LetterID      
     INNER JOIN dbo.master AS M  
                        ON lr.AccountID = M.number  
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
                    )
)r

set @i = 0;

while(@i < (select count(*) from #customers))
begin
	set @i = @i +1;

	select @custcode = customer from #customers where rownum = @i;

DECLARE @ValidationPeriodExpiration date;
	EXEC [dbo].[sp_LetterRequest_CalcValidationPeriodExpiration]
		@ValidationPeriodExpiration = @ValidationPeriodExpiration OUTPUT,
		@CustomerCode = @custcode

	IF(@ValidationPeriodExpiration is not null)
	BEGIN
		update #customers
		set ValidationPeriodExpiration = @ValidationPeriodExpiration
		where rownum = @i
	END
END

END



SET ANSI_NULLS ON
GO
