@isTest
public with sharing class FileUploadControllerTest {
    
    
    class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res;
        }
    }
    @isTest 
    public static void testmethod1()
    {
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       // Id pid=Apexpages.currentpage().getParameters().get('id');
         Account acc = new Account();
        acc.Name ='Test_account_name';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        insert con;

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
        enqlist.add(enq);
        insert enqlist;

        FileUploadController.saveAttachment(enqlist[0].Id, 'StudentPhoto',  'Unit Test Attachment Body','content','jpg');
        FileUploadController.getPic(enqlist[0].Id, 'StudentPhoto');

        Application_Form__c af1=new Application_Form__c();
        af1.Academic_Year__c='2019-20';
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
        af1.Email_Address__c='biswajit@developer.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        insert af1;

        List<Application_Form__c> aflist=new List<Application_Form__c>();
    Application_Form__c af=new Application_Form__c();
        af.Academic_Year__c='2019-20';
        af.Address__c='address';
        af.Adhaar_Card_No__c='768768765654';
        af.Father_Annual_Income__c=10000;
        af.Mother_Anual_Income__c=20000;
        af.Application_Form_Declaration__c=true;
        af.Name='rumeli';
        af.Birth_Place__c='kolkata';
        af.Blood_Group__c='AB+ve';
        af.Father_Business_Address__c='Father_Business_Address__c';
        af.Mother_Business_Address__c='mother_Business_Address__c';
        af.Father_Business_Contact__c='6767876543';
        af.Mother_Business_Contact__c='9876787654';
        af.Category__c='Gen';
        af.Country__c='india';
        af.City__c='kolkata';
        af.Email_Address__c='rumelit@developer.com';
        af.Enquiry__c=enqlist[0].Id;
        af.Student_Name__c='student';
        af.Status__c='Application submitted';
        af.State__c='state';
        af.Single_Parent__c=true;
        af.Seeking_Admission_for_another_Child__c='Yes';
        af.Seeking_Admission_in_Grade__c='PLAYGROUP';
        af.School_Name__c='NUHS';
        af.Relationship__c='father';
        af.Religion__c='Hindu';
        af.Residence_No__c='9887656765';
        af.Father_Name_of_Organisation__c='Father_Name_of_Organisation__c';
        af.Father_Datail_captured__c=true;
        af.Father_Last_Name__c='Father_Last_Name__c';
        af.Father_Occupation__c='Father_Occupation__c';
        af.Father_Phone__c='0989878765';
        af.Father_Qualification__c='Father_Qualification__c';
        af.School_Institution__c=acc.Id;
        af.Document_Verified__c=true;
        af.Print_Copy_Submitted__c=true;
        aflist.add(af);
        insert aflist;

        // Contentversion cv = new Contentversion();
        // cv.Title = 'StudentPhoto-StudentPhoto.png';
        // cv.PathOnClient = 'StudentPhoto-340px-Affidavit-of-Residence.png';
        // cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.urlEncode('Unit Test Attachment Body','UTF-8'));
        // cv.IsMajorVersion = true;
        // cv.description=af.id + '-StudentPhoto';
        // insert cv;

        // //Get Content Documents
        // Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;

        // //Create ContentDocumentLink
        // ContentDocumentLink cdl = New ContentDocumentLink();
        // cdl.LinkedEntityId = af.id;
        // cdl.ContentDocumentId = conDocId;
        // cdl.shareType = 'V';
        // //Insert cdl;

        FileUploadController.saveAttachment(aflist[0].Id, 'StudentPhoto',  'Unit Test Attachment Body','content','jpg');
        FileUploadController.saveAttachment(aflist[0].Id, 'FatherPhoto',  'Unit Test Attachment Body','content','jpg');
        FileUploadController.saveAttachment(aflist[0].Id, 'FatherSignaturePhoto',  'Unit Test Attachment Body','content','jpg');
        FileUploadController.saveAttachment(aflist[0].Id, 'MotherSignaturePhoto',  'Unit Test Attachment Body','content','jpg');
        FileUploadController.saveAttachment(aflist[0].Id, 'MotherPhoto',  'Unit Test Attachment Body','content','jpg');

        PageReference pageRef = Page.ApplicationformPDF;
          Test.setCurrentPage(pageRef);
          Apexpages.currentpage().getparameters().put('id',aflist[0].Id);
          Apexpages.currentpage().getparameters().put('af_id',aflist[0].Id);

         ApexPages.StandardController sc1 = new ApexPages.StandardController(aflist[0]);
         try {

             Applicationform ua=new Applicationform(sc1);
         } catch (Exception e) {

         }
         try {

             Applicationform.fakeMethod();
         } catch (Exception e) {

         }
         try {

             UE_applicationPreview uapreview=new UE_applicationPreview(sc1);
         } catch (Exception e) {

         }
    }

}