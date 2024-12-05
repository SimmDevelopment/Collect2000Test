CREATE TABLE [dbo].[Goals_Desk]
(
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Month] [smalldatetime] NOT NULL,
[Gross] [money] NULL,
[Fee] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Goals_Desk] ADD CONSTRAINT [chk_Goals_Desk_Month] CHECK ((datepart(day,[Month])=(1) AND datepart(hour,[Month])=(0) AND datepart(minute,[Month])=(0)))
GO
ALTER TABLE [dbo].[Goals_Desk] ADD CONSTRAINT [pk_Goals_Desk] PRIMARY KEY CLUSTERED ([Desk], [Month]) ON [PRIMARY]
GO
