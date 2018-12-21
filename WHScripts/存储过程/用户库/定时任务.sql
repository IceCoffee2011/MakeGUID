
----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_CheckGMTask]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_CheckGMTask]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ���GM���߷��ŵĲƸ�
CREATE PROC GSP_GP_CheckGMTask
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ��չ��Ϣ
DECLARE @OldPhone NVARCHAR(32)
DECLARE @OldPwd NVARCHAR(32)
DECLARE @OldScore BIGINT
DECLARE @OldBankScore BIGINT
DECLARE @DelScoreTotal INT
DECLARE @DelScore INT
DECLARE @DelBankScore INT
DECLARE @IsGuest INT
DECLARE @ThePasswordX AS NVARCHAR(32)

DECLARE @CurMinute INT
DECLARE @OldGold INT


-- ִ���߼�
BEGIN
	-- TODO:�������ﲻ̫���ʣ�͵��С����ÿ��Сʱִ��һ�ε�����
	SELECT @CurMinute=DateName(minute,GetDate())
	-- ��Ϊ�˴洢���̻�2���Ӵ���һ��
	IF @CurMinute < 2
	BEGIN
		INSERT INTO WHTreasureDB.dbo.TotalScoreLog(Total, Score, BankScore) SELECT sum(Score)+sum(BankScore),sum(Score),sum(BankScore) FROM WHTreasureDB.dbo.GameScoreInfo
	END

	--TODO:����һ�¶�ʱ��,����Ƿ��лҪ������ʼ,����У�Ҫ������������Ϊ�˴洢���̻�2���Ӵ���һ�Σ���������ѡ��3���ӣ����ٻ�ִ��һ��
	DECLARE c2 cursor for SELECT KindID FROM  UserActivity WHERE Deleted=0 AND DateDiff(minute,BeginDate,GetDate()) > -4 AND DateDiff(minute,BeginDate,GetDate()) < 0
        DECLARE @kindid int
        OPEN c2  
        FETCH c2 INTO @kindid
        WHILE @@fetch_status=0  
        BEGIN  
		--��������
		UPDATE WHTreasureDB.dbo.GameToday SET Win4Activity=0,Lost4Activity=0,Flee4Activity=0 WHERE KindID=@kindid
	END 
	CLOSE c2
	DEALLOCATE c2

	--TODO:�����ʱ6h���������ʺ�
	DELETE FROM WHTreasureDB.dbo.GameScoreLocker where datediff(mi , CollectDate ,getdate()) > 360

	--��鹫��ϵͳ
	UPDATE WHServerInfoDB.dbo.GameBBS SET IsValid=1 WHERE getdate() > StartDate AND getdate() < EndDate AND IsValid != 1
	UPDATE WHServerInfoDB.dbo.GameBBS SET IsValid=0 WHERE getdate() >= EndDate AND IsValid != 0

	-- ��ѯ����ÿ������ִֻ��ǰ5������
	DECLARE c1 cursor for SELECT Top 50 ID,TaskID,UserID,Params from  GMTask WHERE getdate() >= StartDate order by Priority asc
        DECLARE @id int, @taskid int, @userid int, @params VARCHAR(256), @passwd VARCHAR(9)
        OPEN c1  
        FETCH c1 INTO @id, @taskid,@userid,@params
        WHILE @@fetch_status=0  
        BEGIN  
		IF @taskid = 1
		BEGIN
			--���Ƹ�����
			EXEC dbo.GSP_GP_CheckUserGMScore @userid
		END
		ELSE IF @taskid = 7
		BEGIN
			--��������ϵͳ�Ƹ�����

			INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'���������Ƹ�' FROM GMTask WHERE ID=@id
		--��Ҫ����	EXEC dbo.GSP_GP_UserExtendThirdAccount @userid
			DELETE FROM GMTask WHERE ID=@id
		END
		ELSE IF @taskid = 8
		BEGIN
			--����
			INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'����' FROM GMTask WHERE ID=@id
			
			--�Ƿ�ԭ������
			SELECT @OldGold=Gold FROM UserExchangeInfo Where UserID=@userid
			IF @OldGold IS NULL
			BEGIN
				INSERT INTO UserExchangeInfo(UserID, Gold) VALUES(@userid, convert(int,@params))
			END
			ELSE
			BEGIN
				UPDATE UserExchangeInfo SET Gold=Gold+convert(int,@params) WHERE UserID=@userid
			END

			DELETE FROM GMTask WHERE ID=@id
		END
		ELSE IF @taskid = 9
		BEGIN
			--ϵͳ�����������ﲻ��������һ���洢�����д���
			SET @taskid = 9
		END
		ELSE IF @taskid = 6
		BEGIN
			--�۲Ƹ�����:������е�
			-- ��Ϸ��Ϣ
			SELECT @OldScore=Score,@OldBankScore=BankScore FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@userid
			SET @DelScoreTotal = convert(int,@params)
			-- ��Ϣ�ж�
			IF @OldScore IS NOT NULL
			BEGIN
				SET @DelScore = 0
				SET @DelBankScore = 0
				--��ʼ�۷�:�ȴ����п�
				IF @DelScoreTotal > @OldBankScore
				BEGIN
					SET @DelBankScore = @OldBankScore
				END
				ELSE
				BEGIN
					SET @DelBankScore = @DelScoreTotal
				END

				SET @DelScoreTotal = @DelScoreTotal - @DelBankScore

				IF @DelScoreTotal > @OldScore
				BEGIN
					SET @DelScore = @OldScore
				END
				ELSE
				BEGIN
					SET @DelScore = @DelScoreTotal
				END

				SET @DelScoreTotal = @DelScoreTotal - @DelScore

				IF @DelScoreTotal > 0
				BEGIN
					INSERT INTO GMTaskLog SELECT *,getdate(),N'ʧ��',N'�Ƹ�����' FROM GMTask WHERE ID=@id
				END
				ELSE
				BEGIN
					INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'������'+convert(varchar(32),@DelBankScore)+N'Ǯ��'+convert(varchar(32),@DelScore)+N'ԭ'+convert(varchar(32),@OldBankScore)+N'/'+convert(varchar(32),@OldScore) FROM GMTask WHERE ID=@id
					UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score - @DelScore, BankScore = BankScore - @DelBankScore WHERE UserID=@userid
				END
				DELETE FROM GMTask WHERE ID=@id
			END
		END
		ELSE IF @taskid = 2
		BEGIN
			-- ���
			INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'���'+convert(varchar(32),@userid) FROM GMTask WHERE ID=@id
			EXEC dbo.GSP_GR_CongealAccounts @userid,0,N''
			DELETE FROM GMTask WHERE ID=@id
		END
		ELSE IF @taskid = 5
		BEGIN
			-- ���
			INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'���'+convert(varchar(32),@userid) FROM GMTask WHERE ID=@id
			EXEC dbo.GSP_GR_UnCongealAccounts @userid,0,N''
			DELETE FROM GMTask WHERE ID=@id
		END
		ELSE IF @taskid = 3
		BEGIN
			-- �����ֻ���
			SELECT @OldPhone=Phone FROM AccountsInfo(NOLOCK) WHERE UserID=@userid
			INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'ԭ�ֻ���'+@OldPhone FROM GMTask WHERE ID=@id
			UPDATE AccountsInfo SET Phone=@params WHERE UserID=@userid
			DELETE FROM GMTask WHERE ID=@id
		END
		ELSE IF @taskid = 4
		BEGIN
			-- ��������
			SELECT @OldPwd=LogonPass, @IsGuest=IsGuest FROM AccountsInfo(NOLOCK) WHERE UserID=@userid
			SET @passwd = substring(@params, 1, 9)
			SET @ThePasswordX = substring(sys.fn_VarBinToHexStr(hashbytes('MD5',@passwd)),3,32)
			IF @IsGuest = 1
			BEGIN
				INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'�οͣ�ԭ����'+@OldPwd FROM GMTask WHERE ID=@id
				UPDATE AccountsInfo SET LogonPass=@ThePasswordX,InsurePass=@params WHERE UserID=@userid and IsGuest = 1
			END
			ELSE
			BEGIN
				INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'ԭ����'+@OldPwd FROM GMTask WHERE ID=@id
				UPDATE AccountsInfo SET LogonPass=@ThePasswordX WHERE UserID=@userid and IsGuest = 0
			END
			DELETE FROM GMTask WHERE ID=@id
		END
		ELSE IF @taskid = 10
		BEGIN
			-- ���ĲƸ�������Ǯ����

			--�Ƿ�������Ϸ����
			IF NOT EXISTS (SELECT UserID FROM WHTreasureDB.dbo.GameScoreLocker WHERE UserID=@userid)
			BEGIN
				-- ��Ϸ��Ϣ
				SELECT @OldScore=Score FROM WHTreasureDB.dbo.GameScoreInfo WHERE UserID=@userid
				SET @DelScoreTotal = convert(int,@params)
				-- ��Ϣ�ж�
				IF @OldScore IS NOT NULL
				BEGIN
					IF @DelScoreTotal > @OldScore
					BEGIN
						INSERT INTO GMTaskLog SELECT *,getdate(),N'ʧ��',N'�Ƹ�����' FROM GMTask WHERE ID=@id
					END
					ELSE
					BEGIN
						INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'Ǯ��'+convert(varchar(32),@DelScoreTotal)+N'ԭ'+convert(varchar(32),@OldScore) FROM GMTask WHERE ID=@id
						UPDATE WHTreasureDB.dbo.GameScoreInfo SET Score = Score - @DelScoreTotal WHERE UserID=@userid
					END
					DELETE FROM GMTask WHERE ID=@id
				END
			END
		END
		ELSE
		BEGIN
			-- ��֧�ֵ�����
			INSERT INTO GMTaskLog SELECT *,getdate(),N'��֧��',N'�������ݲ�֧��' FROM GMTask WHERE ID=@id
			DELETE FROM GMTask WHERE ID=@id
		END

		FETCH c1 INTO @id,@taskid,@userid,@params  
        END 
	CLOSE c1
	DEALLOCATE c1
END

RETURN 0

GO



----------------------------------------------------------------------------------------------------

USE WHGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_CheckSpeakerTask]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_CheckSpeakerTask]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ���GM���߷��ŵ�ϵͳ����
CREATE PROC GSP_GP_CheckSpeakerTask
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

DECLARE @Params NVARCHAR(256)
DECLARE @UserID INT
DECLARE @ID INT

-- ִ���߼�
BEGIN

	SELECT top 1 @ID=ID, @UserID=UserID, @Params=Params FROM GMTask where TaskID=9 and getdate() >=StartDate order by StartDate
	IF @ID IS NULL
	BEGIN
		RETURN 0
	END

	INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'ϵͳ����' FROM GMTask WHERE ID=@id
	DELETE FROM GMTask WHERE ID=@id

	SELECT @UserID AS UserID, @Params As Params
END

RETURN 0

GO



----------------------------------------------------------------------------------------------------
--��ΪȨ�����⣬����ʹ�ô��������ĳɼƻ�����
-------USE WHGameUserDB
-------GO

-------IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[TR_GP_GMTask]') and OBJECTPROPERTY(ID, N'IsTrigger') = 1)
-------DROP TRIGGER [dbo].[TR_GP_GMTask]
-------GO

-------CREATE TRIGGER TR_GP_GMTask On GMTask FOR INSERT
-------AS

-- ��չ��Ϣ
-------DECLARE @OldPhone NVARCHAR(32)
-------DECLARE @OldPwd NVARCHAR(32)
-------DECLARE @IsGuest INT
-------DECLARE @ThePasswordX AS NVARCHAR(32)
-------DECLARE @id int, @taskid int, @userid int, @params VARCHAR(32), @passwd VARCHAR(9)
-------
-------	SELECT @id=ID, @taskid=TaskID, @userid=UserID, @params=Params, @passwd=Params from inserted
-------	IF @taskid = 1
-------	BEGIN
-------		--���Ƹ�����
-------		EXEC dbo.GSP_GP_CheckUserGMScore @userid
-------	END
-------	ELSE IF @taskid = 2
-------	BEGIN
-------		-- ���
-------		INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'���'+convert(varchar(32),@userid) FROM GMTask WHERE ID=@id
-------		EXEC dbo.GSP_GR_CongealAccounts @userid,0,N''
-------		DELETE FROM GMTask WHERE ID=@id
-------	END
-------	ELSE IF @taskid = 5
-------	BEGIN
-------		-- ���
-------		INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'���'+convert(varchar(32),@userid) FROM GMTask WHERE ID=@id
-------		EXEC dbo.GSP_GR_UnCongealAccounts @userid,0,N''
-------		DELETE FROM GMTask WHERE ID=@id
-------	END
-------	ELSE IF @taskid = 3
-------	BEGIN
-------		-- �����ֻ���
-------		SELECT @OldPhone=Phone FROM AccountsInfo(NOLOCK) WHERE UserID=@userid
-------		INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'ԭ�ֻ���'+@OldPhone FROM GMTask WHERE ID=@id
-------		UPDATE AccountsInfo SET Phone=@params WHERE UserID=@userid
-------		DELETE FROM GMTask WHERE ID=@id
-------	END
-------	ELSE IF @taskid = 4
-------	BEGIN
-------		-- ��������
-------		SELECT @OldPwd=LogonPass, @IsGuest=IsGuest FROM AccountsInfo(NOLOCK) WHERE UserID=@userid
-------		SET @ThePasswordX = substring(sys.fn_VarBinToHexStr(hashbytes('MD5',@passwd)),3,32)
-------		IF @IsGuest = 1
-------		BEGIN
-------			INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'�οͣ�ԭ����'+@OldPwd FROM GMTask WHERE ID=@id
-------			UPDATE AccountsInfo SET LogonPass=@ThePasswordX,InsurePass=@params WHERE UserID=@userid and IsGuest = 1
-------		END
-------		ELSE
-------		BEGIN
-------			INSERT INTO GMTaskLog SELECT *,getdate(),N'���',N'ԭ����'+@OldPwd FROM GMTask WHERE ID=@id
-------			UPDATE AccountsInfo SET LogonPass=@ThePasswordX WHERE UserID=@userid and IsGuest = 0
-------		END
-------		DELETE FROM GMTask WHERE ID=@id
-------	END
-------	ELSE
-------	BEGIN
-------		-- ��֧�ֵ�����
-------		INSERT INTO GMTaskLog SELECT *,getdate(),N'��֧��',N'�������ݲ�֧��' FROM GMTask WHERE ID=@id
-------		DELETE FROM GMTask WHERE ID=@id
-------	END
-------GO



