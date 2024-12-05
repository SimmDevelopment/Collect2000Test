CREATE TABLE [dbo].[Services_SurePlacement_Flags]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NOT NULL,
[InputAddressVerified] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputPhoneVerified] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputAddressProperty] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedAddressProperty] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InputAddressIncomeEst] [int] NULL,
[UpdatedAddressIncomeEst] [int] NULL,
[MVR] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Relatives] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Associates] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PeopleAtWork] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JgtLien] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserved] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_SurePlacement_Flags] ADD CONSTRAINT [PK_Services_SurePlacement_Flags] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
