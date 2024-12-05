CREATE TABLE [dbo].[PhoneHistory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[DateChanged] [datetime] NOT NULL,
[UserChanged] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phonetype] [tinyint] NOT NULL,
[OldNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TransmittedDate] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PhoneHistory] ADD CONSTRAINT [PK_PhoneHistory] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PhoneHistory_AccountID] ON [dbo].[PhoneHistory] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PhoneHistory_DateChanged] ON [dbo].[PhoneHistory] ([DateChanged] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PhoneHistory_DebtorID] ON [dbo].[PhoneHistory] ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
