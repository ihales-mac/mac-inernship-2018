﻿/*
Deployment script for LoginExample

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "LoginExample"
:setvar DefaultFilePrefix "LoginExample"
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
PRINT N'Altering [dbo].[Search]...';


GO
ALTER FUNCTION [dbo].[Search]
(
	@SearchTerm nvarchar(40)
)
RETURNS TABLE
AS
RETURN(
	SELECT ID, FirstName, LastName, Email, DisplayName, PhoneNumber, Address, City, Country, Permission FROM UserInfoSearch WHERE SearchString LIKE CONCAT('%',@SearchTerm,'%')
)
GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
GO

DELETE FROM [UserHasPermission]
GO
DELETE FROM [Log]
GO
DELETE FROM [User]
GO
DELETE FROM [PersonalDetails]
GO
DELETE FROM [Permission]
GO

EXEC AddUser @Email = 'andrei@gmail.com', @Password = 'andrei', @FirstName = 'Andrei', @LastName = 'Bora', @DisplayName = 'AB'
GO
EXEC AddUser @Email = 'imola@gmail.com', @Password = 'imola', @FirstName = 'Imola Katalin', @LastName = 'Deszi', @DisplayName = 'IKD'
GO
EXEC AddUser @Email = 'robert@gmail.com', @Password = 'robert', @FirstName = 'Robert', @LastName = 'Laszlo', @DisplayName = 'AL'
GO
EXEC AddUser @Email = 'andreit@gmail.com', @Password = 'andreit', @FirstName = 'Andrei', @LastName = 'Tudorica', @DisplayName = 'AT'
GO
EXEC AddUser @Email = 'matei@gmail.com', @Password = 'matei', @FirstName = 'Radu Matei', @LastName = 'Birle', @DisplayName = 'RMB'
GO

EXEC AddDetails @Email = 'andrei@gmail.com', @PhoneNumber = '0756985632', @Address = 'da', @City = 'Cluj', @Country = 'Romania'
GO
EXEC AddDetails @Email = 'imola@gmail.com', @PhoneNumber = '0789456258', @Address = 'da', @City = 'Cluj', @Country = 'Romania'
GO
EXEC AddDetails @Email = 'robert@gmail.com', @PhoneNumber = '0764582695', @Address = 'da', @City = 'Cluj', @Country = 'Romania'
GO
EXEC AddDetails @Email = 'andreit@gmail.com', @PhoneNumber = '0798652984', @Address = 'da', @City = 'Cluj', @Country = 'Romania'
GO
EXEC AddDetails @Email = 'matei@gmail.com', @PhoneNumber = '0744598625', @Address = 'da', @City = 'Cluj', @Country = 'Romania'
GO

INSERT INTO Permission (Name, Description, IsDeleted) VALUES('Administrator', 'Takes care of data', 0)
GO
INSERT INTO Permission (Name, Description, IsDeleted) VALUES('SysAdmin', 'Takes care of data and system', 0)
GO
INSERT INTO Permission (Name, Description, IsDeleted) VALUES('User', 'Takes care of nothing', 0)
GO
INSERT INTO Permission (Name, Description, IsDeleted) VALUES('Sealed', 'Can view private data', 0)
GO

EXEC [MakeAdmin] @Email = 'andrei@gmail.com'
GO
EXEC MakeSealed @Email = 'andrei@gmail.com'
GO
EXEC MakeSysAdmin @Email = 'imola@gmail.com'
GO
EXEC MakeUser @Email = 'robert@gmail.com'
GO
EXEC MakeAdmin @Email = 'matei@gmail.com'
GO
EXEC MakeUser @Email = 'andreit@gmail.com'
GO

GO
PRINT N'Update complete.';


GO
