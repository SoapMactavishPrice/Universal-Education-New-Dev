@isTest
public class UE_DocumentDetailTest {
    
   /* public static TestMethod void DocumentDetailTest(){
        UE_DocumentDetail.testmethod1();
    }*/
    
     public static TestMethod  void DocumentDetailTest(){
       // Id pid=Apexpages.currentpage().getParameters().get('id');
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
         
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
         
        Account acc = new Account();
        acc.Name ='Testaccountname';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
        con.LastName ='TestLastname';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
         con.Contact_Status__c ='Non-Qualified';
         con.Contact_Reasons__c='Age criteria';
         con.Lead__c = testLead.Id;
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Academic_Year__c='2019-20';
        enq.Contact__c =con.Id;
        enq.Enquiry_Type__c='TestGeneral';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='testStudent';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='testparent';
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
        enq.Country__c='India';
         enq.Lead__c = testLead.Id;
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
        af1.Lead__c = testLead.Id;
        af1.School_Institution__c = enq.School_Institution__c;
        insert af1;
        
        Admission_Form__c af2=new Admission_Form__c();
        af2.Address__c='address';
        af2.Adhaar_Card_No__c='768768765654';      
        af2.Name='rumeli';
        af2.Student_Name__c='rumeli';
       
        af2.Student_Name__c='student';
        
        af2.Admission_Granted__c=false;
        af2.Non_Stellar_Interaction_Scheduled__c=true;
        af2.Document_Received__c=true;
        af2.Last_Name__c='banerjee';
        af2.Mobile_Number__c='9804661694';
        af2.GuardianName__c='rumeli banerjee';
        af2.GuardianEmail_Id__c='rumeli@gmail.com';
        af2.GuardianMobile_No__c='9804661694';
        af2.Nationality__c='Indian';
        af2.Registration_No__c='2019-20/II/UHSC/REG/9';
        af2.Name='test';
         af2.Lead__c = testLead.Id;
        af2.School_Institution__c = af1.School_Institution__c;
        insert af2;
        
        List_of_Document__c ldc=new List_of_Document__c();
        ldc.Name='Medical Report';
        ldc.isOptional__c=true;
        ldc.Submission_Date__c=system.today();
        ldc.isSubmitted__c=true;
        
        insert ldc;
        
        List< Document_Detail__c> dlist= new List< Document_Detail__c>();
        Document_Detail__c ddc=new Document_Detail__c();
        ddc.Name='ddc1';
        ddc.Is_optional__c=true;
        ddc.Is_Submitted__c=true;
        ddc.Submission_Date__c = system.today();
        ddc.Admission_Form__c=af2.Id;
        
        dlist.add(ddc);
        insert dlist;
        
        System.debug('dlist '+dlist[0]);
        PageReference pageRef = Page.UE_DocumentDetailChecklist;
        Test.setCurrentPage(pageRef);
        system.assertNotEquals(null, af2.id);
        Apexpages.currentpage().getparameters().put('id',af2.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(af2);
        UE_DocumentDetail ap = new UE_DocumentDetail(sc);
        ap.saveDocument();
        

    }
}