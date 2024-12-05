CREATE TABLE [dbo].[AIM_ContactPaperASSN]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ContactID] [int] NULL,
[PaperTypeID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_ContactPaperASSN] ADD CONSTRAINT [PK_AIM_ContactPaperASSN] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_ContactPaperASSN] ADD CONSTRAINT [FK_AIM_ContactPaperASSN_AIM_Contact] FOREIGN KEY ([ContactID]) REFERENCES [dbo].[AIM_Contact] ([ContactId])
GO
ALTER TABLE [dbo].[AIM_ContactPaperASSN] ADD CONSTRAINT [FK_AIM_ContactPaperASSN_AIM_PaperType] FOREIGN KEY ([PaperTypeID]) REFERENCES [dbo].[AIM_PaperType] ([ID])
GO
