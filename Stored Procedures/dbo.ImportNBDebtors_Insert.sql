SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*ImportNBDebtors_Insert*/
CREATE PROCEDURE [dbo].[ImportNBDebtors_Insert]

@Number int,
@Seq tinyint,
@Name varchar(30),
@Street1 varchar(30),
@Street2 varchar(30),
@City varchar(20),
@State varchar(3),
@Zipcode varchar(10),
@HomePhone varchar(30),
@WorkPhone varchar(30),
@SSN varchar(15),
@MR varchar(1),
@OtherName varchar(30),
@DOB DateTime,
@JobName varchar(50),
@JobAddr1 varchar(50),
@Jobaddr2 varchar(50),
@JobCSZ varchar(30),
@JobMemo text,
@Relationship varchar(20),
@Spouse varchar(50),
@SpouseJobName varchar(50),
@SpouseJobAddr1 varchar(50),
@SpouseJobAddr2 varchar(50),
@SpouseJobCSZ varchar(50),
@SpouseJobMemo varchar(30),
@SpouseHomePhone varchar(20),
@SpouseWorkPhone varchar(20),
@SpouseResponsible varchar(1),
@Pager varchar(30),
@OtherPhone1 varchar(20),
@OtherPhoneType varchar(15),
@OtherPhone2 varchar(20),
@OtherPhone2Type varchar(15),
@OtherPhone3 varchar(20),
@OtherPhone3Type varchar(15),
@DebtorMemo text,
@language varchar(30),
@DLNum varchar(50),
@Fax varchar(50),
@Email varchar(50)

AS

INSERT INTO ImportNBDebtors(

Number,
Seq,
Name,
Street1,
Street2,
City,
State,
Zipcode,
HomePhone,
WorkPhone,
SSN,
MR,
OtherName,
DOB,
JobName,
JobAddr1,
Jobaddr2,
JobCSZ,
JobMemo,
Relationship,
Spouse,
SpouseJobName,
SpouseJobAddr1,
SpouseJobAddr2,
SpouseJobCSZ,
SpouseJobMemo,
SpouseHomePhone,
SpouseWorkPhone,
SpouseResponsible,
Pager,
OtherPhone1,
OtherPhoneType,
OtherPhone2,
OtherPhone2Type,
OtherPhone3,
OtherPhone3Type,
DebtorMemo,
language,
DLNum,
Fax,
Email,
DateCreated,
DateUpdated
)

VALUES(
@Number,
@Seq,
@Name,
@Street1,
@Street2,
@City,
@State,
@Zipcode,
@HomePhone,
@WorkPhone,
@SSN,
@MR,
@OtherName,
@DOB,
@JobName,
@JobAddr1,
@Jobaddr2,
@JobCSZ,
@JobMemo,
@Relationship,
@Spouse,
@SpouseJobName,
@SpouseJobAddr1,
@SpouseJobAddr2,
@SpouseJobCSZ,
@SpouseJobMemo,
@SpouseHomePhone,
@SpouseWorkPhone,
@SpouseResponsible,
@Pager,
@OtherPhone1,
@OtherPhoneType,
@OtherPhone2,
@OtherPhone2Type,
@OtherPhone3,
@OtherPhone3Type,
@DebtorMemo,
@language,
@DLNum,
@Fax,
@Email,
GetDate(),
GetDate()
)

Return @@Error
GO
