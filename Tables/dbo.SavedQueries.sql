CREATE TABLE [dbo].[SavedQueries]
(
[ID] [bigint] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__SavedQuer__Creat__2F90BA16] DEFAULT (getdate()),
[Distinct] [bit] NOT NULL CONSTRAINT [DF__SavedQuer__Disti__3084DE4F] DEFAULT (0),
[TopRows] [int] NOT NULL CONSTRAINT [DF__SavedQuer__TopRo__31790288] DEFAULT (0),
[Columns] [image] NULL,
[Conditions] [image] NOT NULL,
[Order] [image] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SavedQueries] ADD CONSTRAINT [PK__SavedQueries__2CB44D6B] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
