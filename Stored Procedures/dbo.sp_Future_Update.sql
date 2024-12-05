SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Future_Update*/
CREATE Procedure [dbo].[sp_Future_Update]
@Number int,
@Ctl varchar(3),
@Entered Datetime,
@Requested Datetime,
@Rmsent varchar(1),
@Action varchar(50),
@Lettercode varchar(5),
@Letterdesc varchar(50),
@Duedate Datetime,
@Amtdue money,
@Sendrm varchar(1),
@Promisetype varchar(10),
@Seq int,
@City varchar(20),
@State varchar(2),
@Zipcode varchar(10),
@Ssn varchar(15),
@Lastname varchar(30),
@Firstname varchar(20),
@Middlename varchar(5),
@Namesuffix varchar(10),
@Streetname varchar(30),
@Streetnumber varchar(10),
@StreetDir varchar(10),
@Hp varchar(10),
@WholeAddress varchar(50),
@User0 varchar(10),
@Suspend bit,
@SifPmt1 varchar(30),
@SifPmt2 varchar(30),
@SifPmt3 varchar(30),
@SifPmt4 varchar(30),
@SifPmt5 varchar(30),
@SifPmt6 varchar(30),
@Uid int
AS

UPDATE future
SET
number = @Number,
ctl = @Ctl,
Entered = @Entered,
Requested = @Requested,
rmsent = @Rmsent,
action = @Action,
lettercode = @Lettercode,
letterdesc = @Letterdesc,
duedate = @Duedate,
amtdue = @Amtdue,
sendrm = @Sendrm,
promisetype = @Promisetype,
seq = @Seq,
city = @City,
state = @State,
zipcode = @Zipcode,
ssn = @Ssn,
Lastname = @Lastname,
firstname = @Firstname,
middlename = @Middlename,
namesuffix = @Namesuffix,
streetname = @Streetname,
Streetnumber = @Streetnumber,
StreetDir = @StreetDir,
hp = @Hp,
WholeAddress = @WholeAddress,
user0 = @User0,
suspend = @Suspend,
SifPmt1 = @SifPmt1,
SifPmt2 = @SifPmt2,
SifPmt3 = @SifPmt3,
SifPmt4 = @SifPmt4,
SifPmt5 = @SifPmt5,
SifPmt6 = @SifPmt6
WHERE uid = @Uid

GO
