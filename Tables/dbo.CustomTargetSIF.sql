CREATE TABLE [dbo].[CustomTargetSIF]
(
[account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[createddate] [datetime] NOT NULL,
[reported] [bit] NOT NULL CONSTRAINT [DF_CustomTargetSIFPIF_reported] DEFAULT (0)
) ON [PRIMARY]
GO
