CREATE TABLE [dbo].[LionStatus]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StatusCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewStatus] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewDescription] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionStatus] ADD CONSTRAINT [PK_LionStatus] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionStatus] ADD CONSTRAINT [FK_LionStatus_status] FOREIGN KEY ([StatusCode]) REFERENCES [dbo].[status] ([code])
GO
