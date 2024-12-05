IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'SIMM2K1\simmauto')
CREATE LOGIN [SIMM2K1\simmauto] FROM WINDOWS
GO
CREATE USER [SIMM2K1\simmauto] FOR LOGIN [SIMM2K1\simmauto]
GO
