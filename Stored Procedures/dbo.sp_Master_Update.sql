SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Master_Update*/
CREATE Procedure [dbo].[sp_Master_Update]
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

UPDATE master
SET
link = @Link,
desk = @Desk,
Name = @Name,
Street1 = @Street1,
Street2 = @Street2,
City = @City,
State = @State,
Zipcode = @Zipcode,
ctl = @Ctl,
other = @Other,
MR = @MR,
account = @Account,
homephone = @Homephone,
workphone = @Workphone,
specialnote = @Specialnote,
received = @Received,
closed = @Closed,
returned = @Returned,
lastpaid = @Lastpaid,
lastpaidamt = @Lastpaidamt,
lastinterest = @Lastinterest,
interestrate = @Interestrate,
worked = @Worked,
userdate1 = @Userdate1,
userdate2 = @Userdate2,
userdate3 = @Userdate3,
contacted = @Contacted,
status = @Status,
customer = @Customer,
SSN = @SSN,
original = @Original,
original1 = @Original1,
original2 = @Original2,
original3 = @Original3,
original4 = @Original4,
original5 = @Original5,
original6 = @Original6,
original7 = @Original7,
original8 = @Original8,
original9 = @Original9,
original10 = @Original10,
Accrued2 = @Accrued2,
Accrued10 = @Accrued10,
paid = @Paid,
paid1 = @Paid1,
paid2 = @Paid2,
paid3 = @Paid3,
paid4 = @Paid4,
paid5 = @Paid5,
paid6 = @Paid6,
paid7 = @Paid7,
paid8 = @Paid8,
paid9 = @Paid9,
paid10 = @Paid10,
current0 = @Current0,
current1 = @Current1,
current2 = @Current2,
current3 = @Current3,
current4 = @Current4,
current5 = @Current5,
current6 = @Current6,
current7 = @Current7,
current8 = @Current8,
current9 = @Current9,
current10 = @Current10,
attorney = @Attorney,
assignedattorney = @Assignedattorney,
promamt = @Promamt,
promdue = @Promdue,
sifpct = @Sifpct,
queue = @Queue,
qflag = @Qflag,
qdate = @Qdate,
qlevel = @Qlevel,
qtime = @Qtime,
extracodes = @Extracodes,
Salary = @Salary,
feecode = @Feecode,
clidlc = @Clidlc,
clidlp = @Clidlp,
seq = @Seq,
Pseq = @Pseq,
Branch = @Branch,
Finders = @Finders,
COMPLETE1 = @COMPLETE1,
Complete2 = @Complete2,
DESK1 = @DESK1,
DESK2 = @DESK2,
Full0 = @Full0,
TotalViewed = @TotalViewed,
TotalWorked = @TotalWorked,
TotalContacted = @TotalContacted,
nsf = @Nsf,
HasBigNote = @HasBigNote,
FirstDesk = @FirstDesk,
FirstReceived = @FirstReceived,
AgencyFlag = @AgencyFlag,
AgencyCode = @AgencyCode,
FeeSchedule = @FeeSchedule,
CustDivision = @CustDivision,
CustDistrict = @CustDistrict,
CustBranch = @CustBranch,
Delinquencydate = @Delinquencydate,
CurrencyType = @CurrencyType,
DOB = @DOB,
sysmonth = @Sysmonth,
SysYear = @SysYear,
DMDateStamp = @DMDateStamp,
id1 = @Id1,
id2 = @Id2,
OriginalCreditor = @OriginalCreditor
WHERE number = @Number

GO
