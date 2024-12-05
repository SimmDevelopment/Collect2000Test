CREATE TABLE [dbo].[LatitudeLegal_AttorneyDistribution]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AttorneyID] [int] NULL,
[StateCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Percentage] [float] NULL,
[DefaultDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultFeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultPostSuitFeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultLawList] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LatitudeLegal_AttorneyDistribution] ADD CONSTRAINT [PK_LatitudeLegal_AttorneyDistribution] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
