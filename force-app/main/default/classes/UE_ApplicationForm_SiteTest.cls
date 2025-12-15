@isTest public class UE_ApplicationForm_SiteTest {
    @isTest public static void tes1()
    {
         UE_ApplicationForm_Site.fakeMethod();
    }
    @isTest public static void testmethod1(){
        lead ld = new lead();
        ld.LastName = 'Vijay';
        ld.Company = 'TestC';
        insert ld;
            
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c='UHSC';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.lead__c = ld.id;
        
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.Contact_Status__c = 'Qualified';
        con.Contact_Reasons__c = 'N/A';
        insert con;
        
        Class__c cl = new Class__c();
        cl.Name = 'TEst';
        cl.Original_Class__c = 'test';
        cl.School_Name__c = acc.Id;
        insert cl;
        
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.lead__c = ld.id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        //enq.Seeking_Admission_in_Grade__c='II';
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
        enq.School_Institution__c=con.AccountId;
        enq.Seeking_Grade__c = cl.Id;
        enq.Relation__c = 'Father';
        insert enq;
        
        smsgupshupTemplate__c sms = new smsgupshupTemplate__c();
        sms.Name__c = 'OTP';
        sms.Description__c = 'Your OTP for using the Universal Admission Enquiry System is %code%';
        insert sms;
        
        Application_Form__c af1=new Application_Form__c();
        af1.lead__c = ld.id;
        af1.Academic_Year__c='2019-20';
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='768768765654';
        af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        af1.Nationality__c='Indian';
        af1.Mother_Tongue__c='Bengali';
        af1.Mother_Occupation__c='House Wife';
        af1.Blood_Group__c='AB+ve';
        af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country1__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enq.Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.School_Institution__c = enq.School_Institution__c;
        af1.Mother_Detail_Captured__c = true;
        af1.Father_Datail_captured__c = true;
        af1.Guardian_Name__c = 'Test';
        af1.Father_First_Name__c = 'Test';
        af1.Father_Last_Name__c = 'Test';
        af1.Father_Name_of_Organisation__c = 'test';
        af1.Mother_First_Name__c = 'Test';
        af1.Mother_Last_Name__c = 'Test';
        af1.Mother_Name_of_Organisation__c = 'Test';
        af1.Mother_Email_Id__c = 'test@test.com';
        af1.Father_Email_Id__c = 'test@test.com';
        af1.Father_Occupation__c = 'Test';
        af1.Mother_Occupation__c = 'HW';
        af1.Mother_Phone__c = '1234567890';
        af1.Father_Phone__c = '1234567890';
        af1.Mother_Qualification__c = 'Test';
        af1.Father_Qualification__c = 'test@';
        af1.Father_Aadhar_Card__c = '112334435353';
        af1.Mother_Adhaar_Card_No__c = '214312131531';
        af1.Form_B_captured__c=true;
        af1.Is_the_child_taking_any_medication__c = null;
        af1.Allergies__c = null;
        insert af1;
        
        enq.Application_Received__c = true;
        enq.Stages__c = 'Application submitted';
        update enq;
        try
        {
        PageReference pageRef = Page.UE_applicationForm_Site;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',af1.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(af1);
        UE_ApplicationForm_Site ag1= new UE_ApplicationForm_Site(sc1);
        
        
        Apexpages.currentpage().getparameters().put('id',enq.Id);
        ApexPages.StandardController scenq1 = new ApexPages.StandardController(enq);
        //UE_ApplicationForm_Site agenq1= new UE_ApplicationForm_Site(scenq1);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new MockHttpResponseGeneratorApplicationOTP());
        ag1.sendOTP();
        ag1.verifyOtpSms();
        ag1.validate();
        ag1.getpassport();
        ag1.getexpdate();
        ag1.validateMother();
        ag1.save();
        UE_ApplicationForm_Site.fakeMethod();
        ag1.toggleEditMode();
        ag1.checkIfParentIsCaptured();
        ag1.redirectToPaymentPage();
        ag1.validateMother2();
        ag1.checkIfParentIsCaptured();
        //ag1.fetchAllUploadedDocuments();
        Test.stopTest();
        
        }catch (exception ex)  
        {
            system.debug(ex);
        }
        //ag1.verifyOtpSms();
        //ag1.sendOTP();
    }
    
  
    
    public static testMethod void testmethod3(){
        lead ld = new lead();
        ld.LastName = 'Vijay';
        ld.Company = 'TestC';
        insert ld;
        
        Account acc = new Account();
        acc.Name ='Testaccountname';
        acc.School_Short_Code__c='UHSC';
        insert acc;
        
        Contact con = new Contact();
        con.Lead__c = ld.id;
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.Contact_Status__c = 'Qualified';
        con.Contact_Reasons__c = 'N/A';
        insert con;
        
        Class__c cl = new Class__c();
        cl.Name = 'TEst';
        cl.Original_Class__c = 'test';
        cl.School_Name__c = acc.Id;
        insert cl;
        
        List<Enquiry__c> enqlist=new List<Enquiry__c>();
        Enquiry__c enq = new Enquiry__c();
        enq.Contact__c =con.Id;
        enq.Lead__c = ld.id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2020-21';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='On Hold';
        enq.Seeking_Admission_in_Grade__c='II';
        enq.Parent_First_Name__c ='test_parent';
        enq.Parent_Last_Name__c= con.LastName;
        enq.Email__c=con.Email;
        enq.Mobile_No__c ='8197318304';
        enq.School_Institution__c=con.AccountId;
        enq.Address__c ='test_address';
        enq.City__c='test_city';
        enq.State__c='test_state';
        enq.Pin_Code__c='125479';
        enq.Source_of_Information__c = 'test_source';
        enq.Stages__c='Application submitted';
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.School_Institution__c=con.AccountId;
        enq.Seeking_Grade__c = cl.Id;
        enqlist.add(enq);
        insert enq;
        
        smsgupshupTemplate__c sms = new smsgupshupTemplate__c();
        sms.Name__c = 'OTP';
        sms.Description__c = 'Your OTP for using the Universal Admission Enquiry System is %code%';
        insert sms;
        
        Application_Form__c af1=new Application_Form__c();
        //af1.Academic_Year__c='2020-21';
        af1.lead__c = ld.id;
        af1.Address__c='address';
        af1.Adhaar_Card_No__c='125478963012';
        af1.Father_Annual_Income__c=1;
        af1.Mother_Anual_Income__c=2;
        af1.Application_Form_Declaration__c=true;
        af1.Name='rumeli';
        af1.Passport_No__c='1234';
        af1.Birth_Place__c='kolkata';
        af1.Nationality__c='Indian';
        af1.Mother_Tongue__c='Bengali';
        af1.Mother_Occupation__c='House Wife';
        af1.Blood_Group__c='AB+ve';
        af1.Father_Business_Address__c='Father_Business_Address__c';
        af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Address__c='mother_Business_Address__c';
        af1.Mobile_Number__c = '1478529630';
        af1.Mother_First_Name__c = 'Test first Name ';
        af1.Mother_Last_Name__c = 'Test last name';
        af1.Mother_Phone__c = '1154369770';
        af1.Mother_Detail_Captured__c = true;
        af1.Mother_Email_Id__c = 'test@gmail.com';
        af1.Mother_Business_Contact__c='1547823690';
        af1.Category__c='Gen';
        af1.Country1__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enq.Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Single_Parent__c = false;
        af1.School_Institution__c = enq.School_Institution__c;
        insert af1;
        
        PageReference pageRef = Page.UE_applicationForm_Site;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',af1.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(af1);
        UE_ApplicationForm_Site ag1= new UE_ApplicationForm_Site(sc1);
        
        Test.startTest();
        try
        {
        Test.setMock(HttpCalloutMock.class,new MockHttpResponseGeneratorApplicationOTP());
        
         UE_ApplicationForm_Site.fakeMethod();
            ag1.sendOTP();
        ag1.verifyOtpSms();
        ag1.getpassport();
        ag1.getexpdate();
        ag1.validateMother();
        ag1.save();
        ag1.toggleEditMode();
        ag1.validate();
        ag1.validateMother2();
        ag1.checkIfParentIsCaptured();
          ag1.getApplicationFormRelation();
        ag1.fetchAllUploadedDocuments();
        ag1.fetchUploadedDocuments();
       
        ag1.verifyOtpSms();
        ag1.sendOTP();
        ag1.FMGResult();
        ag1.FMGSiblingIdInformationtrue();
        ag1.FMGResultNationality();
         Test.stopTest();
        }
        catch(Exception e)
        {
            system.debug(e);
        }
    }
}