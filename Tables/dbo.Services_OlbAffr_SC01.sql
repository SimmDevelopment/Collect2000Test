CREATE TABLE [dbo].[Services_OlbAffr_SC01]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[ScoreType] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sign] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Score] [int] NULL,
[ScoringIndicatorFlag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScoringDeragatoryAlertFlag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstFactor] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondFactor] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThirdFactor] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FourthFactor] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScoreCardIndicator] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_OlbAffr_SC01] ADD CONSTRAINT [PK_Services_OlbAffr_SC01] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
