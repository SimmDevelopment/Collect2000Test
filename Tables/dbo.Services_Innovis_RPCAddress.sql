CREATE TABLE [dbo].[Services_Innovis_RPCAddress]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[ActiveCount] [int] NULL,
[TotalCount] [int] NULL,
[FirstReportedDate] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastReportedDate] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_Innovis_RPCAddress] ADD CONSTRAINT [PK_Services_Innovis_RPCAddress] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
