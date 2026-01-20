@isTest
public class Test_CalendarEventUpdateOnObjectCtrl {
    @isTest 
    static  void TestCalendarEventUpdateOnObjectCtrl ()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Account acc = new Account();
        acc.For_Mapping_Email__c = 'Ebenezer';
        acc.Name ='Test_account_name';
        acc.School_Short_Code__c='UHSC';
        insert acc;
        
        List<Id> conListId= new List<Id>();
        
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='himanshunimje@live.com';
        con.Type__c='Admission Enquiry';
        con.Enquiry_Link_Sent__c=false;
        con.Contact_Status__c='Qualified';
        con.Contact_Reasons__c='N/A';
        insert con;
        
        String ConID= con.Id;
        
        
        conListId.add(con.Id);
        
        
        
        List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
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
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.School_Tour_Scheduled__c=false;
        enq.School_Tour_Re_Scheduled__c=false;
        enq.Interaction_Done__c=true;
        enqlist.add(enq);
        insert enqlist;
        enq.Application_Sent__c=false;
        update enq;
        String objectStartWithAdmissionFormObj = system.Label.StartsWithAdmissionFormObj;
        String objectStartWithEnquiresObj = system.Label.StartsWithEnquiresObj;
        Application_Form__c af1=new Application_Form__c();
        af1.Academic_Year__c='2020-21';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='768768765654';
        af1.Father_Annual_Income__c=10000;
        af1.Mother_Anual_Income__c=20000;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Birth_Place__c='kolkata';
        af1.Blood_Group__c='AB+ve';
        af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Father_Business_Contact__c='6767876543';
        af1.Mother_Business_Contact__c='9876787654';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@developer.com';
        af1.Enquiry__c=enq.Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.School_Institution__c = enq.School_Institution__c;
        //insert af1;
        
        Admission_Form__c af2=new Admission_Form__c();
        af2.Address__c='address';
        af2.Adhaar_Card_No__c='768768765654';      
        af2.Name='rumeli';
        af2.Student_Name__c='rumeli';
        
        af2.Student_Name__c='student';
        
        af2.Admission_Granted__c=false;
        af2.Called_for_Observation__c=true;
        af2.Document_Received__c=true;
        af2.Last_Name__c='banerjee';
        af2.Mobile_Number__c='9804661694';
        af2.GuardianName__c='rumeli banerjee';
        af2.GuardianEmail_Id__c='rumeli@gmail.com';
        af2.GuardianMobile_No__c='9804661694';
        af2.Nationality__c='Indian';
        af2.Registration_No__c='2019-20/II/UHSC/REG/9';
        af2.Name='test';
        af2.School_Institution__c = af1.School_Institution__c;
        insert af2;
        
        
        Lead sobjLead = new Lead();
        sobjLead.Acadmic_Year__c='2021-2022';
        sobjLead.LastName='test';
        sobjLead.MobilePhone='2021542031';
        sobjLead.Company='Test'; 
        sobjLead.School_Institution__c=acc.id; 
        sobjLead.School_Short_Code__c='UHSC'; 
        sobjLead.Status='Duplicate'; 
        //insert sobjLead;
        
        Event sobjEvent = new Event();
        sobjEvent.Subject ='Admissions Meeting';
        sobjEvent.StartDateTime= date.today();
        sobjEvent.EndDateTime = date.today()+1;
        String s1 = String.valueof(af1.Id);
        //System.assert(s1.startsWith('a01'));
        //System.assert(s1.startsWithIgnoreCase('003'));
        //insert sobjEvent;
        //sobjEvent.WhatId = sobjEvent.id;
        //Update sobjEvent;
        list<Event> sEvent = new List<Event>();
        sEvent.add(sobjEvent);
        Insert sEvent;
        Test.startTest();
        CalendarEventUpdateOnObjectCtrl nCalendarEventUpdateOnObjectCtrl = new CalendarEventUpdateOnObjectCtrl();
        CalendarEventUpdateOnObjectCtrl.EventInsert(sEvent);
        CalendarEventUpdateOnObjectCtrl.fakeMethod();
        test.stopTest();
    }
}