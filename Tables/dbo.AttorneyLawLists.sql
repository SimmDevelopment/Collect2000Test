CREATE TABLE [dbo].[AttorneyLawLists]
(
[AttorneyID] [int] NOT NULL,
[LawList] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AttorneyLawLists] ADD CONSTRAINT [pk_AttorneyLawLists] PRIMARY KEY NONCLUSTERED ([AttorneyID], [LawList]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AttorneyLawLists] ADD CONSTRAINT [fk_AttorneyLawLists_Attorney] FOREIGN KEY ([AttorneyID]) REFERENCES [dbo].[attorney] ([AttorneyId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AttorneyLawLists] ADD CONSTRAINT [fk_AttorneyLawLists_LawLists] FOREIGN KEY ([LawList]) REFERENCES [dbo].[LawLists] ([Code]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used to associate Attorneys with Attorney Law Lists', 'SCHEMA', N'dbo', 'TABLE', N'AttorneyLawLists', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Attorney Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'AttorneyLawLists', 'COLUMN', N'AttorneyID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LawList code', 'SCHEMA', N'dbo', 'TABLE', N'AttorneyLawLists', 'COLUMN', N'LawList'
GO
