CREATE TABLE [dbo].[FeeScheduleDetails]
(
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Seq] [tinyint] NOT NULL,
[LowLimit] [real] NULL,
[HighLimit] [real] NULL,
[Fee1] [real] NULL,
[Fee2] [real] NULL,
[Fee3] [real] NULL,
[Fee4] [real] NULL,
[Fee5] [real] NULL,
[Fee6] [real] NULL,
[Fee7] [real] NULL,
[Fee8] [real] NULL,
[Fee9] [real] NULL,
[Fee10] [real] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FeeScheduleDetails] ADD CONSTRAINT [PK_FeeScheduleDetails] PRIMARY KEY NONCLUSTERED ([Code], [Seq]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Details and thresholds for respective feescheule', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fee schedule code', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rate percentage for bucket', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Fee1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rate percentage for bucket', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Fee10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rate percentage for bucket', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Fee2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rate percentage for bucket', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Fee3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rate percentage for bucket', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Fee4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rate percentage for bucket', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Fee5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rate percentage for bucket', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Fee6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rate percentage for bucket', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Fee7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rate percentage for bucket', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Fee8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rate percentage for bucket', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Fee9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Age Based ending day range.  Liquidation based ending  percentage range.  Balance based ending balance range.', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'HighLimit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Age Based beginning day range.  Liquidation based beginning  percentage range.  Balance based beginning balance range.', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'LowLimit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence number of detail record', 'SCHEMA', N'dbo', 'TABLE', N'FeeScheduleDetails', 'COLUMN', N'Seq'
GO
