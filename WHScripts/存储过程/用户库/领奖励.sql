
----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserGetAward]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserGetAward]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- I D ��¼
CREATE PROC GSP_GP_UserGetAward
	@dwUserID INT,	
	@dwTaskID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheUserID INT
DECLARE @TheScore INT
DECLARE @TheLatestDate DATETIME
DECLARE @TheStatus INT

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @TheUserID=UserID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- ��ѯ�û�
	IF @TheUserID IS NULL
	BEGIN
		set @ErrorDescribe = N'�����ʺŲ����ڣ�'
		set @TheStatus = -1
		RETURN -1
	END	

	IF (@dwTaskID >= 10 AND @dwTaskID < 9000) OR (@dwTaskID = 9999)
	BEGIN
		-- ϵͳ�����Ƿ����콱�����ÿ���ʱ��
		SELECT @TheScore=Score
		FROM UserGetAward(NOLOCK) WHERE UserID=@dwUserID and TaskID=@dwTaskID
	END
	ELSE
	BEGIN
		-- �����Ƿ����콱
		SELECT @TheScore=Score
		FROM UserGetAward(NOLOCK) WHERE UserID=@dwUserID and TaskID=@dwTaskID and datediff(day,[LatestDate],getdate())=0
	END

	IF @TheScore IS NULL
	BEGIN
		set @TheLatestDate = (select getdate())
		IF @dwTaskID = 1
		BEGIN
			--��ʱд��
			--set @TheScore = 1000
			SELECT @TheScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and ToClient=1 and name='wx'
			IF @TheScore IS NULL
			BEGIN
				set @ErrorDescribe = N'��������Ȧ�δ��ʼ��'
				set @TheStatus = -2
				RETURN -2
			END
		END
		ELSE IF @dwTaskID = 2
		BEGIN
			--��ʱд��
			--set @TheScore = 500
			SELECT @TheScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and ToClient=1 and name='wy'
			IF @TheScore IS NULL
			BEGIN
				set @ErrorDescribe = N'������ѻδ��ʼ��'
				set @TheStatus = -3
				RETURN -3
			END
		END
		ELSE IF @dwTaskID = 9998
		BEGIN
			SELECT @TheScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and ToClient=1 and name='qqz'
			IF @TheScore IS NULL
			BEGIN
				set @ErrorDescribe = N'����QQ�ռ�δ��ʼ��'
				set @TheStatus = -11
				RETURN -11
			END
		END
		ELSE IF @dwTaskID = 9997
		BEGIN
			SELECT @TheScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and ToClient=1 and name='qqy'
			IF @TheScore IS NULL
			BEGIN
				set @ErrorDescribe = N'����QQ���ѻδ��ʼ��'
				set @TheStatus = -12
				RETURN -12
			END
		END
		ELSE IF @dwTaskID = 3
		BEGIN
			SELECT @TheScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='r3_j1'
			IF @TheScore IS NULL
			BEGIN
				set @ErrorDescribe = N'���˹�ÿ�������δ��ʼ��'
				set @TheStatus = -4
				RETURN -4
			END
		END
		ELSE IF @dwTaskID = 4
		BEGIN
			SELECT @TheScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='r3_j2'
			IF @TheScore IS NULL
			BEGIN
				set @ErrorDescribe = N'���˹�ÿ�������δ��ʼ��'
				set @TheStatus = -5
				RETURN -5
			END
		END
		ELSE IF @dwTaskID = 5
		BEGIN
			SELECT @TheScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='r3_j3'
			IF @TheScore IS NULL
			BEGIN
				set @ErrorDescribe = N'���˹�ÿ�������δ��ʼ��'
				set @TheStatus = -6
				RETURN -6
			END
		END
		ELSE IF @dwTaskID = 6 or @dwTaskID = 10001
		BEGIN
			SELECT @TheScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='r4_j1'
			IF @TheScore IS NULL
			BEGIN
				set @ErrorDescribe = N'���˹�ÿ�������δ��ʼ��'
				set @TheStatus = -7
				RETURN -7
			END
		END
		ELSE IF @dwTaskID = 7 or @dwTaskID = 10002
		BEGIN
			SELECT @TheScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='r4_j2'
			IF @TheScore IS NULL
			BEGIN
				set @ErrorDescribe = N'���˹�ÿ�������δ��ʼ��'
				set @TheStatus = -8
				RETURN -8
			END
		END
		ELSE IF @dwTaskID = 8 or @dwTaskID = 10003
		BEGIN
			SELECT @TheScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='r4_j3'
			IF @TheScore IS NULL
			BEGIN
				set @ErrorDescribe = N'���˹�ÿ�������δ��ʼ��'
				set @TheStatus = -9
				RETURN -9
			END
		END	
		ELSE IF @dwTaskID = 9999
		BEGIN
			SELECT @TheScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='sj_v'
			IF @TheScore IS NULL
			BEGIN
				set @ErrorDescribe = N'�˺�����������δ��ʼ��'
				set @TheStatus = -10
				RETURN -10
			END
		END
		ELSE IF @dwTaskID = 10 or @dwTaskID = 30 or @dwTaskID = 50 
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 300
		END
		ELSE IF @dwTaskID = 11 or @dwTaskID = 31 or @dwTaskID = 51
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 600
		END
		ELSE IF @dwTaskID = 12 or @dwTaskID = 32 or @dwTaskID = 52
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 1000
		END
		ELSE IF @dwTaskID = 13 or @dwTaskID = 33 or @dwTaskID = 53
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 1500
		END
		ELSE IF @dwTaskID = 14 or @dwTaskID = 34 or @dwTaskID = 54
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 2000
		END
		ELSE IF @dwTaskID = 15 or @dwTaskID = 35 or @dwTaskID = 55
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 3000
		END
		ELSE IF @dwTaskID = 16 or @dwTaskID = 36 or @dwTaskID = 56
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 4600
		END
		ELSE IF @dwTaskID = 17 or @dwTaskID = 37 or @dwTaskID = 57
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 6000
		END
		ELSE IF @dwTaskID = 18 or @dwTaskID = 38 or @dwTaskID = 58
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 8000
		END
		ELSE IF @dwTaskID = 19 or @dwTaskID = 39 or @dwTaskID = 59
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 12000
		END
		ELSE IF @dwTaskID = 20 or @dwTaskID = 40 or @dwTaskID = 60
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 16000
		END
		ELSE IF @dwTaskID = 21 or @dwTaskID = 41 or @dwTaskID = 61
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 20000
		END
		ELSE IF @dwTaskID = 22 or @dwTaskID = 42 or @dwTaskID = 62
		BEGIN
			--��ʱд��
			--���˹�ϵͳ��������
			set @TheScore = 25000
		END
		ELSE
		BEGIN
			set @ErrorDescribe = N'������֧�֣�'
			set @TheStatus = -10
			RETURN -10
		END

		INSERT INTO UserGetAward(UserID, TaskID, Score, LatestDate) VALUES(@dwUserID, @dwTaskID, @TheScore, @TheLatestDate)

		-- �ӷ�
		UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score + @TheScore WHERE UserID=@dwUserID
		
		set @ErrorDescribe = N'�콱���ɹ���'

		set @TheStatus = 0
	END
	ELSE
	BEGIN
		set @TheStatus = 99
	END

	-- �������
	SELECT @TheStatus AS Status, @dwTaskID AS TaskID, @dwUserID AS UserID, @TheScore AS Score
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserCanGetSpreadAward]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserCanGetSpreadAward]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------------------------------------

-- �Ƿ�����ȡ�ƹ㽱�����°�װ�İ�����7������Ч
CREATE PROC GSP_GP_UserCanGetSpreadAward
	@dwUserID INT,
	@strMachineSerial NCHAR(32) -- ������ʶ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheUserID INT
DECLARE @TheUserIDR INT
DECLARE @TheDateDiff INT

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @TheUserID=UserID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID
	-- ��ѯ�û�
	IF @TheUserID IS NULL
	BEGIN
		SELECT [ErrorDescribe]=N'�����ʺŲ����ڣ�',@TheUserID AS UserID
		RETURN 4
	END

	-- ���콱��¼
	SELECT @TheUserIDR=UserID FROM UserSpreadR(NOLOCK) WHERE MachineSerial=@strMachineSerial
	IF @TheUserIDR IS NULL
	BEGIN
		--�ټ���Ƿ񳬹�ʱЧ: ע��ʱ��Ϊ7������
		SELECT TOP 1 @TheUserIDR=UserID, @TheDateDiff=DATEDIFF([second], [RegisterDate] , getdate()) FROM AccountsInfo(NOLOCK) 
		WHERE MachineSerial=@strMachineSerial
		ORDER BY RegisterDate ASC;

		-- ��ѯ�û�
		IF @TheUserIDR IS NULL
		BEGIN
			SELECT [ErrorDescribe]=N'�����豸δע�ᣡ',@TheUserID AS UserID
			RETURN 1
		END

		IF @TheDateDiff > 7*24*3600
		BEGIN
			SELECT [ErrorDescribe]=N'���Ѿ������콱��ʱ�ޣ�',@TheUserID AS UserID
			RETURN 5
		END

		SELECT [ErrorDescribe]=N'�������콱��',@TheUserID AS UserID
		RETURN 0
	END
	
	SELECT [ErrorDescribe]=N'�����ʺ��Ѿ����������',@TheUserID AS UserID
	RETURN 2
END

RETURN 3

GO

----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserGetSpreadAward]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserGetSpreadAward]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------------------------------------

-- �ƹ㽱��
CREATE PROC GSP_GP_UserGetSpreadAward
	@dwUserID INT,	
	@dwSpreaderID INT,
	@strMachineSerial NCHAR(32) -- ������ʶ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheUserID INT
DECLARE @TheSpreaderID INT
DECLARE @TheCount INT
DECLARE @TheCountR INT
DECLARE @TheType INT
DECLARE @TheGoldConfig INT
DECLARE @TheGold INT
DECLARE @TheGoldR INT

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�,�������ο��ʺ�
	SELECT @TheUserID=UserID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID AND IsGuest!=1

	-- ��ѯ�û�
	IF @TheUserID IS NULL
	BEGIN
		SELECT [ErrorDescribe]=N'���ȵ��û���������Ϊ��ʽ�ʺţ�',@dwUserID AS UserID
		RETURN 1
	END
	
	-- ��ѯ�ƹ�Ա
	SELECT @TheSpreaderID=UserID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwSpreaderID
	IF @TheSpreaderID IS NULL
	BEGIN
		SELECT [ErrorDescribe]=N'�����벻���ڣ�',@TheUserID AS UserID
		RETURN 2
	END

	SELECT @TheGoldConfig=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='fx_enable'
	IF @TheGoldConfig IS NULL
	BEGIN
		set @ErrorDescribe = N'�ƹ�δ������'
		RETURN 3
	END

	--У�������
	IF LEN(LTRIM(RTRIM(@strMachineSerial))) < 12
	BEGIN
		SELECT [ErrorDescribe]=N'����ϵ�ͷ���',@TheUserID AS UserID
		RETURN 4
	END

	-- �Ƿ��Ѿ��콱
	SELECT @TheCount=Amount
	FROM UserSpreadR(NOLOCK) WHERE MachineSerial=@strMachineSerial
	IF @TheCount IS NULL
	BEGIN
		SET @TheCount = @TheGoldConfig
		SET @TheType = 1
		--��¼
		INSERT INTO UserSpreadR(UserID,SpreaderID,Amount,Type,AwardDate,MachineSerial) 
		VALUES(@dwUserID, @dwSpreaderID, @TheCount, @TheType, getdate(),@strMachineSerial);

		--����(���ƹ���)
		-- �Ƿ��жһ���Ϣ
		SELECT @TheGold=Gold
		FROM UserExchangeInfo(NOLOCK) WHERE UserID=@dwUserID 
		IF @TheGold IS NULL
		BEGIN
			set @TheGold = @TheCount
			INSERT INTO UserExchangeInfo(UserID, Gold, Phone) VALUES(@dwUserID, @TheGold, N'')
		END
		ELSE
		BEGIN
			UPDATE UserExchangeInfo SET Gold = Gold + @TheCount WHERE UserID = @dwUserID
			SET @TheCount = @TheGold + @TheCount
		END

		--����(�ƹ�Ա)
		-- �Ƿ��жһ���Ϣ
		SET @TheCountR = @TheGoldConfig
		SELECT @TheGoldR=Gold
		FROM UserExchangeInfo(NOLOCK) WHERE UserID=@dwSpreaderID 
		IF @TheGoldR IS NULL
		BEGIN
			INSERT INTO UserExchangeInfo(UserID, Gold, Phone) VALUES(@dwSpreaderID, @TheCountR, N'')
		END
		ELSE
		BEGIN
			UPDATE UserExchangeInfo SET Gold = Gold + @TheCountR WHERE UserID = @dwSpreaderID
		END

		--ͳ�ƽ����ƹ������
		DECLARE @TheID INT
		SELECT @TheID=ID FROM WHTreasureDB.dbo.GameDayStatistics(NOLOCK) WHERE Type=3 AND DATEDIFF(day,CollectDate,GETDATE())=0 
		IF @TheID IS NULL
		BEGIN
			INSERT INTO WHTreasureDB.dbo.GameDayStatistics(Type, Value) VALUES(3, @TheCountR)
		END
		ELSE
		BEGIN
			UPDATE WHTreasureDB.dbo.GameDayStatistics SET Value = Value+@TheCountR WHERE ID=@TheID
		END

		SET @ErrorDescribe = N'���Ž����ɹ���'
	END
	ELSE
	BEGIN
		SELECT [ErrorDescribe]=N'���Ѿ���������ˣ�',@TheUserID AS UserID
		RETURN 3
	END

	-- �������
	SELECT @ErrorDescribe AS ErrorDescribe, @TheCount AS Amount, @TheType AS Type, @TheUserID AS UserID, @TheSpreaderID AS Spreader
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserGetSpreadInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserGetSpreadInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO
----------------------------------------------------------------------------------------------------

-- �ƹ���Ϣ
CREATE PROC GSP_GP_UserGetSpreadInfo
	@dwSpreaderID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheUsers INT
DECLARE @TheSpreaderID INT
DECLARE @TheCount INT

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN
	--��ѯ����
	SELECT @TheUsers=COUNT(*), @TheCount=SUM(Amount) FROM UserSpreadR(NOLOCK) WHERE SpreaderID=@dwSpreaderID
	IF @TheUsers = 0
	BEGIN
		SELECT [ErrorDescribe]=N'��û���ƹ��¼��',@dwSpreaderID AS S
		RETURN 1
	END

	--��ѯǰ10����¼
	SELECT TOP 10 (SELECT A.RegAccounts from AccountsInfo(NOLOCK) AS A where A.UserID=R.UserID) AS N,UserID,Amount AS M,
	CONVERT(varchar,AwardDate,102)AS D,@TheUsers AS T, @TheCount AS C,@dwSpreaderID AS S
	FROM UserSpreadR(NOLOCK) AS R WHERE SpreaderID=@dwSpreaderID ORDER BY AwardDate DESC
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
