CREATE TABLE [dbo].[StairStep_Temp_ControlFile]
(
[CurrentMonth] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StairStep_Temp_ControlFile] ADD CONSTRAINT [PK_SS_ControlFile] PRIMARY KEY CLUSTERED ([CurrentMonth]) ON [PRIMARY]
GO
