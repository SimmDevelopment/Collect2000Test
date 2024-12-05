IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'SIMM2K1\divinity')
CREATE LOGIN [SIMM2K1\divinity] FROM WINDOWS
GO
CREATE USER [SIMM2K1\divinity] FOR LOGIN [SIMM2K1\divinity]
GO
