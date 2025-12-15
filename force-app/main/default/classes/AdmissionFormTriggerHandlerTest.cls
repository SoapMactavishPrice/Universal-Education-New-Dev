@isTest
public class AdmissionFormTriggerHandlerTest {
    @isTest public static void testmethod1(){
        Account schInst = new Account();
        schInst.Name = 'Stellar World School (Bandra)';
        schInst.Website = 'https://stellarworldschool.edu.in/';
        schInst.School_Email__c = 'admissions.bandra@stellarworldschool.edu.in';
        schInst.School_Short_Code__c = 'STELRB';
        insert schInst;
        
        Lead ld = new Lead();
        ld.Acadmic_Year__c = '2022-2023';
        ld.LastName = 'test';
        ld.Email = 'test123@test.com';
        ld.MobilePhone = '9897898798';
        ld.Company = 'Test Company';
        ld.School_Institution__c = schInst.Id;
        ld.School_Short_Code__c = 'STELRB';
        ld.Your_First_Name__c = 'Ros';
        ld.Status = 'New';
        ld.LeadSource = 'Website';
        ld.utm_source__c = '';
        insert ld;
        
        List<Admission_Form__c> addlist=new List<Admission_Form__c>();
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
        af2.Status__c = 'New';
        af2.Nationality__c='Indian';
        af2.Registration_No__c='2019-20/II/UHSC/REG/9';
        af2.Lead__c = ld.Id;
        addlist.add(af2);       
        insert addlist;
        
        af2.Status__c = 'Lost';
        update af2;
            
            
        Test.startTest();
        AdmissionFormTriggerHandler.updateCurrentStatus(addlist);
        AdmissionFormTriggerHandler.fakeMethod();
        Test.stopTest();
    }
    
}