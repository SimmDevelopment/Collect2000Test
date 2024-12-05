SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataChargeOff] ( @AccountId INT )
RETURNS TABLE
AS 
    RETURN
    SELECT
            [mco].[number] AS chargeoffnumber, [mco].[SecondaryAgencyIdenitifier], [mco].[SecondaryAccountNumber],
            [mco].[MortgageIdentificationNumber], [mco].[TermsDuration], [mco].[ClosedDate], [mco].[ChargeOffStatus],
            ROUND([mco].[ChargeOffAmount], 0, 1) AS ChargeOffAmount, [mco].[PaymentHistoryProfile],
            mco.PaymentHistoryDate, ISNULL([mco].[HighestCredit], 0) AS HighestCredit, [mco].[CreditLimit],
            [mco].[SpecialComment] AS mcoSpecialComment, [mco].[ComplianceCondition] AS mcoComplianceCondition
        FROM
            dbo.MasterChargeOff [mco]
        WHERE
            mco.number = @accountid ;
						
						
GO
