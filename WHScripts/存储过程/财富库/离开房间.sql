
----------------------------------------------------------------------------------------------------
-- �����û�����(�޸ĺ��)���������,@lScore(�ı�ֵ)
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_LeaveGameServer]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_LeaveGameServer]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �뿪����
CREATE PROC GSP_GR_LeaveGameServer
	@dwUserID INT,								-- �û� I D
	@lScore BIGINT,								-- �û�����
	@lGameGold BIGINT,							-- ��Ϸ���
	@lInsureScore BIGINT,						-- ���н��
	@lLoveliness BIGINT,						-- �������
	@lRevenue BIGINT,							-- ��Ϸ˰��
	@lWinCount INT,								-- ʤ������
	@lLostCount INT,							-- ʧ������
	@lDrawCount INT,							-- �;�����
	@lFleeCount INT,							-- ������Ŀ
	@lExperience INT,							-- �û�����
	@dwPlayTimeCount INT,						-- ��Ϸʱ��
	@dwOnLineTimeCount INT,						-- ����ʱ��
	@wKindID INT,								-- ��Ϸ I D
	@wServerID INT,								-- ���� I D
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
--	UPDATE GameScoreInfo SET Score=Score+@lScore, InsureScore=InsureScore+@lInsureScore, Revenue=Revenue+@lRevenue, WinCount=WinCount+@lWinCount, LostCount=LostCount+@lLostCount, 
--		DrawCount=DrawCount+@lDrawCount, FleeCount=FleeCount+@lFleeCount, PlayTimeCount=PlayTimeCount+@dwPlayTimeCount,
--		OnLineTimeCount=OnLineTimeCount+@dwOnLineTimeCount
--	WHERE UserID=@dwUserID
	UPDATE GameScoreInfo SET WinCount=WinCount+@lWinCount, LostCount=LostCount+@lLostCount, 
		DrawCount=DrawCount+@lDrawCount, FleeCount=FleeCount+@lFleeCount, PlayTimeCount=PlayTimeCount+@dwPlayTimeCount,
		OnLineTimeCount=OnLineTimeCount+@dwOnLineTimeCount
	WHERE UserID=@dwUserID

	-- �������
	DELETE GameScoreLocker WHERE UserID=@dwUserID

	-- �뿪����
	INSERT RecordUserLeave (UserID, Score, Revenue, KindID, ServerID, PlayTimeCount, OnLineTimeCount) 
	VALUES (@dwUserID, @lScore, @lRevenue, @wKindID, @wServerID, @dwPlayTimeCount, @dwOnLineTimeCount)

	-- ����ʱ��ͳ����ʱ��
	IF @dwPlayTimeCount > 0
	BEGIN
		DECLARE @TheTmpUserID INT
		SELECT @TheTmpUserID=UserID FROM GameTimeStatistics(NOLOCK) WHERE UserID=@dwUserID AND KindID=@wKindID
		IF @TheTmpUserID IS NULL
		BEGIN
			--����
			INSERT GameTimeStatistics (UserID, KindID, PlayTime) VALUES(@dwUserID, @wKindID, @dwPlayTimeCount)
		END
		ELSE
		BEGIN
			--����
			UPDATE GameTimeStatistics SET PlayTime=PlayTime+@dwPlayTimeCount WHERE UserID=@dwUserID AND KindID=@wKindID
		END
	END

	--ͳ�Ʋ�ˮ��
	DECLARE @TheTypeValue INT
	IF @wKindID = 998
	BEGIN
		--���˹�
		DECLARE @TheIDSan INT
		SELECT @TheIDSan=ID FROM GameDayStatistics(NOLOCK) WHERE Type=8 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDSan IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(8, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDSan
		END
	END
	ELSE IF @wKindID = 997
	BEGIN
		--���˹�
		DECLARE @TheIDSi INT
		SELECT @TheIDSi=ID FROM GameDayStatistics(NOLOCK) WHERE Type=9 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDSi IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(9, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDSi
		END
	END
	ELSE IF @wKindID = 995
	BEGIN
		--������ʮK
		DECLARE @TheIDEr INT
		SELECT @TheIDEr=ID FROM GameDayStatistics(NOLOCK) WHERE Type=21 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDEr IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(21, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDEr
		END
	END
	ELSE IF @wKindID = 996
	BEGIN
		--��ʯ��ʮK
		DECLARE @TheIDHuang INT
		SELECT @TheIDHuang=ID FROM GameDayStatistics(NOLOCK) WHERE Type=24 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDHuang IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(24, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDHuang
		END
	END
	ELSE IF @wKindID = 990
	BEGIN
		--��ʯ��ʮK
		DECLARE @TheIDQian INT
		SELECT @TheIDQian=ID FROM GameDayStatistics(NOLOCK) WHERE Type=27 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDQian IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(27, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDQian
		END
	END
	ELSE IF @wKindID = 999
	BEGIN
		--��ڴ��
		DECLARE @TheIDChi INT
		SELECT @TheIDChi=ID FROM GameDayStatistics(NOLOCK) WHERE Type=30 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDChi IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(30, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDChi
		END
	END
	ELSE IF @wKindID = 988
	BEGIN
		--��������
		DECLARE @TheIDJian INT
		SELECT @TheIDJian=ID FROM GameDayStatistics(NOLOCK) WHERE Type=33 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDJian IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(33, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDJian
		END
	END
	ELSE IF @wKindID = 987
	BEGIN
		--����
		DECLARE @TheIDChong INT
		SELECT @TheIDChong=ID FROM GameDayStatistics(NOLOCK) WHERE Type=36 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDChong IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(36, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDChong
		END
	END
	ELSE IF @wKindID = 986
	BEGIN
		--ͨɽ
		DECLARE @TheIDTong INT
		SELECT @TheIDTong=ID FROM GameDayStatistics(NOLOCK) WHERE Type=39 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDTong IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(39, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDTong
		END
	END
	ELSE IF @wKindID = 989
	BEGIN
		--����
		DECLARE @TheIDXianTao INT
		SELECT @TheIDXianTao=ID FROM GameDayStatistics(NOLOCK) WHERE Type=42 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDXianTao IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(42, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDXianTao
		END
	END
	ELSE IF @wKindID = 994
	BEGIN
		--ţţ
		DECLARE @TheIDNiu INT
		SELECT @TheIDNiu=ID FROM GameDayStatistics(NOLOCK) WHERE Type=10 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDNiu IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(10, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDNiu
		END

		DECLARE @TheTypeNiu INT
		IF @wServerID = 4001 OR @wServerID = 4005
		BEGIN
			SET @TheTypeNiu = 11
		END
		ELSE IF @wServerID = 4002 OR @wServerID = 4006
		BEGIN
			SET @TheTypeNiu = 12
		END
		ELSE IF @wServerID = 4003 OR @wServerID = 4007
		BEGIN
			SET @TheTypeNiu = 13
		END
		ELSE IF @wServerID = 4004 OR @wServerID = 4008
		BEGIN
			SET @TheTypeNiu = 14
		END
		ELSE IF @wServerID = 4009 OR @wServerID = 4010
		BEGIN
			SET @TheTypeNiu = 15
		END
		ELSE
		BEGIN
			SET @TheTypeNiu = 0
		END
		
		--������
		DECLARE @TheIDNiuR INT
		SELECT @TheIDNiuR=ID FROM GameDayStatistics(NOLOCK) WHERE Type=@TheTypeNiu AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheIDNiuR IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(@TheTypeNiu, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheIDNiuR
		END
	END
	ELSE IF @wKindID = 961
	BEGIN
		--����
		DECLARE @TheSanzhang INT
		SELECT @TheSanzhang=ID FROM GameDayStatistics(NOLOCK) WHERE Type=61 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheSanzhang IS NULL
		BEGIN
			INSERT INTO GameDayStatistics(Type, Value) VALUES(61, @lRevenue)
		END
		ELSE
		BEGIN
			UPDATE GameDayStatistics SET Value = Value + @lRevenue WHERE ID=@TheSanzhang
		END
	END
	-- �û�����
--	INSERT RecordUserLoveliness (UserID, KindID, ServerID,Loveliness,ClientIP)
--	VALUES (@dwUserID,@wKindID,@wServerID,@lLoveliness,@strClientIP)

	-- �û�����
--	UPDATE WHGameUserDB.dbo.AccountsInfo SET Experience=Experience+@lExperience,Loveliness=@lLoveliness WHERE UserID=@dwUserID

	-- @lDrawCountȡƽ�֣����ܵĲ���
	IF @lWinCount + @lLostCount + @lDrawCount > 0
	BEGIN
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
			UPDATE  GameToday SET CollectDate=getDate(),
					      Win = @lWinCount, WinTotal = WinTotal + @lWinCount, Win4Activity = Win4Activity + @lWinCount,
					      Lost = @lLostCount, LostTotal = LostTotal + @lLostCount,Lost4Activity = Lost4Activity + @lLostCount,
					      Flee = @lDrawCount, FleeTotal = FleeTotal + @lDrawCount,Flee4Activity = Flee4Activity + @lDrawCount
			WHERE UserID=@dwUserID and KindID=@wKindID
		END
		ELSE
		BEGIN
			--������Ӯ��������¼�����
			UPDATE  GameToday SET Win = Win + @lWinCount,WinTotal = WinTotal + @lWinCount,Win4Activity = Win4Activity + @lWinCount,
					      Lost = Lost + @lLostCount,LostTotal = LostTotal + @lLostCount,Lost4Activity = Lost4Activity + @lLostCount,
					      Flee = Flee + @lDrawCount,FleeTotal = FleeTotal + @lDrawCount,Flee4Activity = Flee4Activity + @lDrawCount
			WHERE UserID=@dwUserID and KindID=@wKindID
		END
	END
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_RoomStartFinish]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_RoomStartFinish]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �����������
CREATE PROC GSP_GR_RoomStartFinish
	@wKindID INT,			-- ��Ϸ I D
	@wServerID INT			-- ���� I D
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @UserID INT

-- ִ���߼�
BEGIN
	-- ɾ���������û�
	DELETE FROM WHTreasureDB.dbo.GameScoreLocker WHERE ServerID=@wServerID AND KindID=@wKindID
END

RETURN 0

GO

