CREATE TABLE [dbo].[AIM_ContactStateASSN]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ContactID] [int] NULL,
[StateCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_ContactStateASSN] ADD CONSTRAINT [PK_AIM_ContactStateASSN] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_ContactStateASSN] ADD CONSTRAINT [FK_AIM_ContactStateASSN_AIM_Contact] FOREIGN KEY ([ContactID]) REFERENCES [dbo].[AIM_Contact] ([ContactId])
GO
