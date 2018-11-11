
----------------------------------------------------------------------------------------------------

USE ZQGameUserDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_SafeBind]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_SafeBind]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_SafeUnBind]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_SafeUnBind]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- �󶨻���
CREATE PROC GSP_GP_SafeBind
	@dwUserID INT,								-- �û�ID	
	@strInsurePass NCHAR(32),					--��������
	@strMachineSerial NCHAR(32)				-- ������ʶ
WITH ENCRYPTION AS

declare @InsurePass NCHAR(32)


-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	select @InsurePass = InsurePass from AccountsInfo where UserID=@dwUserID
	if @strInsurePass = @InsurePass
		begin 
			UPDATE AccountsInfo SET MoorMachine = 1, MachineSerial = @strMachineSerial WHERE UserID=@dwUserID
			select [ErrorDescribe] = N'��ϲ�㣡�����󶨳ɹ���'
			RETURN 0
		end
	else
		select [ErrorDescribe] = N'����������󣡻�����ʧ�ܣ�'

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- �����
CREATE PROC GSP_GP_SafeUnBind
	@dwUserID INT,								-- �û�ID
	@strInsurePass NCHAR(32)					--��������
WITH ENCRYPTION AS

declare @InsurePass NCHAR(32)

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	select @InsurePass = InsurePass from AccountsInfo where UserID=@dwUserID

if @strInsurePass = @InsurePass
		begin 
			UPDATE AccountsInfo SET MoorMachine = 0 WHERE UserID=@dwUserID
			select [ErrorDescribe] = N'��ϲ�㣡��������󶨳ɹ���'
			RETURN 0
		end
	else
		select [ErrorDescribe] = N'����������󣡻��������ʧ�ܣ�'
	

END

RETURN 0

GO
