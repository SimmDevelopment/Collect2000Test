SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*dbo.sp_LetterRequest_Update*/
CREATE  Procedure [dbo].[sp_LetterRequest_Update]
@LetterRequestID int,
@AccountID int,
@CustomerCode varchar(7),
@LetterID int,
@LetterCode varchar(5),
@SubjDebtorID int,
@DateRequested Datetime,
@DateProcessed Datetime,
@JobName varchar(256),
@DueDate Datetime,
@AmountDue money,
@UserName varchar(10),
@SenderID int,
@RequesterID int,
@Suspend bit,
@SifPmt1 varchar(30),
@SifPmt2 varchar(30),
@SifPmt3 varchar(30),
@SifPmt4 varchar(30),
@SifPmt5 varchar(30),
@SifPmt6 varchar(30),
@SifPmt7 varchar(30) = '',
@SifPmt8 varchar(30) = '',
@SifPmt9 varchar(30) = '',
@SifPmt10 varchar(30) = '',
@SifPmt11 varchar(30) = '',
@SifPmt12 varchar(30) = '',
@SifPmt13 varchar(30) = '',
@SifPmt14 varchar(30) = '',
@SifPmt15 varchar(30) = '',
@SifPmt16 varchar(30) = '',
@SifPmt17 varchar(30) = '',
@SifPmt18 varchar(30) = '',
@SifPmt19 varchar(30) = '',
@SifPmt20 varchar(30) = '',
@SifPmt21 varchar(30) = '',
@SifPmt22 varchar(30) = '',
@SifPmt23 varchar(30) = '',
@SifPmt24 varchar(30) = '',
@Manual bit,
@AddEditMode bit,
@Edited bit,
@DocumentData image,
@Deleted bit,
@CopyCustomer bit,
@SaveImage bit,
@ProcessingMethod int,
@ErrorDescription varchar(200)
AS

UPDATE LetterRequest
SET
AccountID = @AccountID,
CustomerCode = @CustomerCode,
LetterCode = @LetterCode,
LetterID = @LetterID,
SubjDebtorID = @SubjDebtorID,
DateRequested = @DateRequested,
DateProcessed = @DateProcessed,
JobName = @JobName,
DueDate = @DueDate,
AmountDue = @AmountDue,
UserName = @UserName,
SenderID = @SenderID,
RequesterID = @RequesterID,
Suspend = @Suspend,
SifPmt1 = @SifPmt1,
SifPmt2 = @SifPmt2,
SifPmt3 = @SifPmt3,
SifPmt4 = @SifPmt4,
SifPmt5 = @SifPmt5,
SifPmt6 = @SifPmt6,
SifPmt7 = @SifPmt7,
SifPmt8 = @SifPmt8,
SifPmt9 = @SifPmt9,
SifPmt10 = @SifPmt10,
SifPmt11 = @SifPmt11,
SifPmt12 = @SifPmt12,
SifPmt13 = @SifPmt13,
SifPmt14 = @SifPmt14,
SifPmt15 = @SifPmt15,
SifPmt16 = @SifPmt16,
SifPmt17 = @SifPmt17,
SifPmt18 = @SifPmt18,
SifPmt19 = @SifPmt19,
SifPmt20 = @SifPmt20,
SifPmt21 = @SifPmt21,
SifPmt22 = @SifPmt22,
SifPmt23 = @SifPmt23,
SifPmt24 = @SifPmt24,
Manual = @Manual,
AddEditMode = @AddEditMode,
Edited = @Edited,
DocumentData = @DocumentData,
Deleted = @Deleted,
CopyCustomer = @CopyCustomer,
SaveImage = @SaveImage,
ProcessingMethod = @ProcessingMethod,
ErrorDescription = @ErrorDescription
WHERE LetterRequestID = @LetterRequestID



GO