
----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserExchangeInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserExchangeInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ������Ϣ
CREATE PROC GSP_GP_UserExchangeInfo
	@dwUserID INT,
	@strPhone NCHAR(31)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheUserID INT
DECLARE @TheGold INT
DECLARE @ThePhone AS NVARCHAR(31)

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
		RETURN 1
	END	

	-- �Ƿ��жһ���Ϣ
	SELECT @TheGold=Gold,  @ThePhone=Phone
	FROM UserExchangeInfo(NOLOCK) WHERE UserID=@dwUserID 

	IF @TheGold IS NULL
	BEGIN
		set @TheGold = 0
		set @ThePhone = N''
		INSERT INTO UserExchangeInfo(UserID, Gold, Phone) VALUES(@dwUserID, @TheGold, @ThePhone)
		set @ErrorDescribe = N'�״��ύ�һ���Ϣ�ɹ���'
	END
	ELSE
	BEGIN
		IF LEN(@strPhone) > 0
		BEGIN
			UPDATE UserExchangeInfo SET Phone = @strPhone WHERE UserID=@dwUserID 
			set @ErrorDescribe = N'������Ϣ�ɹ���'
			set @ThePhone = @strPhone
		END
	END

	-- �������
	SELECT @TheGold AS Gold, @ThePhone AS Phone, @ErrorDescribe AS ErrorDescribe

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].GSP_GP_UserExchangeProduct') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].GSP_GP_UserExchangeProduct
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �һ�����Ʒ
CREATE PROC GSP_GP_UserExchangeProduct
	@dwUserID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	--��ѯ�ڵ�
	SELECT * FROM UserExchangeProduct(NOLOCK) WHERE Deleted=0 ORDER BY OrderID,AwardID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserExchange]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserExchange]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �һ�
CREATE PROC GSP_GP_UserExchange
	@dwUserID INT,
	@dwAwardID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheUserID INT
DECLARE @TheGold INT
DECLARE @TheAwardID INT
DECLARE @TheLeft INT
DECLARE @ThePrice INT
DECLARE @TheExchangeDate DATETIME
DECLARE @ScoreNum INT
DECLARE @TheType INT

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)
DECLARE @TheAwardName AS NVARCHAR(32)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @TheUserID=UserID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- ��ѯ�û�
	IF @TheUserID IS NULL
	BEGIN
		set @ErrorDescribe = N'�����ʺŲ����ڣ�'
		RETURN 1
	END	

	-- ��ѯ��Ʒ
	SELECT @TheAwardID=AwardID, @TheAwardName=AwardName, @TheLeft=Lefts, @ThePrice=Price, @ScoreNum=ScoreNum, @TheType=Type FROM UserExchangeProduct(NOLOCK) WHERE AwardID=@dwAwardID

	-- ��ѯ��Ʒ
	IF @TheAwardID IS NULL
	BEGIN
		set @ErrorDescribe = N'��Ʒ�����ڣ�'
		RETURN 2
	END

	-- ���Ƿ�
	SELECT @TheGold=Gold FROM UserExchangeInfo(NOLOCK) WHERE UserID=@dwUserID 

	-- �Ƿ��п��
	IF @TheLeft > 0 AND @TheGold >= @ThePrice
	BEGIN
		set @TheExchangeDate = (select getdate())
		set @TheGold = @TheGold - @ThePrice 
		UPDATE UserExchangeInfo SET Gold = @TheGold WHERE UserID = @dwUserID
		UPDATE UserExchangeProduct SET Lefts = Lefts - 1 WHERE AWARDID = @dwAwardID

		INSERT INTO UserExchgR(UserID, AwardID, AwardName, Price, ExchangeDate, TotalScore) VALUES(@dwUserID, @dwAwardID, @TheAwardName, @ThePrice, @TheExchangeDate, 0)

		set @ErrorDescribe = N'�һ��ɹ���'

		IF @TheType = 1
		BEGIN
			--ͳ�ƽ���һ����ֶ�����
			DECLARE @TheIDDou INT
			SELECT @TheIDDou=ID FROM WHTreasureDB.dbo.GameDayStatistics WHERE Type=5 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDDou IS NULL
			BEGIN
				INSERT INTO WHTreasureDB.dbo.GameDayStatistics(Type, Value) VALUES(5, @ThePrice)
			END
			ELSE
			BEGIN
				UPDATE WHTreasureDB.dbo.GameDayStatistics SET Value = Value + @ThePrice WHERE ID=@TheIDDou
			END
		END
		ELSE
		BEGIN
			--ͳ�ƽ���һ���������
			DECLARE @TheIDHua INT
			SELECT @TheIDHua=ID FROM WHTreasureDB.dbo.GameDayStatistics WHERE Type=4 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDHua IS NULL
			BEGIN
				INSERT INTO WHTreasureDB.dbo.GameDayStatistics(Type, Value) VALUES(4, @ThePrice)
			END
			ELSE
			BEGIN
				UPDATE WHTreasureDB.dbo.GameDayStatistics SET Value = Value + @ThePrice WHERE ID=@TheIDHua
			END

		END
	END
	ELSE
	BEGIN
		set @ErrorDescribe = N'��治�㣡'
		RETURN 3
	END

	-- �������
	SELECT @ErrorDescribe AS ErrorDescribe, @TheGold AS Gold, @TheAwardID AS AwardID, @ScoreNum AS TotalScore
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserExchange_V2]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserExchange_V2]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �һ�
CREATE PROC GSP_GP_UserExchange_V2
	@dwUserID INT,
	@dwAwardID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheUserID INT
DECLARE @TheGold INT
DECLARE @TheAwardID INT
DECLARE @TheLeft INT
DECLARE @ThePrice INT
DECLARE @TheExchangeDate DATETIME
DECLARE @ScoreNum INT
DECLARE @TheType INT

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)
DECLARE @TheAwardName AS NVARCHAR(32)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @TheUserID=UserID FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- ��ѯ�û�
	IF @TheUserID IS NULL
	BEGIN
		set @ErrorDescribe = N'�����ʺŲ����ڣ�'
		RETURN 1
	END	

	-- ��ѯ��Ʒ
	SELECT @TheAwardID=AwardID, @TheAwardName=AwardName, @TheLeft=Lefts, @ThePrice=Price, @ScoreNum=ScoreNum, @TheType=Type FROM UserExchangeProduct(NOLOCK) WHERE AwardID=@dwAwardID

	-- ��ѯ��Ʒ
	IF @TheAwardID IS NULL
	BEGIN
		set @ErrorDescribe = N'��Ʒ�����ڣ�'
		RETURN 2
	END

	-- ���Ƿ�
	SELECT @TheGold=Gold FROM UserExchangeInfo(NOLOCK) WHERE UserID=@dwUserID 

	-- �Ƿ��п��
	IF @TheLeft > 0 AND @TheGold >= @ThePrice
	BEGIN
		set @TheExchangeDate = (select getdate())
		set @TheGold = @TheGold - @ThePrice 
		UPDATE UserExchangeInfo SET Gold = @TheGold WHERE UserID = @dwUserID
		UPDATE UserExchangeProduct SET Lefts = Lefts - 1 WHERE AWARDID = @dwAwardID

		--���Ż��ֶ�
		IF @TheType = 1
		BEGIN
			INSERT INTO UserExchgR(UserID, AwardID, AwardName, Price, ExchangeDate, TotalScore, Status, AttachInfo) VALUES(@dwUserID, @dwAwardID, @TheAwardName, @ThePrice, @TheExchangeDate, @ScoreNum, N'�ѷ���', N'system')
			UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score + @ScoreNum WHERE UserID = @dwUserID
			SELECT @ScoreNum = Score FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID = @dwUserID

			--ͳ�ƽ���һ����ֶ�����
			DECLARE @TheIDDou INT
			SELECT @TheIDDou=ID FROM WHTreasureDB.dbo.GameDayStatistics WHERE Type=5 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDDou IS NULL
			BEGIN
				INSERT INTO WHTreasureDB.dbo.GameDayStatistics(Type, Value) VALUES(5, @ThePrice)
			END
			ELSE
			BEGIN
				UPDATE WHTreasureDB.dbo.GameDayStatistics SET Value = Value + @ThePrice WHERE ID=@TheIDDou
			END
		END
		ELSE
		BEGIN
			INSERT INTO UserExchgR(UserID, AwardID, AwardName, Price, ExchangeDate, TotalScore) VALUES(@dwUserID, @dwAwardID, @TheAwardName, @ThePrice, @TheExchangeDate, @ScoreNum)

			--ͳ�ƽ���һ���������
			DECLARE @TheIDHua INT
			SELECT @TheIDHua=ID FROM WHTreasureDB.dbo.GameDayStatistics WHERE Type=4 AND DATEDIFF(day,CollectDate,GETDATE())=0 
			IF @TheIDHua IS NULL
			BEGIN
				INSERT INTO WHTreasureDB.dbo.GameDayStatistics(Type, Value) VALUES(4, @ThePrice)
			END
			ELSE
			BEGIN
				UPDATE WHTreasureDB.dbo.GameDayStatistics SET Value = Value + @ThePrice WHERE ID=@TheIDHua
			END
		END

		set @ErrorDescribe = N'�һ��ɹ���'
	END
	ELSE
	BEGIN
		set @ErrorDescribe = N'��治�㣡'
		RETURN 3
	END

	-- �������
	SELECT @ErrorDescribe AS ErrorDescribe, @TheGold AS Gold, @TheAwardID AS AwardID, @ScoreNum AS TotalScore
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].GSP_GP_UserExchangeRecord') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].GSP_GP_UserExchangeRecord
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �һ���¼
CREATE PROC GSP_GP_UserExchangeRecord
	@dwUserID INT,
	@nPage INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheTotal INT
DECLARE @TheFirst INT
DECLARE @TheSQL	NVARCHAR(256)

-- ִ���߼�
BEGIN
	--��ѯ����
	SELECT @TheTotal=count(*) FROM UserExchgR(NOLOCK) WHERE UserID=@dwUserID

	-- ÿҳ��
	set @TheFirst = 6*@nPage
	set @TheSQL=N'SELECT TOP 6 *,CONVERT(varchar,ExchangeDate,102)AS D,(select count(*) from UserExchgR WHERE UserID='
				+convert(varchar(10),@dwUserID)
				+N')AS T FROM UserExchgR WHERE UserID='
				+convert(varchar(10),@dwUserID)
				+N' AND(ID NOT IN(SELECT TOP '
				+convert(varchar(10),@theFirst)
				+N' ID FROM UserExchgR WHERE UserID='
				+convert(varchar(10),@dwUserID)
				+N' ORDER BY ID DESC))ORDER BY ID DESC'

	exec sp_executesql @TheSQL;  
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
