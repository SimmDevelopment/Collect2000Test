CREATE TABLE [dbo].[AIM_AccountReference]
(
[AccountReferenceId] [int] NOT NULL IDENTITY(1, 1),
[ReferenceNumber] [int] NULL,
[IsPlaced] [bit] NULL,
[LastPlacementDate] [datetime] NULL,
[LastRecallDate] [datetime] NULL,
[ExpectedPendingRecallDate] [datetime] NULL,
[ExpectedFinalRecallDate] [datetime] NULL,
[NumDaysPlacedBeforePending] [int] NULL,
[NumDaysPlacedAfterPending] [int] NULL,
[CurrentlyPlacedAgencyId] [int] NULL,
[CurrentCommissionPercentage] [float] NULL,
[Tier1] [int] NULL,
[Tier2] [int] NULL,
[Tier3] [int] NULL,
[Tier1PlacementDate] [datetime] NULL,
[Tier1RecallDate] [datetime] NULL,
[Tier2PlacementDate] [datetime] NULL,
[Tier2RecallDate] [datetime] NULL,
[Tier3PlacementDate] [datetime] NULL,
[Tier3RecallDate] [datetime] NULL,
[Tier4] [int] NULL,
[Tier4PlacementDate] [datetime] NULL,
[Tier4RecallDate] [datetime] NULL,
[Tier5] [int] NULL,
[Tier5PlacementDate] [datetime] NULL,
[Tier5RecallDate] [datetime] NULL,
[Tier6] [int] NULL,
[Tier6PlacementDate] [datetime] NULL,
[Tier6RecallDate] [datetime] NULL,
[Tier7] [int] NULL,
[Tier7PlacementDate] [datetime] NULL,
[Tier7RecallDate] [datetime] NULL,
[Tier8] [int] NULL,
[Tier8PlacementDate] [datetime] NULL,
[Tier8RecallDate] [datetime] NULL,
[Tier9] [int] NULL,
[Tier9PlacementDate] [datetime] NULL,
[Tier9RecallDate] [datetime] NULL,
[Tier10] [int] NULL,
[Tier10PlacementDate] [datetime] NULL,
[Tier10RecallDate] [datetime] NULL,
[Tier11] [int] NULL,
[Tier11PlacementDate] [datetime] NULL,
[Tier11RecallDate] [datetime] NULL,
[Tier12] [int] NULL,
[Tier12PlacementDate] [datetime] NULL,
[Tier12RecallDate] [datetime] NULL,
[Tier13] [int] NULL,
[Tier13PlacementDate] [datetime] NULL,
[Tier13RecallDate] [datetime] NULL,
[Tier14] [int] NULL,
[Tier14PlacementDate] [datetime] NULL,
[Tier14RecallDate] [datetime] NULL,
[Tier15] [int] NULL,
[Tier15PlacementDate] [datetime] NULL,
[Tier15RecallDate] [datetime] NULL,
[ObjectionFlag] [bit] NULL,
[FeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastTier] [int] NULL CONSTRAINT [DF__AIM_Accou__LastT__028DCD7F] DEFAULT ((0)),
[AgencyAcknowledgement] [bit] NULL CONSTRAINT [DF__AIM_Accou__Agenc__0381F1B8] DEFAULT ((0)),
[AcknowledgementError] [bit] NULL CONSTRAINT [DF__AIM_Accou__Ackno__047615F1] DEFAULT ((0)),
[RecallDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_AccountReference] ADD CONSTRAINT [PK_AccountReference] PRIMARY KEY CLUSTERED ([AccountReferenceId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AIM_AccountReference_CurrentlyPlaced] ON [dbo].[AIM_AccountReference] ([CurrentlyPlacedAgencyId], [IsPlaced]) INCLUDE ([ExpectedFinalRecallDate], [ExpectedPendingRecallDate], [LastPlacementDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AIM_AccountReference_ReferenceNumber] ON [dbo].[AIM_AccountReference] ([ReferenceNumber]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_AccountReference] ADD CONSTRAINT [AIM_FK_AccountReference_Agency] FOREIGN KEY ([CurrentlyPlacedAgencyId]) REFERENCES [dbo].[AIM_Agency] ([AgencyId]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'AccountReferenceId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Commission percentage for account ', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'CurrentCommissionPercentage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency ID where account is currently placed', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'CurrentlyPlacedAgencyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next time for a final recall to go', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'ExpectedFinalRecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next time for a pending recall to go', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'ExpectedPendingRecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag True if account is placed', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'IsPlaced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last time an account was placed', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'LastPlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last time an account was recalled', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'LastRecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time period (days) after placement prior to final recall', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'NumDaysPlacedAfterPending'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time period (days) after placement prior to pending recall', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'NumDaysPlacedBeforePending'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag True if agency objected to the pending recall', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'ObjectionFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The latitude file number = [Master].[number]', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'ReferenceNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier10PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier10RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier11'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier11PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier11RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier12'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier12PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier12RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier13'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier13PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier13RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier14'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier14PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier14RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier15'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier15PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier15RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier1PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier1RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier2PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier2RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier3PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier3RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier4PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier4RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier5PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier5RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier6PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier6RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier7PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier7RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier8PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier8RecallDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers placement date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier9PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This tiers recalled date', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountReference', 'COLUMN', N'Tier9RecallDate'
GO
