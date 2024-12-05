SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  View dbo.vDebtorView    Script Date: 4/11/2002 5:04:15 PM ******/
CREATE VIEW [dbo].[vDebtorView]
AS
SELECT     lower(dbo.status.Description) AS StatusDescription, number, desk, 
                      lower(Name) AS Name, lower(Street1) AS Street1, lower(City) AS City, 
                      lower(Street2) AS Street2, State, Zipcode, MR, account, homephone, workphone, specialnote, received, closed, 
                      returned, lastpaid, lastpaidamt, lastinterest, interestrate, worked, 
                      status, customer, SSN, CONVERT(varchar(19), original, 1) as original, CONVERT(varchar(19), paid, 1) as paid,
                      CONVERT(varchar(19), current0, 1) as current0, qlevel, CASE substring(dbo.status.statustype, 1, 1) 
                      WHEN 0 THEN 0 ELSE 1 END AS accountclosed
FROM         dbo.master INNER JOIN
                      dbo.status ON status = dbo.status.code



GO
