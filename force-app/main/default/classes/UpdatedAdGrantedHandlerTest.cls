@isTest
public class UpdatedAdGrantedHandlerTest {
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
        
        List<Admission_Granted__c> addlist=new List<Admission_Granted__c>();

        Admission_Granted__c ag1=new Admission_Granted__c();
        ag1.Adhaar_Card_No__c='123456789098';
        ag1.Birth_Place__c='kolkata';
        ag1.Category__c='Gen';
        ag1.Status__c = 'New';
        ag1.Lead__c = ld.Id;
        addlist.add(ag1) ;
        insert addlist;
        
        ag1.Status__c = 'Lost';
        update ag1;
        
        
        
        Trigger_Switch__mdt lstMd = [Select Id from Trigger_Switch__mdt where DeveloperName= 'AdmissiGrantupdateCurrentStatus'];
        
        Test.startTest();
        UpdatedAdmissionGrantedHandler.fm();
        Test.stopTest();
    }
}