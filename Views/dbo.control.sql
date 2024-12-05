SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* this view appears to be required by the PAYRPT106 report */
CREATE VIEW [dbo].[control]
AS
SELECT Company, Street1, Street2, City, State, Zipcode, fax, phone, phone800, nextdebtor, nextinvoice, nextlink, password, currentmonth, currentyear, useroptions,
       userdate1, userdate2, userdate3, money1, money2, money3, money4, money5, money6, money7, money8, money9, money10,
       ctl, X1, X2, fees, collections, mtdpdcfees, mtdpdccollections, mtdfees, mtdcollections, ytdfees, ytdcollections, letterrm, letterpdc, letterbp, Option1,
       backuppath, SoftwareVersion, CrystalReports, eomdate
FROM [dbo].[controlFile]
GO
