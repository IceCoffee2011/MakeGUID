
----------------------------------------------------------------------------------------------------

USE WHServerInfoDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetBbsPop]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetBbsPop]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ��������
CREATE PROC GSP_GR_GetBbsPop
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	-- �������: Details,Action,����������������б��������3��IDֵ
	SELECT TOP 1 Details,Action,(SELECT COUNT(*) FROM GameBBS WHERE IsValid=1 AND Type = 2) AS ScrollCount,
	(SELECT COUNT(*) FROM GameBBS WHERE IsValid=1 AND Type = 3) AS ListCount,
	(SELECT Top 1 ID FROM GameBBS WHERE IsValid=1 AND Type = 3 ORDER BY Date DESC) AS List1,
	(SELECT Top 1 ID FROM GameBBS WHERE IsValid=1 AND Type = 3 AND ID NOT IN(SELECT Top 1 ID FROM GameBBS WHERE IsValid=1 AND Type = 3 ORDER BY Date DESC)ORDER BY Date DESC) AS List2,
	(SELECT Top 1 ID FROM GameBBS WHERE IsValid=1 AND Type = 3 AND ID NOT IN(SELECT Top 2 ID FROM GameBBS WHERE IsValid=1 AND Type = 3 ORDER BY Date DESC)ORDER BY Date DESC) AS List3
	FROM GameBBS WHERE IsValid=1 AND Type = 1 ORDER BY Date DESC
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHServerInfoDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetBbsScroll]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetBbsScroll]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ��������
CREATE PROC GSP_GR_GetBbsScroll
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	-- �������
	SELECT TOP 10 Title FROM GameBBS WHERE IsValid=1 AND Type = 2 ORDER BY Date DESC
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHServerInfoDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetBbsList]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetBbsList]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ�б���
CREATE PROC GSP_GR_GetBbsList
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	-- �������
	SELECT TOP 3 ID,Title,Details,Action,CONVERT(varchar(11),Date,120)AS D FROM GameBBS WHERE IsValid=1 AND Type = 3 ORDER BY Date DESC
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHServerInfoDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetBbsPop_V2]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetBbsPop_V2]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ��������
CREATE PROC GSP_GR_GetBbsPop_V2
	@szChannelName	NVARCHAR(32)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @ClientName AS NVARCHAR(32)

-- ִ���߼�
BEGIN
	IF LEN(@szChannelName) = 0 OR @szChannelName IS NULL
	BEGIN
		--Ĭ��ֵ
		SET @ClientName = N'%'
	END
	ELSE
	BEGIN
		SET @ClientName =  substring(@szChannelName, 1, 2) + N'%'
	END

	-- �������: Details,Action,����������������б��������3��IDֵ
	SELECT TOP 1 Details,Action,(SELECT COUNT(*) FROM GameBBS WHERE IsValid=1 AND Type = 2 AND ClientName LIKE @ClientName) AS ScrollCount,
	(SELECT COUNT(*) FROM GameBBS WHERE IsValid=1 AND Type = 3 AND ClientName LIKE @ClientName) AS ListCount,
	(SELECT Top 1 ID FROM GameBBS WHERE IsValid=1 AND Type = 3 AND ClientName LIKE @ClientName ORDER BY Date DESC) AS List1,
	(SELECT Top 1 ID FROM GameBBS WHERE IsValid=1 AND Type = 3 AND ClientName LIKE @ClientName AND ID NOT IN(SELECT Top 1 ID FROM GameBBS WHERE IsValid=1 AND Type = 3 AND ClientName LIKE @ClientName ORDER BY Date DESC)ORDER BY Date DESC) AS List2,
	(SELECT Top 1 ID FROM GameBBS WHERE IsValid=1 AND Type = 3 AND ClientName LIKE @ClientName AND ID NOT IN(SELECT Top 2 ID FROM GameBBS WHERE IsValid=1 AND Type = 3 AND ClientName LIKE @ClientName ORDER BY Date DESC)ORDER BY Date DESC) AS List3
	FROM GameBBS WHERE IsValid=1 AND Type = 1 AND ClientName LIKE @ClientName ORDER BY Date DESC
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHServerInfoDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetBbsScroll_V2]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetBbsScroll_V2]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ��������
CREATE PROC GSP_GR_GetBbsScroll_V2
	@szChannelName	NVARCHAR(32)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @ClientName AS NVARCHAR(32)

-- ִ���߼�
BEGIN
	IF LEN(@szChannelName) = 0 OR @szChannelName IS NULL
	BEGIN
		--Ĭ��ֵ
		SET @ClientName = N'%'
	END
	ELSE
	BEGIN
		SET @ClientName =  substring(@szChannelName, 1, 2) + N'%'
	END

	-- �������
	SELECT TOP 10 Title FROM GameBBS WHERE IsValid=1 AND Type = 2 AND ClientName LIKE @ClientName ORDER BY Date DESC
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHServerInfoDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetBbsList_V2]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetBbsList_V2]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ�б���
CREATE PROC GSP_GR_GetBbsList_V2
	@szChannelName	NVARCHAR(32)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @ClientName AS NVARCHAR(32)

-- ִ���߼�
BEGIN
	IF LEN(@szChannelName) = 0 OR @szChannelName IS NULL
	BEGIN
		--Ĭ��ֵ
		SET @ClientName = N'%'
	END
	ELSE
	BEGIN
		SET @ClientName =  substring(@szChannelName, 1, 2) + N'%'
	END

	-- �������
	SELECT TOP 3 ID,Title,Details,Action,CONVERT(varchar(11),Date,120)AS D FROM GameBBS WHERE IsValid=1 AND Type = 3 AND ClientName LIKE @ClientName ORDER BY Date DESC
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHServerInfoDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetKeFu]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetKeFu]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ�û�����
CREATE PROC GSP_GR_GetKeFu
	@dwUserID INT,
	@nPage INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @TheFirst INT
DECLARE @TheSQL	NVARCHAR(256)

-- ִ���߼�
BEGIN
	-- ÿҳ��
	set @TheFirst = 6*@nPage
	set @TheSQL=N'SELECT TOP 6 *,CONVERT(varchar,Date,102)AS D,(select count(*) from GameKeFu WHERE UserID='
				+convert(varchar(10),@dwUserID)
				+N')AS T FROM GameKeFu WHERE UserID='
				+convert(varchar(10),@dwUserID)
				+N' AND(ID NOT IN(SELECT TOP '
				+convert(varchar(10),@theFirst)
				+N' ID FROM GameKeFu WHERE UserID='
				+convert(varchar(10),@dwUserID)
				+N' ORDER BY ID DESC))ORDER BY ID DESC'

	exec sp_executesql @TheSQL; 
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHServerInfoDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_CommitKeFu]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_CommitKeFu]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �ύ�û�����
CREATE PROC GSP_GR_CommitKeFu
	@dwUserID	INT,
	@Question	NVARCHAR(512),
	@AttachPath	NVARCHAR(127)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @ChannelName AS NVARCHAR(32)

-- ִ���߼�
BEGIN
	--�����û���ѯChannel
	SELECT @ChannelName=UnderWrite FROM WHGameUserDB.dbo.AccountsInfo WHERE UserID=@dwUserID
	IF @ChannelName IS NULL
	BEGIN
		SET @ChannelName = N''
	END
	INSERT INTO GameKeFu(UserID, Question, AttachPath, ChannelName) VALUES(@dwUserID, @Question, LTRIM(RTRIM(@AttachPath)), @ChannelName)
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHServerInfoDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_CommitOnline]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_CommitOnline]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �ύ�������
CREATE PROC GSP_GR_CommitOnline
	@dwTypeID	INT,
	@dwValue	INT,
	@DateCollect	NVARCHAR(32)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	DECLARE @TheID INT
	SELECT @TheID=ID FROM WHTreasureDB.dbo.GameDayStatistics(NOLOCK) WHERE Type=@dwTypeID AND DATEDIFF(day,CollectDate,@DateCollect)=0 
	IF @TheID IS NULL
	BEGIN
		INSERT INTO WHTreasureDB.dbo.GameDayStatistics(Type, Value, CollectDate) VALUES(@dwTypeID, @dwValue, @DateCollect)
	END
	ELSE
	BEGIN
		UPDATE WHTreasureDB.dbo.GameDayStatistics SET Value = @dwValue,CollectDate=@DateCollect WHERE ID=@TheID
	END
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHServerInfoDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserSpeakerSend]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserSpeakerSend]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �ύ����
CREATE PROC GSP_GP_UserSpeakerSend
	@dwUserID	INT,
	@wType		INT,
	@szMsg		NVARCHAR(256)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

declare @iSpreakerScore int
declare @iCurScore int
declare @szAccount NVARCHAR(33)

-- ִ���߼�
BEGIN
	IF @wType = 1
	BEGIN
		-- ��ѯ�û�
		SELECT @szAccount=Accounts FROM WHGameUserDB.dbo.AccountsInfo(NOLOCK) WHERE UserID=@dwUserID
		IF @szAccount IS NULL 
		BEGIN
			-- �������
			SELECT 0 AS Score
			RETURN 1
		END

		-- ��������
		IF EXISTS (SELECT UserID FROM WHTreasureDB.dbo.GameScoreLocker WHERE UserID=@dwUserID)
		BEGIN
			SELECT 0 AS Score
			RETURN 4
		END

		--�û����ȣ�ҪУ��Ƹ�
		-- ����ֵ
		set @iCurScore = 0
		SELECT @iSpreakerScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='speaker'
		IF @iSpreakerScore IS NULL
		BEGIN
			-- �������
			SELECT 0 AS Score
			RETURN 2
		END
		SELECT @iCurScore=Score FROM WHTreasureDB.dbo.GameScoreInfo  WHERE UserID=@dwUserID
		IF @iSpreakerScore > @iCurScore
		BEGIN
			-- �������
			SELECT @iCurScore AS Score
			RETURN 3
		END

		--�۲Ƹ�
		UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score - @iSpreakerScore WHERE UserID=@dwUserID
		SET @iCurScore = @iCurScore - @iSpreakerScore
	END
	ELSE
	BEGIN
		SET @iCurScore = 0
		SET @szAccount = N'system'
	END

	--д��־
	INSERT INTO GameSpeaker(UserID, Account, Txt, Type) VALUES(@dwUserID, @szAccount, @szMsg, @wType)

	-- �������
	SELECT @iCurScore AS Score
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHServerInfoDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_UserQueryConfig]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_UserQueryConfig]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ѯ����
CREATE PROC GSP_UserQueryConfig
	@dwUserID	INT,
	@dwVersion	INT,
	@dwConfigID	INT,
	@szChannel	NVARCHAR(32)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON
declare @ClientName NVARCHAR(32)

-- ִ���߼�
BEGIN
	IF LEN(@szChannel) = 0 OR @szChannel IS NULL
	BEGIN
		--Ĭ��ֵ
		SET @ClientName = N'%'
	END
	ELSE
	BEGIN
		SET @ClientName =  substring(@szChannel, 1, 2) + N'%'
	END

	SELECT K,V FROM UserConfig WHERE (Version = @dwVersion or Version = 0) and (UserID = @dwUserID or UserID = 0) and (ConfigID = @dwConfigID or ConfigID = 0) and IsValid = 1 and ClientName like @ClientName Order by OrderID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
