CREATE TABLE [dbo].[Services_Telewire_TNT]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NULL,
[ClientCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_Telewire_TNT] ADD CONSTRAINT [PK_Services_Telewire] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
