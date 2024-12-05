IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'SIMM2K1\simmsvradmin')
CREATE LOGIN [SIMM2K1\simmsvradmin] FROM WINDOWS
GO
CREATE USER [simmsvradmin] FOR LOGIN [SIMM2K1\simmsvradmin] WITH DEFAULT_SCHEMA=[simmsvradmin]
GO
