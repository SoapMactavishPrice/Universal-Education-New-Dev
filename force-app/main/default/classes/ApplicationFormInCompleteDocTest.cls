@isTest
public class ApplicationFormInCompleteDocTest {
    public static testmethod void testmethod1(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Lead testLead = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert testLead;
        
         Account acc=new Account();
        acc.Name='Test';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.Lead__c=testLead.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        insert con;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Enquiry_No__c = 'ENQ/2021-2022/93';
        enq.Contact__c =con.Id;
        enq.Lead__c=testLead.Id;
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
        insert enq;
        
        Application_Form__c af1=new Application_Form__c();
        af1.Enquiry__c = enq.Id;
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Lead__c=testLead.Id;
        af1.Adhaar_Card_No__c='768768765654';
        af1.Date_of_Birth__c = date.valueOf('2000-02-04');
       // af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        af1.Nationality__c='Indian';
        af1.Mother_Tongue__c='Beng@li';
        af1.Mother_Occupation__c='House Wife';
        af1.Blood_Group__c='AB+ve';
        //af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        //af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Single_Parent__c=true;
        af1.Mother_Detail_Captured__c=true;
        af1.Father_Datail_captured__c=true;
        af1.School_Institution__c = enq.School_Institution__c;
        af1.Application_Form_Declaration__c = true;
        insert af1;
        
        Admission_Form__c ad=new Admission_Form__c();
        ad.Registration_No__c = '2021-2022/REG/1';
        ad.First_Name__c = ' first';
        ad.Last_Name__c = ' last';
        ad.Lead__c=testLead.Id;
        ad.FatherFirst_Name__c = 'F name';
        ad.Father_Last_Name__c = 'F last';
        ad.Email_Address__c = 'test@mail.com';
        ad.Address__c = 'address';
        ad.Date_of_Birth__c =  date.valueOf('2000-02-04');
        ad.Registration_Date__c = date.valueOf('2005-02-04');
        ad.Application_Form__c = af1.Id;
        ad.Enquiry_No__c = enq.Id;
        ad.Observation_Done__c=false;
        ad.Observation_Re_scheduled__c=false;
        ad.School_Institution__c=acc.Id;
        insert ad;
        
        ad.Status__c = 'Document Incomplete';
        update ad;
        
        enq.Stages__c = 'Document Incomplete';
        update enq;
        
        test.startTest();
        ApplicationFormInCompleteDoc.UpdateDocumentInComplete(af1.Id);
        test.stopTest();
    }
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success": true, "message": "Callout simulated successfully"}');
            res.setStatusCode(200);
            return res;
        }
    }

}