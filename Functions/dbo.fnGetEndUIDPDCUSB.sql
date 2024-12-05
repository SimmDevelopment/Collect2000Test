SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnGetEndUIDPDCUSB]
(
    @number INT,
    @startDate DATETIME,
    @endDate DATETIME
)
RETURNS varchar(max)
AS
BEGIN
    declare @output INT
	SELECT @output = (SELECT TOP 1 UID
    FROM pdc WITH (NOLOCK) 
    WHERE number = @number AND CAST(DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
    ORDER BY deposit DESC)
    --select @output = COALESCE(@output + ', ', '') + CONVERT(VARCHAR(10), deposit, 101) + ' - $' + CONVERT(VARCHAR, amount)
    --FROM pdc p WITH (NOLOCK) LEFT OUTER JOIN payhistory p2 WITH (NOLOCK) ON p.PaymentLinkUID = p2.PaymentLinkUID
    --where p.number = @number AND (active = 1 OR printed = 1) AND p2.UID NOT IN (SELECT ReverseOfUID FROM payhistory p3 WITH (NOLOCK) WHERE p.number = p3.number AND ReverseOfUID IS NOT NULL)
    
    
    
--    FROM pdc p WITH (NOLOCK) LEFT OUTER JOIN payhistory p2 WITH (NOLOCK) ON p.PaymentLinkUID = p2.PaymentLinkUID
--WHERE p.number = 10982783 AND p2.UID NOT IN (SELECT ReverseOfUID FROM payhistory p3 WITH (NOLOCK) WHERE p.number = p3.number AND ReverseOfUID IS NOT NULL)
    
    

    return @output
END
GO
