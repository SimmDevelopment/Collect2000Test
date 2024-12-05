SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataBankruptcy] ( @debtorid INT )
RETURNS TABLE
AS 
    RETURN
    SELECT
            b.debtorid AS bankruptdebtorid, b.chapter, b.dateFiled, b.dateNotice, b.proofFiled, b.dateTime341,
            b.WithdrawnDate, b.dischargeDate, b.dismissalDate, b.reaffirmDateFiled
        FROM
            [dbo].[bankruptcy] b
        WHERE
            b.debtorid = @debtorid ;
GO
