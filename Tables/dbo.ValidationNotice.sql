CREATE TABLE [dbo].[ValidationNotice]
(
[NoticeID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[LetterRequestID] [int] NULL,
[ValidationNoticeSentDate] [date] NULL,
[ValidationPeriodExpiration] [date] NULL,
[ValidationPeriodCompleted] [bit] NOT NULL,
[LastUpdated] [datetime] NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ValidationNoticeType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DebtorID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ValidationNotice] ADD CONSTRAINT [PK_ValidationNotice] PRIMARY KEY CLUSTERED ([NoticeID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ValidationNotice] ADD CONSTRAINT [FK_ValidationNotice_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number])
GO
