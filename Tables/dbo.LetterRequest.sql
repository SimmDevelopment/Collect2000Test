CREATE TABLE [dbo].[LetterRequest]
(
[LetterRequestID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[CustomerCode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LetterID] [int] NOT NULL,
[LetterCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateRequested] [datetime] NOT NULL CONSTRAINT [DF_LetterRequest_DateRequested] DEFAULT (getdate()),
[DateProcessed] [datetime] NOT NULL CONSTRAINT [DF_LetterRequest_DateProcessed] DEFAULT ('1/1/1753 12:00:00'),
[JobName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DueDate] [datetime] NOT NULL CONSTRAINT [DF_LetterRequest_DueDate] DEFAULT ('1/1/1753 12:00:00'),
[AmountDue] [money] NOT NULL CONSTRAINT [DF_LetterRequest_AmountDue] DEFAULT (0),
[UserName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Suspend] [bit] NOT NULL CONSTRAINT [DF_LetterRequest_Suspend] DEFAULT (0),
[SifPmt1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt4] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt5] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt6] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manual] [bit] NOT NULL CONSTRAINT [DF_LetterRequest_Manual] DEFAULT (0),
[AddEditMode] [bit] NOT NULL CONSTRAINT [DF_LetterRequest_AddEditMode] DEFAULT (0),
[Edited] [bit] NOT NULL CONSTRAINT [DF_LetterRequest_Edited] DEFAULT (0),
[DocumentData] [varbinary] (max) NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_LetterRequest_Deleted] DEFAULT (0),
[CopyCustomer] [bit] NOT NULL CONSTRAINT [DF_LetterRequest_CopyCustomer] DEFAULT (0),
[SaveImage] [bit] NOT NULL CONSTRAINT [DF_LetterRequest_SaveImage] DEFAULT (0),
[ProcessingMethod] [int] NOT NULL CONSTRAINT [DF_LetterRequest_ProcessingMethod] DEFAULT (0),
[ErrorDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_LetterRequest_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_LetterRequest_DateUpdated] DEFAULT (getdate()),
[SubjDebtorID] [int] NULL,
[SenderID] [int] NULL,
[RequesterID] [int] NULL,
[FutureID] [int] NOT NULL CONSTRAINT [DF_LetterRequest_FutureID] DEFAULT (0),
[RecipientDebtorID] [int] NULL,
[RecipientDebtorSeq] [tinyint] NULL,
[LtrSeriesQueueID] [int] NULL,
[SifPmt7] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt8] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt9] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt10] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt11] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt12] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt13] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt14] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt15] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt16] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt17] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt18] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt19] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt20] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt21] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt22] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt23] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SifPmt24] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PdcId] [int] NULL CONSTRAINT [DF_LetterRequest_PdcId] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterRequest] ADD CONSTRAINT [CHK_DocumentData_MaxSize] CHECK ((datalength([DocumentData])<=(131072)))
GO
ALTER TABLE [dbo].[LetterRequest] ADD CONSTRAINT [PK_LetterRequest] PRIMARY KEY CLUSTERED ([LetterRequestID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LetterRequest_AccountID] ON [dbo].[LetterRequest] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LetterRequest_DateCreated_UserName] ON [dbo].[LetterRequest] ([DateCreated], [UserName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LetterRequest_DateProcessed] ON [dbo].[LetterRequest] ([DateProcessed]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LetterRequest_DueDate] ON [dbo].[LetterRequest] ([DueDate] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LetterRequest_FutureID] ON [dbo].[LetterRequest] ([FutureID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_LetterRequest_GetForVendor] ON [dbo].[LetterRequest] ([LetterID], [Deleted], [Suspend], [AddEditMode], [Edited], [DateProcessed], [DateRequested] DESC) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table used by Letter Console to schedule and process debtor letters', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'FileNumber - Master.Number ', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of first installment due ', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'AmountDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set copies Customer on letter', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'CopyCustomer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer that the account belongs to ', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'CustomerCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date letter request created', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date letter printed - letter file created', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'DateProcessed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date letter requested by user', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'DateRequested'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date letter request last updated', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator that request was deleted prior to being executed', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'Deleted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Document image of letter if SaveImage is set ', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'DocumentData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date first installment is due ', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'DueDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates letter document has been edited by User.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'Edited'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used.  Future table Identity ID.  Use of the Future table for letter generation will be discontinued in a future version of Latitude.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'FutureID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Process name of job printing letter - creating file', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'JobName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Five digit numeric letter code assigned within the Letter Console program.  Generally used for internal reference purposes', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'LetterCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identity for the letter code ', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'LetterID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Auto generated Unique Identity for request ', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'LetterRequestID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates manual request for letter on account by collector', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'Manual'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PDC Id for PDC NITD Letters', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'PdcId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DebtorID receiving the letter ', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'RecipientDebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence number of debtor receiving letter', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'RecipientDebtorSeq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set saves letter image to table (documentation and documentation_attachments)', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SaveImage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for first payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for tenth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for eleventh payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt11'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for twelth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt12'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for thirteenth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt13'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for fourteenth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt14'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for fifteenth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt15'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for sixteenth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt16'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for seventeenth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt17'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for eighteenth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt18'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for nineteenth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt19'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for second payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for twentieth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt20'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for twenty-first payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt21'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for twenty-second payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt22'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for twenty-third payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt23'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for twenty-fourth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt24'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for third payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for fourth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for fifth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for sixth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for seventh payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for eighth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for nineth payment.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SifPmt9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique debtor ID for the primary debtor on the account', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'SubjDebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator suspending processing of letter', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'Suspend'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Username requesting letter', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest', 'COLUMN', N'UserName'
GO
