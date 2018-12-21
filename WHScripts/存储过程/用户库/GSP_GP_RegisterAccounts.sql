USE [WHGameUserDB]
GO
/****** Object:  StoredProcedure [dbo].[GSP_GP_RegisterAccounts]    Script Date: 2018/12/21 18:56:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------------------------

-- �ʺ�ע��
create PROC [dbo].[GSP_GP_RegisterAccounts]
	@strAccounts NVARCHAR(31),					-- �û��ʺ�
	@strPassword NCHAR(32),						-- �û�����
	@strSpreader NVARCHAR(31),					-- �ƹ�Ա��
	@wFaceID INT,							    -- ͷ���ʶ
	@cbGender TINYINT,							-- �û��Ա�
	@strClientIP NVARCHAR(15),					-- ���ӵ�ַ
	@strMachineSerial NCHAR(32)					-- ������ʶ
  AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @FaceID INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @RegAccounts NVARCHAR(31)
DECLARE @TmpRegAccounts NVARCHAR(31)
DECLARE @UnderWrite NVARCHAR(63)

-- ��չ��Ϣ
DECLARE @GameID INT
DECLARE @SpreaderID INT
DECLARE @Gender TINYINT
DECLARE @Experience INT
DECLARE @Loveliness INT
DECLARE @MemberOrder INT
DECLARE @MemberOverDate DATETIME
DECLARE @CustomFaceVer TINYINT
DECLARE @IsGuest TINYINT
DECLARE @GOLDSCORE INT

-- ��������
DECLARE @EnjoinLogon AS INT
DECLARE @EnjoinRegister AS INT
DECLARE @ErrorDescribe AS NVARCHAR(128)
DECLARE @Rule AS NVARCHAR(512)
DECLARE @guestAccounts NVARCHAR(31)		-- �ο��ʺ�
DECLARE @guestPasswordX NVARCHAR(32)		-- �ο�����
DECLARE @guestPassword NVARCHAR(32)		-- �ο���������
DECLARE @guestGender TINYINT			-- �ο��Ա�
DECLARE @NeedGuest AS INT			-- �Ƿ���Ҫ�ο��ʺ�
DECLARE @iCount AS INT				-- ѭ��������
DECLARE @TheWeekday AS INT --�������ڼ�

-- ִ���߼�
BEGIN
	-- Ч������
	--IF (SELECT COUNT(*) FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strAccounts)>0)>0
	--BEGIN
	--	SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ��������������ʺ������������ַ�����������ʺ������ٴ������ʺţ�'
	--	RETURN 4
	--END

	-- Ч���ַ
	--SELECT @EnjoinRegister=EnjoinRegister FROM ConfineAddress(NOLOCK) WHERE AddrString=@strClientIP AND GETDATE()<EnjoinOverDate
	--IF @EnjoinRegister IS NOT NULL AND @EnjoinRegister<>0
	--BEGIN
	--	SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�������ڵ� IP ��ַ��ע�Ṧ�ܣ�����ϵ�ͻ����������˽���ϸ�����'
	--	RETURN 5
	--END
	
	-- Ч�����
	--SELECT @EnjoinRegister=EnjoinRegister FROM ConfineMachine(NOLOCK) WHERE MachineSerial=@strMachineSerial AND GETDATE()<EnjoinOverDate
	--IF @EnjoinRegister IS NOT NULL AND @EnjoinRegister<>0
	--BEGIN
	--	SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�����Ļ�����ע�Ṧ�ܣ�����ϵ�ͻ����������˽���ϸ�����'
	--	RETURN 6
	--END
 
	-- ��ѯ�û�
	--IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts)
	--BEGIN
	--	SELECT [ErrorDescribe]=N'���ʺ����ѱ�ע�ᣬ�뻻��һ�ʺ����ֳ����ٴ�ע�ᣡ'
	--	RETURN 7
	--END

	SET @RegAccounts = @strAccounts

	--��ȡ�ο��ʺ�
	SET @NeedGuest = 1
	IF LEN(@strAccounts) = 0
	BEGIN
		--�ȸ��ݻ�������й���
		SELECT TOP 1 @strAccounts=Accounts,@GuestPassword=InsurePass,@TmpRegAccounts=RegAccounts FROM AccountsInfo(NOLOCK) WHERE MachineSerial=@strMachineSerial AND IsGuest=1
		IF LEN(@strAccounts) <> 0
		BEGIN
			--SELECT [ErrorDescribe]=N'���ð��豸���ʺţ�'
			SET @NeedGuest = 0
			SET @RegAccounts = @TmpRegAccounts
		END
		ELSE
		BEGIN
			SET @iCount = 0
			WHILE @iCount < 1
			BEGIN
				SET @iCount = @iCount + 1
				SELECT TOP 1 @guestAccounts=Accounts, @guestPassword=Password, @guestPasswordX=PasswordX, @guestGender=Gender from GuestInfo
				IF @guestAccounts IS NULL
				BEGIN
					SELECT [ErrorDescribe]=N'�ο��˺������ˣ�'
					RETURN 9
				END
				set @strAccounts = @guestAccounts
				set @strPassword = @guestPasswordX
				set @cbGender = @guestGender
				SET @RegAccounts = @strAccounts

				DELETE FROM GuestInfo WHERE Accounts = @strAccounts

				-- ��ѯ�û�
				--IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts)
				--BEGIN
				--	SELECT [ErrorDescribe]=N'���ο��ʺ����ѱ�ע�ᣬ�뻻��һ�ʺ����ֳ����ٴ�ע�ᣡ'
					--RETURN 10
				--END
				--ELSE 
				--BEGIN
				--	BREAK
				--END
			END
		END
	END

	--IF @iCount = 10
	--BEGIN
	--	SELECT [ErrorDescribe]=N'�ο��ʺ������꣡'
	--	RETURN 10
	--END

	--У���ƹ�Ա��Ϣ @strSpreader
	--Ҫ���ʺŵ��ƹ�Ա���豸�󶨣�ֻ�Ͽ��豸��һ�ΰ�װʱ���ƹ�����
	DECLARE @strOldSpreader NVARCHAR(31)
	DECLARE @strTheSpreader NVARCHAR(31)
	--SELECT TOP 1 @strOldSpreader=SpreaderID FROM AccountsInfo WHERE MachineSerial=@strMachineSerial ORDER BY UserID ASC
	--IF @strOldSpreader IS NOT NULL
	--BEGIN
		--�ӿͻ����ύ�������ţ�����ʱд���ֶ�UnderWrite������
	--	SET @strTheSpreader = N''
	--END
	--ELSE
	--BEGIN
		SET @strTheSpreader = @strSpreader
	--END

	IF @NeedGuest <> 0
	BEGIN
		-- ע���û�
		INSERT AccountsInfo (Accounts,RegAccounts,LogonPass,InsurePass,SpreaderID,UnderWrite,Gender,FaceID,MachineSerial,GameLogonTimes,RegisterIP,LastLogonIP,IsGuest)
		VALUES (@strAccounts,@strAccounts,@strPassword,@GuestPassword,@strTheSpreader,@strSpreader,@cbGender,@wFaceID,@strMachineSerial,1,@strClientIP,@strClientIP,1)
		

		-- �����ж�
		IF @@ERROR<>0
		BEGIN
			SELECT [ErrorDescribe]=N'�ʺ��Ѵ��ڣ��뻻��һ�ʺ����ֳ����ٴ�ע�ᣡ'
			RETURN 8
		END
	END

	-- ��ѯ�û�
	DECLARE @Nullity BIT
	SELECT @UserID=UserID, @Accounts=Accounts, @UnderWrite=UnderWrite, @Gender=Gender, @FaceID=FaceID, @Experience=Experience,
		@MemberOrder=MemberOrder, @Nullity=Nullity, @MemberOverDate=MemberOverDate, @Loveliness=Loveliness,@CustomFaceVer=CustomFaceVer
	FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts
	
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

	-- �����ʶ
--	SELECT @GameID=GameID FROM GameIdentifier(NOLOCK) WHERE UserID=@UserID
--	IF @GameID IS NULL 
--	BEGIN
----		SET @GameID=0
--		SET @ErrorDescribe=N'�û�ע��ɹ�����δ�ɹ���ȡ��Ϸ ID ���룬ϵͳ�Ժ󽫸������䣡'
--	END
--	ELSE UPDATE AccountsInfo SET GameID=@GameID WHERE UserID=@UserID	
	
	-- ��Ϸ��Ϣ
	--SET @GoldScore = 0
	SELECT @GoldScore=Score FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@UserID

	-- ��Ϣ�ж�
	IF @GoldScore IS NULL
	BEGIN
		-- ��������
		INSERT INTO WHTreasureDB.dbo.GameScoreInfo (UserID, LastLogonIP, RegisterIP)	VALUES (@UserID,@strClientIP,@strClientIP)

		-- ��Ϸ��Ϣ
		SELECT @GoldScore=Score FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@UserID
	END

	-- ��ѯϵͳ��������
	SET @Rule = N''
	DECLARE c1 cursor for SELECT name,value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and ToClient=1
        DECLARE @sname varchar(32), @svalue varchar(64), @nWeekday INT, @nLen INT, @nTemp INT
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
	--׷��ip��Ϣ
	SET @Rule = @Rule + '|ip:' + @strClientIP

	-- ��¼��־
--	DECLARE @DateID INT
--	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
--	UPDATE SystemStreamInfo SET GameRegisterSuccess=GameRegisterSuccess+1 WHERE DateID=@DateID
--	IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, GameRegisterSuccess) VALUES (@DateID, 1)

	-- �������
	SET @IsGuest = 1
	SELECT @UserID AS UserID, @GameID AS GameID, @Accounts AS Accounts, @RegAccounts AS NickName, @GuestPassword AS GuestPassword, @UnderWrite AS UnderWrite, @FaceID AS FaceID, @Gender AS Gender, @Experience AS Experience, @MemberOrder AS MemberOrder, @MemberOverDate AS MemberOverDate,@ErrorDescribe AS ErrorDescribe, @Loveliness AS Loveliness,@CustomFaceVer AS CustomFaceVer,@GoldScore AS GoldScore, @Rule AS LobbyRule, @IsGuest AS IsGuest

END

RETURN 0

