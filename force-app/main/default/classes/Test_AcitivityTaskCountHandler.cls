@isTest
public class Test_AcitivityTaskCountHandler {
   
    @isTest 
    static  void TestupdateTaskCountOnContact (){
        
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.MobilePhone='9123445678';
        con.Email='himanshunimje@live.com';
        con.Type__c='Admission Enquiry';
        con.Enquiry_Link_Sent__c=false;
        con.Contact_Status__c='Qualified';
        con.Contact_Reasons__c='N/A';
        insert con;
        
        Task tsk = new Task();
        tsk.Subject = 'OUTBOUND Call';
        tsk.Priority = 'Normal';
        tsk.Status = 'Completed';
        tsk.Call_Status__c = 'Connected';
        tsk.WhoId = con.Id;
        insert tsk;
        
        Test.startTest();
         AcitivityTaskCountHandler.fakeMethod();
        Test.stopTest();
        
    }
     @isTest 
    static  void TestupdateTaskCountOnEnq (){
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.MobilePhone='9123445678';
        con.Email='himanshunimje@live.com';
        con.Type__c='Admission Enquiry';
        con.Enquiry_Link_Sent__c=false;
        con.Contact_Status__c='Qualified';
        con.Contact_Reasons__c='N/A';
        insert con;
 
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2022-2023';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        insert enq;      
                
        Task tsk = new Task();
        tsk.Subject = 'OUTBOUND Call';
        tsk.Priority = 'Normal';
        tsk.Status = 'Completed';
        tsk.Call_Status__c = 'Completed';
        tsk.WhatId = enq.Id;
        insert tsk;
   
    }
     @isTest 
    static  void TestupdateTaskCountOnAppForm (){
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.MobilePhone='9123445678';
        con.Email='himanshunimje@live.com';
        con.Type__c='Admission Enquiry';
        con.Enquiry_Link_Sent__c=false;
        con.Contact_Status__c='Qualified';
        con.Contact_Reasons__c='N/A';
        insert con;
 
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2022-2023';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        insert enq; 
        
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
        insert af1;
                
        Task tsk = new Task();
        tsk.Subject = 'OUTBOUND Call';
        tsk.Priority = 'Normal';
        tsk.Status = 'Completed';
        tsk.Call_Status__c = 'Completed';
        tsk.WhatId = af1.Id;
        insert tsk;
   
    }
    @isTest 
    static  void TestupdateTaskCountOnAddForm (){
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.MobilePhone='9123445678';
        con.Email='himanshunimje@live.com';
        con.Type__c='Admission Enquiry';
        con.Enquiry_Link_Sent__c=false;
        con.Contact_Status__c='Qualified';
        con.Contact_Reasons__c='N/A';
        insert con;
 
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2022-2023';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        insert enq; 
        
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
        insert af1;
        
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
                
        Task tsk = new Task();
        tsk.Subject = 'OUTBOUND Call';
        tsk.Priority = 'Normal';
        tsk.Status = 'Completed';
        tsk.Call_Status__c = 'Completed';
        tsk.WhatId = af2.Id;
        insert tsk;
   
    }
     @isTest 
    static  void TestupdateTaskCountOnAddGrant (){
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());

        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.MobilePhone='9123445678';
        con.Email='himanshunimje@live.com';
        con.Type__c='Admission Enquiry';
        con.Enquiry_Link_Sent__c=false;
        con.Contact_Status__c='Qualified';
        con.Contact_Reasons__c='N/A';
        insert con;
 
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2022-2023';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        insert enq; 
        
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
        insert af1;
        
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
        
        Admission_Granted__c addGrant = new Admission_Granted__c();
        addGrant.Name = 'Test Add Grant';   
        insert addGrant;
        
        Task tsk = new Task();
        tsk.Subject = 'OUTBOUND Call';
        tsk.Priority = 'Normal';
        tsk.Status = 'Completed';
        tsk.Call_Status__c = 'Completed';
        tsk.WhatId = addGrant.Id;
        insert tsk;
   
    }
}