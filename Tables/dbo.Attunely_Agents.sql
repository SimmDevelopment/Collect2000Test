CREATE TABLE [dbo].[Attunely_Agents]
(
[AgentKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Display] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Agents] ADD CONSTRAINT [PK_Attunely_Agents] PRIMARY KEY CLUSTERED ([AgentKey]) ON [PRIMARY]
GO
