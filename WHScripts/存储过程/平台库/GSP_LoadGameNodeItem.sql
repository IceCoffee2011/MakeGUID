USE [WHServerInfoDB]
GO
/****** Object:  StoredProcedure [dbo].[GSP_LoadGameNodeItem]    Script Date: 2018/12/21 16:38:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------------------------

--���ؽڵ�
create  PROCEDURE [dbo].[GSP_LoadGameNodeItem]   AS

--��������
SET NOCOUNT ON

--��ѯ�ڵ�
SELECT * FROM GameNodeItem(NOLOCK) WHERE Nullity=0 ORDER BY SortID

RETURN 0

