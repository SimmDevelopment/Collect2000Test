SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_MoveTFHoldingsFile] @ImportDir VARCHAR(255)
AS
BEGIN
    -- Declare the PowerShell script path
    DECLARE @scriptPath VARCHAR(255) = 'T:\WinSCP\Automation\FileMoveScripts\MoveTFHoldings2.ps1';
    
    -- Construct the full PowerShell command
    DECLARE @powershellCmd VARCHAR(1000) = 'powershell.exe -ExecutionPolicy Bypass -File ' + @scriptPath + ' -ImportDir ' + @ImportDir;
    
    -- Execute the PowerShell command
    EXEC xp_cmdshell @powershellCmd;
END
GO
