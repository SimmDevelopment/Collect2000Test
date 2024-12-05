CREATE TABLE [dbo].[AIM_RecallReasonCode]
(
[RecallReasonCodeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AvailableForSameTier] [bit] NULL,
[ReversePlacement] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_RecallReasonCode] ADD CONSTRAINT [PK_RecallReasonCode] PRIMARY KEY CLUSTERED ([RecallReasonCodeId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_RecallReasonCode] ADD CONSTRAINT [IX_RecallReasonCode] UNIQUE NONCLUSTERED ([Code]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'AIM_RecallReasonCode', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag for whether or not we will mark the tier upon recall', 'SCHEMA', N'dbo', 'TABLE', N'AIM_RecallReasonCode', 'COLUMN', N'AvailableForSameTier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined code for this recall reason code', 'SCHEMA', N'dbo', 'TABLE', N'AIM_RecallReasonCode', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_RecallReasonCode', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_RecallReasonCode', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_RecallReasonCode', 'COLUMN', N'RecallReasonCodeId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_RecallReasonCode', 'COLUMN', N'RecallReasonCodeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag for whether the placement will still be valid upon recall', 'SCHEMA', N'dbo', 'TABLE', N'AIM_RecallReasonCode', 'COLUMN', N'ReversePlacement'
GO
