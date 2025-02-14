SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Master_Add*/
CREATE Procedure [dbo].[sp_Master_Add]
@Number int,
@Link int,
@Desk varchar(10),
@Name varchar(30),
@Street1 varchar(30),
@Street2 varchar(30),
@City varchar(20),
@State varchar(3),
@Zipcode varchar(10),
@Ctl varchar(3),
@Other varchar(30),
@MR varchar(1),
@Account varchar(30),
@Homephone varchar(30),
@Workphone varchar(30),
@Specialnote varchar(75),
@Received Datetime,
@Closed Datetime,
@Returned Datetime,
@Lastpaid Datetime,
@Lastpaidamt money,
@Lastinterest Datetime,
@Interestrate money,
@Worked Datetime,
@Userdate1 Datetime,
@Userdate2 Datetime,
@Userdate3 Datetime,
@Contacted Datetime,
@Status varchar(5),
@Customer varchar(7),
@SSN varchar(15),
@Original money,
@Original1 money,
@Original2 money,
@Original3 money,
@Original4 money,
@Original5 money,
@Original6 money,
@Original7 money,
@Original8 money,
@Original9 money,
@Original10 money,
@Accrued2 money,
@Accrued10 money,
@Paid money,
@Paid1 money,
@Paid2 money,
@Paid3 money,
@Paid4 money,
@Paid5 money,
@Paid6 money,
@Paid7 money,
@Paid8 money,
@Paid9 money,
@Paid10 money,
@Current0 money,
@Current1 money,
@Current2 money,
@Current3 money,
@Current4 money,
@Current5 money,
@Current6 money,
@Current7 money,
@Current8 money,
@Current9 money,
@Current10 money,
@Attorney varchar(5),
@Assignedattorney Datetime,
@Promamt money,
@Promdue Datetime,
@Sifpct money,
@Queue varchar(26),
@Qflag varchar(1),
@Qdate varchar(8),
@Qlevel varchar(3),
@Qtime varchar(4),
@Extracodes varchar(40),
@Salary money,
@Feecode varchar(30),
@Clidlc Datetime,
@Clidlp Datetime,
@Seq int,
@Pseq int,
@Branch varchar(5),
@Finders Datetime,
@COMPLETE1 Datetime,
@Complete2 Datetime,
@DESK1 varchar(10),
@DESK2 varchar(10),
@Full0 Datetime,
@TotalViewed int,
@TotalWorked int,
@TotalContacted int,
@Nsf varchar(1),
@HasBigNote varchar(1),
@FirstDesk varchar(10),
@FirstReceived Datetime,
@AgencyFlag tinyint,
@AgencyCode varchar(5),
@FeeSchedule varchar(5),
@CustDivision varchar(15),
@CustDistrict varchar(15),
@CustBranch varchar(15),
@Delinquencydate Datetime,
@CurrencyType varchar(20),
@DOB Datetime,
@Sysmonth tinyint,
@SysYear smallint,
@DMDateStamp varchar(10),
@Id1 varchar(40),
@Id2 varchar(40),
@OriginalCreditor varchar(50)
AS

INSERT INTO master
(
number,
link,
desk,
Name,
Street1,
Street2,
City,
State,
Zipcode,
ctl,
other,
MR,
account,
homephone,
workphone,
specialnote,
received,
closed,
returned,
lastpaid,
lastpaidamt,
lastinterest,
interestrate,
worked,
userdate1,
userdate2,
userdate3,
contacted,
status,
customer,
SSN,
original,
original1,
original2,
original3,
original4,
original5,
original6,
original7,
original8,
original9,
original10,
Accrued2,
Accrued10,
paid,
paid1,
paid2,
paid3,
paid4,
paid5,
paid6,
paid7,
paid8,
paid9,
paid10,
current0,
current1,
current2,
current3,
current4,
current5,
current6,
current7,
current8,
current9,
current10,
attorney,
assignedattorney,
promamt,
promdue,
sifpct,
queue,
qflag,
qdate,
qlevel,
qtime,
extracodes,
Salary,
feecode,
clidlc,
clidlp,
seq,
Pseq,
Branch,
Finders,
COMPLETE1,
Complete2,
DESK1,
DESK2,
Full0,
TotalViewed,
TotalWorked,
TotalContacted,
nsf,
HasBigNote,
FirstDesk,
FirstReceived,
AgencyFlag,
AgencyCode,
FeeSchedule,
CustDivision,
CustDistrict,
CustBranch,
Delinquencydate,
CurrencyType,
DOB,
sysmonth,
SysYear,
DMDateStamp,
id1,
id2,
OriginalCreditor
)
VALUES
(
@Number,
@Link,
@Desk,
@Name,
@Street1,
@Street2,
@City,
@State,
@Zipcode,
@Ctl,
@Other,
@MR,
@Account,
@Homephone,
@Workphone,
@Specialnote,
@Received,
@Closed,
@Returned,
@Lastpaid,
@Lastpaidamt,
@Lastinterest,
@Interestrate,
@Worked,
@Userdate1,
@Userdate2,
@Userdate3,
@Contacted,
@Status,
@Customer,
@SSN,
@Original,
@Original1,
@Original2,
@Original3,
@Original4,
@Original5,
@Original6,
@Original7,
@Original8,
@Original9,
@Original10,
@Accrued2,
@Accrued10,
@Paid,
@Paid1,
@Paid2,
@Paid3,
@Paid4,
@Paid5,
@Paid6,
@Paid7,
@Paid8,
@Paid9,
@Paid10,
@Current0,
@Current1,
@Current2,
@Current3,
@Current4,
@Current5,
@Current6,
@Current7,
@Current8,
@Current9,
@Current10,
@Attorney,
@Assignedattorney,
@Promamt,
@Promdue,
@Sifpct,
@Queue,
@Qflag,
@Qdate,
@Qlevel,
@Qtime,
@Extracodes,
@Salary,
@Feecode,
@Clidlc,
@Clidlp,
@Seq,
@Pseq,
@Branch,
@Finders,
@COMPLETE1,
@Complete2,
@DESK1,
@DESK2,
@Full0,
@TotalViewed,
@TotalWorked,
@TotalContacted,
@Nsf,
@HasBigNote,
@FirstDesk,
@FirstReceived,
@AgencyFlag,
@AgencyCode,
@FeeSchedule,
@CustDivision,
@CustDistrict,
@CustBranch,
@Delinquencydate,
@CurrencyType,
@DOB,
@Sysmonth,
@SysYear,
@DMDateStamp,
@Id1,
@Id2,
@OriginalCreditor
)

--SET @MasterID = @@IDENTITY

GO
