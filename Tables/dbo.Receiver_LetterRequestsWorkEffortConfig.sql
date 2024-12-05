CREATE TABLE [dbo].[Receiver_LetterRequestsWorkEffortConfig]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClientId] [int] NOT NULL,
[LetterCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActionCategory] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActionCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActionText] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_LetterRequestsWorkEffortConfig] ADD CONSTRAINT [PK_Receiver_LetterRequestsWorkEffortConfig] PRIMARY KEY NONCLUSTERED ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table contains work effort configuration related to letters for an agency', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_LetterRequestsWorkEffortConfig', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The category of the work effort', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_LetterRequestsWorkEffortConfig', 'COLUMN', N'ActionCategory'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The action code of the work effort', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_LetterRequestsWorkEffortConfig', 'COLUMN', N'ActionCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The text of the work effort', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_LetterRequestsWorkEffortConfig', 'COLUMN', N'ActionText'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity key', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_LetterRequestsWorkEffortConfig', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key from the code column of the dbo.Letter table', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_LetterRequestsWorkEffortConfig', 'COLUMN', N'LetterCode'
GO
