CREATE TABLE [dbo].[AIM_Reconciliation]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AgencyID] [int] NOT NULL CONSTRAINT [DF__AIM_Recon__Agenc__38F4CB28] DEFAULT ((0)),
[BatchFileHistoryID] [int] NOT NULL,
[LatitudeAgencyID] [int] NULL,
[LatitudeNumber] [int] NULL,
[LatitudeBalance] [money] NULL,
[LatitudeAccount] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number] [int] NULL,
[Account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Reconciliation] ADD CONSTRAINT [PK_AIM_Reconciliation] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AIM_Reconciliation_ALL] ON [dbo].[AIM_Reconciliation] ([AgencyID], [BatchFileHistoryID], [LatitudeAgencyID], [LatitudeNumber], [Number]) ON [PRIMARY]
GO
