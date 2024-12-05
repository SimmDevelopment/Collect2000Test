CREATE TABLE [dbo].[Services_CT_EmployerAddress]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street3] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstReportedDate] [datetime] NULL,
[LastReportedDate] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginationCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_CT_EmployerAddress] ADD CONSTRAINT [PK_Services_CT_EmployerAddress] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
