IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'SIMM2K1\zacharys')
CREATE LOGIN [SIMM2K1\zacharys] FROM WINDOWS
GO
CREATE USER [SIMM2K1\zacharys] FOR LOGIN [SIMM2K1\zacharys]
GO
