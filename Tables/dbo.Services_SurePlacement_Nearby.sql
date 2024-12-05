CREATE TABLE [dbo].[Services_SurePlacement_Nearby]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[FirstName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NearbyType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NearbySeqNum] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement_Nearby] ADD CONSTRAINT [PK_Services_SurePlacement_Nearby] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
