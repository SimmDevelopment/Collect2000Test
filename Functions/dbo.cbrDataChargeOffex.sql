SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataChargeOffex]
    ( @accountid int)
RETURNS TABLE
AS 
    RETURN		
						select
						mco.number as chargeoffnumber,
                       CASE WHEN [mco].[ChargeOffAmount] IS NULL THEN 0 ELSE 1 END as HasChargeOffRecord,
                        ROUND([mco].[ChargeOffAmount],0,1) AS ChargeOffAmount,
                        CASE WHEN [mco].[PaymentHistoryProfile] IS NULL OR [mco].[paymenthistorydate] IS NULL THEN '' 
							 --WHEN DATEDIFF(m,[mco].[paymenthistorydate], GETDATE()) <= 0 THEN [mco].[PaymentHistoryProfile]
							 --ELSE SUBSTRING(REPLICATE('L', DATEDIFF(m,[mco].[paymenthistorydate], GETDATE())) + [mco].[PaymentHistoryProfile], 1, 24) 
							 --LAT-10022 Premier Bankcard - CBR Payment History Profile(It is coming two times, if this is not commented.It is already getting updated in other function)
							 ELSE [mco].[PaymentHistoryProfile] 
						END AS PaymentHistoryProfile, --profile
                        CASE WHEN [mco].[PaymentHistoryProfile] IS NULL OR [mco].[paymenthistorydate] IS NULL THEN null 
							 ELSE [mco].[paymenthistorydate] 
						END AS PaymentHistoryDate,
                        ISNULL([mco].[HighestCredit], 0) as HighestCredit,
                        [mco].[CreditLimit],                         
 						[mco].[SecondaryAgencyIdenitifier],
						[mco].[SecondaryAccountNumber],
						[mco].[MortgageIdentificationNumber],
						[mco].[TermsDuration],
						[mco].[ClosedDate] as mcoClosedDate,
						[mco].[ChargeOffStatus],
						[mco].[SpecialComment] AS mcoSpecialComment,
						[mco].[ComplianceCondition] AS mcoComplianceCondition
				from
						[MasterChargeOff] AS [mco]
						where [mco].[number] = @accountid or @accountid is null
GO
