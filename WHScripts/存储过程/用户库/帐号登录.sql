
----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_CheckUserGMScore]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_CheckUserGMScore]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ���GM���߷��ŵĲƸ�
CREATE PROC GSP_GP_CheckUserGMScore
	@dwUserID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheUserID INT
DECLARE @TheCount INT
DECLARE @GoldScore INT
DECLARE @Status NVARCHAR(32)
DECLARE @Comment NVARCHAR(64)

-- ִ���߼�
BEGIN
	-- ��ѯ�û��ķ��Ƹ�����1��
	SELECT @TheUserID=UserID, @TheCount=sum(convert(int,Params))  FROM GMTask(NOLOCK) WHERE UserID=@dwUserID and TaskID=1 group by UserID

	-- û������
	IF @TheUserID IS NULL
	BEGIN
		RETURN 0
	END	

	-- ��Ϸ��Ϣ
	SELECT @GoldScore=Score FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
	-- ��Ϣ�ж�
	IF @GoldScore IS NULL
	BEGIN
		SET @TheCount = 0
		SET @Status = N'ʧ��'
		SET @Comment = N'�Ƹ�����ID������'
	END
	ELSE
	BEGIN
		SET @Status = N'�ɹ�'
		SET @Comment = N'���ŲƸ�'+convert(varchar(32),@TheCount)
	END

	-- ִ������
	INSERT INTO GMTaskLog SELECT *,getdate(),@Status,@Comment FROM GMTask WHERE UserID=@dwUserID and TaskID=1
	UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score + @TheCount WHERE UserID=@dwUserID
	DELETE FROM GMTask WHERE UserID=@dwUserID and TaskID=1

	RETURN @TheCount
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_EfficacyAccounts]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_EfficacyAccounts]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �ʺŵ�½
CREATE PROC GSP_GP_EfficacyAccounts
	@strAccounts NVARCHAR(31),					-- �û��ʺ�
	@strPassword NCHAR(32),						-- �û�����
	@strClientIP NVARCHAR(15),					-- ���ӵ�ַ
	@strMachineSerial NCHAR(32)					-- ������ʶ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @FaceID INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @RegAccounts NVARCHAR(31)
DECLARE @UnderWrite NVARCHAR(63)

-- ��չ��Ϣ
DECLARE @GameID INT
DECLARE @Gender TINYINT
DECLARE @Experience INT
DECLARE @Loveliness INT
DECLARE @MemberOrder INT
DECLARE @MemberOverDate DATETIME
DECLARE @CustomFaceVer TINYINT
DECLARE @IsGuest TINYINT
DECLARE @GOLDSCORE INT
DECLARE @Welfare INT
DECLARE @WelfareLost INT
DECLARE @GMScore INT


-- ��������
DECLARE @EnjoinLogon AS INT
DECLARE @ErrorDescribe AS NVARCHAR(128)
DECLARE @Rule AS NVARCHAR(512)

-- ִ���߼�
BEGIN
	-- Ч���ַ
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineAddress(NOLOCK) WHERE AddrString=@strClientIP AND GETDATE()<EnjoinOverDate
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�������ڵ� IP ��ַ�ĵ�¼���ܣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 4
	END
	
	-- Ч�����
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineMachine(NOLOCK) WHERE MachineSerial=@strMachineSerial AND GETDATE()<EnjoinOverDate
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�����Ļ����ĵ�¼���ܣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 7
	END
 
	-- ��ѯ�û�
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @LogonPass AS NCHAR(32)
	DECLARE	@MachineSerial NCHAR(32)
	DECLARE @MoorMachine AS TINYINT
	SELECT @UserID=UserID, @GameID=GameID,  @Accounts=Accounts, @RegAccounts=RegAccounts, @UnderWrite=UnderWrite, @LogonPass=LogonPass, @FaceID=FaceID,
		@Gender=Gender, @Nullity=Nullity, @StunDown=StunDown, @Experience=Experience, @MemberOrder=MemberOrder, @MemberOverDate=MemberOverDate, 
		@MoorMachine=MoorMachine, @MachineSerial=MachineSerial, @Loveliness=Loveliness,@CustomFaceVer=CustomFaceVer,@IsGuest=IsGuest
	FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts

	-- ��ѯ�û�
	IF @UserID IS NULL
	BEGIN
		SELECT [ErrorDescribe]=N'�����ʺŲ����ڻ������������������֤���ٴγ��Ե�¼��'
		RETURN 1
	END	

	-- �ʺŽ�ֹ
--	IF @Nullity<>0
--	BEGIN
--		SELECT [ErrorDescribe]=N'�����ʺ���ʱ���ڶ���״̬������ϵ�ͻ����������˽���ϸ�����'
--		RETURN 2
--	END	

	-- �ʺŹر�
	IF @StunDown<>0
	BEGIN
		SELECT [ErrorDescribe]=N'�����ʺ�ʹ���˰�ȫ�رչ��ܣ��������¿�ͨ����ܼ���ʹ�ã�'
		RETURN 2
	END	
	
	-- �̶�����
	IF @MoorMachine=1
	BEGIN
		IF @MachineSerial<>@strMachineSerial
		BEGIN
			SELECT [ErrorDescribe]=N'�����ʺ�ʹ�ù̶�������½���ܣ�������ʹ�õĻ���������ָ���Ļ�����'
			RETURN 1
		END
	END

	-- �����ж�
	IF @LogonPass<>@strPassword
	BEGIN
		SELECT [ErrorDescribe]=N'�����ʺŲ����ڻ������������������֤���ٴγ��Ե�¼��'
		RETURN 3
	END

	-- �̶�����
	IF @MoorMachine=2
	BEGIN
		SET @MoorMachine=1
		SET @ErrorDescribe=N'�����ʺųɹ�ʹ���˹̶�������½���ܣ�'
		UPDATE AccountsInfo SET MoorMachine=@MoorMachine, MachineSerial=@strMachineSerial WHERE UserID=@UserID
	END

	-- ��Ա�ȼ�
	IF GETDATE()>=@MemberOverDate 
	BEGIN 
		SET @MemberOrder=0

		-- ɾ�����ڻ�Ա���
		DELETE FROM MemberInfo WHERE UserID=@UserID
	END
	ELSE 
	BEGIN
		DECLARE @MemberCurDate DATETIME

		-- ��ǰ��Աʱ��
		SELECT @MemberCurDate=MIN(MemberOverDate) FROM MemberInfo WHERE UserID=@UserID

		-- ɾ�����ڻ�Ա
		IF GETDATE()>=@MemberCurDate
		BEGIN
			-- ɾ����Ա���޹��ڵ����л�Ա���
			DELETE FROM MemberInfo WHERE UserID=@UserID AND MemberOverDate<=GETDATE()

			-- �л�����һ�����Ա���
			SELECT @MemberOrder=MAX(MemberOrder) FROM MemberInfo WHERE UserID=@UserID
			IF @MemberOrder IS NOT NULL
			BEGIN
				UPDATE AccountsInfo SET MemberOrder=@MemberOrder WHERE UserID=@UserID
			END
			ELSE SET @MemberOrder=0
		END
	END

	--���ͱ�
	EXEC @Welfare=dbo.GSP_GP_UserWelfare @UserID,@WelfareLost output

	-- ��Ϸ��Ϣ
	SELECT @GoldScore=Score FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@UserID

	-- ��Ϣ�ж�
	IF @GoldScore IS NULL
	BEGIN
		-- ��������
		INSERT INTO WHTreasureDB.dbo.GameScoreInfo (UserID, LastLogonIP, RegisterIP)	VALUES (@UserID,@strClientIP,@strClientIP)

		-- ��Ϸ��Ϣ
		SELECT @GoldScore=Score FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@UserID

		SET @Welfare=-2
		SET @WelfareLost=0
	END

	
	--���GM���߷��ŵĽ���
	EXEC @GMScore=dbo.GSP_GP_CheckUserGMScore @UserID
	SET @GoldScore = @GoldScore + @GMScore

	-- ������Ϣ
	UPDATE AccountsInfo SET MemberOrder=@MemberOrder, GameLogonTimes=GameLogonTimes+1,LastLogonDate=GETDATE(),
		LastLogonIP=@strClientIP WHERE UserID=@UserID

	-- ��ѯϵͳ��������
	SET @Rule = N''
	DECLARE c1 cursor for SELECT name,value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and ToClient=1
        DECLARE @sname varchar(32), @svalue varchar(64)  
        OPEN c1  
        FETCH c1 INTO @sname,@svalue  
        WHILE @@fetch_status=0  
        BEGIN  
		IF @Rule = ''  
		BEGIN  
			SET @Rule = @sname + ':' + @svalue
		END
		ELSE 
		BEGIN  
			SET @Rule = @Rule + '|' + @sname + ':' + @svalue
		END 

		FETCH c1 INTO @sname,@svalue  
        END 
	CLOSE c1
	DEALLOCATE c1

	-- ��¼��־
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	UPDATE SystemStreamInfo SET GameLogonSuccess=GameLogonSuccess+1 WHERE DateID=@DateID
	IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, GameLogonSuccess) VALUES (@DateID, 1)

	-- �������
	SELECT @UserID AS UserID, @GameID AS GameID, @Accounts AS Accounts,@RegAccounts AS NickName, @UnderWrite AS UnderWrite, @FaceID AS FaceID, 
		@Gender AS Gender, @Experience AS Experience, @MemberOrder AS MemberOrder, @MemberOverDate AS MemberOverDate,
		@ErrorDescribe AS ErrorDescribe, @Loveliness AS Loveliness,@CustomFaceVer AS CustomFaceVer, @GoldScore AS GoldScore, @Welfare AS Welfare, @WelfareLost AS WelfareLost, @Rule AS LobbyRule, @IsGuest AS IsGuest

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_EfficacyAccounts_v2]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_EfficacyAccounts_v2]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �ʺŵ�½
CREATE PROC GSP_GP_EfficacyAccounts_v2
	@strAccounts NVARCHAR(31),					-- �û��ʺ�
	@strPassword NCHAR(32),						-- �û�����
	@strClientIP NVARCHAR(15),					-- ���ӵ�ַ
	@strMachineSerial NCHAR(32),					-- ������ʶ
	@strLoginServer NVARCHAR(15)		-- ��¼���������ƣ��������ֲ�ͬ�Ŀͻ��ˣ��Է��ز�ͬ������
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @FaceID INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @RegAccounts NVARCHAR(31)
DECLARE @UnderWrite NVARCHAR(63)

-- ��չ��Ϣ
DECLARE @GameID INT
DECLARE @Gender TINYINT
DECLARE @Experience INT
DECLARE @Loveliness INT
DECLARE @MemberOrder INT
DECLARE @MemberOverDate DATETIME
DECLARE @CustomFaceVer TINYINT
DECLARE @IsGuest TINYINT
DECLARE @GOLDSCORE INT
DECLARE @Welfare INT
DECLARE @WelfareLost INT
DECLARE @GMScore INT


-- ��������
DECLARE @EnjoinLogon AS INT
DECLARE @ErrorDescribe AS NVARCHAR(128)
DECLARE @Rule AS NVARCHAR(512)

DECLARE @TheWeekday AS INT --�������ڼ�

-- ִ���߼�
BEGIN
	-- Ч���ַ
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineAddress(NOLOCK) WHERE AddrString=@strClientIP AND GETDATE()<EnjoinOverDate
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�������ڵ� IP ��ַ�ĵ�¼���ܣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 4
	END
	
	-- Ч�����
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineMachine(NOLOCK) WHERE MachineSerial=@strMachineSerial AND GETDATE()<EnjoinOverDate
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�����Ļ����ĵ�¼���ܣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 7
	END
 
	-- ��ѯ�û�
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @LogonPass AS NCHAR(32)
	DECLARE	@MachineSerial NCHAR(32)
	DECLARE @MoorMachine AS TINYINT
	SELECT @UserID=UserID, @Accounts=Accounts, @RegAccounts=RegAccounts, @LogonPass=LogonPass,
		@Gender=Gender, @Nullity=Nullity, @StunDown=StunDown, @MachineSerial=MachineSerial, @IsGuest=IsGuest
	FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts

	-- ��ѯ�û�
	IF @UserID IS NULL
	BEGIN
		SELECT [ErrorDescribe]=N'�����ʺŲ����ڻ������������������֤���ٴγ��Ե�¼��'
		RETURN 1
	END	

	-- �ʺŽ�ֹ
--	IF @Nullity<>0
--	BEGIN
--		SELECT [ErrorDescribe]=N'�����ʺ���ʱ���ڶ���״̬������ϵ�ͻ����������˽���ϸ�����'
--		RETURN 2
--	END	

	-- �ʺŹر�
	IF @StunDown<>0
	BEGIN
		SELECT [ErrorDescribe]=N'�����ʺ�ʹ���˰�ȫ�رչ��ܣ��������¿�ͨ����ܼ���ʹ�ã�'
		RETURN 2
	END	
	
	-- �̶�����
	IF @MoorMachine=1
	BEGIN
		IF @MachineSerial<>@strMachineSerial
		BEGIN
			SELECT [ErrorDescribe]=N'�����ʺ�ʹ�ù̶�������½���ܣ�������ʹ�õĻ���������ָ���Ļ�����'
			RETURN 1
		END
	END

	-- �����ж�
	IF @LogonPass<>@strPassword
	BEGIN
		SELECT [ErrorDescribe]=N'�����ʺŲ����ڻ������������������֤���ٴγ��Ե�¼��'
		RETURN 3
	END

	--���ͱ�
	EXEC @Welfare=dbo.GSP_GP_UserWelfare @UserID,@WelfareLost output

	-- ��Ϸ��Ϣ
	SELECT @GoldScore=Score FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@UserID

	-- ��Ϣ�ж�
	IF @GoldScore IS NULL
	BEGIN
		-- ��������
		INSERT INTO WHTreasureDB.dbo.GameScoreInfo (UserID, LastLogonIP, RegisterIP)	VALUES (@UserID,@strClientIP,@strClientIP)

		-- ��Ϸ��Ϣ
		SELECT @GoldScore=Score FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@UserID

		SET @Welfare=-2
		SET @WelfareLost=0
	END

	
	--���GM���߷��ŵĽ���
	EXEC @GMScore=dbo.GSP_GP_CheckUserGMScore @UserID
	SET @GoldScore = @GoldScore + @GMScore

	-- ������Ϣ
	UPDATE AccountsInfo SET GameLogonTimes=GameLogonTimes+1,LastLogonDate=GETDATE(),
		LastLogonIP=@strClientIP WHERE UserID=@UserID

	-- ��ѯϵͳ��������
	SET @Rule = N''
	DECLARE c1 cursor for SELECT name,value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and ToClient=1 and (LoginServer like '%,'+@strLoginServer+',%' or LoginServer = 'all')
        DECLARE @sname varchar(32), @svalue varchar(64), @nWeekday INT, @nLen INT, @nTemp INT
        OPEN c1  
        FETCH c1 INTO @sname,@svalue  
        WHILE @@fetch_status=0  
        BEGIN  
		
		IF @sname='wx_task'	--�ж���������е�΢�ŷ����Ƿ���ʾ
		BEGIN
			SET @nTemp = 0
			SET @TheWeekday=CONVERT(INT, datepart(weekday, getdate()))-1 --��ǰ���ڼ�
			IF @TheWeekday = 0		--������ʱֵΪ7
				SET @TheWeekday = 7
				
			WHILE @svalue<>''
			BEGIN
				SET @nLen = LEN(@svalue)
				IF @nLen = 1
				BEGIN
					SET @nWeekday = CONVERT(INT, LEFT(@svalue, 1))
					SET @svalue = STUFF(@svalue, 1, 1, '')
				END
				ELSE
				BEGIN
					SET @nWeekday = CONVERT(INT, LEFT(@svalue, CHARINDEX('/', @svalue)-1))
					SET @svalue = STUFF(@svalue, 1, 2, '')
				END
				
				IF @TheWeekday = @nWeekday
				BEGIN
					SET @nTemp = 1
					BREAK
				END
			END
			
			IF @nTemp = 1
			BEGIN
				SET @svalue = '1'
			END
			ELSE 
			BEGIN
				SET @svalue = '0'
			END
		END
		
		IF @Rule = ''  
		BEGIN  
			SET @Rule = @sname + ':' + @svalue
		END
		ELSE 
		BEGIN  
			SET @Rule = @Rule + '|' + @sname + ':' + @svalue
		END 

		FETCH c1 INTO @sname,@svalue  
        END 
	CLOSE c1
	DEALLOCATE c1

	-- �������
	SELECT @UserID AS UserID, 0 AS GameID, @Accounts AS Accounts,@RegAccounts AS NickName, N'' AS UnderWrite, 0 AS FaceID, 
		@Gender AS Gender, 0 AS Experience, 0 AS MemberOrder, 0 AS MemberOverDate,
		@ErrorDescribe AS ErrorDescribe, 0 AS Loveliness,0 AS CustomFaceVer, @GoldScore AS GoldScore, @Welfare AS Welfare, @WelfareLost AS WelfareLost, @Rule AS LobbyRule, @IsGuest AS IsGuest

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
