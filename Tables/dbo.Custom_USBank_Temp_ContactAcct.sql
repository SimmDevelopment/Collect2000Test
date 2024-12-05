CREATE TABLE [dbo].[Custom_USBank_Temp_ContactAcct]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[AgencyId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNum] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactRecType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameRelationship] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LeadContactInd] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponsibleParty] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredCurrency] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_USBank_Temp_ContactAcct] ADD CONSTRAINT [PK_Custom_USBank_Temp_ContactAcct] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
