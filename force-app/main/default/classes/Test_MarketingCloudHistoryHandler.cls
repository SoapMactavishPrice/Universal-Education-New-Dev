@isTest
public class Test_MarketingCloudHistoryHandler {
    public static testmethod void insertMarketingCloudHistory(){
        
        Account acc=new Account();
        acc.Name='Testaccount';
        
        insert acc;
        
        lead ld=new lead();
        ld.LastName='bc';
        ld.FirstName='yx';
        ld.LeadSource='website';
        ld.Status='unqualified';
        ld.MobilePhone='98765432';
        ld.Phone='752555667';
        ld.School_Institution__c=acc.Id;
     //   ld.Seeking_Admission_in_Grade__c='Play Group';
        ld.Converted__c=false;
        ld.Email='ns@gmail.com';
        ld.Company='vs';
        ld.Status = 'New';
        ld.Your_First_Name__c = 'rohith';
        ld.Your_Last_Name__c = 'alguri';
        ld.Category__c = 'Day scholar';
        ld.Seeking_Admission_in_Grade__c= 'sr.kg';
        ld.Relation__c = 'father';
        ld.Gender__c = 'male';
        ld.Date_of_Birth__c = date.newInstance(1995, 01, 29);

        insert ld;
        
        Marketing_Cloud_History__c MH = new Marketing_Cloud_History__c();
        //MH.name = 'TestMCH';
        MH.Lead__c = ld.id;
        MH.Customer_Message__c = '{"Body":"Hi, I would love to schedule a visit.Please let me know when the earliest appointment is this week.}';
        
        insert MH;
        
        
        
        Task tsk = new Task();
        tsk.WhoId = ld.id;
        tsk.Subject = 'A New Inbound WhatsApp message has been received, Please check.';
        tsk.Status = 'Open';
        tsk.Priority = 'High';
        tsk.ActivityDate = Date.today();
        insert tsk;        
        
        
        
        
    }
}