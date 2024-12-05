CREATE TABLE [dbo].[ServiceHistory_RESPONSES]
(
[ResponseID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[FileName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateReturned] [datetime] NOT NULL,
[DateProcessed] [datetime] NULL,
[XmlInfoReturned] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceHistory_RESPONSES] ADD CONSTRAINT [PK_ServiceHistory_RESPONSES] PRIMARY KEY CLUSTERED ([ResponseID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServiceHistory_RESPONSES_RequestID] ON [dbo].[ServiceHistory_RESPONSES] ([RequestID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceHistory_RESPONSES] WITH NOCHECK ADD CONSTRAINT [FK_ServiceHistory_RESPONSES_ServiceHistory] FOREIGN KEY ([RequestID]) REFERENCES [dbo].[ServiceHistory] ([RequestID]) ON DELETE CASCADE ON UPDATE CASCADE NOT FOR REPLICATION
GO
