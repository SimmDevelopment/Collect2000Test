SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetPDCByDebtorId    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionGetPDCByDebtorId]
(
	@DebtorId int
)
AS
	SET NOCOUNT ON;
SELECT 
pdc.UID, 
pdc.number, 
pdc.entered, 
pdc.[On Hold], 
pdc.amount, 
pdc.[Check Number], 
pdc.[Deposit Date], 
pdc.Desk, 
pdc.[Nitd Sent], 
pdc.customer, 
pdc.Processed 
FROM dbo.LionPDC pdc with (nolock) 
Join Debtors d with (nolock) on d.number=pdc.number
where d.DebtorId=@DebtorId

GO
