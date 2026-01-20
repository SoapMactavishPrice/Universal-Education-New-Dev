@isTest
public class UE_ShowApplicationNumberTest {
     static TestMethod void testsms(){
        
         UE_showApplicationNumber.testmethod1();
         
       /* Account acc = new Account();
        acc.Name ='Testaccountname';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'TestFirstname';
   		con.LastName ='TestLastname';
   		con.AccountId=acc.Id;
   		con.MobilePhone='9123445678';
    	con.Email='rumeli@developer.com';
    	con.Type__c='Admission Enquiry';
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
         
        PageReference pageRef = Page.showApplicationNumber;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', af1.Id);
        //test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(af1);
        UE_showApplicationNumber testcon = new UE_showApplicationNumber(sc);
        testcon.downloadForm_B_C_D_D();
        testcon.downloadForm_A();
        //test.stopTest(); */
        
    }
}