SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Future_Add*/
CREATE Procedure [dbo].[sp_Future_Add]
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

INSERT INTO future
(
number,
ctl,
Entered,
Requested,
rmsent,
action,
lettercode,
letterdesc,
duedate,
amtdue,
sendrm,
promisetype,
seq,
city,
state,
zipcode,
ssn,
Lastname,
firstname,
middlename,
namesuffix,
streetname,
Streetnumber,
StreetDir,
hp,
WholeAddress,
user0,
suspend,
SifPmt1,
SifPmt2,
SifPmt3,
SifPmt4,
SifPmt5,
SifPmt6
)
VALUES
(
@Number,
@Ctl,
@Entered,
@Requested,
@Rmsent,
@Action,
@Lettercode,
@Letterdesc,
@Duedate,
@Amtdue,
@Sendrm,
@Promisetype,
@Seq,
@City,
@State,
@Zipcode,
@Ssn,
@Lastname,
@Firstname,
@Middlename,
@Namesuffix,
@Streetname,
@Streetnumber,
@StreetDir,
@Hp,
@WholeAddress,
@User0,
@Suspend,
@SifPmt1,
@SifPmt2,
@SifPmt3,
@SifPmt4,
@SifPmt5,
@SifPmt6
)

--SET @FutureID = @@IDENTITY

GO
