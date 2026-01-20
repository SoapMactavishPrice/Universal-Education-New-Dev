@isTest 
public class UpdateMobileNumberBatchTest {
      static testMethod void testMethod1() 
    {
       // List<Account> lstAccount= new List<Account>();
        Account acc=new Account();
        acc.Name='xyz';
        
        insert acc;
        
         id leadids=Apexpages.currentPage().getparameters().get('id'); 
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
        ld.Email='dd@gmail.com';
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
        ld.DupMobileNumber__c=null;
        update ld;
        Test.startTest();

            UpdateMobileNumber obj = new UpdateMobileNumber();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }

}