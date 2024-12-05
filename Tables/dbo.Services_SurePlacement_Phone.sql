CREATE TABLE [dbo].[Services_SurePlacement_Phone]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[Phone] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ListingName] [varchar] (99) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement_Phone] ADD CONSTRAINT [PK_Services_SurePlacement_Phone] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
