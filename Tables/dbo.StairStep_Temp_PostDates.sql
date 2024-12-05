CREATE TABLE [dbo].[StairStep_Temp_PostDates]
(
[PlacementMonth] [datetime] NOT NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MTD Collections] [money] NOT NULL,
[MTD Fees] [money] NOT NULL,
[Post Dates] [money] NOT NULL,
[Projected Fees] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StairStep_Temp_PostDates] ADD CONSTRAINT [PK_SS_PostDates] PRIMARY KEY CLUSTERED ([PlacementMonth], [Customer]) ON [PRIMARY]
GO
