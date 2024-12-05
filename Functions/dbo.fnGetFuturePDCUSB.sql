SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnGetFuturePDCUSB]
(
    @number int
)
RETURNS varchar(max)
AS
BEGIN
    declare @output varchar(max)
    select @output = COALESCE(@output + ', ', '') + CONVERT(VARCHAR(10), deposit, 101) + ' - $' + CONVERT(VARCHAR, amount)
    FROM pdc p WITH (NOLOCK) LEFT OUTER JOIN payhistory p2 WITH (NOLOCK) ON p.PaymentLinkUID = p2.PaymentLinkUID
    where p.number = @number AND (active = 1 OR printed = 1) AND p2.UID NOT IN (SELECT ReverseOfUID FROM payhistory p3 WITH (NOLOCK) WHERE p.number = p3.number AND ReverseOfUID IS NOT NULL)
    
    
    
--    FROM pdc p WITH (NOLOCK) LEFT OUTER JOIN payhistory p2 WITH (NOLOCK) ON p.PaymentLinkUID = p2.PaymentLinkUID
--WHERE p.number = 10982783 AND p2.UID NOT IN (SELECT ReverseOfUID FROM payhistory p3 WITH (NOLOCK) WHERE p.number = p3.number AND ReverseOfUID IS NOT NULL)
    
    ORDER BY deposit

    return @output
END
GO
