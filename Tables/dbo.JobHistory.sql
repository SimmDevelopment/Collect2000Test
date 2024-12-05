CREATE TABLE [dbo].[JobHistory]
(
[Number] [int] NOT NULL IDENTITY(1, 1),
[JobNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecutedOn] [datetime] NULL,
[ExecutedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobData] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
