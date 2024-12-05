SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*spLinkBalances_Select*/
CREATE PROCEDURE [dbo].[spLinkBalances_Select]
	@Link int
AS

 /*
**Name            :spLinkBalances_Select
**Function        :Selects the sum of all money buckets on Linked accounts
**Creation        :9/1/2004
**Used by         :Latitude.Account object
**Change History  :
*/


Select isnull(sum(original),0) as O, 
isnull(sum(original1),0) as O1,
isnull( sum(original2),0)as O2, 
isnull(sum(original3),0)as O3, 
isnull(sum(original4),0)as O4, 
isnull(sum(original5),0)as O5, 
isnull(sum(original6),0)as O6, 
isnull(sum(original7),0)as O7, 
isnull(sum(original8),0)as O8, 
isnull(sum(original9),0)as O9, 
isnull(sum(original10),0)as O10,
isnull(sum(Accrued2),0) as A2, 
isnull(sum(accrued10),0) as A10, 
isnull(-sum(Paid),0)as P, 
isnull(-sum(Paid1),0)as P1, 
isnull(-sum(Paid2),0)as P2, 
isnull(-sum(Paid3),0)as P3, 
isnull(-sum(Paid4),0)as P4, 
isnull(-sum(Paid5),0)as P5,
isnull(-sum(Paid6),0)as P6, 
isnull(-sum(Paid7),0)as P7, 
isnull(-sum(Paid8),0)as P8, 
isnull(-sum(Paid9),0)as P9, 
isnull(-sum(Paid10),0)as P10,
isnull(sum(Current0),0)as C, 
isnull(sum(Current1),0)as C1, 
isnull(sum(Current2),0)as C2, 
isnull(sum(Current3),0)as C3, 
isnull(sum(Current4),0)as C4, 
isnull(sum(Current5),0)as C5, 
isnull(sum(Current6),0)as C6, 
isnull(sum(Current7),0)as C7, 
isnull(sum(Current8),0)as C8, 
isnull(sum(Current9),0)as C9, 
isnull(sum(Current10),0)as C10
from master with(nolock) where Link = @Link and qlevel < '998'


GO
