#ifndef _LIBARY_H
#define _LIBARY_H

#include <stdlib.h>
#include "appoint.h"
#include "Manager.h"
#include "Mysql_select.h"
#include "Reader.h"
#include "ways.h"

class Libary
{
private:
	Chaxun se;
	Manager * manager;
	Reader * read;
	SuManager * sumanag;
public:
	Ways *way;
	Libary(string ip="192.168.1.166",string id="root",string pwd="mysql55",string db="Libarydb",int port=3306):se(ip.c_str(),id.c_str(),pwd.c_str(),db.c_str(),port),manager(NULL),read(NULL),sumanag(NULL){}
	~Libary(){}
	void Lib_Run(int i=3)
	{
	        Chaxun& se=this->se;
		MYSQL_RES *point;
		while(i!=0)
		{
			i=way->welcome_wind();
			if(i==1)
			{
				way->input_id_pwd_wind();
				string id,id1,pwd;
				cin>>id>>pwd;
				id1="select manage_pwd,manage_name,manage_position from manager where manage_id = '"+id+"';";
				se.Demand_str_one(id1.c_str(),0,0);
				if(se.data==NULL)
					return;
				if(pwd==string(se.data))
				{
					se.Demand_str_one(id1.c_str(),0,1);
					std::string name(se.data);
					se.Demand_str_one(id1.c_str(),0,2);
					string position(se.data);
					if(position=="��������Ա")
					{
						cout<<"       ��ӭ�㳬������Ա"<<name<<endl;
						sumanag=new SuManager(id,pwd,name,position);
						while(i!=0)
						{
							i=Ways::super_manager_wind();
							if(i==1)//���ӹ���Ա  
								sumanag->Add_Member(1,se);
							if(i==2)//����ͼ��     
								sumanag->Add_Member(2,se);
							if(i==3)//����ѧ��       
								sumanag->Add_Member(3,se);
							if(i==4)//ȥ������Ա        
								sumanag->Del_Member(1,se);
							if(i==5)//�޸�ͼ��         
								sumanag->Del_Member(2,se);
							if(i==6)//ȥ��ѧ��        
								sumanag->Del_Member(3,se);
							if(i==7)//��ʾ����ѧ����Ϣ  
								sumanag->Show_News(1,se);
							if(i==8)//��ʾ���й���Ա��Ϣ
								sumanag->Show_News(2,se);
							if(i==9)//��ʾ����ͼ����Ϣ  
								sumanag->Show_News(3,se);
							if(i==10)//����Ա������ѯ   
								sumanag->Show_News(4,se);
							if(i==11)//�軹���¼�ܲ�ѯ 
								sumanag->Show_News(5,se);
							if(i==12)//ԤԼ��¼�ܲ�ѯ 
								sumanag->Show_News(6,se);
						}
						if(i==0)
						{
							Lib_Run();
							delete sumanag;
						}
					}
					if(position=="����Ա")
					{
						cout<<"       ��ӭ�����Ա"<<name<<endl;
						manager=new Manager(id,pwd,name,position);
						while(i!=0)
						{
							i=Ways::manager_wind();
							if(i==1)//δ�黹�鱾��ѯ
                                                        {  
								string str=Ways::input_time_wind();
								//manager->select_Unreturn(str,se);
                                                        }
							if(i==2)//����δ����ѯ    
								manager->select_Unreturn_now(se);
							if(i==3)//�޸�ͼ����Ϣ    
								manager->item_Chang(se);
							if(i==4)//ͼ����鼮�ܲ�ѯ
								manager->select_Library_all(se);
							if(i==5)//�������        
								manager->return_Book(se);
							if(i==6)//�������       
								manager->lend_Book(se);
							if(i==7)//�����������    
								manager->pwd_Chang(se);
							if(i==8)//��ѯͼ����Ϣ   
								manager->select_Library_one(se);
							if(i==9)//ͼ���ʧ        
								manager->report_Lost(se);
							if(i==10)//��ʧͼ��黹  
								manager->return_Lost(se);
							if(i==11)//�������ԤԼ   
								manager->process_reserva_Book(se);
						}
						if(i==0)
						{
							Lib_Run();
							delete manager;
						}
					}
				}
			}
			if(i==2)
			{
				Ways::input_id_pwd_wind();
				string id,id1,pwd;
				cin>>id>>pwd;
				id1="select Read_pwd,Read_name,Read_type,number from reader where Read_id = '"+id+"';";
				//cout<<id1<<endl;
				se.Demand_str_one(id1.c_str(),0,0);
				if(pwd==string(se.data))
				{
					se.Demand_str_one(id1.c_str(),0,1);
					string name(se.data);
					se.Demand_str_one(id1.c_str(),0,2);
					string type(se.data);
					se.Demand_str_one(id1.c_str(),0,3);
					string snumber(se.data);
					read=new Reader(id,pwd,name,atoi(type.c_str()),atoi(snumber.c_str()));
					while(i!=0)
					{
						i=read->way->reader_wind();
						if(i==1)//��ʧ�鱾��ѯ    
							read->select_Lost(se);
						if(i==2)//����鱾��ѯ    
							read->select_Compens(se);
						if(i==3)//ͼ����ڲ����ѯ
							read->select_Library(se);
						if(i==4)//������ʷ��ѯ   
							read->select_History(se);
						if(i==5)//�ֽ��鼰�����ѯ
							read->select_Book_now(se);
						if(i==6)//�����������    
							read->pwd_Change(se);
						if(i==7)//Ԥ��ͼ�����    
							read->reserva_Book(se);
						if(i==8)//ȡ��Ԥ��ͼ�����
							read->cancel_reserva_Book(se);
						if(i==9)//ԤԼ�����ѯ  
							read->select_reserva_Book(se);
					}
					if(i==0)
					{
						Lib_Run();
						delete read;
					}
				}
			}
		}
	}
};
#endif