SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*CREATE VIEW dbo.Documerge*/
CREATE VIEW [dbo].[Documerge]
AS
SELECT     dbo.master.number, dbo.master.Name, dbo.master.other, dbo.master.Street1, dbo.master.Street2, dbo.master.City, dbo.master.State, 
                      dbo.master.Zipcode, ISNULL(dbo.master.City, '') + ', ' + ISNULL(dbo.master.State, '') + ' ' + ISNULL(dbo.master.Zipcode, '') AS CSZ, dbo.master.account, 
                      dbo.master.received, dbo.master.lastpaid, dbo.master.userdate1, dbo.master.userdate2, dbo.master.userdate3, dbo.master.customer, 
                      dbo.Customer.Name AS CustomerName, dbo.Customer.Street1 AS custstreet1, dbo.Customer.Street2 AS custstreet2, dbo.Customer.City AS custcity, 
                      dbo.Customer.State AS custstate, dbo.Customer.Zipcode AS custzipcode, ISNULL(dbo.Customer.City, '') + ', ' + ISNULL(dbo.Customer.State, '') 
                      + ' ' + ISNULL(dbo.Customer.Zipcode, '') AS custcsz, dbo.Customer.Contact AS custcontact, ISNULL(dbo.Customer.customer, '') 
                      + ' - ' + ISNULL(dbo.Customer.Name, '') AS customercombo, '$' + CONVERT(varchar(19), dbo.master.current0, 1) AS [current], '$' + CONVERT(varchar(19),
                       dbo.master.current1, 1) AS current1, '$' + CONVERT(varchar(19), dbo.master.current2, 1) AS current2, '$' + CONVERT(varchar(19), dbo.master.current3, 
                      1) AS current3, '$' + CONVERT(varchar(19), dbo.master.current4, 1) AS current4, '$' + CONVERT(varchar(19), dbo.master.current5, 1) AS current5, 
                      '$' + CONVERT(varchar(19), dbo.master.current6, 1) AS current6, '$' + CONVERT(varchar(19), dbo.master.current7, 1) AS current7, 
                      '$' + CONVERT(varchar(19), dbo.master.current8, 1) AS current8, '$' + CONVERT(varchar(19), dbo.master.current9, 1) AS current9, 
                      '$' + CONVERT(varchar(19), dbo.master.current10, 1) AS current10, '$' + CONVERT(varchar(19), dbo.master.paid, 1) AS paid, '$' + CONVERT(varchar(19), 
                      dbo.master.paid1, 1) AS paid1, '$' + CONVERT(varchar(19), dbo.master.paid2, 1) AS paid2, '$' + CONVERT(varchar(19), dbo.master.paid3, 1) AS paid3, 
                      '$' + CONVERT(varchar(19), dbo.master.paid4, 1) AS paid4, '$' + CONVERT(varchar(19), dbo.master.paid5, 1) AS paid5, '$' + CONVERT(varchar(19), 
                      dbo.master.paid6, 1) AS paid6, '$' + CONVERT(varchar(19), dbo.master.paid7, 1) AS paid7, '$' + CONVERT(varchar(19), dbo.master.paid8, 1) AS paid8, 
                      '$' + CONVERT(varchar(19), dbo.master.paid9, 1) AS paid9, '$' + CONVERT(varchar(19), dbo.master.paid10, 1) AS paid10, '$' + CONVERT(varchar(19), 
                      dbo.master.original, 1) AS original, '$' + CONVERT(varchar(19), dbo.master.original1, 1) AS original1, '$' + CONVERT(varchar(19), dbo.master.original2, 
                      1) AS original2, '$' + CONVERT(varchar(19), dbo.master.original3, 1) AS original3, '$' + CONVERT(varchar(19), dbo.master.original4, 1) AS original4, 
                      '$' + CONVERT(varchar(19), dbo.master.original5, 1) AS original5, '$' + CONVERT(varchar(19), dbo.master.original6, 1) AS original6, 
                      '$' + CONVERT(varchar(19), dbo.master.original7, 1) AS original7, '$' + CONVERT(varchar(19), dbo.master.original8, 1) AS original8, 
                      '$' + CONVERT(varchar(19), dbo.master.original9, 1) AS original9, '$' + CONVERT(varchar(19), dbo.master.original10, 1) AS original10, 
                      dbo.future.amtdue AS promiseamount, dbo.future.duedate AS promisedue, dbo.master.SSN, dbo.controlFile.Company, 
                      dbo.controlFile.Street1 AS CompanyAddr1, dbo.controlFile.Street2 AS CompanyAddr2, dbo.controlFile.City AS CompanyCity, 
                      dbo.controlFile.State AS CompanyState, dbo.controlFile.Zipcode AS CompanyZip, ISNULL(dbo.controlFile.City, '') + ', ' + ISNULL(dbo.controlFile.State, '') 
                      + ' ' + ISNULL(dbo.controlFile.Zipcode, '') AS companycombo, dbo.controlFile.phone AS companyphone, dbo.controlFile.fax AS CompanyFax, 
                      dbo.controlFile.phone800 AS Company800Phone, dbo.master.desk, dbo.master.Name AS LNF, dbo.future.SifPmt1, dbo.future.SifPmt2, 
                      dbo.future.SifPmt3, dbo.future.SifPmt4, dbo.future.SifPmt5, dbo.future.SifPmt6, L1.line1 AS L1_Line1, L1.line2 AS L1_Line2, L1.line3 AS L1_Line3, 
                      L1.line4 AS L1_Line4, L1.line5 AS L1_Line5, L2.line1 AS L2_Line1, L2.line2 AS L2_Line2, L2.line3 AS L2_Line3, L2.line4 AS L2_Line4, 
                      L2.line5 AS L2_Line5, L3.line1 AS L3_Line1, L3.line2 AS L3_Line2, L3.line3 AS L3_Line3, L3.line4 AS L3_Line4, L3.line5 AS L3_Line5, 
                      L4.line1 AS L4_Line1, L4.line2 AS L4_Line2, L4.line3 AS L4_Line3, L4.line4 AS L4_Line4, L4.line5 AS L4_Line5, CONVERT(varchar, dbo.master.clidlc, 
                      107) AS CustomerDLC, CONVERT(varchar, dbo.master.clidlp, 107) AS CustomerDLP, dbo.StateRestrictions.Advisory AS State_Legal_Advisory, 
                      '$' + CONVERT(varchar(19), linktotals.LinkedBalance, 1) AS LinkedBalance
FROM         dbo.master LEFT OUTER JOIN
                      dbo.Customer ON dbo.master.customer = dbo.Customer.customer LEFT OUTER JOIN
                      dbo.extradata L1 ON L1.number = dbo.master.number AND L1.extracode = 'L1' LEFT OUTER JOIN
                      dbo.extradata L2 ON L2.number = dbo.master.number AND L2.extracode = 'L2' LEFT OUTER JOIN
                      dbo.extradata L3 ON L3.number = dbo.master.number AND L3.extracode = 'L3' LEFT OUTER JOIN
                      dbo.extradata L4 ON L4.number = dbo.master.number AND L4.extracode = 'L4' LEFT OUTER JOIN
                      dbo.future ON dbo.master.number = dbo.future.number LEFT OUTER JOIN
                      dbo.StateRestrictions ON dbo.StateRestrictions.abbreviation = dbo.master.State LEFT OUTER JOIN
                          (SELECT     SUM(current0) AS LinkedBalance, link
                            FROM          master
                            WHERE      link > 0
                            GROUP BY link) linktotals ON linktotals.link = dbo.master.link CROSS JOIN
                      dbo.controlFile

GO
