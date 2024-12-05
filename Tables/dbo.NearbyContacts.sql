CREATE TABLE [dbo].[NearbyContacts]
(
[NearbyContactID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NOT NULL,
[Type] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LName] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MI] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Addr1] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Addr2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Zip] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoginName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequestID] [int] NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__NearbyCon__Creat__76B2067F] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NearbyContacts] ADD CONSTRAINT [pk_NearbyContacts] PRIMARY KEY CLUSTERED ([NearbyContactID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_NearbyContacts_number] ON [dbo].[NearbyContacts] ([number]) ON [PRIMARY]
GO
