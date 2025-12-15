@isTest public class Ue_ApplicationReceivedButtonTest {
    @isTest public static void testmethod1(){
         System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        Lead ld = new Lead();
        ld.WA_Response_1__c = 'Response 1';
        ld.WA_Response_2__c = 'Response 2';
        ld.WA_Star_Response__c = 'Star Response';
        ld.LastName ='Patil';
        ld.Company ='test';
        ld.Task_Count__c = 0;
        ld.Dormant_Count__c = 0;
        ld.Dormant__c = false;
        insert ld;
        
        
        Account acc = new Account();
        acc.Name ='Test_account_name';
        //acc.lead = ld.id;
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.AccountId=acc.Id;
        con.MobilePhone='9804661694';
        con.Email='rumeli@gmail.com';
        con.Type__c='Admission Enquiry';
        con.Contact_Status__c = 'Qualified';
        con.Contact_Reasons__c = 'N/A';
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
        enq.Lead__c = ld.id;
        enqlist.add(enq);
   insert enqlist;
        
        
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
        af1.Father_Business_Contact__c='9843356798';
        af1.Mother_Business_Contact__c='9876456364';
        af1.Category__c='Gen';
        af1.Country__c='india';
        af1.City__c='kolkata';
        af1.Email_Address__c='rumeli@gmail.com';
        af1.Enquiry__c=enqlist[0].Id;
        af1.Student_Name__c='student';
        af1.Status__c='Application submitted';
        af1.State__c='state';
        af1.Lead__c = ld.id;
        insert af1;
        
        PageReference pageRef = Page.UE_applicationReceivedButton;
        Test.setCurrentPage(pageRef);
        Apexpages.currentpage().getparameters().put('id',af1.Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(af1);
        Ue_ApplicationReceivedButton ag1= new Ue_ApplicationReceivedButton(sc1);
        
        ag1.UpdateApplicationForm();
        Ue_ApplicationReceivedButton.fakeMethod();
    }
}