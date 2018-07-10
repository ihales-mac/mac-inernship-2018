﻿/*
Deployment script for exercise1

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "exercise1"
:setvar DefaultFilePrefix "exercise1"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Altering [dbo].[Login]...';


GO
ALTER PROCEDURE [dbo].[Login]
	@username nVARchar(50),
	@password nVARchar(50),
	@response nvarchar(20) out
AS
BEGIN
	DECLARE  @FullName nvarchar(21)
	set @FullName = (SELECT dbo.PrintName(FirstName,LastName) From [User] 
									WHERE ((Username=@username or Email=@username) and [Password]=HASHBYTES ('MD2',@password)));
	if (@FullName = NULL)
		BEGIN
			if((Select dbo.PrintName(FirstName,LastName) From [User] WHERE (Username=@username or Email=@username)) = null)
				set @response = 'INV USER'
			else
				set @response = 'INV PW' 
		END
	ELSE
		set @response = @FullName
	INSERT INTO [Log] (Response,Username) VALUES (@response,@username)
END
GO
PRINT N'Update complete.';


GO
