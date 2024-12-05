CREATE TABLE [dbo].[Custom_USBank_CACS_Contact_Email_History]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AgencyID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNumber] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactID] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactRecType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalKey] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NickName] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddr] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailType] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAvailibility] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredEmailIND] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number] [int] NULL,
[Debtorid] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_USBank_CACS_Contact_Email_History] ADD CONSTRAINT [PK_Custom_USBank_CACS_Contact_Email_History] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
