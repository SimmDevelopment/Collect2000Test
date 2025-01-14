CREATE TABLE [dbo].[Teams]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DepartmentID] [int] NOT NULL,
[SupervisorID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Teams] ADD CONSTRAINT [PK__Teams__1413882A] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Teams] ADD CONSTRAINT [UQ__Teams__1507AC63] UNIQUE NONCLUSTERED ([Name]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Teams] ADD CONSTRAINT [FK__Teams__Departmen__15FBD09C] FOREIGN KEY ([DepartmentID]) REFERENCES [dbo].[Departments] ([ID])
GO
ALTER TABLE [dbo].[Teams] ADD CONSTRAINT [FK__Teams__Superviso__16EFF4D5] FOREIGN KEY ([SupervisorID]) REFERENCES [dbo].[Users] ([ID])
GO
