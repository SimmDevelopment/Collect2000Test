IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'SIMM2K1\nckenny')
CREATE LOGIN [SIMM2K1\nckenny] FROM WINDOWS
GO
CREATE USER [SIMM2K1\nckenny] FOR LOGIN [SIMM2K1\nckenny]
GO
