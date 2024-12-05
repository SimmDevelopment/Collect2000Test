CREATE TABLE [dbo].[Custom_Propensio_Portfolio_Log]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DateEntered] [datetime] NULL CONSTRAINT [DF__Custom_Pr__DateE__64BF0A24] DEFAULT (getdate()),
[StoredProcedure] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Username] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IPAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OldStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OldStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OldCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OldState] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OldZip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OldEmailAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumberNormalized] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumberFormatted] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusMessage] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Propensio_Portfolio_Log] ADD CONSTRAINT [PK__Custom_P__3214EC27B32F100A] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
