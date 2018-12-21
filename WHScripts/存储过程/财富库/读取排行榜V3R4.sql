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