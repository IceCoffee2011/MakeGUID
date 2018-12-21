
----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_CheckID]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_CheckID]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ������Ϣ
CREATE PROC GSP_GP_CheckID
	@strAccount NVARCHAR(31)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��������
DECLARE @TheUserID INT
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @TheUserID=UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccount

	-- ��ѯ�û�
	IF @TheUserID IS NULL
	BEGIN
		set @ErrorDescribe = N'�����ʺŲ����ڣ�'

		-- �������
		SELECT @ErrorDescribe AS ErrorDescribe, @strAccount AS Accounts
		RETURN 0
	END	

	set @ErrorDescribe = N'�����ʺ��Ѵ��ڣ�'

	-- �������
	SELECT @ErrorDescribe AS ErrorDescribe, @strAccount AS Accounts
	RETURN 1
END

RETURN 1

GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_CheckNicKName]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_CheckNicKName]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ������Ϣ
CREATE PROC GSP_GP_CheckNicKName
	@strNickName NVARCHAR(31)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��������
DECLARE @TheUserID INT
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @TheUserID=UserID FROM AccountsInfo(NOLOCK) WHERE RegAccounts=@strNickName

	-- ��ѯ�û�
	IF @TheUserID IS NULL
	BEGIN
		set @ErrorDescribe = N'�����ǳƲ����ڣ�'

		-- �������
		SELECT @ErrorDescribe AS ErrorDescribe, @strNickName AS Accounts
		RETURN 0
	END	

	set @ErrorDescribe = N'�����ǳ��Ѵ��ڣ�'

	-- �������
	SELECT @ErrorDescribe AS ErrorDescribe, @strNickName AS Accounts
	RETURN 1
END

RETURN 1

GO
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_Register]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_Register]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- ע��
CREATE PROC GSP_GP_Register
	@strAccounts NVARCHAR(31),					-- �û��ʺ�
	@strNickName NVARCHAR(31),					-- �û��ǳ�
	@strPhone NVARCHAR(31),						-- �û��ֻ�
	@strPassword NCHAR(32),						-- �û�����
	@cbGender TINYINT,						-- �û��Ա�
	@strClientIP NVARCHAR(15),					-- ���ӵ�ַ
	@strMachineSerial NCHAR(32),					-- ������ʶ
	@strChannel NVARCHAR(32)					-- ������
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @ReturnCode INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @NickName NVARCHAR(31)

-- ��չ��Ϣ
DECLARE @Gender TINYINT
DECLARE @EnjoinRegister AS INT

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN

	-- Ч������
	IF (SELECT COUNT(*) FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strAccounts)>0)>0
	BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'��Ǹ��֪ͨ��������������ʺ������������ַ�����������ʺ������ٴ������ʺţ�'
		RETURN 3
	END

	-- Ч���ǳ�
	IF (SELECT COUNT(*) FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strNickName)>0)>0
	BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'��Ǹ��֪ͨ��������������ǳƺ��������ַ�����������ǳƺ��ٴ������ʺţ�'
		RETURN 4
	END

	-- Ч���ַ
	SELECT @EnjoinRegister=EnjoinRegister FROM ConfineAddress(NOLOCK) WHERE AddrString=@strClientIP AND GETDATE()<EnjoinOverDate
	IF @EnjoinRegister IS NOT NULL AND @EnjoinRegister<>0
	BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�������ڵ� IP ��ַ��ע�Ṧ�ܣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 5
	END
	
	-- Ч�����
	SELECT @EnjoinRegister=EnjoinRegister FROM ConfineMachine(NOLOCK) WHERE MachineSerial=@strMachineSerial AND GETDATE()<EnjoinOverDate
	IF @EnjoinRegister IS NOT NULL AND @EnjoinRegister<>0
	BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�����Ļ�����ע�Ṧ�ܣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 6
	END
 
	-- ��ѯ�û�
	IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts)
	BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'���ʺ����ѱ�ע�ᣬ�뻻��һ�ʺ����ֳ����ٴ�ע�ᣡ'
		RETURN 7
	END

	-- ��ѯ�ǳ�
	IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE RegAccounts=@strNickName)
	BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'���ǳ��ѱ�ע�ᣬ�뻻��һ�ǳƳ����ٴ�ע�ᣡ'
		RETURN 8
	END

	-- ע���û�
	IF @strPhone <> N''
	BEGIN
		INSERT AccountsInfo (Accounts,RegAccounts,Phone,LogonPass,InsurePass,Gender,MachineSerial,GameLogonTimes,RegisterIP,LastLogonIP,UnderWrite)
		VALUES (@strAccounts,@strNickName,@strPhone,@strPassword,N'',@cbGender,@strMachineSerial,1,@strClientIP,@strClientIP,@strChannel)
	END
	ELSE BEGIN
		INSERT AccountsInfo (Accounts,RegAccounts,LogonPass,InsurePass,Gender,MachineSerial,GameLogonTimes,RegisterIP,LastLogonIP,UnderWrite)
		VALUES (@strAccounts,@strNickName,@strPassword,N'',@cbGender,@strMachineSerial,1,@strClientIP,@strClientIP,@strChannel)
	END
	

	-- �����ж�
	IF @@ERROR<>0
	BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'�ʺ��Ѵ��ڣ��뻻��һ�ʺ����ֳ����ٴ�ע�ᣡ'
		RETURN 9
	END
	ELSE BEGIN
		SET @ErrorDescribe = N'ע��ɹ���'
	END

	-- �������
	SELECT @ErrorDescribe AS ErrorDescribe, @strAccounts AS Accounts
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_IDUpdate]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_IDUpdate]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- ����
CREATE PROC GSP_GP_IDUpdate
	@strAccounts NVARCHAR(31),					-- �û��ʺ�
	@strAccountsNew NVARCHAR(31),					-- �û����ʺ�
	@strNickName NVARCHAR(31),					-- �û��ǳ�
	@strPassword NCHAR(32),						-- �û�����
	@cbGender TINYINT						-- �û��Ա�
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @ReturnCode INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @NickName NVARCHAR(31)

-- ��չ��Ϣ
DECLARE @Gender TINYINT
DECLARE @EnjoinUpdate AS INT

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN

	-- Ч������
	IF (SELECT COUNT(*) FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strAccountsNew)>0)>0
	BEGIN
		SELECT @strAccountsNew AS Accounts, [ErrorDescribe]=N'��Ǹ��֪ͨ��������������ʺ������������ַ�����������ʺ������ٴ������ʺţ�'
		RETURN 3
	END

	-- Ч���ǳ�
	IF (SELECT COUNT(*) FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strNickName)>0)>0
	BEGIN
		SELECT @strAccountsNew AS Accounts, [ErrorDescribe]=N'��Ǹ��֪ͨ��������������ǳƺ��������ַ�����������ǳƺ��ٴ������ʺţ�'
		RETURN 4
	END

	-- ��ѯ�ǳ�
	IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE RegAccounts=@strNickName and Accounts!=@strAccounts)
	BEGIN
		SELECT @strAccountsNew AS Accounts, [ErrorDescribe]=N'���ǳ��ѱ�ע�ᣬ�뻻��һ�ǳƳ����ٴ�ע�ᣡ'
		RETURN 8
	END

	-- ��ѯ�û�
	IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts)
	BEGIN
		--����
		UPDATE AccountsInfo SET RegAccounts=@strNickName,Phone=@strAccountsNew,LogonPass=@strPassword,InsurePass=@strPassword,Gender=@cbGender,Accounts=@strAccountsNew,IsGuest=0
		WHERE Accounts=@strAccounts
		
		-- �����ж�
		IF @@ERROR<>0
		BEGIN
			SELECT @strAccountsNew AS Accounts, [ErrorDescribe]=N'�����ʺ�ʧ�ܣ�'
			RETURN 9
		END
		ELSE BEGIN
			SELECT @strAccountsNew AS Accounts, [ErrorDescribe]=N'�����ɹ���'
			RETURN 0
		END
	END


	-- �������
	SET @ErrorDescribe=N'ԭ�ʺŲ�����'
	SELECT @strAccountsNew AS Accounts, @ErrorDescribe AS ErrorDescribe
END

RETURN 10

GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- ��ѯ�û���Ϣ
CREATE PROC GSP_GP_UserInfo
	@strAccounts NVARCHAR(31)					-- �û��ʺ�
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @ReturnCode INT
DECLARE @Accounts NVARCHAR(31)
DECLARE @NickName NVARCHAR(31)
DECLARE @Phone NVARCHAR(31)

-- ��չ��Ϣ
DECLARE @Gender TINYINT

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID, @Gender=Gender, @NickName=RegAccounts, @Phone=Phone, @Accounts=Accounts
	FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts

	IF @UserID IS NULL 
	BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'�ʺŲ����ڣ�'
		RETURN 1
	END

	-- �������
	SELECT @ErrorDescribe AS ErrorDescribe, @Gender AS Gender, @NickName AS NickName, @Phone AS Phone, @Accounts AS Accounts
	RETURN 0
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ResetPwd]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ResetPwd]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- ��������
CREATE PROC GSP_GP_ResetPwd
	@strAccounts NVARCHAR(31),					-- �û��ʺ�
	@strPassword NVARCHAR(32)					-- �û�����
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @ReturnCode INT

-- ��չ��Ϣ
DECLARE @Accounts NVARCHAR(31)

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts

	IF @UserID IS NULL 
	BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'�ʺŲ����ڣ�'
		RETURN 1
	END

	--����
	UPDATE AccountsInfo SET LogonPass=@strPassword
	WHERE Accounts=@strAccounts

	-- �����ж�
	IF @@ERROR<>0
	BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'��������ʧ�ܣ�'
		RETURN 9
	END
	ELSE BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'��������ɹ���'
		RETURN 0
	END
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ModifyIndividual]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ModifyIndividual]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- �޸��û���Ϣ
CREATE PROC GSP_GP_ModifyIndividual
	@strAccounts NVARCHAR(31),					-- �û��ʺ�
	@strNickName NVARCHAR(31),					-- �û��ǳ�
	@strPhone NCHAR(31),						-- �ֻ���
	@cbGender TINYINT						-- �û��Ա�
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @ReturnCode INT

-- ��չ��Ϣ

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID FROM AccountsInfo(NOLOCK) WHERE Accounts=@strAccounts

	IF @UserID IS NULL 
	BEGIN
		SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'�ʺŲ����ڣ�'
		RETURN 1
	END

	--����
	SET @ReturnCode = 0
	IF @strNickName <> N''
	BEGIN
		-- Ч���ǳ�
		IF (SELECT COUNT(*) FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strNickName)>0)>0
		BEGIN
			SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'��Ǹ��֪ͨ��������������ǳƺ��������ַ�����������ǳơ���'
			RETURN 4
		END

		-- ��ѯ�ǳ�
		IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE RegAccounts=@strNickName)
		BEGIN
			SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'���ǳ��ѱ�ע�ᣬ�뻻��һ�ǳƣ�'
			RETURN 8
		END

		UPDATE AccountsInfo SET RegAccounts=@strNickName WHERE Accounts=@strAccounts

		-- �����ж�
		IF @@ERROR<>0
		BEGIN
			SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'�޸��ǳ�ʧ�ܣ�'
			RETURN 9
		END
	END
	
	IF @strPhone <> N''
	BEGIN
		UPDATE AccountsInfo SET Phone=@strPhone WHERE Accounts=@strAccounts

		-- �����ж�
		IF @@ERROR<>0
		BEGIN
			SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'���ֻ�ʧ�ܣ�'
			RETURN 10
		END
	END

	IF @cbGender <> 0
	BEGIN
		UPDATE AccountsInfo SET Gender=@cbGender WHERE Accounts=@strAccounts

		-- �����ж�
		IF @@ERROR<>0
		BEGIN
			SELECT @strAccounts AS Accounts, [ErrorDescribe]=N'�޸��Ա�ʧ�ܣ�'
			RETURN 11
		END
	END

	-- �������
	SELECT @ErrorDescribe AS ErrorDescribe, @strAccounts AS Accounts
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_GetIDCard]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_GetIDCard]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- ��ѯ�û�ʵ����֤��Ϣ
CREATE PROC GSP_GP_GetIDCard
	@dwUserID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @IDName NVARCHAR(32)
DECLARE @IDCard NVARCHAR(32)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID, @IDName=IDName, @IDCard=IDCard  FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	IF @UserID IS NULL 
	BEGIN
		RETURN 1
	END

	-- �������
	SELECT @IDName AS IDName, @IDCard AS IDCard
	RETURN 0
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_CommitIDCard]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_CommitIDCard]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- �޸��û�ʵ����֤��Ϣ
CREATE PROC GSP_GP_CommitIDCard
	@dwUserID INT,
	@IDName NVARCHAR(32),
	@IDCard NVARCHAR(32)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	IF @UserID IS NULL 
	BEGIN
		RETURN 1
	END

	--����
	UPDATE AccountsInfo SET IDName=@IDName, IDCard=@IDCard WHERE UserID=@dwUserID

	RETURN 0
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserBankInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserBankInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- ��ѯ�û�������Ϣ
CREATE PROC GSP_GP_UserBankInfo
	@dwUserID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	IF @UserID IS NULL 
	BEGIN
		RETURN 1
	END

	--�Ƿ�������Ϸ����
	IF EXISTS (SELECT UserID FROM WHTreasureDB.dbo.GameScoreLocker WHERE UserID=@dwUserID)
	BEGIN
		RETURN 2
	END

	--��ѯ�Ƹ�
	SELECT Score AS curScore, BankScore AS bankScore FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserBankCharge]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserBankCharge]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- �û���������
CREATE PROC GSP_GP_UserBankCharge
	@nOpCode INT,
	@dwUserID INT,
	@dwCurScore INT,
	@dwBankScore INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @CurScore INT
DECLARE @BankScore INT
DECLARE @IncScore INT
DECLARE @DescScore INT

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	IF @UserID IS NULL 
	BEGIN
		RETURN 1
	END

	--�Ƿ�������Ϸ����
	IF EXISTS (SELECT UserID FROM WHTreasureDB.dbo.GameScoreLocker WHERE UserID=@dwUserID)
	BEGIN
		RETURN 2
	END

	--��ѯ�Ƹ�
	SELECT @CurScore=Score, @BankScore=BankScore FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
	IF @CurScore IS NULL 
	BEGIN
		RETURN 3
	END

	--�Ƹ��ܺͲ��ܱ仯
	SET @IncScore = @dwCurScore - @CurScore
	SET @DescScore = @BankScore - @dwBankScore
	IF @IncScore <>  @DescScore OR @dwCurScore < 0 OR @dwBankScore < 0
	BEGIN
		RETURN 4
	END

	--�����Ϸ���
	IF @nOpCode = 1
	BEGIN
		--��
		IF (@dwCurScore >= @CurScore) OR (@dwBankScore <= @BankScore)
		BEGIN
			RETURN 6
		END
	END
	ELSE IF @nOpCode = 2
	BEGIN
		--ȡ
		IF (@dwCurScore <= @CurScore) OR (@dwBankScore >= @BankScore)
		BEGIN
			RETURN 7
		END
	END
	ELSE
	BEGIN
		RETURN 5
	END

	--д��
	UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score + @IncScore, BankScore = BankScore - @DescScore WHERE UserID=@dwUserID
	--д��־
	INSERT INTO WHTreasureDB.dbo.GameBankLog(UserID, ExpectScore, ExpectBankScore, OpCode, PreScore, PreBankScore, IncScore, DescScore) VALUES(@dwUserID, @dwCurScore, @dwBankScore, @nOpCode, @CurScore, @BankScore, @IncScore, @DescScore)
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_GetActivityList]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_GetActivityList]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ��б�
CREATE PROC GSP_GP_GetActivityList
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	-- �������
	SELECT TOP 5 ID,Type,Title,Text,IconUrl,LinkUrl,CASE 
		WHEN getdate()<BeginDate AND Type=2 THEN '1'
		WHEN getdate()>EndDate AND Type=2 THEN '3'
		WHEN Type=2 THEN '2'
		ELSE '0' END AS Status
	FROM UserActivity WHERE Deleted=0 ORDER BY OrderID

END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_GetActivity]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_GetActivity]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ�
CREATE PROC GSP_GP_GetActivity
	@dwUserID INT,
	@dwActivityID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @CheckDate INT
DECLARE @UserID INT
DECLARE @KindID INT
DECLARE @MaxAmount INT
DECLARE @HadAmount INT
DECLARE @TotalAmount INT
DECLARE @DengAmount INT
DECLARE @Unit INT
DECLARE @ImageUrl NVARCHAR(50)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID
	IF @UserID IS NULL 
	BEGIN
		RETURN 1
	END

	-- ��ѯ�
	SELECT @KindID=KindID, @ImageUrl=ImageUrl, @Unit=CAST(Param AS INT) FROM UserActivity(NOLOCK) WHERE ID=@dwActivityID AND Deleted=0
	IF @KindID IS NULL 
	BEGIN
		RETURN 2
	END

	
	-- У�����ݣ�
	--У��ʱ��
	SELECT @CheckDate=ID FROM UserActivity WHERE ID=@dwActivityID AND Deleted=0 AND getdate()>BeginDate AND getdate()<EndDate
	IF @CheckDate IS NULL 
	BEGIN
		SET @MaxAmount = 0
		SET @HadAmount = 0
		SET @TotalAmount = 0
	END
	ELSE
	BEGIN
		-- ͳ������
		SELECT @TotalAmount=Win4Activity+Lost4Activity+Flee4Activity FROM WHTreasureDB.dbo.GameToday(NOLOCK) WHERE UserID=@dwUserID AND KindID=@KindID
		SELECT @HadAmount=count(*) FROM UserActivityR(NOLOCK) WHERE UserID=@dwUserID AND ActivityID=@dwActivityID

		--ת���ɴ���
		SET @MaxAmount = @TotalAmount / @Unit
	END

	-- �����
	SELECT @DengAmount=count(*) FROM  UserActivityR(NOLOCK) WHERE ActivityID=@dwActivityID
	IF @DengAmount IS NULL
	BEGIN
		SELECT N'' AS UserName, N'' AS PrizeName,@ImageUrl AS ImageUrl, @MaxAmount AS M, @HadAmount AS N, @TotalAmount AS T, @Unit AS U
		RETURN 0
	END
	IF @DengAmount = 0
	BEGIN
		SELECT N'' AS UserName, N'' AS PrizeName,@ImageUrl AS ImageUrl, @MaxAmount AS M, @HadAmount AS N, @TotalAmount AS T, @Unit AS U
		RETURN 0
	END 

	-- ȡ����ʾ���������
	--SELECT N'' AS UserName, N'' AS PrizeName,@ImageUrl AS ImageUrl, @MaxAmount AS M, @HadAmount AS N, @TotalAmount AS T, @Unit AS U
	--��ʾ��������ݣ�ȡǰ5��
	SELECT TOP 5 UserName,PrizeName,@ImageUrl AS ImageUrl, @MaxAmount AS M, @HadAmount AS N, @TotalAmount AS T, @Unit AS U
	FROM  UserActivityR(NOLOCK) WHERE ActivityID=@dwActivityID Order By Price Desc, ExchangeDate Desc

	RETURN 0
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_GetActivityLuckyList]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_GetActivityLuckyList]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ���齱���б�
CREATE PROC GSP_GP_GetActivityLuckyList
	@dwUserID INT,
	@dwActivityID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @UserID INT
DECLARE @KindID INT
DECLARE @MaxAmount INT
DECLARE @HadAmount INT
DECLARE @TotalAmount INT
DECLARE @Unit INT

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID
	IF @UserID IS NULL 
	BEGIN
		RETURN 1
	END

	-- ��ѯ�
	SELECT @KindID=KindID, @Unit=CAST(Param AS INT) FROM UserActivity(NOLOCK) WHERE ID=@dwActivityID AND Deleted=0
	IF @KindID IS NULL 
	BEGIN
		RETURN 2
	END

	-- ͳ������
	SELECT @TotalAmount=Win4Activity+Lost4Activity+Flee4Activity FROM WHTreasureDB.dbo.GameToday(NOLOCK) WHERE UserID=@dwUserID AND KindID=@KindID
	SELECT @HadAmount=count(*) FROM UserActivityR(NOLOCK) WHERE UserID=@dwUserID AND ActivityID=@dwActivityID
	
	-- У�����ݣ�
	--ת���ɴ���
	SET @MaxAmount = @TotalAmount / @Unit
	IF @HadAmount >= @MaxAmount
	BEGIN
		RETURN 3
	END

	--���Թ��齱����Ʒ
	SELECT PrizeID AS PID, PrizeUrl, Price, PrizeName, Stock, Possibility, MaxCount, 
		(SELECT count(*) FROM UserActivityR WHERE PrizeID = UserActivityPrize.PrizeID AND DateDiff(day, getdate(), ExchangeDate)=0) AS TodayCount
	FROM UserActivityPrize WHERE Deleted=0 AND ActivityID=@dwActivityID

END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_GetActivityLucky]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_GetActivityLucky]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------


-- ��ȡָ����Ʒ
CREATE PROC GSP_GP_GetActivityLucky
	@dwUserID INT,
	@dwActivityID INT,
	@dwPrizeID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @UserID INT
DECLARE @szUserName NVARCHAR(32)
DECLARE @KindID INT
DECLARE @MaxAmount INT
DECLARE @HadAmount INT
DECLARE @TotalAmount INT
DECLARE @Unit INT
DECLARE @Stock INT
DECLARE @TotalCount INT
DECLARE @TodayCount INT
DECLARE @MaxCount INT
DECLARE @Price INT
DECLARE @PrizeType INT
DECLARE @szPrizeName NVARCHAR(49)
DECLARE @szPrizeUrl NVARCHAR(49)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @UserID=UserID, @szUserName=RegAccounts FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID
	IF @UserID IS NULL 
	BEGIN
		RETURN 1
	END

	-- ��ѯ�
	SELECT @KindID=KindID, @Unit=CAST(Param AS INT) FROM UserActivity(NOLOCK) WHERE ID=@dwActivityID AND Deleted=0 AND getdate()>BeginDate AND getdate()<EndDate
	IF @KindID IS NULL 
	BEGIN
		RETURN 2
	END

	-- ͳ������
	SELECT @TotalAmount=Win4Activity+Lost4Activity+Flee4Activity FROM WHTreasureDB.dbo.GameToday(NOLOCK) WHERE UserID=@dwUserID AND KindID=@KindID
	SELECT @HadAmount=count(*) FROM UserActivityR(NOLOCK) WHERE UserID=@dwUserID AND ActivityID=@dwActivityID
	
	-- У�����ݣ�
	--ת���ɴ���
	SET @MaxAmount = @TotalAmount / @Unit
	IF @HadAmount >= @MaxAmount
	BEGIN
		RETURN 3
	END

	--���Թ��齱����Ʒ
	SELECT @Price=Price, @szPrizeUrl=PrizeUrl, @szPrizeName=PrizeName, @Stock=Stock, @MaxCount=MaxCount,@PrizeType=PrizeType FROM UserActivityPrize WHERE  PrizeID=@dwPrizeID and ActivityID=@dwActivityID
	SELECT @TodayCount=count(*) FROM UserActivityR WHERE PrizeID=@dwPrizeID and ActivityID=@dwActivityID AND DateDiff(day, getdate(), ExchangeDate)=0

	--У�����
	IF @Stock IS NULL
	BEGIN
		RETURN 4
	END

	IF @Stock <= 0
	BEGIN
		RETURN 5
	END

	IF @TodayCount >= @MaxCount
	BEGIN
		RETURN 6
	END

	--���Գ���
	UPDATE UserActivityPrize SET Stock = Stock -1 WHERE PrizeID=@dwPrizeID and ActivityID=@dwActivityID
	IF @PrizeType = 1
	BEGIN
		INSERT INTO UserActivityR(UserID, UserName, ActivityID, PrizeID, PrizeName, Price, Status, AttachInfo) 
			VALUES(@dwUserID, @szUserName, @dwActivityID, @dwPrizeID, @szPrizeName, @Price, N'�ѷ���', N'System')
		--�����ֶ�
		UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score + @Price WHERE UserID=@dwUserID
	END
	ELSE
	BEGIN
		INSERT INTO UserActivityR(UserID, UserName, ActivityID, PrizeID, PrizeName, Price) 
			VALUES(@dwUserID, @szUserName, @dwActivityID, @dwPrizeID, @szPrizeName, @Price)
	END

	--������
	SELECT @dwPrizeID AS PID, @szPrizeUrl AS PrizeUrl, @Price AS Price, @szPrizeName AS PrizeName
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------


USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].GSP_GP_GetActivityRecord') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].GSP_GP_GetActivityRecord
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �齱��¼
CREATE PROC GSP_GP_GetActivityRecord
	@dwUserID INT,
	@dwActivityID INT,
	@nPage INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheTotal INT
DECLARE @TheFirst INT
DECLARE @TheSQL	NVARCHAR(512)

-- ִ���߼�
BEGIN
	--��ѯ����
	SELECT @TheTotal=count(*) FROM UserActivityR(NOLOCK) WHERE UserID=@dwUserID AND ActivityID=@dwActivityID

	-- ÿҳ��
	set @TheFirst = 6*@nPage
	set @TheSQL=N'SELECT TOP 6 *,CONVERT(varchar,ExchangeDate,102)AS D,(select count(*) from UserActivityR WHERE UserID='
				+convert(varchar(10),@dwUserID)
				+N' AND ActivityID='
				+convert(varchar(10),@dwActivityID)
				+N')AS T FROM UserActivityR WHERE UserID='
				+convert(varchar(10),@dwUserID)
				+N' AND ActivityID='
				+convert(varchar(10),@dwActivityID)
				+N' AND(ID NOT IN(SELECT TOP '
				+convert(varchar(10),@theFirst)
				+N' ID FROM UserActivityR WHERE UserID='
				+convert(varchar(10),@dwUserID)
				+N' AND ActivityID='
				+convert(varchar(10),@dwActivityID)
				+N' ORDER BY ID DESC))ORDER BY ID DESC'

	exec sp_executesql @TheSQL;  
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
