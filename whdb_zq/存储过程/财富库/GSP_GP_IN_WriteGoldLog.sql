set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go










-- =============================================
-- Author:		<Author,cxf>
-- Create date: <Create Date,2012-01-10>
-- Description:	<Description,д�����־>
-- =============================================
ALTER PROCEDURE [dbo].[GSP_GP_IN_WriteGoldLog]
	@CTableNameDate					NVARCHAR(50),						--����
	@IUserID						INT,								--�û�ID
	@TChangeType					TINYINT,							--�䶯����
	@IChangeGold					INT,								--�䶯���
	@CIpAddress						NVARCHAR(15)						--IP
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CTableName				NVARCHAR(50)						--TABLE
	--DECLARE @CSql					NVARCHAR(1000)						--SQL
	DECLARE @ILastGold				INT									--�����

	SET @CTableName='QPWebDB.dbo.UserGoldLog_'+@CTableNameDate
	SELECT @ILastGold=Score FROM QPTreasureDB.dbo.GameScoreInfo WHERE UserID=@IUserID

	EXEC ('INSERT INTO '+@CTableName+'(UserID,ChangeType,LastGold,ChangeGold,IpAddress) VALUES
		('+@IUserID+','+@TChangeType+','+@ILastGold+','+@IChangeGold+','''+@CIpAddress+''')')

	/*SET @CSql='INSERT INTO '+@CTableName+'(UserID,ChangeType,LastGold,ChangeGold,IpAddress) VALUES
		('+CONVERT(NVARCHAR(10),@IUserID)+',10,'+CONVERT(NVARCHAR(10),@ILastGold)+','+
			CONVERT(NVARCHAR(10),@IChangeGold)+','''+@IpAddress+''')'
	EXEC sp_executesql @CSql,
		N'@CTableName NVARCHAR(50) OUTPUT', @CTableName OUTPUT*/

	RETURN 1
END










