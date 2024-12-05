CREATE TABLE [dbo].[LawLists]
(
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[YouGotClaimsID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__LawLists__YouGot__0AE9454C] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LawLists] ADD CONSTRAINT [PK__LawLists__3AC340F7] PRIMARY KEY NONCLUSTERED ([Code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table retains defined Attorney law lists', 'SCHEMA', N'dbo', 'TABLE', N'LawLists', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined Unique Law List code', 'SCHEMA', N'dbo', 'TABLE', N'LawLists', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of Law list', 'SCHEMA', N'dbo', 'TABLE', N'LawLists', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'YouGotClaims ID of the Law list', 'SCHEMA', N'dbo', 'TABLE', N'LawLists', 'COLUMN', N'YouGotClaimsID'
GO
