CREATE TABLE [dbo].[notice]
(
[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssn] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[collateral] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[agent] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[agentinfo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[number] [int] NULL,
[to_] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[from_] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Notice1] ON [dbo].[notice] ([zipcode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
