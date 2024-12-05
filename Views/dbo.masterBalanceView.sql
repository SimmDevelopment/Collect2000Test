SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[masterBalanceView]
AS
SELECT     number, link, original, original1, original2, original3, original4, original5, original6, original7, original8, original9, original10, Accrued2, Accrued10, paid, 
                      paid1, paid2, paid3, paid4, paid5, paid6, paid7, paid8, paid10, paid9, current0, current1, current2, current3, current4, current5, current6, current7, 
                      current8, current9, current10
FROM         dbo.master
GO
