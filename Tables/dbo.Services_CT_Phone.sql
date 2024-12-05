CREATE TABLE [dbo].[Services_CT_Phone]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[SegmentIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ToFileDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[Filler01] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_CT_Phone] ADD CONSTRAINT [PK_Services_CT_Phone] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
