@echo off

TITLE �������ݿ⡾Ver6.6_Spreader�� �����ű�������... [�ڼ�����ر�]

if not exist "G:\WHDB" (
		md G:\WHDB
	)

Rem �������ݿ�����
set rootPath=���ݿ�ű�\
osql -E -i "%rootPath%���ݿ�ɾ��.sql"
osql -E -i "%rootPath%1_1_�û���ű�.sql"
osql -E -i "%rootPath%1_2_ƽ̨��ű�.sql"
osql -E -i "%rootPath%1_3_�Ƹ���ű�.sql"
osql -E -i "%rootPath%2_1_�û���ű�.sql"
osql -E -i "%rootPath%2_2_ƽ̨��ű�.sql"
osql -E -i "%rootPath%2_3_�Ƹ���ű�.sql"

Rem �����ӷ�����������
set rootPath=���ݽű�\
osql -E -i "%rootPath%��������.sql"

Rem �洢����
set rootPath=�洢����\�û���\
osql -E  -i "%rootPath%��ʶ��¼.sql"
osql -E  -i "%rootPath%�ʺŵ�½V3R4.sql"
osql -E  -i "%rootPath%ע���ʺ�V3R4.sql"
osql -E  -i "%rootPath%�û�Ȩ��.sql"
osql -E  -i "%rootPath%�����ʺ�.sql"
osql -E  -i "%rootPath%�Զ���ͷ��.sql"
osql -E  -i "%rootPath%��ʶ��¼.sql"
osql -E  -i "%rootPath%��ʱ����.sql"
osql -E  -i "%rootPath%��ͱ�.sql"
osql -E  -i "%rootPath%�콱��.sql"
osql -E  -i "%rootPath%�̳ǳ�ֵ.sql"
osql -E  -i "%rootPath%�̳Ƕһ�.sql"
osql -E  -i "%rootPath%������΢���ʺ�.sql"
osql -E  -i "%rootPath%΢���ʺŰ��ֻ���.sql"
osql -E  -i "%rootPath%΢���ʺ�ע��.sql"
osql -E  -i "%rootPath%�޸ĸ���ǩ��.sql"
osql -E  -i "%rootPath%�û�ǩ��.sql"
osql -E  -i "%rootPath%�û�Ȩ��.sql"
osql -E  -i "%rootPath%�û�����.sql"

set rootPath=�洢����\ƽ̨��\
osql -E  -i "%rootPath%�ύ����.sql"
osql -E  -i "%rootPath%��Ӫ����.sql"

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
osql -E  -i "%rootPath%ID��¼����V3R4.sql"
osql -E  -i "%rootPath%��ȡ���а�V3R4.sql"
osql -E  -i "%rootPath%�������а�V3R4.sql"
osql -E  -i "%rootPath%��Ӫ����.sql"

pause

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


