CREATE TABLE [dbo].[AIM_RequestResponseAssn]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[ResponseID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_RequestResponseAssn] ADD CONSTRAINT [PK_AIM_RequestResponseAssn] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
