CREATE TABLE [dbo].[AIM_Acknowledgment]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AgencyID] [int] NOT NULL CONSTRAINT [DF__AIM_Ackno__Agenc__3CC55C0C] DEFAULT ((0)),
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
ALTER TABLE [dbo].[AIM_Acknowledgment] ADD CONSTRAINT [PK_AIM_Acknowledgment] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AIM_Acknowledgment_ALL] ON [dbo].[AIM_Acknowledgment] ([AgencyID], [BatchFileHistoryID], [LatitudeAgencyID], [LatitudeNumber], [Number]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used by AIM to bulk load data from an AACK file.  Acknowledgment reports and updates to AIM_AccountReference are generated from the Data.  ', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Acknowledgment', NULL, NULL
GO
