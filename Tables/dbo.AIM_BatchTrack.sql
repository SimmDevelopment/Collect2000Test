CREATE TABLE [dbo].[AIM_BatchTrack]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[Months] [smallint] NULL,
[Percentages] [bit] NOT NULL CONSTRAINT [DF__AIM_Batch__Perce__5F648CD3] DEFAULT ((0)),
[CumulativeTotals] [bit] NOT NULL CONSTRAINT [DF__AIM_Batch__Cumul__6058B10C] DEFAULT ((0)),
[Summaries] [bit] NOT NULL CONSTRAINT [DF__AIM_Batch__Summa__614CD545] DEFAULT ((0)),
[CardView] [bit] NOT NULL CONSTRAINT [DF__AIM_Batch__CardV__6240F97E] DEFAULT ((0)),
[Aggregation] [tinyint] NOT NULL CONSTRAINT [DF__AIM_Batch__Aggre__63351DB7] DEFAULT ((0)),
[GroupPortfolio] [bit] NOT NULL CONSTRAINT [DF__AIM_Batch__Group__642941F0] DEFAULT ((0)),
[GroupAgency] [bit] NOT NULL CONSTRAINT [DF__AIM_Batch__Group__651D6629] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_BatchTrack] ADD CONSTRAINT [PK_BatchTrack] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_BatchTrack] ADD CONSTRAINT [UNQ_BatchTrackName] UNIQUE NONCLUSTERED ([Name]) ON [PRIMARY]
GO
