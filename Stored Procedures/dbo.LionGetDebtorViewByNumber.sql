SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetDebtorViewByNumber    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LionGetDebtorViewByNumber]
	@number int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		d.DebtorID,
		d.number,
		d.account,
		d.Name,
		d.[Desk Code],
		d.[Desk Description],
		d.received,
		d.[Status Code],
		d.[Status Description],
		d.[Debtor Seq],
		d.HomePhone,
		d.WorkPhone,
		d.Street1,
		d.Street2,
		d.City,
		d.State,
		d.MR,
		d.closed,
		d.returned,
		d.lastpaid,
		d.lastpaidamt,
		d.lastinterest,
		d.SSN,
		d.Zipcode,
		d.DOB FROM dbo.LionDebtorView d with (nolock)
	where d.Number=@number
	order by d.[Debtor Seq] asc
END


GO
