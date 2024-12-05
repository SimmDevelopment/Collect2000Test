CREATE TABLE [dbo].[ImportNBLetters]
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
[city] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[SifPmt6] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table for NewBusiness load.  ', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of first installment due ', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'amtdue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City of Recepient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'city'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date first installment is due ', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'duedate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp created', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'Entered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First Name of recipient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'firstname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last Nmae of recipient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'Lastname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Five digit numeric letter code assigned within the Letter Console program.  Gene', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'lettercode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of letter', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'letterdesc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Middle Name of recipient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'middlename'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Suffix Name of recipient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'namesuffix'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FileNumber - Master.Number ', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 - Single Payment,2 - Monthly Payments,3 - Bi-Weekly Payments,4 - Twice a Month', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'promisetype'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date letter requested by user or collector', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'Requested'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating Reminder has been sent', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'rmsent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating Reminder Letter will be issued', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'sendrm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for first payment.', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'SifPmt1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for second payment.', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'SifPmt2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for third payment.', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'SifPmt3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for fourth payment.', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'SifPmt4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for fifth payment.', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'SifPmt5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Future multipart settlement information showing amount due and date due  for sixth payment.', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'SifPmt6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Social Security Number of recipient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'ssn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State of Recipient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'state'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Direction of street for recipient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'StreetDir'
GO
EXEC sp_addextendedproperty N'MS_Description', N'StreetName of recipient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'streetname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Streetnumber of recipient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'Streetnumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator suspending processing of letter', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'suspend'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Use Logon Name of collector processing import', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'user0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Complete address of recipient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'WholeAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ZipCode of recipient', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBLetters', 'COLUMN', N'zipcode'
GO
