CREATE TABLE [dbo].[Services_CT_Person]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[RecordType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Surname] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondSurname] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GenerationCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseNumber] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetDir] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_CT_Person] ADD CONSTRAINT [PK_Services_CT_Person] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
