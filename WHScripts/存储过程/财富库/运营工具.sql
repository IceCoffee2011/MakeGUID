----------------------------------------------------------------------------------------------------

USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_WriteStatistics]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_WriteStatistics]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ����ͳ������
CREATE PROC GSP_GR_WriteStatistics
	@dwType INT,
	@dwDay INT,
	@dwHour INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @ID INT
DECLARE @Score BIGINT
DECLARE @BankScore BIGINT

DECLARE @RechargeAdd BIGINT
DECLARE @GmAdd BIGINT
DECLARE @ExchangeAdd BIGINT
DECLARE @SigninAdd BIGINT
DECLARE @AwardAdd BIGINT
DECLARE @NewerAdd BIGINT
DECLARE @WelfareAdd BIGINT
DECLARE @RevenueDel BIGINT
DECLARE @GmDel BIGINT

DECLARE @TotalAdd BIGINT
DECLARE @TotalDel BIGINT

-- ִ���߼�
BEGIN
	--ͳ�ƽ������ʣ��
	DECLARE @TheID INT
	SELECT @TheID=ID FROM GameDayStatistics(NOLOCK) WHERE Type=1 AND DATEDIFF(day,CollectDate,GETDATE())=0 
	IF @TheID IS NULL
	BEGIN
		DECLARE @TheTotalGold INT
		SELECT @TheTotalGold=SUM(Gold) FROM WHGameUserDB.dbo.UserExchangeInfo
		INSERT INTO GameDayStatistics(Type, Value) VALUES(1, @TheTotalGold)
	END

	-- �����������
	SELECT @ID=ID FROM GameScoreStatistics WHERE DateDiff(dd, CollectDate, GetDate()) = 0
	-- ����ж�
	IF @ID IS NOT NULL
	BEGIN
		--����������
		RETURN 1
	END

	--���ɽ��������
	--�ܲƸ�
	SELECT @Score=sum(Score),@BankScore=sum(BankScore) FROM GameScoreInfo

	--��ֵ
	IF @dwType = 1
	BEGIN
		SELECT @RechargeAdd=SUM(TotalScore) FROM WHGameUserDB.dbo.UserRechargeOrder WHERE States=1 AND RechargeDate > convert(varchar(10),getdate() - @dwDay,120) AND RechargeDate <convert(varchar(10),getdate(),120)
	END
	ELSE
	BEGIN
		SELECT @RechargeAdd=SUM(TotalScore) FROM WHGameUserDB.dbo.UserRechargeOrder WHERE States=1 AND datediff(hour,RechargeDate,getdate()) <= @dwHour
	END
	IF @RechargeAdd IS NULL
	BEGIN
		SET @RechargeAdd = 0
	END
	
	--GM����
	IF @dwType = 1
	BEGIN
		SELECT @GmAdd=SUM(CAST(Params as int)) FROM WHGameUserDB.dbo.GMTaskLog WHERE TaskID=1 and status='�ɹ�' AND FinishDate > convert(varchar(10),getdate() - @dwDay,120) AND FinishDate <convert(varchar(10),getdate(),120)
	END
	ELSE
	BEGIN
		SELECT @GmAdd=SUM(CAST(Params as int)) FROM WHGameUserDB.dbo.GMTaskLog WHERE TaskID=1 and status='�ɹ�'  AND datediff(hour,FinishDate,getdate()) <= @dwHour
	END
	IF @GmAdd IS NULL
	BEGIN
		SET @GmAdd = 0
	END

	--�һ�
	IF @dwType = 1
	BEGIN
		SELECT @ExchangeAdd=SUM(TotalScore) FROM WHGameUserDB.dbo.UserExchgR WHERE Status='�ѷ���' AND ExchangeDate > convert(varchar(10),getdate() - @dwDay,120) AND ExchangeDate <convert(varchar(10),getdate(),120)
	END
	ELSE
	BEGIN
		SELECT @ExchangeAdd=SUM(TotalScore) FROM WHGameUserDB.dbo.UserExchgR WHERE Status='�ѷ���'  AND datediff(hour,ExchangeDate,getdate()) <= @dwHour
	END
	IF @ExchangeAdd IS NULL
	BEGIN
		SET @ExchangeAdd = 0
	END

	--ǩ��
	IF @dwType = 1
	BEGIN
		SELECT @SigninAdd=SUM(Score) FROM WHGameUserDB.dbo.UserScoreLog WHERE Type=1 and CollectDate > convert(varchar(10),getdate() - @dwDay,120) AND CollectDate <convert(varchar(10),getdate(),120)
	END
	ELSE
	BEGIN
		SELECT @SigninAdd=SUM(Score) FROM WHGameUserDB.dbo.UserScoreLog WHERE Type=1 and datediff(hour,CollectDate,getdate()) <= @dwHour
	END
	IF @SigninAdd IS NULL
	BEGIN
		SET @SigninAdd = 0
	END


	--��������
	IF @dwType = 1
	BEGIN
		SELECT @AwardAdd=SUM(Score) FROM WHGameUserDB.dbo.UserGetAward WHERE LatestDate > convert(varchar(10),getdate() - @dwDay,120) AND LatestDate <convert(varchar(10),getdate(),120)
	END
	ELSE
	BEGIN
		SELECT @AwardAdd=SUM(Score) FROM WHGameUserDB.dbo.UserGetAward WHERE datediff(hour,LatestDate,getdate()) <= @dwHour
	END
	IF @AwardAdd IS NULL
	BEGIN
		SET @AwardAdd = 0
	END

	--����
	IF @dwType = 1
	BEGIN
		SELECT @NewerAdd=count(*)*10000 FROM WHGameUserDB.dbo.AccountsInfo WHERE RegisterDate > convert(varchar(10),getdate() - @dwDay,120) AND RegisterDate <convert(varchar(10),getdate(),120)
	END
	ELSE
	BEGIN
		SELECT @NewerAdd=count(*)*10000 FROM WHGameUserDB.dbo.AccountsInfo WHERE datediff(hour,RegisterDate,getdate()) <= @dwHour
	END
	IF @NewerAdd IS NULL
	BEGIN
		SET @NewerAdd = 0
	END

	--�ͱ�
	IF @dwType = 1
	BEGIN
		SELECT @WelfareAdd=SUM(Score) FROM WHGameUserDB.dbo.UserScoreLog WHERE Type=2 and CollectDate > convert(varchar(10),getdate() - @dwDay,120) AND CollectDate <convert(varchar(10),getdate(),120)
	END
	ELSE
	BEGIN
		SELECT @WelfareAdd=SUM(Score) FROM WHGameUserDB.dbo.UserScoreLog WHERE Type=2 and datediff(hour,CollectDate,getdate()) <= @dwHour
	END
	IF @WelfareAdd IS NULL
	BEGIN
		SET @WelfareAdd = 0
	END

	--GM����
	IF @dwType = 1
	BEGIN
		SELECT @GmDel=SUM(CAST(Params as int)) FROM WHGameUserDB.dbo.GMTaskLog WHERE TaskID=6 and status='�ɹ�' AND FinishDate > convert(varchar(10),getdate() - @dwDay,120) AND FinishDate <convert(varchar(10),getdate(),120)
	END
	ELSE
	BEGIN
		SELECT @GmDel=SUM(CAST(Params as int)) FROM WHGameUserDB.dbo.GMTaskLog WHERE TaskID=6 and status='�ɹ�'  AND datediff(hour,FinishDate,getdate()) <= @dwHour
	END
	IF @GmDel IS NULL
	BEGIN
		SET @GmDel = 0
	END

	--��ˮ
	IF @dwType = 1
	BEGIN
		SELECT @RevenueDel=SUM(Revenue) FROM WHTreasureDB.dbo.RecordUserLeave WHERE LeaveTime > convert(varchar(10),getdate() - @dwDay,120) and LeaveTime <convert(varchar(10),getdate(),120)
	END
	ELSE
	BEGIN
		SELECT @RevenueDel=SUM(Revenue) FROM WHTreasureDB.dbo.RecordUserLeave WHERE datediff(hour,LeaveTime,getdate()) <= @dwHour
	END
	IF @RevenueDel IS NULL
	BEGIN
		SET @RevenueDel = 0
	END

	--������������
	SET @TotalAdd = @RechargeAdd + @GmAdd + @ExchangeAdd + @SigninAdd + @AwardAdd + @NewerAdd + @WelfareAdd
	SET @TotalDel = @RevenueDel + @GmDel
	INSERT INTO GameScoreStatistics(Total, TotalAdd, TotalDel, Score, BankScore, RechargeAdd, GmAdd, ExchangeAdd, SigninAdd, AwardAdd, NewerAdd, WelfareAdd, RevenueDel, GmDel) VALUES(@Score+@BankScore, @TotalAdd, @TotalDel, @Score, @BankScore, @RechargeAdd, @GmAdd, @ExchangeAdd, @SigninAdd, @AwardAdd, @NewerAdd, @WelfareAdd, @RevenueDel, @GmDel)
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_WriteRanking]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_WriteRanking]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �������а�
CREATE PROC GSP_GR_WriteRanking
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	-- ���������
	TRUNCATE TABLE GameScoreRanking
	
	--RankingStatusΪ1ʱ�ǲμ�����
	INSERT INTO GameScoreRanking(UserID, Score, RankingStatus) SELECT TOP 50 UserID, Score, RankingStatus FROM GameScoreInfo where RankingStatus=1 ORDER BY Score DESC
	
	--ʵ�ʵ�����û��ʵ���ϵ��ô�
	--INSERT INTO GameScoreRanking(UserID, Score) SELECT TOP 50 UserID, Score FROM GameScoreInfo ORDER BY Score DESC

	-- �����ǳƣ��Ա�
	UPDATE t SET t.NickName=u.RegAccounts,t.Gender=u.Gender, t.DescribeInfo=u.UnderWrite FROM GameScoreRanking as t,WHGameUserDB.dbo.AccountsInfo AS u WHERE  t.UserID=u.UserID

	--ͳ��:1/2��ʾ����Ȼ��/�����Сʱ��1�죬24Сʱ
	EXEC dbo.GSP_GR_WriteStatistics 1,1,24
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetRanking_V2]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetRanking_V2]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ���а�
CREATE PROC GSP_GR_GetRanking_V2
	@dwUserID INT,								-- �û� I D
	@nPage INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @MyRank INT
DECLARE @TheFirst INT
DECLARE @TheSQL	NVARCHAR(256)

-- ִ���߼�
BEGIN
	--SELECT @szDescribe=DescribeInfo FROM AccountsInfo WHERE UserID=@dwUserID AND RankingStatus=1
	SELECT @MyRank=ID FROM GameScoreRanking WHERE UserID=@dwUserID AND RankingStatus=1
	-- ����ж�
	IF @MyRank IS NULL
	BEGIN
		SET @MyRank = 0
	END
	
	-- ÿҳ��
	set @TheFirst = 6*@nPage
	set @TheSQL=N'SELECT TOP 6 *,Convert(varchar(16),[CreateDate],120) AS D,'
				+convert(varchar(10),@MyRank)
				+N'AS Mine,(select count(*) from GameScoreRanking WHERE RankingStatus=1)AS T FROM GameScoreRanking WHERE(ID NOT IN(SELECT TOP '
				+convert(varchar(10),@theFirst)
				+N' ID FROM GameScoreRanking ORDER BY ID)) AND RankingStatus=1'

	exec sp_executesql @TheSQL; 
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetRanking]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetRanking]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ���а�
CREATE PROC GSP_GR_GetRanking
	@dwUserID INT,								-- �û� I D
	@nPage INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @MyRank INT
DECLARE @TheFirst INT
DECLARE @TheSQL	NVARCHAR(256)

-- ִ���߼�
BEGIN

	SELECT @MyRank=ID FROM GameScoreRanking WHERE UserID=@dwUserID AND RankingStatus=1
	-- ����ж�
	IF @MyRank IS NULL
	BEGIN
		SET @MyRank = 0
	END
	
	-- ÿҳ��
	set @TheFirst = 6*@nPage
	set @TheSQL=N'SELECT TOP 6 *,Convert(varchar(16),[CreateDate],120) AS D,'
				+convert(varchar(10),@MyRank)
				+N'AS Mine,(select count(*) from GameScoreRanking WHERE RankingStatus=1)AS T FROM GameScoreRanking WHERE(ID NOT IN(SELECT TOP '
				+convert(varchar(10),@theFirst)
				+N' ID FROM GameScoreRanking ORDER BY ID)) AND RankingStatus=1'

	exec sp_executesql @TheSQL; 
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetUserRankingStatus]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetUserRankingStatus]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ������а�״̬
CREATE PROC GSP_GR_GetUserRankingStatus
	@dwUserID INT								-- �û� I D
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @TheRankingStatus INT

-- ִ���߼�
BEGIN
	SELECT @TheRankingStatus=RankingStatus FROM GameScoreInfo WHERE UserID=@dwUserID
	-- ����ж�
	IF @TheRankingStatus IS NULL
	BEGIN
		SET @TheRankingStatus = 1
	END

	SELECT @TheRankingStatus AS RS
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------


USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_ModifyRankingStatus]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_ModifyRankingStatus]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- �����Ƿ������а�
CREATE PROC GSP_GR_ModifyRankingStatus
	@dwUserID INT,								-- �û� I D
	@nRankingStatus INT
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	update GameScoreInfo set RankingStatus=@nRankingStatus
	where UserID=@dwUserID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetTaskStat]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetTaskStat]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ��ҵ�����ͳ������
CREATE PROC GSP_GR_GetTaskStat
	@dwUserID INT								-- �û� I D
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @WinToday3 INT
DECLARE @LostToday3 INT
DECLARE @WinTotal3 INT
DECLARE @LostTotal3 INT
DECLARE @WinToday4 INT
DECLARE @LostToday4 INT
DECLARE @WinTotal4 INT
DECLARE @LostTotal4 INT
DECLARE @AwardToday3 INT
DECLARE @AwardToday4 INT
DECLARE @AwardAll3 INT
DECLARE @AwardAll4 INT
DECLARE @TheDate NVARCHAR(31)

-- ִ���߼�
BEGIN
	--���˹�������
	SELECT @WinToday3=Win,@LostToday3=Lost,@WinTotal3=WinTotal,@LostTotal3=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
	FROM GameToday WHERE UserID=@dwUserID and KindID=998
	-- ����ж�
	IF @WinToday3 IS NULL
	BEGIN
		SET @WinToday3 = 0
		SET @LostToday3 = 0
		SET @WinTotal3 = 0
		SET @LostTotal3 = 0
	END
	ELSE
	BEGIN
		IF @TheDate <> Convert(varchar(10),getDate(),120)
		BEGIN
			--���ǽ���
			SET @WinToday3 = 0
			SET @LostToday3 = 0
		END
	END

	--���˹�������
	SELECT @WinToday4=Win,@LostToday4=Lost,@WinTotal4=WinTotal,@LostTotal4=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
	FROM GameToday WHERE UserID=@dwUserID and KindID=997
	-- ����ж�
	IF @WinToday4 IS NULL
	BEGIN
		SET @WinToday4 = 0
		SET @LostToday4 = 0
		SET @WinTotal4 = 0
		SET @LostTotal4 = 0
	END
	ELSE
	BEGIN
		IF @TheDate <> Convert(varchar(10),getDate(),120)
		BEGIN
			--���ǽ���
			SET @WinToday4 = 0
			SET @LostToday4 = 0
		END
	END

	--���˹�ÿ���������콱�׶�
	SELECT @AwardToday3=count(*)
	FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
	WHERE UserID=@dwUserID and TaskID in (3,4,5) and datediff(day,[LatestDate],getdate())=0

	--���˹�ÿ���������콱�׶�
	SELECT @AwardToday4=count(*)
	FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
	WHERE UserID=@dwUserID and TaskID in (6,7,8) and datediff(day,[LatestDate],getdate())=0

	--���˹�ϵͳ�������콱�׶�
	SELECT @AwardAll3=count(*)
	FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
	WHERE UserID=@dwUserID and TaskID >=10 and TaskID <=22 

	--���˹�ϵͳ�������콱�׶�
	SELECT @AwardAll4=count(*)
	FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
	WHERE UserID=@dwUserID and TaskID >=30 and TaskID <=42 

	-- �������
	SELECT @WinToday3 AS wtoday3, @LostToday3 AS ltoday3, @WinTotal3 AS wtotal3, @LostTotal3 AS ltotal3,
	@WinToday4 AS wtoday4, @LostToday4 AS ltoday4, @WinTotal4 AS wtotal4, @LostTotal4 AS ltotal4,
	@AwardToday3 AS atoday3, @AwardToday4 AS atoday4, @AwardAll3 AS atotal3, @AwardAll4 AS atotal4
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

USE WHTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_GetTaskStat_v2]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_GetTaskStat_v2]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��ȡ��ҵ�����ͳ������
CREATE PROC GSP_GR_GetTaskStat_v2
	@dwUserID INT,				-- �û� I D
	@strLoginServer NVARCHAR(15)		-- ��¼���������ƣ��������ֲ�ͬ�Ŀͻ��ˣ��Է��ز�ͬ������
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @WinToday3 INT
DECLARE @LostToday3 INT
DECLARE @WinTotal3 INT
DECLARE @LostTotal3 INT
DECLARE @WinToday4 INT
DECLARE @LostToday4 INT
DECLARE @WinTotal4 INT
DECLARE @LostTotal4 INT
DECLARE @AwardToday3 INT
DECLARE @AwardToday4 INT
DECLARE @AwardAll3 INT
DECLARE @AwardAll4 INT
DECLARE @TheDate NVARCHAR(31)

-- ִ���߼�
BEGIN
	IF (@strLoginServer = 'daye') or (@strLoginServer = 'yangxin') or (@strLoginServer = 'dagong') or (@strLoginServer = N'')
	BEGIN
		--���˹�������
		SELECT @WinToday3=Win,@LostToday3=Lost,@WinTotal3=WinTotal,@LostTotal3=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=998
		-- ����ж�
		IF @WinToday3 IS NULL
		BEGIN
			SET @WinToday3 = 0
			SET @LostToday3 = 0
			SET @WinTotal3 = 0
			SET @LostTotal3 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday3 = 0
				SET @LostToday3 = 0
			END
		END

		--���˹�������
		SELECT @WinToday4=Win,@LostToday4=Lost,@WinTotal4=WinTotal,@LostTotal4=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=997
		-- ����ж�
		IF @WinToday4 IS NULL
		BEGIN
			SET @WinToday4 = 0
			SET @LostToday4 = 0
			SET @WinTotal4 = 0
			SET @LostTotal4 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday4 = 0
				SET @LostToday4 = 0
			END
		END

		--���˹�ÿ���������콱�׶�
		SELECT @AwardToday3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (3,4,5) and datediff(day,[LatestDate],getdate())=0

		--���˹�ÿ���������콱�׶�
		SELECT @AwardToday4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (6,7,8) and datediff(day,[LatestDate],getdate())=0

		--���˹�ϵͳ�������콱�׶�
		SELECT @AwardAll3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=10 and TaskID <=22 

		--���˹�ϵͳ�������콱�׶�
		SELECT @AwardAll4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=30 and TaskID <=42 
	END
	ELSE IF @strLoginServer = 'huangshi'
	BEGIN
		--���˹�������
		SELECT @WinToday3=Win,@LostToday3=Lost,@WinTotal3=WinTotal,@LostTotal3=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=998
		-- ����ж�
		IF @WinToday3 IS NULL
		BEGIN
			SET @WinToday3 = 0
			SET @LostToday3 = 0
			SET @WinTotal3 = 0
			SET @LostTotal3 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday3 = 0
				SET @LostToday3 = 0
			END
		END
		
		--��ʯ��ʮK������
		SELECT @WinToday4=Win,@LostToday4=Lost,@WinTotal4=WinTotal,@LostTotal4=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=996
		-- ����ж�
		IF @WinToday4 IS NULL
		BEGIN
			SET @WinToday4 = 0
			SET @LostToday4 = 0
			SET @WinTotal4 = 0
			SET @LostTotal4 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday4 = 0
				SET @LostToday4 = 0
			END
		END

		--���˹�ÿ���������콱�׶�
		SELECT @AwardToday3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (3,4,5) and datediff(day,[LatestDate],getdate())=0

		--��ʯ��ʮKÿ���������콱�׶�
		SELECT @AwardToday4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (10001,10002,10003) and datediff(day,[LatestDate],getdate())=0

		--���˹�ϵͳ�������콱�׶�
		SELECT @AwardAll3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=10 and TaskID <=22 

		--��ʯ��ʮKϵͳ�������콱�׶�
		SELECT @AwardAll4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=50 and TaskID <=62 
	END
	ELSE IF @strLoginServer = 'ezhou'
	BEGIN
		--���˹�������
		SELECT @WinToday3=Win,@LostToday3=Lost,@WinTotal3=WinTotal,@LostTotal3=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=998
		-- ����ж�
		IF @WinToday3 IS NULL
		BEGIN
			SET @WinToday3 = 0
			SET @LostToday3 = 0
			SET @WinTotal3 = 0
			SET @LostTotal3 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday3 = 0
				SET @LostToday3 = 0
			END
		END
		
		--������ʮK������
		SELECT @WinToday4=Win,@LostToday4=Lost,@WinTotal4=WinTotal,@LostTotal4=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=995
		-- ����ж�
		IF @WinToday4 IS NULL
		BEGIN
			SET @WinToday4 = 0
			SET @LostToday4 = 0
			SET @WinTotal4 = 0
			SET @LostTotal4 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday4 = 0
				SET @LostToday4 = 0
			END
		END

		--���˹�ÿ���������콱�׶�
		SELECT @AwardToday3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (3,4,5) and datediff(day,[LatestDate],getdate())=0

		--��ʯ��ʮKÿ���������콱�׶�
		SELECT @AwardToday4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (10001,10002,10003) and datediff(day,[LatestDate],getdate())=0

		--���˹�ϵͳ�������콱�׶�
		SELECT @AwardAll3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=10 and TaskID <=22 

		--��ʯ��ʮKϵͳ�������콱�׶�
		SELECT @AwardAll4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=50 and TaskID <=62 
	END
	ELSE IF @strLoginServer = 'qianjiang'
	BEGIN
		--���˹�������
		SELECT @WinToday3=Win,@LostToday3=Lost,@WinTotal3=WinTotal,@LostTotal3=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=998
		-- ����ж�
		IF @WinToday3 IS NULL
		BEGIN
			SET @WinToday3 = 0
			SET @LostToday3 = 0
			SET @WinTotal3 = 0
			SET @LostTotal3 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday3 = 0
				SET @LostToday3 = 0
			END
		END
		
		--Ǳ��ǧ�ֵ�����
		SELECT @WinToday4=Win,@LostToday4=Lost,@WinTotal4=WinTotal,@LostTotal4=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=990
		-- ����ж�
		IF @WinToday4 IS NULL
		BEGIN
			SET @WinToday4 = 0
			SET @LostToday4 = 0
			SET @WinTotal4 = 0
			SET @LostTotal4 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday4 = 0
				SET @LostToday4 = 0
			END
		END

		--���˹�ÿ���������콱�׶�
		SELECT @AwardToday3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (3,4,5) and datediff(day,[LatestDate],getdate())=0

		--Ǳ��ǧ��ÿ���������콱�׶�
		SELECT @AwardToday4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (10001,10002,10003) and datediff(day,[LatestDate],getdate())=0

		--���˹�ϵͳ�������콱�׶�
		SELECT @AwardAll3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=10 and TaskID <=22 

		--Ǳ��ǧ��ϵͳ�������콱�׶�
		SELECT @AwardAll4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=50 and TaskID <=62 
	END
	ELSE IF @strLoginServer = 'chibi'
	BEGIN
		--���˹�������
		SELECT @WinToday3=Win,@LostToday3=Lost,@WinTotal3=WinTotal,@LostTotal3=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=998
		-- ����ж�
		IF @WinToday3 IS NULL
		BEGIN
			SET @WinToday3 = 0
			SET @LostToday3 = 0
			SET @WinTotal3 = 0
			SET @LostTotal3 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday3 = 0
				SET @LostToday3 = 0
			END
		END
		
		--��ڴ��������
		SELECT @WinToday4=Win,@LostToday4=Lost,@WinTotal4=WinTotal,@LostTotal4=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=999
		-- ����ж�
		IF @WinToday4 IS NULL
		BEGIN
			SET @WinToday4 = 0
			SET @LostToday4 = 0
			SET @WinTotal4 = 0
			SET @LostTotal4 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday4 = 0
				SET @LostToday4 = 0
			END
		END

		--���˹�ÿ���������콱�׶�
		SELECT @AwardToday3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (3,4,5) and datediff(day,[LatestDate],getdate())=0

		--��ڴ��ÿ���������콱�׶�
		SELECT @AwardToday4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (10001,10002,10003) and datediff(day,[LatestDate],getdate())=0

		--���˹�ϵͳ�������콱�׶�
		SELECT @AwardAll3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=10 and TaskID <=22 

		--��ڴ��ϵͳ�������콱�׶�
		SELECT @AwardAll4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=50 and TaskID <=62 
	END
	ELSE IF @strLoginServer = 'jianli'
	BEGIN
		--���˹�������
		SELECT @WinToday3=Win,@LostToday3=Lost,@WinTotal3=WinTotal,@LostTotal3=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=998
		-- ����ж�
		IF @WinToday3 IS NULL
		BEGIN
			SET @WinToday3 = 0
			SET @LostToday3 = 0
			SET @WinTotal3 = 0
			SET @LostTotal3 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday3 = 0
				SET @LostToday3 = 0
			END
		END
		
		--��������������
		SELECT @WinToday4=Win,@LostToday4=Lost,@WinTotal4=WinTotal,@LostTotal4=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=988
		-- ����ж�
		IF @WinToday4 IS NULL
		BEGIN
			SET @WinToday4 = 0
			SET @LostToday4 = 0
			SET @WinTotal4 = 0
			SET @LostTotal4 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday4 = 0
				SET @LostToday4 = 0
			END
		END

		--���˹�ÿ���������콱�׶�
		SELECT @AwardToday3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (3,4,5) and datediff(day,[LatestDate],getdate())=0

		--��������ÿ���������콱�׶�
		SELECT @AwardToday4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (10001,10002,10003) and datediff(day,[LatestDate],getdate())=0

		--���˹�ϵͳ�������콱�׶�
		SELECT @AwardAll3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=10 and TaskID <=22 

		--��������ϵͳ�������콱�׶�
		SELECT @AwardAll4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=50 and TaskID <=62 
	END
	ELSE IF @strLoginServer = 'chongyang'
	BEGIN
		--���˹�������
		SELECT @WinToday3=Win,@LostToday3=Lost,@WinTotal3=WinTotal,@LostTotal3=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=998
		-- ����ж�
		IF @WinToday3 IS NULL
		BEGIN
			SET @WinToday3 = 0
			SET @LostToday3 = 0
			SET @WinTotal3 = 0
			SET @LostTotal3 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday3 = 0
				SET @LostToday3 = 0
			END
		END
		
		--����������
		SELECT @WinToday4=Win,@LostToday4=Lost,@WinTotal4=WinTotal,@LostTotal4=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=987
		-- ����ж�
		IF @WinToday4 IS NULL
		BEGIN
			SET @WinToday4 = 0
			SET @LostToday4 = 0
			SET @WinTotal4 = 0
			SET @LostTotal4 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday4 = 0
				SET @LostToday4 = 0
			END
		END

		--���˹�ÿ���������콱�׶�
		SELECT @AwardToday3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (3,4,5) and datediff(day,[LatestDate],getdate())=0

		--����ÿ���������콱�׶�
		SELECT @AwardToday4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (10001,10002,10003) and datediff(day,[LatestDate],getdate())=0

		--���˹�ϵͳ�������콱�׶�
		SELECT @AwardAll3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=10 and TaskID <=22 

		--����ϵͳ�������콱�׶�
		SELECT @AwardAll4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=50 and TaskID <=62 
	END
	ELSE IF @strLoginServer = 'tongshan'
	BEGIN
		--���˹�������
		SELECT @WinToday3=Win,@LostToday3=Lost,@WinTotal3=WinTotal,@LostTotal3=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=998
		-- ����ж�
		IF @WinToday3 IS NULL
		BEGIN
			SET @WinToday3 = 0
			SET @LostToday3 = 0
			SET @WinTotal3 = 0
			SET @LostTotal3 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday3 = 0
				SET @LostToday3 = 0
			END
		END
		
		--ͨɽ������
		SELECT @WinToday4=Win,@LostToday4=Lost,@WinTotal4=WinTotal,@LostTotal4=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=986
		-- ����ж�
		IF @WinToday4 IS NULL
		BEGIN
			SET @WinToday4 = 0
			SET @LostToday4 = 0
			SET @WinTotal4 = 0
			SET @LostTotal4 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday4 = 0
				SET @LostToday4 = 0
			END
		END

		--���˹�ÿ���������콱�׶�
		SELECT @AwardToday3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (3,4,5) and datediff(day,[LatestDate],getdate())=0

		--ͨɽÿ���������콱�׶�
		SELECT @AwardToday4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (10001,10002,10003) and datediff(day,[LatestDate],getdate())=0

		--���˹�ϵͳ�������콱�׶�
		SELECT @AwardAll3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=10 and TaskID <=22 

		--ͨɽϵͳ�������콱�׶�
		SELECT @AwardAll4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=50 and TaskID <=62 
	END
	ELSE IF @strLoginServer = 'xiantao'
	BEGIN
		--���˹�������
		SELECT @WinToday3=Win,@LostToday3=Lost,@WinTotal3=WinTotal,@LostTotal3=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=998
		-- ����ж�
		IF @WinToday3 IS NULL
		BEGIN
			SET @WinToday3 = 0
			SET @LostToday3 = 0
			SET @WinTotal3 = 0
			SET @LostTotal3 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday3 = 0
				SET @LostToday3 = 0
			END
		END
		
		--���ҵ�����
		SELECT @WinToday4=Win,@LostToday4=Lost,@WinTotal4=WinTotal,@LostTotal4=LostTotal, @TheDate=Convert(varchar(10),[CollectDate],120)
		FROM GameToday WHERE UserID=@dwUserID and KindID=989
		-- ����ж�
		IF @WinToday4 IS NULL
		BEGIN
			SET @WinToday4 = 0
			SET @LostToday4 = 0
			SET @WinTotal4 = 0
			SET @LostTotal4 = 0
		END
		ELSE
		BEGIN
			IF @TheDate <> Convert(varchar(10),getDate(),120)
			BEGIN
				--���ǽ���
				SET @WinToday4 = 0
				SET @LostToday4 = 0
			END
		END

		--���˹�ÿ���������콱�׶�
		SELECT @AwardToday3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (3,4,5) and datediff(day,[LatestDate],getdate())=0

		--ͨɽÿ���������콱�׶�
		SELECT @AwardToday4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID in (10001,10002,10003) and datediff(day,[LatestDate],getdate())=0

		--���˹�ϵͳ�������콱�׶�
		SELECT @AwardAll3=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=10 and TaskID <=22 

		--ͨɽϵͳ�������콱�׶�
		SELECT @AwardAll4=count(*)
		FROM [WHGameUserDB].[dbo].[UserGetAward](NOLOCK)
		WHERE UserID=@dwUserID and TaskID >=50 and TaskID <=62 
	END

	-- �������
	SELECT @WinToday3 AS wtoday3, @LostToday3 AS ltoday3, @WinTotal3 AS wtotal3, @LostTotal3 AS ltotal3,
	@WinToday4 AS wtoday4, @LostToday4 AS ltoday4, @WinTotal4 AS wtotal4, @LostTotal4 AS ltotal4,
	@AwardToday3 AS atoday3, @AwardToday4 AS atoday4, @AwardAll3 AS atotal3, @AwardAll4 AS atotal4
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------
