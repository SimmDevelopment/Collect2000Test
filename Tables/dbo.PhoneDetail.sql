CREATE TABLE [dbo].[PhoneDetail]
(
[TransDate] [datetime] NULL,
[Extension] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Trunk] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[number] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Duration] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DMinutes] [int] NULL,
[Dseconds] [int] NULL,
[RecordDate] [datetime] NULL,
[Dhours] [int] NULL,
[DeskName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransTime] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
