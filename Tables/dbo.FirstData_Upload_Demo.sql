CREATE TABLE [dbo].[FirstData_Upload_Demo]
(
[Number] [int] NOT NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorSEQ] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateChanged] [datetime] NOT NULL,
[DebtorName] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ZipCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PType] [smallint] NOT NULL,
[CID] [int] NOT NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FirstData_Upload_Demo] ADD CONSTRAINT [PK_FirstData_Upload_Demo] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
