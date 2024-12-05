SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataPayhistoryex] ( @AccountId INT , @is1stparty bit, @CLIDLP datetime, @lastpaid datetime, @lastpaidamt money)
RETURNS TABLE
AS 
    RETURN
    SELECT
            @AccountId AS lastpaidnumber, MAX(COALESCE(P.datepaid, @CLIDLP, @lastpaid)) AS LastPaymentDate,
            SUM(COALESCE(P.totalpaid, @lastpaidamt)) AS lastPaymentAmount, MAX(p.datepaid) AS payhistorydatepaid,
            
            SUM(CASE WHEN (CASE WHEN @is1stparty = 'TRUE' THEN isnull(P.DateTimeEntered,'19000101') ELSE isnull(P.datepaid,'19000101') END)
             > isnull(dt.dateReported,'19000101') THEN COALESCE(CASE WHEN ISNULL(DATEDIFF(d,P.DateTimeEntered,GETDATE()),0) < 39 THEN P.totalpaid ELSE 0 END,(
             CASE WHEN @lastpaid > isnull(dt.dateReported,'19000101') THEN @lastpaidamt ELSE 0 END)) 
					ELSE 0 END) as ActualPaymentAmount
	
        FROM
            dbo.payhistory p 
            outer apply dbo.cbraccounthistory(p.number) dt
        WHERE
            p.number = @AccountID
            AND p.uid NOT IN ( SELECT ISNULL(reverseofuid, 0) FROM dbo.payhistory )
            AND p.batchtype IN ( 'PU', 'PA', 'PC' )
        GROUP BY
            p.number ;
GO
