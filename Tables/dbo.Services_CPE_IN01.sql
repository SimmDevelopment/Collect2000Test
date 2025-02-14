CREATE TABLE [dbo].[Services_CPE_IN01]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[IN01] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SegmentLength] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BureauMarket] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BureauSubmarket] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndustryCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MemberCode] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofInquiry] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryFirstName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryMiddleName] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryLastName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryPrefix] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquirySuffix] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryMaternalName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryHouseNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryPredirection] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryStreetName] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryPostdirection] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryStreetType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryApartmentNumber] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryCity] [varchar] (27) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryState] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryZIPCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryPhonenumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InquiryEmploymentName] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_CPE_IN01] ADD CONSTRAINT [PK_Services_CPE_IN01] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
