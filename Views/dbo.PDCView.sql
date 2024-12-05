SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*PDCView*/
CREATE VIEW [dbo].[PDCView]
AS
SELECT     dbo.pdc.UID, dbo.pdc.number, dbo.Debtors.Name, dbo.pdc.entered, dbo.pdc.deposit, dbo.pdc.amount, dbo.pdc.PDC_Type, dbo.pdc.SurCharge, 
                      dbo.master.customer, dbo.master.desk, dbo.pdc.nitd, dbo.pdc.LtrCode, dbo.pdc.checknbr, dbo.pdc.ApprovedBy, dbo.pdc.Printed, dbo.pdc.onhold, 
                      dbo.pdc.PromiseMode, dbo.pdc.ProjectedFee, dbo.pdc.UseProjectedFee, dbo.pdc.Active, dbo.pdc.CollectorFee, dbo.pdc.SEQ
FROM         dbo.master INNER JOIN
                      dbo.Debtors INNER JOIN
                      dbo.pdc ON dbo.Debtors.Number = dbo.pdc.number AND dbo.Debtors.Seq = COALESCE(dbo.pdc.SEQ, 0) ON dbo.master.number = dbo.Debtors.Number


GO
