CREATE TABLE [dbo].[Services_TransUnion_CPE2_MT01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActualMessageLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentSegmentNumber] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalSegemntNumber] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThresholdNumber] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageText] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_MT01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_MT01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
