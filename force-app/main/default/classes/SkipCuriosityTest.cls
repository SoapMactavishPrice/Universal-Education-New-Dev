@isTest
public class SkipCuriosityTest {
    static testMethod void testSkipCuriosity(){
        
        System.Test.setMock(HttpCalloutMock.class, new StellarAPICalloutMock());
        lead ld = new lead();
        ld.LastName = 'Vijay';
        ld.Company = 'TestC';
        insert ld;
        
        Account acc = new Account();
        acc.Name ='Test_account_name';
        acc.School_Short_Code__c='123';
        acc.Org_code__c='3214';
        acc.School_Email__c='aluguri.rohith@gmail.com';   
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test_First_name';
        con.LastName ='Test_Last _name';
        con.Lead__c = ld.id;
        con.AccountId=acc.Id;
        con.MobilePhone='9123445678';
        con.Email='rumeli@developer.com';
        con.Type__c='Admission Enquiry';
        con.Academic_Year__c='2022-2023';
        con.Relation__c='mother';
        con.Gender__c='male';
        con.Your_First_Name__c='ABC';
        con.Your_Last_Name__c='abc';
        con.Category__c='day scholar';
        con.Date_of_Birth__c=system.today();
        con.Program__c='sr.kg';
        con.OtherCity='abc';
        con.OtherCountry='ind';
        con.OtherState='abc';
        con.OtherStreet='abc';
        con.Contact_Status__c = 'New';
        con.Contact_Reasons__c = 'N/A';
        con.Stellar_Seeking_Admission_in_Grade__c  ='Nursery';
        con.Current_school__c = 'Vikas';
        insert con;
        
        
        Enquiry__c enq = new Enquiry__c();
        enq.Name = 'CUR/'+con.Academic_Year__c+'/278';
        enq.Contact__c =con.Id;
        enq.Lead__c = ld.id;
        enq.Enquiry_Type__c='Test_General';
        enq.Date_of_Birth__c=system.today();
        enq.Academic_Year__c='2015';
        enq.FirstName__c='test_Student';
        enq.Last_Name__c='Test';
        enq.Log_Status__c='School Tour ';
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
        enq.Interested__c = true;
        enq.Application_Received__c=true;
        enq.Application_Sent__c=true;
        enq.School_Tour_Scheduled__c=false;
        enq.School_Tour_Re_Scheduled__c=false;
        enq.Interaction_Done__c=false;
        
        enq.Enquiry_No__c='32548';
        enq.Academic_Year__c= '2021-2022';
        enq.Address__c='hyd';
        enq.City__c='hyd';
        enq.Email__c='aluguri.rohith@gmail.com';
        enq.Mobile_No__c='9030280123';
        enq.Country__c='ind';
        enq.Gender__c='male';
        enq.orgCode__c='1235';
        enq.Curriculum__c='ib';
        enq.Category__c='day scholar';
        enq.Building_Apt_Name__c='abc';
        enq.Flat_No_House_No__c='123';
        enq.Street__c='abc';
        enq.Landmark__c='abc';
        enq.Area__c='abc';
        enq.Stages__c='Meet Done';
        enq.Current_school__c = con.Current_school__c;
       
        insert enq;
        
        Test.startTest();
        //SkipCuriosity nSkipCuriosity = new SkipCuriosity();
        SkipCuriosity.CreateEnquiryRecord(con.Id);
        SkipCuriosity.fakeMethod();
       // SkipCuriosity.CreateEnquiry();
        SkipEnquiry.CreateEnquiryRecord(con.Id);
        Test.stopTest();
    }
}