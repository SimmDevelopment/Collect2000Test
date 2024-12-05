CREATE TABLE [dbo].[Custom_SIMM_Discover_RecallExceptions]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NULL,
[account] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[received] [datetime] NULL
) ON [PRIMARY]
GO
