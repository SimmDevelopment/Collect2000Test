CREATE TABLE [dbo].[CustomCustGroupLetter]
(
[CustomCustGroupLetterID] [int] NOT NULL IDENTITY(1, 1),
[CustomCustGroupID] [int] NOT NULL,
[LetterID] [int] NOT NULL,
[LetterCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CopyCustomer] [bit] NOT NULL CONSTRAINT [DF_CustomCustGroupLetter_CopyCustomer] DEFAULT (0),
[SaveImage] [bit] NOT NULL CONSTRAINT [DF_CustomCustGroupLetter_SaveImage] DEFAULT (0),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_CustomCustGroupLetters_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_CustomCustGroupLetters_DateUpdated] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomCustGroupLetter] ADD CONSTRAINT [PK_CustomCustGroupLetter] PRIMARY KEY CLUSTERED ([CustomCustGroupLetterID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomCustGroupLetter] ADD CONSTRAINT [FK_CustomCustGroupLetter_CustomCustGroups] FOREIGN KEY ([CustomCustGroupID]) REFERENCES [dbo].[CustomCustGroups] ([ID])
GO
ALTER TABLE [dbo].[CustomCustGroupLetter] ADD CONSTRAINT [FK_CustomCustGroupLetter_letter] FOREIGN KEY ([LetterID]) REFERENCES [dbo].[letter] ([LetterID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom groups may be created for letters in order to apply the same letter allowances to every customer within the group.', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLetter', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator to copy Customer on letter', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLetter', 'COLUMN', N'CopyCustomer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of Parent CustomCustGroup', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLetter', 'COLUMN', N'CustomCustGroupID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLetter', 'COLUMN', N'CustomCustGroupLetterID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp created', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLetter', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLetter', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'5 digit letter code of letter to be assigned', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLetter', 'COLUMN', N'LetterCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of Letter to be assigned', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLetter', 'COLUMN', N'LetterID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator to save letter Image', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLetter', 'COLUMN', N'SaveImage'
GO
