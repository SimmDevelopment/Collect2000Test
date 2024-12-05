SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_RunPowerShellScript]
AS
BEGIN
    -- Suppress count messages
    SET NOCOUNT ON;

    DECLARE @powershellScriptPath NVARCHAR(255);
    DECLARE @cmd NVARCHAR(4000);

    SET @powershellScriptPath = 'T:\WinSCP\Automation\FileMoveScripts\MoveTFHoldings1.ps1';
    SET @cmd = N'powershell.exe -ExecutionPolicy Bypass -File ' + @powershellScriptPath;

    -- Execute the PowerShell script
    EXEC xp_cmdshell @cmd;
END
GO
