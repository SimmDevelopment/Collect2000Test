CREATE TABLE [dbo].[ztempacbLVcalls]
(
[acct] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[client_practice_id] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Livevox Result] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CallConnectTimeCT] [datetime] NULL,
[Call End Time] [datetime] NULL,
[Call Duration] [int] NULL,
[Rounded Duration] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hold Time] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Operator Duration] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Transfer Duration] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last Key Pressed] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filename] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Skill ID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
