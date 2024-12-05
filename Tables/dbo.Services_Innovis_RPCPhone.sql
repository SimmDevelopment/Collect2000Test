CREATE TABLE [dbo].[Services_Innovis_RPCPhone]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[ActiveCount] [int] NULL,
[TotalCount] [int] NULL,
[FirstReportedDate] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastReportedDate] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactIndex] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_Innovis_RPCPhone] ADD CONSTRAINT [PK_Services_Innovis_RPCPhone] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
