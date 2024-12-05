CREATE TABLE [dbo].[Services_TransUnion_CPE2_TA01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlertCondition] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfInquiriesInLast60Days] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_TA01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_TA01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO