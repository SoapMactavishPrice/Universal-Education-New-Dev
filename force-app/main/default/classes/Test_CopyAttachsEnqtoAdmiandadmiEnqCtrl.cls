@isTest
public class Test_CopyAttachsEnqtoAdmiandadmiEnqCtrl {
    @isTest 
    public static void TestCopyAttachsEnqtoAdmiandadmiEnqCtrl()
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
        enq.Application_Sent__c=false;
        enq.School_Tour_Scheduled__c=false;
        enq.School_Tour_Re_Scheduled__c=false;
        enq.Interaction_Done__c=true;
        insert enq;
        Test.startTest();
        Blob b = Blob.valueOf('Test Data');
        
        Attachment attachment = new Attachment();
        attachment.ParentId = acc.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        
        insert attachment;
        
        
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
        insert af1;
        
        smsgupshupTemplate__c sms = new smsgupshupTemplate__c();
        sms.Name__c = 'OTP';
        sms.Description__c = 'Your OTP for using the Universal Admission Enquiry System is %code%';
        insert sms;
        
        CopyAttachmentsEnqtoAdmiandadmiEnqCtrl.fakeMethod();
        
        CopyAttachmentsEnqtoAdmiandadmiEnqCtrl nCopyAttachmentsEnqtoAdmiandadmiEnqCtrl = new CopyAttachmentsEnqtoAdmiandadmiEnqCtrl();
        //nCopyAttachmentsEnqtoAdmiandadmiEnqCtrl.
        test.stopTest();
    }
    
    public static void TestCopyAttachsEnqtoAdmiandadmiEnqCtrl1()
    {
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Account acc = new Account();
        acc.For_Mapping_Email__c = 'Ebenezer';
        acc.Name ='Test_account_name';
        acc.School_Short_Code__c='UHSC';
        insert acc;
        
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
        
        Test.startTest();
        
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
        af1.Father_Business_Address__c='FatherBusinessAddress';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        //af1.Enquiry__c=enq.Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        insert af1;
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = af1.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        
        insert attachment;
        
        CopyAttachmentsEnqtoAdmiandadmiEnqCtrl nCopyAttachmentsEnqtoAdmiandadmiEnqCtrl = new CopyAttachmentsEnqtoAdmiandadmiEnqCtrl();
        //nCopyAttachmentsEnqtoAdmiandadmiEnqCtrl.fakeMethod();
        test.stopTest();
    }
   
}