CREATE TABLE [dbo].[AIM_StairStep]
(
[StairStepId] [int] NOT NULL IDENTITY(1, 1),
[BatchFileHistoryId] [int] NULL,
[AgencyId] [int] NULL,
[TotalNumberPlaced] [int] NULL,
[TotalDollarsPlaced] [money] NULL,
[Adjustments] [money] NULL,
[TotalFees] [money] NULL,
[DatePlaced] [datetime] NULL,
[Month1] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__4273486A] DEFAULT ((0)),
[Month2] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__43676CA3] DEFAULT ((0)),
[Month3] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__445B90DC] DEFAULT ((0)),
[Month4] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__454FB515] DEFAULT ((0)),
[Month5] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__4643D94E] DEFAULT ((0)),
[Month6] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__4737FD87] DEFAULT ((0)),
[Month7] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__482C21C0] DEFAULT ((0)),
[Month8] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__492045F9] DEFAULT ((0)),
[Month9] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__4A146A32] DEFAULT ((0)),
[Month10] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__4B088E6B] DEFAULT ((0)),
[Month11] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__4BFCB2A4] DEFAULT ((0)),
[Month12] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__4CF0D6DD] DEFAULT ((0)),
[Month13] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__4DE4FB16] DEFAULT ((0)),
[Month14] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__4ED91F4F] DEFAULT ((0)),
[Month15] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__4FCD4388] DEFAULT ((0)),
[Month16] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__50C167C1] DEFAULT ((0)),
[Month17] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__51B58BFA] DEFAULT ((0)),
[Month18] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__52A9B033] DEFAULT ((0)),
[Month19] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__539DD46C] DEFAULT ((0)),
[Month20] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__5491F8A5] DEFAULT ((0)),
[Month21] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__55861CDE] DEFAULT ((0)),
[Month22] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__567A4117] DEFAULT ((0)),
[Month23] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__576E6550] DEFAULT ((0)),
[Month24] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__58628989] DEFAULT ((0)),
[Month99] [money] NULL CONSTRAINT [DF__AIM_Stair__Month__5956ADC2] DEFAULT ((0)),
[TotalCollected] [money] NULL,
[PlacementSysMonth] [int] NULL,
[PlacementSysYear] [int] NULL,
[Customer] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchID] [int] NULL,
[TotalEquipmentNumberPlaced] [int] NULL CONSTRAINT [DF__AIM_StairStep__TotalEquipmentNumberPlaced] DEFAULT ((0)),
[TotalEquipmentDollarsPlaced] [money] NULL CONSTRAINT [DF__AIM_StairStep__TotalEquipmentDollarsPlaced] DEFAULT ((0)),
[EquipmentMonth1] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth1] DEFAULT ((0)),
[EquipmentMonth2] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth2] DEFAULT ((0)),
[EquipmentMonth3] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth3] DEFAULT ((0)),
[EquipmentMonth4] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth4] DEFAULT ((0)),
[EquipmentMonth5] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth5] DEFAULT ((0)),
[EquipmentMonth6] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth6] DEFAULT ((0)),
[EquipmentMonth7] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth7] DEFAULT ((0)),
[EquipmentMonth8] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth8] DEFAULT ((0)),
[EquipmentMonth9] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth9] DEFAULT ((0)),
[EquipmentMonth10] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth10] DEFAULT ((0)),
[EquipmentMonth11] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth11] DEFAULT ((0)),
[EquipmentMonth12] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth12] DEFAULT ((0)),
[EquipmentMonth13] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth13] DEFAULT ((0)),
[EquipmentMonth14] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth14] DEFAULT ((0)),
[EquipmentMonth15] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth15] DEFAULT ((0)),
[EquipmentMonth16] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth16] DEFAULT ((0)),
[EquipmentMonth17] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth17] DEFAULT ((0)),
[EquipmentMonth18] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth18] DEFAULT ((0)),
[EquipmentMonth19] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth19] DEFAULT ((0)),
[EquipmentMonth20] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth20] DEFAULT ((0)),
[EquipmentMonth21] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth21] DEFAULT ((0)),
[EquipmentMonth22] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth22] DEFAULT ((0)),
[EquipmentMonth23] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth23] DEFAULT ((0)),
[EquipmentMonth24] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth24] DEFAULT ((0)),
[EquipmentMonth99] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentMonth99] DEFAULT ((0)),
[EquipmentTotalCollected] [money] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentTotalCollected] DEFAULT ((0)),
[EquipmentCountMonth1] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth1] DEFAULT ((0)),
[EquipmentCountMonth2] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth2] DEFAULT ((0)),
[EquipmentCountMonth3] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth3] DEFAULT ((0)),
[EquipmentCountMonth4] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth4] DEFAULT ((0)),
[EquipmentCountMonth5] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth5] DEFAULT ((0)),
[EquipmentCountMonth6] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth6] DEFAULT ((0)),
[EquipmentCountMonth7] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth7] DEFAULT ((0)),
[EquipmentCountMonth8] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth8] DEFAULT ((0)),
[EquipmentCountMonth9] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth9] DEFAULT ((0)),
[EquipmentCountMonth10] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth10] DEFAULT ((0)),
[EquipmentCountMonth11] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth11] DEFAULT ((0)),
[EquipmentCountMonth12] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth12] DEFAULT ((0)),
[EquipmentCountMonth13] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth13] DEFAULT ((0)),
[EquipmentCountMonth14] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth14] DEFAULT ((0)),
[EquipmentCountMonth15] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth15] DEFAULT ((0)),
[EquipmentCountMonth16] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth16] DEFAULT ((0)),
[EquipmentCountMonth17] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth17] DEFAULT ((0)),
[EquipmentCountMonth18] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth18] DEFAULT ((0)),
[EquipmentCountMonth19] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth19] DEFAULT ((0)),
[EquipmentCountMonth20] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth20] DEFAULT ((0)),
[EquipmentCountMonth21] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth21] DEFAULT ((0)),
[EquipmentCountMonth22] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth22] DEFAULT ((0)),
[EquipmentCountMonth23] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth23] DEFAULT ((0)),
[EquipmentCountMonth24] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth24] DEFAULT ((0)),
[EquipmentCountMonth99] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountMonth99] DEFAULT ((0)),
[EquipmentCountTotalCollected] [int] NULL CONSTRAINT [DF__AIM_StairStep__EquipmentCountTotalCollected] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_StairStep] ADD CONSTRAINT [PK_AIM_StairStep] PRIMARY KEY CLUSTERED ([StairStepId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'total of dollars adjusted', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Adjustments'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the agency associated with this stairstep record', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'AgencyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the batch file history id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'BatchFileHistoryId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date the placement was made', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'DatePlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month11'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month12'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month13'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month14'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month15'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month16'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month17'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month18'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month19'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month20'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month21'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month22'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month23'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month24'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month''s collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'Month99'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude system month placed', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'PlacementSysMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude system year placed', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'PlacementSysYear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'StairStepId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total of all collections', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'TotalCollected'
GO
EXEC sp_addextendedproperty N'MS_Description', N'total balance of accounts placed', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'TotalDollarsPlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'total of fees collected', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'TotalFees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'total number of accounts placed', 'SCHEMA', N'dbo', 'TABLE', N'AIM_StairStep', 'COLUMN', N'TotalNumberPlaced'
GO
