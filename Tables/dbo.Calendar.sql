CREATE TABLE [dbo].[Calendar]
(
[Date] [smalldatetime] NOT NULL,
[PostingDay] [bit] NOT NULL CONSTRAINT [DF__Calendar__Postin__7DC91862] DEFAULT ((1)),
[IsFirstDay] [bit] NOT NULL CONSTRAINT [DF__Calendar__IsFirs__7EBD3C9B] DEFAULT ((0)),
[IsLastDay] [bit] NOT NULL CONSTRAINT [DF__Calendar__IsLast__7FB160D4] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Calendar] ADD CONSTRAINT [chk_Calendar_Date] CHECK ((datepart(hour,[Date])=(0) AND datepart(minute,[Date])=(0)))
GO
ALTER TABLE [dbo].[Calendar] ADD CONSTRAINT [pk_Calendar] PRIMARY KEY CLUSTERED ([Date]) ON [PRIMARY]
GO
