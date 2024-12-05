CREATE TABLE [dbo].[Service_CPE_SC01_BU_72007]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[Sign] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Score] [int] NULL,
[ScoringIndicatorFlag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScoringDeragatoryAlertFlag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstFactor] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondFactor] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThirdFactor] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FourthFactor] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScoreCardIndicator] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScoreType] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
