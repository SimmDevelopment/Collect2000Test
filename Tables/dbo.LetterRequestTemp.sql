CREATE TABLE [dbo].[LetterRequestTemp]
(
[AccountID] [int] NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desk] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LetterCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CopyCustomer] [bit] NULL,
[SaveImage] [bit] NULL,
[SubjDebtorID] [int] NULL,
[SenderID] [int] NULL,
[RecipientDebtorID] [int] NULL,
[RecipientDebtorSeq] [tinyint] NULL,
[UserID] [int] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary table used to retain dunning letters.  Referenced by  stored procedure  LetterRequestSQL_Execute', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestTemp', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestTemp', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set copies Customer on letter', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestTemp', 'COLUMN', N'CopyCustomer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer code assigned to the debtor account', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestTemp', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account Desk', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestTemp', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Five digit numeric letter code assigned within the Letter Console program.  Gene', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestTemp', 'COLUMN', N'LetterCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique debtor ID for the debtor on the account receiving the letter', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestTemp', 'COLUMN', N'RecipientDebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Sequence number for the debtor receiving the letter', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestTemp', 'COLUMN', N'RecipientDebtorSeq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set saves letter image to table (documentation and documentation_attachments)', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestTemp', 'COLUMN', N'SaveImage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique debtor ID for the primary debtor on the account', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestTemp', 'COLUMN', N'SubjDebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Identity ID of the User that requested the letter', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestTemp', 'COLUMN', N'UserID'
GO
