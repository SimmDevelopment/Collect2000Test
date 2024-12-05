SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*sp_Debtor_Update*/
CREATE  Procedure [dbo].[sp_Debtor_Update]
@DebtorID int,
@Number int,
@Seq int,
@Name varchar(30),
@Street1 varchar(30),
@Street2 varchar(30),
@City varchar(25),
@State varchar(3),
@Zipcode varchar(10),
@HomePhone varchar(20),
@WorkPhone varchar(20),
@SSN varchar(11),
@MR varchar(1),
@OtherName varchar(30),
@DOB Datetime,
@JobName varchar(30),
@JobAddr1 varchar(50),
@Jobaddr2 varchar(50),
@JobCSZ varchar(50),
@JobMemo text,
@Relationship varchar(15),
@Spouse varchar(50),
@SpouseJobName varchar(50),
@SpouseJobAddr1 varchar(50),
@SpouseJobAddr2 varchar(50),
@SpouseJobCSZ varchar(50),
@SpouseJobMemo text,
@SpouseHomePhone varchar(20),
@SpouseWorkPhone varchar(20),
@SpouseResponsible varchar(1),
@Pager varchar(20),
@OtherPhone1 varchar(20),
@OtherPhoneType varchar(15),
@OtherPhone2 varchar(20),
@OtherPhone2Type varchar(15),
@OtherPhone3 varchar(20),
@OtherPhone3Type varchar(15),
@DebtorMemo text,
@Language varchar(30),
@Email varchar(50),
@Fax varchar(50),
@DLNum varchar(50)
AS

UPDATE Debtors
SET
Number = @Number,
Seq = @Seq,
Name = @Name,
Street1 = @Street1,
Street2 = @Street2,
City = @City,
State = @State,
Zipcode = @Zipcode,
HomePhone = @HomePhone,
WorkPhone = @WorkPhone,
SSN = @SSN,
MR = @MR,
OtherName = @OtherName,
DOB = @DOB,
JobName = @JobName,
JobAddr1 = @JobAddr1,
Jobaddr2 = @Jobaddr2,
JobCSZ = @JobCSZ,
JobMemo = @JobMemo,
Relationship = @Relationship,
Spouse = @Spouse,
SpouseJobName = @SpouseJobName,
SpouseJobAddr1 = @SpouseJobAddr1,
SpouseJobAddr2 = @SpouseJobAddr2,
SpouseJobCSZ = @SpouseJobCSZ,
SpouseJobMemo = @SpouseJobMemo,
SpouseHomePhone = @SpouseHomePhone,
SpouseWorkPhone = @SpouseWorkPhone,
SpouseResponsible = @SpouseResponsible,
Pager = @Pager,
OtherPhone1 = @OtherPhone1,
OtherPhoneType = @OtherPhoneType,
OtherPhone2 = @OtherPhone2,
OtherPhone2Type = @OtherPhone2Type,
OtherPhone3 = @OtherPhone3,
OtherPhone3Type = @OtherPhone3Type,
DebtorMemo = @DebtorMemo,
language = @Language,
Email = @Email,
Fax = @Fax,
DLNum = @DLNum,
DateUpdated = GETDATE()
WHERE DebtorID = @DebtorID



GO
