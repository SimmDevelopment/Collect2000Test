CREATE TABLE [dbo].[Services_TransUnion_CPE2_CP01]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[SegmentType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InformationType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberSourceName] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountDocketNumber] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RemarksPublicRecordTypeCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WordingOfTheRemarksOrPublicRecordTypeCode] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_TransUnion_CPE2_CP01] ADD CONSTRAINT [PK_Services_TransUnion_CPE2_CP01] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
