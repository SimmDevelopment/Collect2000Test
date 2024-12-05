CREATE TABLE [dbo].[future]
(
[number] [int] NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Entered] [datetime] NULL,
[Requested] [datetime] NULL,
[rmsent] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[action] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lettercode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[letterdesc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[duedate] [datetime] NULL,
[amtdue] [money] NULL,
[sendrm] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promisetype] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seq] [int] NULL,
[city] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssn] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lastname] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firstname] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[middlename] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[namesuffix] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[streetname] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Streetnumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetDir] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hp] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WholeAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[user0] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[suspend] [bit] NULL,
[SifPmt1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt4] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt5] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt6] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[uid] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*trg_Future_Insert*/
CREATE  TRIGGER [dbo].[trg_Future_Insert] ON [dbo].[future]
FOR INSERT 
AS
-- Name:		trg_Future_Insert
-- Function:		This trigger will insert a letterrequest record and a letterrequestrecipient record
-- Creation:		unknnown
-- Change History:	7/23/2003 jcc added insert to fields RequesterID and SubjDebtorID by
--			joining in the debtors table.
--			5/13/2004 jcc added if statement to ensure the inserted future record
--			had an action value of 'Letter' to properly create letter requests

declare @action varchar(50)
select @action = action from inserted
if @action = 'Letter'
begin
	INSERT INTO LetterRequest
	(
	AccountID,
	CustomerCode,
	LetterID,
	LetterCode,
	DateRequested,
	DueDate,
	AmountDue,
	UserName,
	Suspend,
	SifPmt1,
	SifPmt2,
	SifPmt3,
	SifPmt4,
	SifPmt5,
	SifPmt6,
	CopyCustomer,
	SaveImage,
	ProcessingMethod,
	DateCreated,
	DateUpdated,
	FutureID,
	SubjDebtorID,
	SenderID,
	RequesterID
	)
	SELECT
		distinct I.number,
		M.Customer,
		L.LetterID,
		I.lettercode,
		I.Requested,
		CASE
			WHEN I.duedate IS NULL THEN '1/1/1753 12:00:00'
			ELSE I.duedate
		END,
		CASE
			WHEN I.amtdue IS NULL THEN 0
			ELSE I.amtdue
		END,
		CASE
			WHEN I.user0 IS NULL THEN ''
			ELSE I.user0
		END,
		CASE
			WHEN I.Suspend IS NULL THEN 0
			ELSE I.Suspend
		END, 
		I.SifPmt1,
		I.SifPmt2,
		I.SifPmt3,
		I.SifPmt4,
		I.SifPmt5,
		I.SifPmt6,
		CLA.CopyCustomer,
		CLA.SaveImage,
		0,
		I.Entered,
		I.Entered,
		I.uid,
		D.DebtorID,
		ISNULL(U.ID, 0),
		ISNULL(U.ID, 0)
	FROM INSERTED I
	JOIN Letter L ON I.lettercode = L.Code
	JOIN Master M on I.number = M.number
	JOIN CustLtrAllow CLA ON M.customer = CLA.CustCode AND CLA.LtrCode = I.lettercode
	JOIN Debtors D ON D.Number = I.number AND
		D.Seq =
		CASE
			WHEN I.seq IS NULL THEN 0
			ELSE I.seq
		END
	LEFT OUTER JOIN Users U ON I.user0 = U.LoginName

	--Now add the recipient
	INSERT INTO LetterRequestRecipient
	(
	LetterRequestID,
	AccountID,
	Seq,
	DebtorID
	)
	SELECT
	LR.LetterRequestID,
	I.number,
	CASE
		WHEN I.seq IS NULL THEN 0
		ELSE I.seq
	END,
	D.DebtorID
	FROM INSERTED I
	JOIN LetterRequest LR ON I.uid = LR.FutureID
	JOIN Debtors D ON D.Number = I.number AND
		D.Seq =
		CASE
			WHEN I.seq IS NULL THEN 0
			ELSE I.seq
		END
end

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*trg_Future_Update*/
CREATE TRIGGER [dbo].[trg_Future_Update] ON [dbo].[future]
FOR UPDATE 
AS
-- Name:		trg_Future_Update
-- Function:		This trigger will update a letter request record
-- Creation:		unknnown
-- Change History:	5/13/2004 jcc added if statement to ensure the inserted future record
--			had an action value of 'Letter' to properly create letter requests

declare @action varchar(50)
select @action = action from inserted
if @action = 'Letter'
begin
	UPDATE LetterRequest
	SET
		LetterID = L.LetterID,
		LetterCode = I.lettercode,
		DateRequested = I.Requested,
		DueDate =
		CASE
			WHEN I.duedate IS NULL THEN '1/1/1753 12:00:00'
			ELSE I.duedate
		END,
		AmountDue = 
		CASE
			WHEN I.amtdue IS NULL THEN 0
			ELSE I.amtdue
		END,
		UserName = I.user0,
		Suspend = 
		CASE
			WHEN I.Suspend IS NULL THEN 0
			ELSE I.Suspend
		END, 
		SifPmt1 = I.SifPmt1,
		SifPmt2 = I.SifPmt2,
		SifPmt3 = I.SifPmt3,
		SifPmt4 = I.SifPmt4,
		SifPmt5 = I.SifPmt5,
		SifPmt6 = I.SifPmt6,
		DateCreated = I.Entered,
		DateUpdated = I.Entered
	FROM INSERTED I
	JOIN LetterRequest LR ON I.uid = LR.FutureID
	JOIN Letter L ON I.lettercode = L.Code
end

GO
CREATE NONCLUSTERED INDEX [IX_Future_Number] ON [dbo].[future] ([number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Future_Requested_Action] ON [dbo].[future] ([Requested], [action]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Future_UID] ON [dbo].[future] ([uid]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used to define future letter requests,pdcs and other actions on account.  Primarily used by Custodian tasks.  This table is subject to be phased out in a future release of Latitude.', 'SCHEMA', N'dbo', 'TABLE', N'future', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Action code or decription of future action', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'action'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount due for Promise, PDC', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'amtdue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City of respective Primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'city'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Requestdate for letter, Duedate for PDC or Promise', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'duedate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp created', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'Entered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Firstname of primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'firstname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lastname of Primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'Lastname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lettercode of future letterrequest', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'lettercode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter description or other future description', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'letterdesc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Middlename of primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'middlename'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Namesuffix of primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'namesuffix'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 - Single Payment,2 - Monthly Payments,3 - Bi-Weekly Payments,4 - Twice a Month', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'promisetype'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date requested for letter entries', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'Requested'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Y/N remider letter sent for letters', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'rmsent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Y/N send remider flag for promises', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'sendrm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for first payment.', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'SifPmt1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for second payment.', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'SifPmt2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for third payment.', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'SifPmt3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for fourth payment.', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'SifPmt4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for fifth payment.', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'SifPmt5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for sixth payment.', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'SifPmt6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Social Security Number of respective Primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'ssn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State of respective primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'state'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street Direction of primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'StreetDir'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street name of primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'streetname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street Number of primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'Streetnumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Suspend indicator switch', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'suspend'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'uid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'user0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Complete address string of primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'WholeAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Zipcode of respective primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'future', 'COLUMN', N'zipcode'
GO
