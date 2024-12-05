SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetDebtorBalances    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 11/13/2006
-- Description:	
-- =============================================
/*
select top 5 d.debtorId
From Debtors d with (nolock)
Join master m with (nolock) on m.number=d.number
exec LionGetDebtorBalances @debtorId=6;
exec LionGetDebtorBalances @debtorId=7;
exec LionGetDebtorBalances @debtorId=8;
exec LionGetDebtorBalances @debtorId=9;
exec LionGetDebtorBalances @debtorId=10;
*/
CREATE PROCEDURE [dbo].[LionGetDebtorBalances]
	-- Add the parameters for the stored procedure here
	@DebtorId int,
	@paid money output,
	@current money output,
	@original money output
AS
BEGIN

	SET NOCOUNT ON;

	Select	@paid=isnull(m.paid,0)*-1,
			@current=isnull(m.current0,0),
			@original=isnull(m.original,0) 
	From Master m with (nolock)
	Join Debtors d with (nolock) on d.number=m.number
	Where d.debtorId=@DebtorId

END

GO
