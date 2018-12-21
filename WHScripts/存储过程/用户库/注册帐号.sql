
----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_RegisterAccounts]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_RegisterAccounts]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �ʺ�ע��
CREATE PROC GSP_GP_RegisterAccounts
	@strAccounts NVARCHAR(31),					-- �û��ʺ�
	@strPassword NCHAR(32),						-- �û�����
	@strSpreader NVARCHAR(31),					-- �ƹ�Ա��
	@wFaceID INT,							-- ͷ���ʶ
	@cbGender TINYINT,							-- �û��Ա�
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
	IF (SELECT COUNT(*) FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strAccounts)>0)>0
	BEGIN
		SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ��������������ʺ������������ַ�����������ʺ������ٴ������ʺţ�'
		RETURN 4
	END

	-- Ч���ַ
	SELECT @EnjoinRegister=EnjoinRegister FROM ConfineAddress(NOLOCK) WHERE AddrString=@strClientIP AND GETDATE()<EnjoinOverDate
	IF @EnjoinRegister IS NOT NULL AND @EnjoinRegister<>0
	BEGIN
		SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�������ڵ� IP ��ַ��ע�Ṧ�ܣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 5
	END
	
	-- Ч�����
	SELECT @EnjoinRegister=EnjoinRegister FROM ConfineMachine(NOLOCK) WHERE MachineSerial=@strMachineSerial AND GETDATE()<EnjoinOverDate
	IF @EnjoinRegister IS NOT NULL AND @EnjoinRegister<>0
	BEGIN
		SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�����Ļ�����ע�Ṧ�ܣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 6
	END
 
	-- ��ѯ�û�
	IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts)
	BEGIN
		SELECT [ErrorDescribe]=N'���ʺ����ѱ�ע�ᣬ�뻻��һ�ʺ����ֳ����ٴ�ע�ᣡ'
		RETURN 7
	END

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
			WHILE @iCount < 100
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
				IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts)
				BEGIN
					SELECT [ErrorDescribe]=N'���ο��ʺ����ѱ�ע�ᣬ�뻻��һ�ʺ����ֳ����ٴ�ע�ᣡ'
					--RETURN 10
				END
				ELSE 
				BEGIN
					BREAK
				END
			END
		END
	END

	IF @iCount = 100
	BEGIN
		SELECT [ErrorDescribe]=N'�ο��ʺ������꣡'
		RETURN 10
	END

	--У���ƹ�Ա��Ϣ @strSpreader
	--Ҫ���ʺŵ��ƹ�Ա���豸�󶨣�ֻ�Ͽ��豸��һ�ΰ�װʱ���ƹ�����
	DECLARE @strOldSpreader NVARCHAR(31)
	DECLARE @strTheSpreader NVARCHAR(31)
	SELECT TOP 1 @strOldSpreader=SpreaderID FROM AccountsInfo WHERE MachineSerial=@strMachineSerial ORDER BY UserID ASC
	IF @strOldSpreader IS NOT NULL
	BEGIN
		--�ӿͻ����ύ�������ţ�����ʱд���ֶ�UnderWrite������
		SET @strTheSpreader = N''
	END
	ELSE
	BEGIN
		SET @strTheSpreader = @strSpreader
	END

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
	SELECT @UserID=UserID, @Accounts=Accounts, @UnderWrite=UnderWrite, @Gender=Gender, @FaceID=FaceID, @Experience=Experience,
		@MemberOrder=MemberOrder, @MemberOverDate=MemberOverDate, @Loveliness=Loveliness,@CustomFaceVer=CustomFaceVer
	FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts

	-- �����ʶ
	SELECT @GameID=GameID FROM GameIdentifier(NOLOCK) WHERE UserID=@UserID
	IF @GameID IS NULL 
	BEGIN
		SET @GameID=0
		SET @ErrorDescribe=N'�û�ע��ɹ�����δ�ɹ���ȡ��Ϸ ID ���룬ϵͳ�Ժ󽫸������䣡'
	END
	ELSE UPDATE AccountsInfo SET GameID=@GameID WHERE UserID=@UserID	
	
	-- ��Ϸ��Ϣ
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

	-- ��¼��־
	DECLARE @DateID INT
	SET @DateID=CAST(CAST(GETDATE() AS FLOAT) AS INT)
	UPDATE SystemStreamInfo SET GameRegisterSuccess=GameRegisterSuccess+1 WHERE DateID=@DateID
	IF @@ROWCOUNT=0 INSERT SystemStreamInfo (DateID, GameRegisterSuccess) VALUES (@DateID, 1)

	-- �������
	SET @IsGuest = 1
	SELECT @UserID AS UserID, @GameID AS GameID, @Accounts AS Accounts, @RegAccounts AS NickName, @GuestPassword AS GuestPassword, @UnderWrite AS UnderWrite, @FaceID AS FaceID, @Gender AS Gender, @Experience AS Experience, @MemberOrder AS MemberOrder, @MemberOverDate AS MemberOverDate,@ErrorDescribe AS ErrorDescribe, @Loveliness AS Loveliness,@CustomFaceVer AS CustomFaceVer,@GoldScore AS GoldScore, @Rule AS LobbyRule, @IsGuest AS IsGuest

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------


USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].GSP_GP_UserCreateGuestAccount') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].GSP_GP_UserCreateGuestAccount
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �һ�����Ʒ
CREATE PROC GSP_GP_UserCreateGuestAccount
	@dwBegin INT,
	@dwCount INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @TheIndex INT
DECLARE @TheAccounts AS NVARCHAR(32)
DECLARE @TmpAccounts AS NVARCHAR(32)

--ע������
DECLARE @ThePassword AS VARCHAR(8)
DECLARE @ThePasswordX AS NVARCHAR(32)


-- ִ���߼�
BEGIN
	SET @TheIndex = 0
	WHILE @TheIndex < @dwCount
	BEGIN
		SET @TheAccounts = 'kaa' + convert(varchar(10), cast(ceiling(rand() * 1000000) as int) + @dwBegin)
		SET @ThePassword = convert(varchar(10),cast(ceiling(rand() * 10000000) as int) + 10000000)
		SET @ThePasswordX = substring(sys.fn_VarBinToHexStr(hashbytes('MD5',@ThePassword)),3,32)

		-- �����Ƿ��ظ�
		SELECT @TmpAccounts=Accounts FROM GuestInfo(NOLOCK) WHERE Accounts=@TheAccounts
		IF @TmpAccounts IS NULL 
		BEGIN
			--�ټ���û���
			SELECT @TmpAccounts=Accounts FROM AccountsInfo(NOLOCK) WHERE Accounts=@TheAccounts
			IF @TmpAccounts IS NULL 
			BEGIN
				--����
				IF @TheIndex%2 = 0
				BEGIN
					INSERT GuestInfo(Accounts, PasswordX, Password, Gender) VALUES(@TheAccounts, @ThePasswordX, @ThePassword, 48)
				END
				ELSE
				BEGIN
					INSERT GuestInfo(Accounts, PasswordX, Password, Gender) VALUES(@TheAccounts, @ThePasswordX, @ThePassword, 49)
				END
				
				SET @TheIndex = @TheIndex + 1
			END
			ELSE
			BEGIN
				SET @TmpAccounts = NULL
			END
		END
		ELSE
		BEGIN
			SET @TmpAccounts = NULL
		END
	END
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------


USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].GSP_GP_UserCreateSpecialAccount') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].GSP_GP_UserCreateSpecialAccount
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ����ʺ�
CREATE PROC GSP_GP_UserCreateSpecialAccount
	@TheA AS NVARCHAR(32),
	@TheP AS VARCHAR(8),
	@TheS AS NVARCHAR(32)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @TheIndex INT
DECLARE @TheAccounts AS NVARCHAR(32)
DECLARE @TmpAccounts AS NVARCHAR(32)

--ע������
DECLARE @ThePassword AS VARCHAR(8)
DECLARE @ThePasswordX AS NVARCHAR(32)


DECLARE	@return_value int

-- ִ���߼�
BEGIN

SET @ThePasswordX = substring(sys.fn_VarBinToHexStr(hashbytes('MD5',@TheP)),3,32)

EXEC	@return_value = [dbo].[GSP_GP_RegisterAccounts]
		@strAccounts = @TheA,
		@strPassword = @ThePasswordX,
		@strSpreader = @TheS,
		@wFaceID = 9999,
		@cbGender = 48,
		@strClientIP = N'1.1.1.1',
		@strMachineSerial = N'1111'

SELECT	'Return Value' = @return_value

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

