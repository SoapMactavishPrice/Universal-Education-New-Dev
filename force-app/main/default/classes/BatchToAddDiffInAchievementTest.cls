@istest
public class BatchToAddDiffInAchievementTest {
    
 static testMethod void upsertNewAchievement(){
        Account acc = new Account();
        acc.Website = 'www.primusschool.edu.in';
        acc.School_Short_Code__c = 'PRIMUS';
        acc.School_Email__c = 'administrator@primusschool.edu.in';
        acc.Name = 'Primus Public School';
        insert acc;
        
        Admission_Granted__c ad= new Admission_Granted__c();
        ad.Registration_No__c = '2021-2022/REG/36';
        ad.Fees_Status__c = 'Unpaid' ;
        ad.Original_Document__c = 'Pending';
        ad.Status__c = 'Admission Process Completed';
        insert ad;
            
        Targets__c tr = new Targets__c();
        tr.Target__c = 10;
        tr.Unique_Key__c = '123578';
        tr.Month__c = 'February';
        tr.Year__c = '2021';
        insert tr;
        
        List<Targets__c> Target = [Select Id, Achievement__c,Target__c, Unique_Key__c, Year__c, Month__c from Targets__c ];
        
          Test.startTest();
          	BatchToAddDiffInAchievementSchedular batchSch=new BatchToAddDiffInAchievementSchedular();
            String sch='0 5 2 * * ?';
            //System.schedule(String jobName, String cronExp, APEX_OBJECT schedulable);
            System.schedule('Batch Schedule', sch , batchSch);
          Test.stopTest();
    }
}