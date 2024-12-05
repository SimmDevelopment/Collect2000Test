CREATE TABLE [dbo].[Custom_SMSTextStop]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[phonenumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StopDate] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_SMSTextStop] ADD CONSTRAINT [PK_Custom_SMSTextStop] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
