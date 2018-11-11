
----------------------------------------------------------------------------------------------------

USE ZQServerInfoDB
GO

----------------------------------------------------------------------------------------------------

-- ɾ������
DELETE GameTypeItem
DELETE GameKindItem
DELETE GameNodeItem
GO

----------------------------------------------------------------------------------------------------

-- ��������
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 1, '�Ƹ���Ϸ',100, 0)
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 2, '������Ϸ',200, 0)
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 3, '�˿���Ϸ',300, 0)
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 4, '�齫��Ϸ',400, 0)
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 5, '������Ϸ',500, 0)
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 6, '������Ϸ',600, 0)
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 7, '�ط���Ϸ',700, 0)


----------------------------------------------------------------------------------------------------

-- �Ƹ���Ϸ
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 1, 1, '��ť���', 'ShowHandAN.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 1, 1, '�������', 'ShowHandCM.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 1, 1, '�������', 'ShowHandSZ.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 2, 1, '��ť����', 'HKFiveCardAN.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 2, 1, '��������', 'HKFiveCardCM.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 2, 1, '��������', 'HKFiveCardSZ.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 3, 1, '�����˿�', 'DZShowHand.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 4, 1, '����ţţ', 'OxEx.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 5, 1, 'ţţ', 'Ox.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 6, 1, 'թ��', 'ZaJinHua.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 7, 1, 'ʮ����', 'Thirteen.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 8, 1, '���˸�', '28Gang.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 9, 1, '��Ͳ��', 'TuiTongZi.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 10, 1, '��񶷵���', 'LandCrazy.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 11, 1, '����', 'CheXuan.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 12, 1, '���', 'RedNine.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 13, 1, 'ҡ����', 'Liarsdice.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 14, 1, '�ƾ�', 'PaiJiu.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 15, 1, 'ʮ���', 'TenHalfPoint.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 16, 1, '21 ��', 'BlackJack.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 17, 1, '����', 'TianDaKeng.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 18, 1, '����', 'FourCard.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 19, 1, '�������', 'ShowHandANEx.exe', 67078, 100, 0, 'ZQTreasureDB')


-- ������Ϸ
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 100, 2, '�ټ���', 'Baccarat.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 101, 2, '���˵�˫', 'DanShuangBattle.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 102, 2, '�������', 'ShowHandBattle.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 103, 2, 'ʮ����Ф', 'ZodiacBattle.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 104, 2, '����ţţ', 'OxBattle.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 105, 2, '����', 'RedNineBattle.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 106, 2, '�����ƾ�', 'PaiJiuBattle.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 107, 2, '����������', 'LongHuDouBattle.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 108, 2, '������', 'BumperCarBattle.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 109, 2, '����С��', 'NineXiaoBattle.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 110, 2, '���˱�ʮ', 'BieShiBattle.exe', 67078, 100, 0, 'ZQTreasureDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 111, 2, '��������', 'DiceBattle.exe', 67078, 100, 0, 'ZQTreasureDB')

-- �˿���Ϸ
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 200, 3, '������', 'Land.exe', 67078, 100, 0, 'ZQLandDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 201, 3, '����������', 'Land2.exe', 67078, 100, 0, 'ZQLand2DB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 202, 3, '���˶�����', 'LandEx.exe', 67078, 100, 0, 'ZQLandExDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 203, 3, '��������', 'UpGrade2.exe', 67078, 100, 0, 'ZQUpGrade2DB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 204, 3, '��������', 'UpGrade3.exe', 67078, 100, 0, 'ZQUpGrade3DB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 205, 3, '�ķ�����', 'UpGrade4.exe', 67078, 100, 0, 'ZQUpGrade4DB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 206, 3, '��������', 'UpGradeGX.exe', 67078, 100, 0, 'ZQUpGradeGXDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 207, 3, '�������', 'BiaoFen.exe', 67078, 100, 0, 'ZQBiaoFenDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 208, 3, '����˫��', 'ShuangKouEx.exe', 67078, 100, 0, 'ZQShuangKouExDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 209, 3, '˫��', 'ShuangKou.exe', 67078, 100, 0, 'ZQShuangKouDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 210, 3, 'ǧ��˫��', 'ShuangKouQB.exe', 67078, 100, 0, 'ZQShuangKouQBDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 211, 3, '�ٱ�˫��', 'ShuangKouBB.exe', 67078, 100, 0, 'ZQShuangKouBBDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 212, 3, '����', 'GuanPaiBG.exe', 67078, 100, 0, 'ZQGuanPaiBGDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 213, 3, '����', 'GuanPai.exe', 67078, 100, 0, 'ZQGuanPaiDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 214, 3, '�����', 'ChuDaDi.exe', 67078, 100, 0, 'ZQChuDaDiDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 215, 3, '����', 'GongZhu.exe', 67078, 100, 0, 'ZQGongZhuDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 216, 3, '�ڿ�', 'WaKeng.exe', 67078, 100, 0, 'ZQWaKengDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 217, 3, '510K', '510K.exe', 67078, 100, 0, 'ZQ510KDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 218, 3, '����', 'HongWu.exe', 67078, 100, 0, 'ZQHongWuDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 219, 3, '��������', 'HongWu2.exe', 67078, 100, 0, 'ZQHongWu2DB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 220, 3, '��������', 'HongWu3.exe', 67078, 100, 0, 'ZQHongWu3DB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 221, 3, '����һ', 'SanDaYi.exe', 67078, 100, 0, 'ZQSanDaYiDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 222, 3, '��Ǩ�走', 'GuanDanSQ.exe', 67078, 100, 0, 'ZQGuanDanSQDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 223, 3, '�����走', 'GuanDanHA.exe', 67078, 100, 0, 'ZQGuanDanHADB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 224, 3, '���������', 'SanDaHaHN.exe', 67078, 100, 0, 'ZQSanDaHaHNDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 225, 3, '��ʮ', 'RedTen.exe', 67078, 100, 0, 'ZQRedTenDB')

-- �齫��Ϸ
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 300, 4, '�����齫', 'SparrowDZ.exe', 67078, 100, 0, 'ZQSparrowDZDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 301, 4, '�����齫', 'SparrowGB.exe', 67078, 100, 0, 'ZQSparrowGBDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 302, 4, 'Ѫս�齫', 'SparrowXZ.exe', 67078, 100, 0, 'ZQSparrowXZDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 303, 4, '��ɳ�齫', 'SparrowCS.exe', 67078, 100, 0, 'ZQSparrowCSDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 304, 4, '�㽭�齫', 'SparrowZJ.exe', 67078, 100, 0, 'ZQSparrowZJDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 305, 4, '�����齫', 'SparrowCC.exe', 67078, 100, 0, 'ZQSparrowCCDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 306, 4, '�����齫', 'SparrowER.exe', 67078, 100, 0, 'ZQSparrowERDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 307, 4, '�����齫', 'SparrowWZ.exe', 67078, 100, 0, 'ZQSparrowWZDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 308, 4, '���ݶ����齫', 'SparrowWZEX.exe', 67078, 100, 0, 'ZQSparrowWZEXDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 309, 4, '�����齫', 'SparrowNH.exe', 67078, 100, 0, 'ZQSparrowNHDB')



-- ������Ϸ
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 400, 5, '�й�����', 'ChinaChess.exe', 67078, 100, 0, 'ZQChinaChessDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 401, 5, '������', 'GoBang.exe', 67078, 100, 0, 'ZQGoBangDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 402, 5, '�Ĺ�����', 'FourEnsign.exe', 67078, 100, 0, 'ZQFourEnsignDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 403, 5, 'Χ��', 'WeiQi.exe', 67078, 100, 0, 'ZQWeiQiDB')


-- ������Ϸ
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 500, 6, '������', 'LLShow.exe', 67078, 100, 0, 'ZQLLShowDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 501, 6, '������', 'Plane.exe', 67078, 100, 0, 'ZQPlaneDB')


-- �ط���Ϸ
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 600, 7, '����ţ��', 'OxYW.exe', 67078, 100, 0, 'ZQOxYWDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 601, 7, '�����ܵÿ�', 'RunFastHN.exe', 67078, 100, 0, 'ZQRunFastHNDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 602, 7, '�ܺ���', 'PaoHuZi.exe', 67078, 100, 0, 'ZQPaoHuZiDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 603, 7, '������ʮ', 'RedTenDB.exe', 67078, 100, 0, 'ZQRedTenDBDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 604, 7, '��Դ��ʮ', 'RedTenLY.exe', 67078, 100, 0, 'ZQRedTenLYDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 605, 7, '������ʮ', 'RedTenDD.exe', 67078, 100, 0, 'QRedTenDDDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 606, 7, '�˫��', 'ShuangKouFH.exe', 67078, 100, 0, 'ZQShuangKouFHDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 607, 7, '����������', 'LandLB.exe', 67078, 100, 0, 'ZQLandLBDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 608, 7, '����������', 'WuLangTui.exe', 67078, 100, 0, 'ZQWuLangTuiDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 609, 7, '��Դ����', 'PaoYao.exe', 67078, 100, 0, 'ZQPaoYaoDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 610, 7, '����ʮ', 'SanQiShi.exe', 67078, 100, 0, 'ZQSanQiShiDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 611, 7, '����', 'DaZong.exe', 67078, 100, 0, 'ZQDaZongDB')
INSERT GameKindItem (KindID, TypeID, KindName, ProcessName, MaxVersion, SortID, Nullity, DataBaseName) VALUES ( 612, 7, '�Ͼ��ܵÿ�', 'RunFastNJ.exe', 67078, 100, 0, 'ZQRunFastNJDB')

----------------------------------------------------------------------------------------------------
GO