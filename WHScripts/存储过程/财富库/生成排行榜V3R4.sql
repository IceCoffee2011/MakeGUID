
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