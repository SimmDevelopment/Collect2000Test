CREATE TABLE [dbo].[ztempacbresults]
(
[Date Call Began] [datetime] NULL,
[Time Call Began] [datetime] NULL,
[Time Call Ended] [datetime] NULL,
[Duration] [int] NULL,
[Dialed_Phone_Number] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Termination Code] [varchar] (510) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Translation] [varchar] (34) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Connect Status] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Right Party] [int] NOT NULL,
[account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
