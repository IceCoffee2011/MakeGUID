
----------------------------------------------------------------------------------------------------

USE ZQServerInfoDB
GO

----------------------------------------------------------------------------------------------------

-- 删除数据
DELETE DataBaseInfo
GO

----------------------------------------------------------------------------------------------------

-- 连接信息
INSERT DataBaseInfo (DBPort, DBAddr, DBUser, DBPassword) VALUES (1433, '127.0.0.1', '027129486b47d67febe8', '073429186b5ad6e4ebde0733291f6b47d67febe8')

----------------------------------------------------------------------------------------------------

GO