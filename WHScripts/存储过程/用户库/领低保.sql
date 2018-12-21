
----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_UserWelfare]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_UserWelfare]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- I D ��¼
CREATE PROC GSP_GP_UserWelfare
	@dwUserID INT,
	@TheLost INT output
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @TheUserID INT
DECLARE @LatestTimes INT
DECLARE @TheTimes INT
DECLARE @TheLatestDate DATETIME

-- ��������
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	SELECT @TheUserID=UserID FROM WHTreasureDB.dbo.GameScoreInfo(NOLOCK) WHERE UserID=@dwUserID

	-- ��ѯ�û�
	IF @TheUserID IS NULL
	BEGIN
		set @ErrorDescribe = N'�����ʺŲ����ڣ�'
		RETURN -1
	END	

	-- ����ֵ
	declare @iCurScore int
	declare @iMaxCount int
	declare @iMaxScore int
	declare @iWelfareScore int
	declare @iBankCurScore int
	declare @iAllCurScore int
	set @iCurScore = 0
	set @iBankCurScore = 0
	set @iAllCurScore = 0
	--set @iMaxCount = 3
	--set @iMaxScore = 2000
	--set @iWelfareScore = 1000
	SELECT @iMaxCount=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='di_c'
	IF @iMaxCount IS NULL
	BEGIN
		set @ErrorDescribe = N'��ͱ��δ������'
		RETURN -4
	END
	SELECT @iMaxScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='di_s'
	IF @iMaxScore IS NULL
	BEGIN
		set @ErrorDescribe = N'��ͱ��δ������'
		RETURN -5
	END
	SELECT @iWelfareScore=value from WHServerInfoDB.dbo.GameConfig WHERE getdate() >= ValidDate and name='di_w'
	IF @iWelfareScore IS NULL
	BEGIN
		set @ErrorDescribe = N'��ͱ��δ������'
		RETURN -6
	END

	SELECT @iCurScore=Score, @iBankCurScore=BankScore FROM WHTreasureDB.dbo.GameScoreInfo(NOLOCK) WHERE UserID=@dwUserID
	-- ������͵�ǰ���֮��
	set @iAllCurScore = @iCurScore + @iBankCurScore
	IF @iAllCurScore >= @iMaxScore
	BEGIN
		set @ErrorDescribe = N'�Ƹ�������Сֵ��'
		RETURN -2
	END

	-- �Ƿ�����ͱ�
	SELECT @LatestTimes=Times,  @TheLatestDate=LatestDate
	FROM UserWelfare(NOLOCK) WHERE UserID=@dwUserID 

	IF @LatestTimes IS NULL
	BEGIN
		set @TheLatestDate =(select getdate())
		set @TheTimes = 1
		INSERT INTO UserWelfare(UserID, Times, LatestDate) VALUES(@dwUserID, @TheTimes, @TheLatestDate)
		set @ErrorDescribe = N'�״���ͱ��ɹ���'

		-- �ӷ�
		UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score + @iWelfareScore WHERE UserID=@dwUserID
		--��־:2��ʾ��ͱ�
		INSERT INTO UserScoreLog(UserID, Type, Score) VALUES(@dwUserID, 2, @iWelfareScore)
	END
	ELSE
	BEGIN
		-- ��ѯ�����Ƿ�ǩ��
		set @LatestTimes = 0
		SELECT @LatestTimes=Times,  @TheLatestDate=LatestDate
		FROM UserWelfare(NOLOCK) WHERE UserID=@dwUserID and datediff(day,[LatestDate],getdate())=0 

		IF @LatestTimes >= @iMaxCount
		BEGIN
			set @ErrorDescribe = N'�����Ѿ������ͱ���ȡ������'
			RETURN -3
		END
		ELSE IF @LatestTimes > 0
		BEGIN
			-- ��������ͱ�
			set @TheLatestDate =(select getdate())
			UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score + @iWelfareScore WHERE UserID=@dwUserID
			UPDATE UserWelfare SET Times = Times + 1, LatestDate = @TheLatestDate WHERE UserID=@dwUserID 
			SET @TheTimes = @LatestTimes + 1
			--��־:2��ʾ��ͱ�
			INSERT INTO UserScoreLog(UserID, Type, Score) VALUES(@dwUserID, 2, @iWelfareScore)
		END
		ELSE
		BEGIN
			set @TheLatestDate =(select getdate())
			set @TheTimes = 1
			set @ErrorDescribe = N'ѭ����ͱ��ɹ���'
			UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score + @iWelfareScore WHERE UserID=@dwUserID
			UPDATE UserWelfare SET Times = @TheTimes, LatestDate = @TheLatestDate WHERE UserID=@dwUserID 
			--��־:2��ʾ��ͱ�
			INSERT INTO UserScoreLog(UserID, Type, Score) VALUES(@dwUserID, 2, @iWelfareScore)
		END
	END

	-- �������
	--SELECT @iCurScore=Score
	--FROM WHTreasureDB.dbo.GameScoreInfo(NOLOCK) WHERE UserID=@dwUserID
	--SELECT @TheTimes AS Times, @TheLatestDate AS LatestDate, @ErrorDescribe AS ErrorDescribe, @iCurScore AS GoldScore

	SET @TheLost = @iMaxCount - @TheTimes
--	SELECT @TheTimes AS TheLost 

	RETURN @iWelfareScore
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
