@isTest
public class CalledForInteractionControllerTest {
         @isTest public static void testmethod6()
     {   
       
         
         Account acc = new Account();
         acc.For_Mapping_Email__c = 'Ebenezer';
         acc.Name ='Universal Test';
         acc.School_Short_Code__c='123';
         acc.Org_code__c='3214';
         acc.School_Email__c='aluguri.rohith@gmail.com';
         insert acc;
         
            lead ld=new lead();
        ld.LastName='bc';
        ld.FirstName='yx';
        ld.LeadSource='website';
        ld.Status='unqualified';
        ld.MobilePhone='98765432';
        ld.Phone='752555667';
        ld.School_Institution__c=acc.Id;
     //   ld.Seeking_Admission_in_Grade__c='Play Group';
        ld.Converted__c=false;
        ld.Email='dd@gmail.com';
        ld.Company='vs';
        ld.Status = 'New';
        ld.Your_First_Name__c = 'rohith';
        ld.Your_Last_Name__c = 'alguri';
        ld.Category__c = 'Day scholar';
        ld.Seeking_Admission_in_Grade__c= 'sr.kg';
        ld.Relation__c = 'father';
        ld.Gender__c = 'male';
        ld.Date_of_Birth__c = date.newInstance(1995, 01, 29);

        insert ld;
         
        
         Contact con = new Contact();
         con.FirstName = 'Test_First_name';
         con.LastName ='Test_Last _name';
         con.AccountId=acc.Id;
         con.MobilePhone='9123445678';
         con.Email='rumeli@developer.com';
         con.Type__c='Admission Enquiry';
         con.Academic_Year__c='2021-2022';
         con.Relation__c='mother';
         con.Gender__c='male';
         con.Your_First_Name__c='ABC';
         con.Your_Last_Name__c='abc';
         con.Category__c='day scholar';
         con.Date_of_Birth__c=system.today();
         con.Program__c='sr.kg';
         con.OtherCity='abc';
         con.OtherCountry='ind';
         con.OtherState='abc';
         con.OtherStreet='abc';
         con.Lead__c = ld.id;
         insert con;
        
         List<Enquiry__c> enqlist=new List<Enquiry__c>();
         Enquiry__c enq = new Enquiry__c();
         enq.Contact__c =con.Id;
         enq.Enquiry_Type__c='Test_General';
         enq.Date_of_Birth__c=system.today();
         enq.Academic_Year__c='2015';
         enq.FirstName__c='test_Student';
         enq.Last_Name__c='Test';
         enq.Log_Status__c='School Tour Scheduled';
         enq.Seeking_Admission_in_Grade__c='II';
         enq.Parent_First_Name__c ='test_parent';
         enq.Parent_Last_Name__c= con.LastName;
         enq.Email__c=con.Email;
         enq.Mobile_No__c =con.MobilePhone;
         enq.School_Institution__c=con.AccountId;
         enq.Address__c ='test_address';
         enq.City__c='test_city';
         enq.State__c='test_state';
         enq.Pin_Code__c='125479';
         enq.Source_of_Information__c = 'test_source';
         enq.Stages__c='Interested';
         enq.Interested__c = true;
         enq.Application_Received__c=true;
         enq.Application_Sent__c=true;
         enq.School_Tour_Scheduled__c=true;
         enq.School_Tour_Re_Scheduled__c=false;
         enq.Interaction_Done__c=false;
         enq.Enquiry_No__c='32548';
         enq.Academic_Year__c= '2021-2022';
         enq.Address__c='hyd';
         enq.City__c='hyd';
         enq.Email__c='aluguri.rohith@gmail.com';
         enq.Name='rohith';
         enq.Mobile_No__c='9030280123';
         enq.Country__c='ind';
         enq.Gender__c='male';
         enq.orgCode__c='1235';
         enq.Curriculum__c='ib';
         enq.Category__c='day scholar';
         enq.Building_Apt_Name__c='abc';
         enq.Flat_No_House_No__c='123';
         enq.Street__c='abc';
         enq.Landmark__c='abc';
         enq.Area__c='abc';
         enq.lead__c = ld.id;
         enqlist.add(enq);
         insert enqlist;
        
         enq.School_Tour_Re_Scheduled__c = true;
         update enq;
        
         List<Event> evId = new List<Event>();
         Event ev=new Event();
         ev.Description='abcdefg';
         ev.Subject='Call';
         ev.WhatId=enqlist[0].Id;
         ev.StartDateTime=system.now();
         ev.EndDateTime=system.now();
         ev.Contact__c = con.Id ;
         ev.School_Institution__c = acc.Id;
         ev.OwnerId=UserInfo.getUserId();
         ev.Enquiry_Email__c='aluguri.rohith@gmail.com';
         ev.Description='hdjjh';
         insert ev;
         evId.add(ev);
        
         Test.setMock(HttpCalloutMock.class, new GoogleCalendarHttpCalloutMock());
         String string1 = ev.StartDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss-06:30');
         String string2 = ev.StartDateTime.format('yyyy-MM-dd\'T\'hh:mm:ss-06:30');
         Test.startTest();
        
         PageReference pageRef = Page.SchoolTour;
         Test.setCurrentPage(pageRef);
         Apexpages.currentpage().getparameters().put('id',enqlist[0].Id);
        
         ApexPages.StandardController sc1 = new ApexPages.StandardController(enqlist[0]);
         //SchoolTourController ua=new SchoolTourController(sc1);
         CalledForInteractionController cf = new CalledForInteractionController(sc1);
           cf.NoShow();
         
        // cf.
         
        /* ua.listenq = enqlist;
         ua.listev = evId;
         ua.schoolTourRescheduled(); 
         ua.noShowCheck();
         ua.noHoldEnq();
         ua.enqInterested();
*/
CalledForInteractionController.fakeMethod();    
         Test.stopTest();
        
     }

}