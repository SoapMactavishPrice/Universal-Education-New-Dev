/*@isTest
public class InteractionAdmissionFormCtrlTest {
    @isTest public static void testmethod1(){
        InteractionAdmissionFormCtrl.dum();
          }

}*/

@isTest
public class InteractionAdmissionFormCtrlTest {
    
    // Mock class for the HTTP callout
    private class MyHttpCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Mock response for the web service callout
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "success"}');  // Sample response body
            res.setStatusCode(200);  // HTTP status code 200 for success
            return res;
        }
    }

    @isTest
    static void testCalledForInteraction() {
        
         // Set up the mock for the web service callout
    Test.setMock(HttpCalloutMock.class, new MyHttpCalloutMock());
        
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead; 
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.Org_code__c = 'UST';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
        con.LastName ='TestLastname';
        con.Lead__c=testLead.id;
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@gmail.com';
        con.Type__c='Admission Enquiry';
        con.Contact_Status__c = 'Qualified'; 
        con.Contact_Reasons__c = 'N/A';
        insert con;
        
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Lead__c=testLead.id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2020-21';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        //enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        insert enq;
        
        Application_Form__c af1=new Application_Form__c();
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Lead__c=testLead.id;
        af1.Adhaar_Card_No__c='768768765654';
        af1.Father_Annual_Income__c=10000;
        af1.Mother_Anual_Income__c=20000;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Birth_Place__c='kolkata';
        af1.Blood_Group__c='AB+ve';
        af1.Father_Business_Address__c='FatherBusinessAddress';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enq.Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.School_Institution__c = enq.School_Institution__c;
        insert af1;
        
        Admission_Form__c af2=new Admission_Form__c();
        af2.Address__c='address';
        af2.Lead__c=testLead.id;
        af2.Adhaar_Card_No__c='768768765654'; 
        af2.Name='rumeli';
        af2.Student_Name__c='rumeli';        
        af2.Enquiry_No__c=af1.Enquiry__c;
        af2.Student_Name__c='student';
        af2.Application_Form__c=af1.Id;
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
        af2.School_Institution__c = af1.School_Institution__c;
        insert af2;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(af2);
        
        Test.startTest();
        InteractionAdmissionFormCtrl controller = new InteractionAdmissionFormCtrl(sc);
        controller.CalledForInteraction();

        // Fetch the updated Admission_Form__c record
        Admission_Form__c updatedAdmissionForm = [SELECT Interaction_Scheduled__c, Status__c FROM Admission_Form__c WHERE Id = :af2.Id];
        
              Test.stopTest();
    }
    
   

    @isTest
    static void testInteractionRescheduled() {
        
         // Set up the mock for the web service callout
    Test.setMock(HttpCalloutMock.class, new MyHttpCalloutMock());
        // Create test data
         Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead; 
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.Org_code__c = 'UST';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
        con.LastName ='TestLastname';
        con.Lead__c=testLead.id;
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@gmail.com';
        con.Type__c='Admission Enquiry';
        con.Contact_Status__c = 'Qualified'; 
        con.Contact_Reasons__c = 'N/A';
        insert con;
        
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Lead__c=testLead.id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2020-21';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        //enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        insert enq;
        
        Application_Form__c af1=new Application_Form__c();
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Lead__c=testLead.id;
        af1.Adhaar_Card_No__c='768768765654';
        af1.Father_Annual_Income__c=10000;
        af1.Mother_Anual_Income__c=20000;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Birth_Place__c='kolkata';
        af1.Blood_Group__c='AB+ve';
        af1.Father_Business_Address__c='FatherBusinessAddress';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enq.Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.School_Institution__c = enq.School_Institution__c;
        insert af1;
        
        Admission_Form__c af2=new Admission_Form__c();
        af2.Address__c='address';
        af2.Lead__c=testLead.id;
        af2.Adhaar_Card_No__c='768768765654'; 
        af2.Name='rumeli';
        af2.Student_Name__c='rumeli';        
        af2.Enquiry_No__c=af1.Enquiry__c;
        af2.Student_Name__c='student';
        af2.Application_Form__c=af1.Id;
        af2.Admission_Granted__c=false;
        af2.Called_for_Observation__c=true;
        af2.Document_Received__c=true;
        af2.Last_Name__c='banerjee';
        af2.Mobile_Number__c='9804661694';
        af2.Non_Stellar_Interaction_Scheduled__c= False;
        af2.GuardianName__c='rumeli banerjee';
        af2.GuardianEmail_Id__c='rumeli@gmail.com';
        af2.GuardianMobile_No__c='9804661694';
        af2.Nationality__c='Indian';
        af2.Registration_No__c='2019-20/II/UHSC/REG/9';
        af2.School_Institution__c = af1.School_Institution__c;
        insert af2;
        
        
       

        ApexPages.StandardController sc = new ApexPages.StandardController(af2);

        Test.startTest();
        InteractionAdmissionFormCtrl controller = new InteractionAdmissionFormCtrl(sc);
        controller.InteractionRescheduled();
        controller.InteractionOnline();
        controller.InteractionOnlineRescheduled();
       // controller.IntractionDoneEnquiry();
        // Fetch the updated Admission_Form__c record
        Admission_Form__c updatedAdmissionForm = [SELECT Interaction_Scheduled__c, Interaction_Rescheduled__c, Status__c FROM Admission_Form__c WHERE Id = :af2.Id];
        
       
        Test.stopTest();
    }
    
   
/*
    @isTest
    static void testIntractionDoneEnquiry() {
        // Create test data
       
         Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead; 
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.Org_code__c = 'UST';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
        con.LastName ='TestLastname';
        con.Lead__c=testLead.id;
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@gmail.com';
        con.Type__c='Admission Enquiry';
        con.Contact_Status__c = 'Qualified'; 
        con.Contact_Reasons__c = 'N/A';
        insert con;
        
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Lead__c=testLead.id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2020-21';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        //enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c =con.MobilePhone;
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='testaddress';
        enq.City__c='testcity';
        enq.State__c='teststate';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'testsource';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        insert enq;
        
        Application_Form__c af1=new Application_Form__c();
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Lead__c=testLead.id;
        af1.Adhaar_Card_No__c='768768765654';
        af1.Father_Annual_Income__c=10000;
        af1.Mother_Anual_Income__c=20000;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Birth_Place__c='kolkata';
        af1.Blood_Group__c='AB+ve';
        af1.Father_Business_Address__c='FatherBusinessAddress';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enq.Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.School_Institution__c = enq.School_Institution__c;
        insert af1;
        
        Admission_Form__c af2=new Admission_Form__c();
        af2.Address__c='address';
        af2.Lead__c=testLead.id;
        af2.Adhaar_Card_No__c='768768765654'; 
        af2.Name='rumeli';
        af2.Student_Name__c='rumeli';        
        af2.Enquiry_No__c=af1.Enquiry__c;
        af2.Student_Name__c='student';
        af2.Application_Form__c=af1.Id;
        af2.Admission_Granted__c=false;
        af2.Called_for_Observation__c=true;
        af2.Document_Received__c=true;
        af2.Last_Name__c='banerjee';
        af2.Mobile_Number__c='9804661694';
        af2.Non_Stellar_Interaction_Scheduled__c= False;
        af2.GuardianName__c='rumeli banerjee';
        af2.GuardianEmail_Id__c='rumeli@gmail.com';
        af2.GuardianMobile_No__c='9804661694';
        af2.Nationality__c='Indian';
        af2.Registration_No__c='2019-20/II/UHSC/REG/9';
        af2.School_Institution__c = af1.School_Institution__c;
        af2.Non_Stellar_Interaction_Done__c = false;
         af2.Non_Stellar_Interaction_Scheduled__c = false;
         af2.Interaction_Scheduled__c = false;
         af2.Interaction_Rescheduled__c = false;
         af2.Interaction_Online_Scheduled__c = false;
         af2.Interaction_Done__c = false;
        insert af2;

       

        ApexPages.StandardController sc = new ApexPages.StandardController(af2);

        Test.startTest();
        InteractionAdmissionFormCtrl controller = new InteractionAdmissionFormCtrl(sc);
        PageReference retURL = controller.IntractionDoneEnquiry();

        // Fetch the updated Admission_Form__c record
        Admission_Form__c updatedAdmissionForm = [SELECT Non_Stellar_Interaction_Done__c, Status__c FROM Admission_Form__c WHERE Id = :af2.Id];

        
        Test.stopTest();
    }*/

}