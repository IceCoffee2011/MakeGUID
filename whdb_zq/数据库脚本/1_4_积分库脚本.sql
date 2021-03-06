USE [master]
GO
/****** 对象:  Database [ZQGameScoreDB]    脚本日期: 12/08/2008 11:50:05 ******/
CREATE DATABASE [ZQGameScoreDB] ON  PRIMARY 
( NAME = N'ZQGameScoreDB', FILENAME = N'G:\whdb_zq\ZQGameScoreDB.mdf' , SIZE = 33280KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ZQGameScoreDB_log', FILENAME = N'G:\whdb_zq\ZQGameScoreDB_log.LDF' , SIZE = 6272KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 COLLATE Chinese_PRC_CI_AS
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ZQGameScoreDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ZQGameScoreDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ZQGameScoreDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ZQGameScoreDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ZQGameScoreDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ZQGameScoreDB] SET  READ_WRITE 
GO
ALTER DATABASE [ZQGameScoreDB] SET RECOVERY FULL 
GO
ALTER DATABASE [ZQGameScoreDB] SET  MULTI_USER 
GO
if ( ((@@microsoftversion / power(2, 24) = 8) and (@@microsoftversion & 0xffff >= 760)) or 
		(@@microsoftversion / power(2, 24) >= 9) )begin 
	exec dbo.sp_dboption @dbname =  N'ZQGameScoreDB', @optname = 'db chaining', @optvalue = 'OFF'
 end