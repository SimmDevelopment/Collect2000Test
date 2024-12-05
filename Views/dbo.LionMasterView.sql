SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  View dbo.LionMasterView    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE VIEW [dbo].[LionMasterView]
AS
SELECT     dbo.master.number, dbo.master.link, dbo.master.desk AS [Desk Code], dbo.master.Name, dbo.master.Street1, dbo.master.Street2, dbo.master.City, 
                      dbo.master.Zipcode, dbo.master.State, dbo.master.account, dbo.master.MR, dbo.master.homephone, dbo.master.workphone, dbo.master.specialnote, 
                      dbo.master.received, dbo.master.closed, dbo.master.returned, dbo.master.lastpaid, dbo.master.lastpaidamt, dbo.master.lastinterest, 
                      dbo.master.interestrate, dbo.master.worked, dbo.master.userdate1, dbo.master.userdate2, dbo.master.userdate3, dbo.master.contacted, 
                      ISNULL(ls.NewStatus, dbo.master.status) AS [Status Code], dbo.master.customer, dbo.master.original, dbo.master.original1, dbo.master.original2, 
                      dbo.master.original3, dbo.master.original4, dbo.master.original5, dbo.master.original6, dbo.master.original7, dbo.master.original8, 
                      dbo.master.original9, dbo.master.original10, dbo.master.Accrued2, dbo.master.Accrued10, dbo.master.paid, dbo.master.paid1, dbo.master.paid2, 
                      dbo.master.paid3, dbo.master.paid4, dbo.master.paid5, dbo.master.paid7, dbo.master.paid6, dbo.master.paid8, dbo.master.paid9, dbo.master.paid10, 
                      dbo.master.current0, dbo.master.current1, dbo.master.current2, dbo.master.current3, dbo.master.current4, dbo.master.current6, dbo.master.current7, 
                      dbo.master.current5, dbo.master.current8, dbo.master.current9, dbo.master.current10, dbo.master.queue, dbo.master.qdate, dbo.master.qlevel, 
                      dbo.master.extracodes, dbo.master.feecode, dbo.master.clidlc, dbo.master.clidlp, dbo.master.seq, dbo.master.Pseq, dbo.master.Branch, 
                      dbo.master.TotalViewed, dbo.master.TotalWorked, dbo.master.TotalContacted, dbo.master.DOB, dbo.master.sysmonth, dbo.master.SysYear, 
                      desk.name AS [Desk Description], s.Description, ISNULL(ls.NewDescription, s.Description) AS [Status Description]
FROM         dbo.master WITH (nolock) LEFT OUTER JOIN
                      dbo.desk AS desk WITH (nolock) ON desk.code = dbo.master.desk LEFT OUTER JOIN
                      dbo.status AS s WITH (nolock) ON s.code = dbo.master.status LEFT OUTER JOIN
                      dbo.LionStatus AS ls ON ls.StatusCode = dbo.master.status

GO
