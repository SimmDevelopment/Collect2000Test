SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionGetMasterByDebtorId    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LionGetMasterByDebtorId]
	@debtorId int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	
		m.number,
		m.link,
		m.[Desk Code],
		m.Name,
		m.Street1,
		m.Street2,
		m.City,
		m.Zipcode,
		m.State,
		m.account,
		m.MR,
		m.homephone,
		m.workphone,
		m.specialnote,
		m.received,
		m.closed,
		m.returned,
		m.lastpaid,
		m.lastpaidamt,
		m.lastinterest,
		m.interestrate,
		m.worked,
		m.userdate1,
		m.userdate2,
		m.userdate3,
		m.contacted,
		m.[Status Code],
		m.customer,
		m.original,
		m.original1,
		m.original2,
		m.original3,
		m.original4,
		m.original5,
		m.original6,
		m.original7,
		m.original8,
		m.original9,
		m.original10,
		m.Accrued2,
		m.Accrued10,
		m.paid,
		m.paid1,
		m.paid2,
		m.paid3,
		m.paid4,
		m.paid5,
		m.paid7,
		m.paid6,
		m.paid8,
		m.paid9,
		m.paid10,
		m.current0,
		m.current1,
		m.current2,
		m.current3,
		m.current4,
		m.current6,
		m.current7,
		m.current5,
		m.current8,
		m.current9,
		m.current10,
		m.queue,
		m.qdate,
		m.qlevel,
		m.extracodes,
		m.feecode,
		m.clidlc,
		m.clidlp,
		m.seq,
		m.Pseq,
		m.Branch,
		m.TotalViewed,
		m.TotalWorked,
		m.TotalContacted,
		m.DOB,
		m.sysmonth,
		m.SysYear,
		m.[Desk Description],
		m.[Status Description]
	FROM dbo.LionMasterView m with (nolock)
	Join Debtors d with (nolock) on d.Number=m.number
	where d.DebtorId=@debtorId
END


GO
