USE [WHTreasureDB]
GO
/****** Object:  StoredProcedure [dbo].[GSP_GR_EfficacyUserID]    Script Date: 2018/12/21 20:24:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec GSP_GR_EfficacyUserID 1103000,'d41d8cd98f00b204e9800998ecf8427e','127.0.0.1','',999,10010
----------------------------------------------------------------------------------------------------

-- I D ��¼
create PROC [dbo].[GSP_GR_EfficacyUserID]
	@dwUserID INT,								-- �û� I D
	@strPassword NCHAR(32),						-- �û�����
	@strClientIP NVARCHAR(15),					-- ���ӵ�ַ
	@strMachineSerial NCHAR(32),				-- ������ʶ
	@wKindID INT,								-- ��Ϸ I D
	@wServerID INT								-- ���� I D
  AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @FaceID INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @UnderWrite NVARCHAR(63)

-- ��չ��Ϣ
DECLARE @GameID INT
DECLARE @GroupID INT
DECLARE @UserRight INT
DECLARE @Gender TINYINT
DECLARE @Loveliness INT
DECLARE @MasterRight INT
DECLARE @MasterOrder INT
DECLARE @MemberOrder INT
DECLARE @MemberOverDate DATETIME
DECLARE @GroupName NVARCHAR(31)
DECLARE @CustomFaceVer TINYINT

-- ���ֱ���
DECLARE @GameGold INT
DECLARE @InsureScore INT
DECLARE @Score INT
DECLARE @WinCount INT
DECLARE @LostCount INT
DECLARE @DrawCount INT
DECLARE @FleeCount INT
DECLARE @Experience INT

DECLARE @gmaeKindId INT
DECLARE @gameServerID INT
DECLARE @paramsInfo NVARCHAR(256)
-- ������Ϣ
DECLARE @PropCount INT

-- ��������
DECLARE @EnjoinLogon BIGINT
DECLARE @ErrorDescribe AS NVARCHAR(128)

DECLARE @TheVipOrder INT
-- ִ���߼�
BEGIN
	-- Ч���ַ
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineAddress(NOLOCK) WHERE AddrString=@strClientIP AND GETDATE()<EnjoinOverDate
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�������ڵ� IP ��ַ����Ϸ��¼Ȩ�ޣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 8
	END
	
	-- Ч�����
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineMachine(NOLOCK) WHERE MachineSerial=@strMachineSerial AND GETDATE()<EnjoinOverDate
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�����Ļ�������Ϸ��¼Ȩ�ޣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 7
	END
 
	-- ��ѯ�û�
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @LogonPass AS NCHAR(32)
	DECLARE	@MachineSerial NCHAR(32)
	DECLARE @MoorMachine AS TINYINT
	SELECT @UserID=UserID, @GameID=GameID, @Accounts=RegAccounts, @LogonPass=LogonPass,
		@Gender=Gender, @Nullity=Nullity, @StunDown=StunDown, @Experience=Experience,
		@MoorMachine=MoorMachine, @MachineSerial=MachineSerial, @TheVipOrder = MemberOrder
	FROM WHGameUserDB.dbo.AccountsInfo WHERE UserID=@dwUserID

	-- ��ѯ�û�
	IF @UserID IS NULL
	BEGIN
		SELECT [ErrorDescribe]=N'�����ʺŲ����ڻ������������������֤���ٴγ��Ե�¼��'
		RETURN 1
	END	

	-- �ʺŽ�ֹ
	IF @Nullity<>0
	BEGIN
		--SELECT [ErrorDescribe]=N'�����ʺ���ʱ���ڶ���״̬������ϵ�ͻ����������˽���ϸ�����'
		--SELECT @paramsInfo = Comment FROM GMTaskLog WHERE UserID = @dwUserID
		-- �ж��Ƿ񳬹����ʱ��
		DECLARE @passDate DATETIME
		DECLARE @FinishDate DATETIME
		SET @passDate =( select max(StartDate) FROM [WHGameUserDB].[dbo].[GMTaskLog] where UserID = @UserID and TaskID = 2)
		-- ��ȡ��ǰʱ��Ľ��ʱ��
		SELECT @FinishDate = SubmitDate FROM [WHGameUserDB].[dbo].[GMTaskLog] where UserID = @UserID and StartDate = @passDate
		IF getDate() > @FinishDate and @passDate < @FinishDate 
		BEGIN
			SELECT [ErrorDescribe]=N'�����ʺ��Ѿ���⣬�����µ�¼��'
			-- �����ʺ���Ϣ
			UPDATE WHGameUserDB.dbo.AccountsInfo SET Nullity = 0 WHERE UserID=@UserID and Nullity = 1
			RETURN 5
		END	
		IF EXISTS (SELECT * FROM UserUnBind(NOLOCK) WHERE UserID=@UserID and (Type=1 or getDate()<FinishDate))
		BEGIN
			SELECT [ErrorDescribe]=N'�����ʺ��Ѿ���⣬�����µ�¼��'
			-- �����ʺ���Ϣ
			UPDATE WHGameUserDB.dbo.AccountsInfo SET Nullity = 0 WHERE UserID=@UserID and Nullity = 1
			RETURN 5
		END
		--SELECT @paramsInfo = Params FROM WHGameUserDB.dbo.GMTaskLog WHERE UserID=@dwUserID
		IF @passDate IS NULL
		BEGIN
			SELECT [ErrorDescribe]=N'�����ʺ�'+convert(varchar(15),@UserID)+N'���ڳ���δ��¼�ѱ����ᣬ����ϵ�ͷ����.'
		END
		ELSE
		BEGIN
			SELECT [ErrorDescribe] = Params FROM WHGameUserDB.dbo.GMTaskLog 
			WHERE UserID=@UserID and TaskID = 2 and StartDate = ( select max(StartDate) FROM [WHGameUserDB].[dbo].[GMTaskLog] where UserID = @UserID)
		END
		
		RETURN 2
	END

	-- �ʺŹر�
	IF @StunDown<>0
	BEGIN
		SELECT [ErrorDescribe]=N'�����ʺ�ʹ���˰�ȫ�رչ��ܣ����뵽���¿�ͨ����ܼ���ʹ�ã�'
		RETURN 2
	END	
	
	-- �̶�����
	IF @MoorMachine=1
	BEGIN
		IF @MachineSerial<>@strMachineSerial
		BEGIN
			-- �ҳ����ڵ���Ϸ�뷿��
			SELECT @gmaeKindId=KindID, @gameServerID=ServerID FROM GameScoreLocker(NOLOCK) WHERE UserID=@dwUserID
		
			SELECT [ErrorDescribe] = CONVERT(varchar(10),@gmaeKindId) + '|' + CONVERT(varchar(10),@gameServerID)
			--SELECT [ErrorDescribe]=N'�����ʺ�ʹ�ù̶�������¼���ܣ�������ʹ�õĻ���������ָ���Ļ�����'
			RETURN 1
		END
	END

	---- �����ж�
	--IF @LogonPass<>@strPassword
	--BEGIN
	--	SELECT [ErrorDescribe]=N'�����ʺŲ����ڻ������������������֤���ٴγ��ԣ�',����1=@LogonPass,����2=@strPassword
	--	RETURN 3
	--END


	-- ��������
	IF EXISTS (SELECT UserID FROM GameScoreLocker WHERE UserID=@dwUserID and ServerID!=@wServerID )
	BEGIN
		-- �ҳ����ڵ���Ϸ�뷿��
		SELECT @gmaeKindId=KindID, @gameServerID=ServerID FROM GameScoreLocker(NOLOCK) WHERE UserID=@dwUserID
		
		SELECT [ErrorDescribe] = CONVERT(varchar(10),@gmaeKindId) + '|' + CONVERT(varchar(10),@gameServerID)
		--SELECT [ErrorDescribe]=N'���Ѿ���������Ϸ�����ˣ�����ͬʱ�ڽ������Ϸ�����ˣ�'
		RETURN 4
	END
	DELETE FROM GameScoreLocker WHERE UserID=@dwUserID
	INSERT GameScoreLocker (UserID,KindID,ServerID) VALUES (@dwUserID,@wKindID,@wServerID)

	-- ��Ϸ��Ϣ
	SELECT @Score=Score, @InsureScore=InsureScore, @WinCount=WinCount, @LostCount=LostCount, @DrawCount=DrawCount,
		@DrawCount=DrawCount
	FROM GameScoreInfo WHERE UserID=@dwUserID

	-- ��Ϣ�ж�
	IF @Score IS NULL
	BEGIN
		SELECT [ErrorDescribe]=N'ȱ�ټ�¼��'
		RETURN 5
	END

	-- ������Ϣ
	UPDATE GameScoreInfo SET AllLogonTimes=AllLogonTimes+1, LastLogonDate=GETDATE(), LastLogonIP=@strClientIP WHERE UserID=@dwUserID

	-- ���
	SET @GameGold=@Score

	-- �����¼
	INSERT RecordUserEnter (UserID, Score, KindID, ServerID, ClientIP) VALUES (@UserID, @Score, @wKindID, @wServerID, @strClientIP)

		-- ��Ϸ��Ϣ
	SELECT @WinCount=WinTotal, @LostCount=LostTotal, @FleeCount=FleeTotal
	FROM GameToday WHERE UserID = @dwUserID and KindID = @wKindID
	
	IF @FleeCount IS NULL
	BEGIN
		set @FleeCount = 0
		set @WinCount = 0
		set @LostCount = 0
		set @DrawCount = 0
	END
	-- �������
	SELECT @UserID AS UserID, 0 AS GameID, 0 AS GroupID, @Accounts AS Accounts, N'' AS UnderWrite, 0 AS FaceID, 
		@Gender AS Gender, N'' AS GroupName, @TheVipOrder AS MemberOrder, 0 AS UserRight, 0 AS MasterRight, 
		0 AS MasterOrder, @TheVipOrder AS MemberOrder, @WinCount AS WinCount, @LostCount AS LostCount, 0 AS Loveliness,
		0 AS PropCount, @GameGold AS GameGold, 0 AS InsureScore, 0 AS Loveliness, 0 AS CustomFaceVer,
		@DrawCount AS DrawCount, @FleeCount AS FleeCount, @Score AS Score, @Experience AS Experience, @ErrorDescribe AS ErrorDescribe

END

RETURN 0

