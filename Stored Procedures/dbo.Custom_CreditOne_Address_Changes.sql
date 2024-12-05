SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CreditOne_Address_Changes]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select dbo.date(getdate()) as [FileDate], right(m.account, 6) as [Acct], d.firstname as [First], d.lastname as [Last], d.street1 as [NewAddress1], d.street2 as [NewAddress2], d.city as [NewCity], d.state as [NewState], d.zipcode as [NewZip]
from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0 
where customer = '0001038' and m.number in (select accountid from addresshistory with (nolock) where datechanged >= dateadd(dd, -1, getdate()) and datechanged <= getdate())
END
GO
