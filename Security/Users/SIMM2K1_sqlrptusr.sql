IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'SIMM2K1\sqlrptusr')
CREATE LOGIN [SIMM2K1\sqlrptusr] FROM WINDOWS
GO
CREATE USER [SIMM2K1\sqlrptusr] FOR LOGIN [SIMM2K1\sqlrptusr] WITH DEFAULT_SCHEMA=[sqlrptusr]
GO
