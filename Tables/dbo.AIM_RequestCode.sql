CREATE TABLE [dbo].[AIM_RequestCode]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultText] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desk] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QLevel] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequiresResponse] [bit] NOT NULL CONSTRAINT [DF__AIM_Reque__Requi__4A546154] DEFAULT ((0)),
[ResponseDays] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_RequestCode] ADD CONSTRAINT [PK_AIM_RequestCode] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
