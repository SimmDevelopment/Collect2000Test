SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[Custom_Bureaus_Acknowledgment]

@Received datetime

 AS

select id2 as [TBI Number], account as [Original Account], original1 as [Placed Principal], current1 + current2 as [Placed Current Balance]
from master with (nolock)
where customer = '0000993' and dbo.date(received) = dbo.date(@received)
GO
