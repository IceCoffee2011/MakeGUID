@echo off

TITLE �������ݿ⡾Ver6.6_Spreader�� �����ű�������... [�ڼ�����ر�]

if not exist "G:\whdb_zq" (
		md G:\whdb_zq
	)

Rem �������ݿ�����
set rootPath=���ݿ�ű�\
osql -E -i "%rootPath%���ݿ�ɾ��.sql"
osql -E -i "%rootPath%1_1_�û���ű�.sql"
osql -E -i "%rootPath%1_2_ƽ̨��ű�.sql"
osql -E -i "%rootPath%1_3_�Ƹ���ű�.sql"
osql -E -i "%rootPath%1_4_���ֿ�ű�.sql"
osql -E -i "%rootPath%1_5_��ϰ��ű�.sql"
osql -E -i "%rootPath%1_6_������ű�.sql"


osql -E -i "%rootPath%2_1_�û���ű�.sql"
osql -E -i "%rootPath%2_2_ƽ̨��ű�.sql"
osql -E -i "%rootPath%2_3_�Ƹ���ű�.sql"
osql -E -i "%rootPath%2_4_���ֱ�ű�.sql"
osql -E -i "%rootPath%2_5_��ϰ��ű�.sql"
osql -E -i "%rootPath%2_6_������ű�.sql"

osql -E -i "%rootPath%web1.sql"
osql -E -i "%rootPath%web2.sql"
osql -E -i "%rootPath%GameScoreInfo.sql"
osql -E -i "%rootPath%GradeList.sql"
osql -E -i "%rootPath%HallVersion.sql"
osql -E -i "%rootPath%IndividualDatum.sql"
osql -E -i "%rootPath%LoggingLog.sql"
osql -E -i "%rootPath%PlacardCommon.sql"


Rem �����ӷ�����������
set rootPath=���ݽű�\
osql -E -i "%rootPath%������Ϣ.sql"
osql -E -i "%rootPath%��Ϸ�б�.sql"
osql -E -i "%rootPath%�Ƹ�����.sql"
osql -E -i "%rootPath%ƽ̨����.sql"
osql -E -i "%rootPath%�û�����.sql"
osql -E -i "%rootPath%�ʻ�����.sql"

osql -E -i "%rootPath%AccountsInfo.sql"
osql -E -i "%rootPath%GameScoreInfo.sql"
osql -E -i "%rootPath%1400_1499.sql"
osql -E -i "%rootPath%1400_1499�ӽ��.sql"

Rem �洢����
set rootPath=�洢����\�û���\
osql -E  -i "%rootPath%��ʶ��¼.sql"
osql -E  -i "%rootPath%�ʺŵ�¼.sql"
osql -E  -i "%rootPath%ע���ʺ�.sql"
osql -E  -i "%rootPath%�û�Ȩ��.sql"
osql -E  -i "%rootPath%�����ʺ�.sql"
osql -E  -i "%rootPath%�Զ���ͷ��.sql"
osql -E  -i "%rootPath%�󶨻���.sql"

osql -E  -i "%rootPath%GSP_GP_ContinueConnect.sql"
osql -E  -i "%rootPath%GSP_GP_EfficacyAccounts.sql"
osql -E  -i "%rootPath%GSP_GP_GetGradeList.sql"
osql -E  -i "%rootPath%GSP_GP_GetPlacard.sql"
osql -E  -i "%rootPath%GSP_GP_GetTask.sql"
osql -E  -i "%rootPath%GSP_GP_GiftCurrency.sql"


set rootPath=�洢����\ƽ̨��\
osql -E  -i "%rootPath%��������.sql"
osql -E  -i "%rootPath%��������.sql"
osql -E  -i "%rootPath%������Ϣ.sql"
osql -E  -i "%rootPath%���ؽڵ�.sql"

set rootPath=�洢����\�Ƹ���\
osql -E  -i "%rootPath%��ʶ��¼.sql"
osql -E  -i "%rootPath%���ػ�����.sql"
osql -E  -i "%rootPath%�뿪����.sql"
osql -E  -i "%rootPath%��Ϸд��.sql"
osql -E  -i "%rootPath%�û�Ȩ��.sql"
osql -E  -i "%rootPath%�������.sql"
osql -E  -i "%rootPath%�����һ�.sql"
osql -E  -i "%rootPath%�ʻ�����.sql"
osql -E  -i "%rootPath%���м�¼.sql"

osql -E  -i "%rootPath%GSP_GP_DayWinLoseCount.sql"
osql -E  -i "%rootPath%GSP_GP_IN_WriteGoldLog.sql"
osql -E  -i "%rootPath%GSP_GR_DeleteUserLocker.sql"
osql -E  -i "%rootPath%GSP_GR_EfficacyUserID.sql"
osql -E  -i "%rootPath%GSP_GR_WriteGameScore.sql"

set rootPath=�洢����\���ֿ�\
osql -E  -i "%rootPath%��ʶ��¼.sql"
osql -E  -i "%rootPath%���ػ�����.sql"
osql -E  -i "%rootPath%�뿪����.sql"
osql -E  -i "%rootPath%��Ϸд��.sql"
osql -E  -i "%rootPath%�û�Ȩ��.sql"
osql -E  -i "%rootPath%�������.sql"
osql -E  -i "%rootPath%�����һ�.sql"
osql -E  -i "%rootPath%�ʻ�����.sql"
osql -E  -i "%rootPath%���м�¼.sql"

set rootPath=�洢����\��ϰ��\
osql -E  -i "%rootPath%��ʶ��¼.sql"
osql -E  -i "%rootPath%���ػ�����.sql"
osql -E  -i "%rootPath%�뿪����.sql"
osql -E  -i "%rootPath%��Ϸд��.sql"
osql -E  -i "%rootPath%�û�Ȩ��.sql"
osql -E  -i "%rootPath%�������.sql"
osql -E  -i "%rootPath%�����һ�.sql"
osql -E  -i "%rootPath%�ʻ�����.sql"
osql -E  -i "%rootPath%���м�¼.sql"

set rootPath=�洢����\������\
osql -E  -i "%rootPath%��ʶ��¼.sql"
osql -E  -i "%rootPath%���ػ�����.sql"
osql -E  -i "%rootPath%�뿪����.sql"
osql -E  -i "%rootPath%��Ϸд��.sql"
osql -E  -i "%rootPath%�û�Ȩ��.sql"
osql -E  -i "%rootPath%�������.sql"
osql -E  -i "%rootPath%�����һ�.sql"
osql -E  -i "%rootPath%�ʻ�����.sql"
osql -E  -i "%rootPath%���м�¼.sql"
pause

CLS
@echo off
@echo ����������ϷID ����
set rootPath=���ݽű�\
osql -E  -i "%rootPath%��ʶ����.sql"

COLOR 0A
CLS
@echo off
cls
echo ------------------------------
echo.
echo	��Ҫ���ݿ⽨����ɣ�������Լ�ƽ̨�Ļ�����Ϸִ�� 
echo.
echo.
echo	��Ȩ���У� �����������Ƽ����޹�˾
echo ------------------------------

pause


