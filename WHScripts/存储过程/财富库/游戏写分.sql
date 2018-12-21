
----------------------------------------------------------------------------------------------------

USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_WriteGameScore]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_WriteGameScore]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��Ϸд��(δʹ�ã�ʵ��ʹ�õ���GSP_GR_LeaveGameServer)
CREATE PROC GSP_GR_WriteGameScore
	@dwUserID INT,								-- �û� I D
	@lScore BIGINT,								-- �û�����
	@lRevenue BIGINT,							-- ��Ϸ˰��
	@lWinCount INT,								-- ʤ������
	@lLostCount INT,							-- ʧ������
	@lDrawCount INT,							-- �;�����
	@lFleeCount INT,							-- ������Ŀ
	@lExperience INT,							-- �û�����
	@dwPlayTimeCount INT,						-- ��Ϸʱ��
	@dwOnLineTimeCount INT,						-- ����ʱ��
	@wKindID INT,							-- ��Ϸ I D
	@wServerID INT,						-- ���� I D
	@strClientIP NVARCHAR(15)					-- ���ӵ�ַ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @UserID INT

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID FROM GameScoreInfo(NOLOCK) WHERE UserID=@dwUserID
	-- ��ѯ�û�
	IF @UserID IS NULL
	BEGIN
		RETURN 1
	END

	-- �û�����
	UPDATE GameScoreInfo SET Score=Score+@lScore, Revenue=Revenue+@lRevenue, WinCount=WinCount+@lWinCount, LostCount=LostCount+@lLostCount,
		DrawCount=DrawCount+@lDrawCount, FleeCount=FleeCount+@lFleeCount, PlayTimeCount=PlayTimeCount+@dwPlayTimeCount, 
		OnLineTimeCount=OnLineTimeCount+@dwOnLineTimeCount
	WHERE UserID=@dwUserID

	-- �û�����
	UPDATE WHGameUserDB.dbo.AccountsInfo SET Experience=Experience+@lExperience WHERE UserID=@dwUserID

	-- ͳ����ҽ�����Ӯ����
	-- �Ƿ��м�¼
	DECLARE @TheDate NVARCHAR(31)
	SELECT @TheDate=Convert(varchar(10),[CollectDate],120)
	FROM GameToday(NOLOCK) 
	WHERE UserID=@dwUserID and KindID=@wKindID

	--����û�м�¼
	IF @TheDate IS NULL
	BEGIN
		--����һ��Ĭ�ϼ�¼
		INSERT INTO GameToday(UserID, KindID, Win, Lost, Flee, WinTotal, LostTotal, FleeTotal, Win4Activity, Lost4Activity, Flee4Activity) VALUES(@dwUserID,@wKindID,0,0,0,0,0,0,0,0,0)
	END

	--�Ƿ���Ҫ��������
	IF @TheDate <> Convert(varchar(10),getDate(),120)
	BEGIN
		UPDATE  GameToday SET CollectDate=getDate(), Win=0,Lost=0,Flee=0 WHERE UserID=@dwUserID and KindID=@wKindID
	END

	--������Ӯ��������¼�����
	UPDATE  GameToday SET Win = Win + @lWinCount,WinTotal = WinTotal + @lWinCount,Win4Activity = Win4Activity + @lWinCount,
			      Lost = Lost + @lLostCount,LostTotal = LostTotal + @lLostCount,Lost4Activity = Lost4Activity + @lLostCount,
			      Flee = Flee + @lFleeCount,FleeTotal = FleeTotal + @lFleeCount,Flee4Activity = Flee4Activity + @lFleeCount
	WHERE UserID=@dwUserID and KindID=@wKindID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_WriteGameRecord]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_WriteGameRecord]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��Ϸд��
CREATE PROC GSP_GR_WriteGameRecord
	@dwUserID INT,								-- �û� I D
	@lScore BIGINT,								-- �û����ַ���
	@lTotalScore BIGINT,								-- �û���ǰ�ܷ���
	@lRevenue BIGINT,							-- ��Ϸ˰��
	@lResult INT,								-- ʤ��
	@lAward INT,								-- ����
	@lTime BIGINT,								-- ʱ���
	@wKindID INT,							-- ��Ϸ I D
	@wServerID INT,						-- ���� I D
	@strClientIP NVARCHAR(15)					-- ���ӵ�ַ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @UserID INT

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID FROM GameScoreInfo(NOLOCK) WHERE UserID=@dwUserID
	-- ��ѯ�û�
	IF @UserID IS NULL
	BEGIN
		RETURN 1
	END

	DECLARE @adate datetime
	SET @adate = DATEADD (ss ,@lTime % 60 ,DATEADD(mi,@lTime / 60, '1970-01-01 08:00:00'));  --ʱ��

	IF @lAward > 0
	BEGIN
		-- �������� TODO:Ӧ�÷ŵ������Ĵ洢������
		-- �Ƿ��жһ���Ϣ
		DECLARE @TheGold INT
		SELECT @TheGold=Gold
		FROM WHGameUserDB.dbo.UserExchangeInfo(NOLOCK) WHERE UserID=@dwUserID 

		IF @TheGold IS NULL
		BEGIN
			INSERT INTO WHGameUserDB.dbo.UserExchangeInfo(UserID, Gold, Phone) VALUES(@dwUserID, @lAward, N'')
		END
		ELSE
		BEGIN
			IF @lAward > 0
			BEGIN
				UPDATE WHGameUserDB.dbo.UserExchangeInfo SET Gold = Gold + @lAward WHERE UserID=@dwUserID 
			END
		END

		--ͳ�ƽ��������
		DECLARE @TheID INT
		SELECT @TheID=ID FROM GameDayStatistics(NOLOCK) WHERE Type=1 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheID IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(1, @lAward)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheID
		END
	END

	-- �û���¼
	INSERT GameResultDetails(UserID,TotalScore,Score,Revenue,Result,Award,KindID,ServerID,CollectDate,ClientIP)
	VALUES(@dwUserID,@lTotalScore,@lScore,@lRevenue,@lResult,@lAward,@wKindID,@wServerID,@adate,@strClientIP);

	UPDATE GameScoreInfo SET Score=Score+@lScore, Revenue=Revenue+@lRevenue
	WHERE UserID=@dwUserID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_WriteGameRecord_V2]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_WriteGameRecord_V2]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��Ϸд��
CREATE PROC GSP_GR_WriteGameRecord_V2
	@dwUserID INT,								-- �û� I D
	@lScore BIGINT,								-- �û����ַ���
	@lTotalScore BIGINT,								-- �û���ǰ�ܷ���
	@lRevenue BIGINT,							-- ��Ϸ˰��
	@lResult INT,								-- ʤ��
	@lAward INT,								-- ����
	@lTime BIGINT,								-- ʱ���
	@wKindID INT,							-- ��Ϸ I D
	@wServerID INT,						-- ���� I D
	@wTableID INT,						-- ���� I D
	@strClientIP NVARCHAR(15)					-- ���ӵ�ַ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @UserID INT

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID FROM GameScoreInfo(NOLOCK) WHERE UserID=@dwUserID
	-- ��ѯ�û�
	IF @UserID IS NULL
	BEGIN
		RETURN 1
	END

	DECLARE @adate datetime
	SET @adate = DATEADD (ss ,@lTime % 60 ,DATEADD(mi,@lTime / 60, '1970-01-01 08:00:00'));  --ʱ��

	IF @lAward > 0
	BEGIN
		-- �������� TODO:Ӧ�÷ŵ������Ĵ洢������
		-- �Ƿ��жһ���Ϣ
		DECLARE @TheGold INT
		SELECT @TheGold=Gold
		FROM WHGameUserDB.dbo.UserExchangeInfo(NOLOCK) WHERE UserID=@dwUserID 

		IF @TheGold IS NULL
		BEGIN
			INSERT INTO WHGameUserDB.dbo.UserExchangeInfo(UserID, Gold, Phone) VALUES(@dwUserID, @lAward, N'')
		END
		ELSE
		BEGIN
			IF @lAward > 0
			BEGIN
				UPDATE WHGameUserDB.dbo.UserExchangeInfo SET Gold = Gold + @lAward WHERE UserID=@dwUserID 
			END
		END

		--ͳ�ƽ��콱�����������
		DECLARE @TheID INT
		SELECT @TheID=ID FROM GameDayStatistics(NOLOCK) WHERE Type=2 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheID IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(2, @lAward)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheID
		END

		--ͳ�ƽ������˹��������������
		IF @wKindID = 998
		BEGIN
			DECLARE @TheIDSan INT
			SELECT @TheIDSan=ID FROM GameDayStatistics(NOLOCK) WHERE Type=6 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDSan IS NULL
			BEGIN
				INSERT INTO GameDayStatistics(Type, Value) VALUES(6, @lAward)
			END
			ELSE
			BEGIN
				UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheIDSan
			END
		END
		ELSE IF @wKindID = 997
		BEGIN
			--ͳ�ƽ������˹��������������
			DECLARE @TheIDSi INT
			SELECT @TheIDSi=ID FROM GameDayStatistics(NOLOCK) WHERE Type=7 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDSi IS NULL
			BEGIN
				INSERT INTO GameDayStatistics(Type, Value) VALUES(7, @lAward)
			END
			ELSE
			BEGIN
				UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheIDSi
			END
		END
		ELSE IF @wKindID = 995
		BEGIN
			--ͳ�ƽ��������ʮK�������������
			DECLARE @TheIDEr INT
			SELECT @TheIDEr=ID FROM GameDayStatistics(NOLOCK) WHERE Type=20 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDEr IS NULL
			BEGIN
				INSERT INTO GameDayStatistics(Type, Value) VALUES(20, @lAward)
			END
			ELSE
			BEGIN
				UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheIDEr
			END
		END
		ELSE IF @wKindID = 996
		BEGIN
			--ͳ�ƽ����ʯ��ʮK�������������
			DECLARE @TheIDHuang INT
			SELECT @TheIDHuang=ID FROM GameDayStatistics(NOLOCK) WHERE Type=23 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDHuang IS NULL
			BEGIN
				INSERT INTO GameDayStatistics(Type, Value) VALUES(23, @lAward)
			END
			ELSE
			BEGIN
				UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheIDHuang
			END
		END
		ELSE IF @wKindID = 990
		BEGIN
			--ͳ�ƽ���Ǳ��ǧ�ֽ������������
			DECLARE @TheIDQian INT
			SELECT @TheIDQian=ID FROM GameDayStatistics(NOLOCK) WHERE Type=26 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDQian IS NULL
			BEGIN
				INSERT INTO GameDayStatistics(Type, Value) VALUES(26, @lAward)
			END
			ELSE
			BEGIN
				UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheIDQian
			END
		END
		ELSE IF @wKindID = 999
		BEGIN
			--ͳ�ƽ����ڴ���������������
			DECLARE @TheIDChi INT
			SELECT @TheIDChi=ID FROM GameDayStatistics(NOLOCK) WHERE Type=29 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDChi IS NULL
			BEGIN
				INSERT INTO GameDayStatistics(Type, Value) VALUES(29, @lAward)
			END
			ELSE
			BEGIN
				UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheIDChi
			END
		END
		ELSE IF @wKindID = 988
		BEGIN
			--ͳ�ƽ�����������������������
			DECLARE @TheIDJian INT
			SELECT @TheIDJian=ID FROM GameDayStatistics(NOLOCK) WHERE Type=32 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDJian IS NULL
			BEGIN
				INSERT INTO GameDayStatistics(Type, Value) VALUES(32, @lAward)
			END
			ELSE
			BEGIN
				UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheIDJian
			END
		END
		ELSE IF @wKindID = 987
		BEGIN
			--ͳ�ƽ�������������������
			DECLARE @TheIDChong INT
			SELECT @TheIDChong=ID FROM GameDayStatistics(NOLOCK) WHERE Type=35 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDChong IS NULL
			BEGIN
				INSERT INTO GameDayStatistics(Type, Value) VALUES(35, @lAward)
			END
			ELSE
			BEGIN
				UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheIDChong
			END
		END
		ELSE IF @wKindID = 986
		BEGIN
			--ͳ�ƽ���ͨɽ�������������
			DECLARE @TheIDTong INT
			SELECT @TheIDTong=ID FROM GameDayStatistics(NOLOCK) WHERE Type=38 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDTong IS NULL
			BEGIN
				INSERT INTO GameDayStatistics(Type, Value) VALUES(38, @lAward)
			END
			ELSE
			BEGIN
				UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheIDTong
			END
		END
		ELSE IF @wKindID = 989
		BEGIN
			--ͳ�ƽ������ҽ������������
			DECLARE @TheIDXianTao INT
			SELECT @TheIDXianTao=ID FROM GameDayStatistics(NOLOCK) WHERE Type=41 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDXianTao IS NULL
			BEGIN
				INSERT INTO GameDayStatistics(Type, Value) VALUES(41, @lAward)
			END
			ELSE
			BEGIN
				UPDATE GameDayStatistics SET Value = Value + @lAward WHERE ID=@TheIDXianTao
			END
		END
	END


	-- �û���¼
	INSERT GameResultDetails(UserID,TotalScore,Score,Revenue,Result,Award,KindID,ServerID,TableID,CollectDate,ClientIP)
	VALUES(@dwUserID,@lTotalScore,@lScore,@lRevenue,@lResult,@lAward,@wKindID,@wServerID,@wTableID,@adate,@strClientIP);

	UPDATE GameScoreInfo SET Score=Score+@lScore, Revenue=Revenue+@lRevenue WHERE UserID=@dwUserID
	UPDATE GameScoreInfo SET Score=0 WHERE UserID=@dwUserID And Score<0

END

RETURN 0

GO

