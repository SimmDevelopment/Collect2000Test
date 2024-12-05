SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ChargedOffBalanceDetailTotal]
AS
    SELECT  cobd.ChargedOffBalanceDetailId ,
            cobd.AccountId ,
            cobd.ChargedOffAmount ,
            cobd.Interest ,
            cobd.Interest + ISNULL(dbo.ChargedOffBalanceDetailViewCalculatedColumn(cobd.AccountId, 2),0) AS TotalInterest ,
            cobd.Fees ,
            cobd.Fees + ISNULL(dbo.ChargedOffBalanceDetailViewCalculatedColumn(cobd.AccountId, 3),0) AS TotalFees ,
            cobd.Payments ,
            cobd.Payments + ISNULL(dbo.ChargedOffBalanceDetailViewCalculatedColumn(cobd.AccountId, 1),0) AS TotalPayments ,
            cobd.LastModifiedDate
    FROM    dbo.ChargedOffBalanceDetail AS cobd


GO
