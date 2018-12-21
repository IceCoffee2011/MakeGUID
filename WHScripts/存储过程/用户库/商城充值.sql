
USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].GSP_GP_UserMallProduct') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].GSP_GP_UserMallProduct
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �̳ǵ���Ʒ(android)
CREATE PROC GSP_GP_UserMallProduct
	@dwUserID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	--��ѯ�ڵ�
	SELECT productID,productPrice,productImg,productName, CASE 
		WHEN getdate()>HotBeginDate AND getdate()<HotEndDate THEN HotFlag
		ELSE 0 END AS HotFlag, CASE 
		WHEN getdate()>HotBeginDate AND getdate()<HotEndDate THEN ProductNameAdd
		ELSE N'' END AS ProductNameAdd
	FROM [WHGameUserDB].[dbo].[UserMallProduct] where Deleted=0 and Type=0 ORDER BY OrderID

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].GSP_GP_UserMallProduct_IOS') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].GSP_GP_UserMallProduct_IOS
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �̳ǵ���Ʒ(ios)
CREATE PROC GSP_GP_UserMallProduct_IOS
	@dwUserID INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	--��ѯ�ڵ�
	SELECT productID,productPrice,productImg,productName, CASE 
		WHEN getdate()>HotBeginDate AND getdate()<HotEndDate THEN HotFlag
		ELSE 0 END AS HotFlag, CASE 
		WHEN getdate()>HotBeginDate AND getdate()<HotEndDate THEN ProductNameAdd
		ELSE N'' END AS ProductNameAdd
	FROM [WHGameUserDB].[dbo].[UserMallProduct] where Deleted=0 and Type=1 ORDER BY OrderID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserMallPlaceOrder]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserMallPlaceOrder]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �¶���
CREATE PROC GSP_GP_UserMallPlaceOrder
	@dwUserID INT,
	@dwProductID INT,
	@RechargeWay NVARCHAR(10)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheOrderNum NVARCHAR(20)
DECLARE @TheOrderState INT
DECLARE @TheOrderTime DATETIME
DECLARE @TheProductName NVARCHAR(20)
DECLARE @TheProductNameAdd NVARCHAR(20)
DECLARE @TheToken NVARCHAR(20)
DECLARE @TheproductPrice INT
DECLARE @TheProductBilling NVARCHAR(20)
DECLARE @TheRechargeScore INT
DECLARE @TheHotFlag TINYINT

-- ִ���߼�
BEGIN
	--���ڲ���Ϊ��ǰ���ڡ�
	DECLARE @TheTime varchar(20)
	set @TheTime = rtrim(convert(char,getdate(),102))+' '+(convert(char,getdate(),108)) 
	DECLARE @a datetime,@tmp varchar(20),@tmp1 varchar(20)
	set @a=convert(datetime,@TheTime)
	set @tmp=convert(char(8),@a,112)
	
	--set @tmp1=convert(char(6),datepart(hh,@a)*10000 + datepart(mi,@a)*100 + datepart(ss,@a))
	
	--set @tmp=@tmp+@tmp1

	DECLARE @date NVARCHAR(20)
	declare @num nvarchar(20)
	set @date = convert(VARCHAR(20),getdate(),112)--��ʽΪ20130117
	--set @date = rtrim(convert(char,getdate(),112))+''+(convert(char,getdate(),108))
	--�жϱ����Ƿ���ڵ��յ�����
	DECLARE @CountMax nvarchar(20)
	
	--select @CountMax = MAX(OrderID) FROM UserRechargeOrder WHERE convert(varchar(10),rtrim(ltrim(@date))) = convert(varchar(10),rtrim(ltrim(getdate())))
	--���@CountMax�����ڿգ����ʾ�����е��յ�����

	--�����ھ������ڼӡ�0001��Ϊ���յĵ�һ������
	
	set @TheOrderNum =  '91' + @tmp +  '000001'
	SELECT @CountMax = MAX(OrderID) FROM UserRechargeOrder(NOLOCK)
	IF (@CountMax <> '')
		BEGIN
			
			--�ڽ���ȡ������󶩵���ȡ���ұߣ����棩6λ��תΪint�ͼ�һ
			IF (@tmp = right(left(@CountMax,10),8))
				BEGIN
					set @num = convert(varchar(20),convert(int,right(@CountMax,6))+1)
					--��replicate����,�ظ���ֵ��0�������ϸ�λ
					set @num = replicate('0',6-len(@num))+@num
				END
			ELSE
				BEGIN
					set @num = '000001'
				END
			--print @TheOrderNum
			set @TheOrderNum =  '91' + @tmp + @num
		END

	set @date = @a
	set @TheOrderState = 0

	-- ���ȡһ��6λ��
	set @TheToken = cast(ceiling(rand() * 1000000) as int)

--	set @TheOrderTime = (select getdate())
	-- ��ѯ��Ʒ��
	SELECT @TheProductName=ProductName,@TheProductPrice=productPrice,@TheProductBilling=BillingIndex,
	@TheProductNameAdd=(CASE 
		WHEN getdate()>HotBeginDate AND getdate()<HotEndDate THEN ProductNameAdd
		ELSE N'' END),
	@TheRechargeScore=(CASE 
		WHEN getdate()>HotBeginDate AND getdate()<HotEndDate THEN scoreNum+ScoreNumAdd
		ELSE scoreNum END ),
	@TheHotFlag=(CASE 
		WHEN getdate()>HotBeginDate AND getdate()<HotEndDate THEN HotFlag
		ELSE 0 END)
	FROM UserMallProduct(NOLOCK) WHERE @dwProductID = productID
--	SELECT @TheProductPrice = productPrice FROM UserMallProduct(NOLOCK) WHERE @dwProductID = productID
--	SELECT @TheProductBilling = BillingIndex FROM UserMallProduct(NOLOCK) WHERE @dwProductID = productID
--	SELECT @TheRechargeScore=scoreNum FROM UserMallProduct WHERE productID = @dwProductID


	--���붩����
	INSERT INTO UserRechargeOrder(UserID,ProductID,OrderId,ProductName,ProductNameAdd,HotFlag,ProductPrice,RechargeDate,States,RechargeWay,TotalScore) VALUES(@dwUserID,@dwProductID,@TheOrderNum,@TheProductName,@TheProductNameAdd,@TheHotFlag,@TheProductPrice,@date,@TheOrderState,@RechargeWay,@TheRechargeScore)
	--����token��
	INSERT INTO UserToken(UserID,ProductId,RechargeDate,Token,OrderId) VALUES(@dwUserID,@dwProductID,@date,@TheToken,@TheOrderNum)
	
	--�������
	SELECT @TheOrderNum AS dwOrderID, @TheProductName AS productName, @TheToken AS token, @TheproductPrice AS productPrice, @TheProductBilling AS billingIndex

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].GSP_GP_UserCancelOrder') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].GSP_GP_UserCancelOrder
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ȡ������
CREATE PROC GSP_GP_UserCancelOrder
	@dwOrderID nvarchar(20)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	--��ѯ�ڵ�
	delete from UserRechargeOrder where OrderId= @dwOrderID
	--SELECT * FROM UserMallProduct(NOLOCK) WHERE Deleted=0 ORDER BY productID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].GSP_GP_UserMallBuyResult') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].GSP_GP_UserMallBuyResult
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �̳ǹ�����
CREATE PROC GSP_GP_UserMallBuyResult
	@dwOrderNum nvarchar(20)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheUserID INT --���id
DECLARE @TheRechargeScore INT --��ֵ�Ļ��ֶ���
DECLARE @TheProductID INT
DECLARE @ThedwGoldScore INT --��ҵĻ��ֶ���

-- ��������
DECLARE @TheState AS INT --֧��״̬

-- ִ���߼�
BEGIN
	--У��֧��״̬
	SELECT @TheState=States FROM UserRechargeOrder WHERE OrderID = @dwOrderNum
	IF @TheState<>0
	BEGIN
		RETURN 1 --��֧��״̬
	END

	--���¶���״̬��ʱ��
	UPDATE UserRechargeOrder SET States=1,HookDate=getdate() WHERE OrderID = @dwOrderNum
	--
	SELECT @TheUserID=UserID, @TheProductID=productID, @TheRechargeScore=TotalScore FROM UserRechargeOrder WHERE OrderID = @dwOrderNum
--	SELECT @TheRechargeScore=scoreNum FROM UserMallProduct WHERE productID = @TheProductID
	--������һ��ֶ���Ϣ
	UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score + @TheRechargeScore WHERE UserID=@TheUserID
	SELECT @ThedwGoldScore=Score FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@TheUserID

	--���
	SELECT @TheUserID AS UserID, @TheProductID AS productID, @ThedwGoldScore AS dwGoldScore
	
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------



USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].GSP_GP_UserMallUpdateResult') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].GSP_GP_UserMallUpdateResult
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �̳Ǹ��½��
CREATE PROC GSP_GP_UserMallUpdateResult
	@dwOrderNum nvarchar(20)
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheUserID INT --���id
DECLARE @TheRechargeScore INT --��ֵ�Ļ��ֶ���
DECLARE @TheProductID INT
DECLARE @ThedwGoldScore INT --��ҵĻ��ֶ���

-- ��������
DECLARE @TheState AS INT --֧��״̬

-- ִ���߼�
BEGIN
	--У��֧��״̬
	SELECT @TheState=States FROM UserRechargeOrder WHERE OrderID = @dwOrderNum
	IF @TheState<>0
	BEGIN
		RETURN 1 --��֧��״̬
	END

	--���¶���״̬
	UPDATE UserRechargeOrder SET States=1,HookDate=getdate() WHERE OrderID = @dwOrderNum
	
	SELECT @TheUserID=UserID, @TheProductID=productID, @TheRechargeScore=TotalScore FROM UserRechargeOrder WHERE OrderID = @dwOrderNum
	--SELECT @TheRechargeScore=scoreNum FROM UserMallProduct WHERE productID = @TheProductID
	--������һ��ֶ���Ϣ
	UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score + @TheRechargeScore WHERE UserID=@TheUserID
	SELECT @ThedwGoldScore=Score FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@TheUserID

	--���
	SELECT @TheUserID AS UserID, @TheProductID AS productID, @ThedwGoldScore AS dwGoldScore
	
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

