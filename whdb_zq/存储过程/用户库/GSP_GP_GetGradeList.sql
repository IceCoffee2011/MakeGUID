use ZQGameUserDB;
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

---��ȡ�ȼ��б�
create PROCEDURE [dbo].[GSP_GP_GetGradeList]
	
AS

DECLARE @Count					INT						--�ȼ�����

BEGIN
	--�ȼ�������
	SELECT @Count = COUNT(*) FROM GradeList
	IF(@Count>0)
		SELECT * FROM GradeList --�ȼ��б�

	RETURN @Count
END