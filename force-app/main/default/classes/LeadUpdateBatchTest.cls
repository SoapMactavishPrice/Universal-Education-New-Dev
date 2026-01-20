@isTest 
public class LeadUpdateBatchTest {
      static testMethod void testMethod1() 
      {
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
          
            Contact con = new Contact();  
            con.LastName=ld.Name;
            con.Email=ld.Email;
            con.MobilePhone=ld.MobilePhone;
            con.AccountId = ld.School_Institution__c;
            con.Phone = ld.Phone;
            con.Your_First_Name__c = ld.Your_First_Name__c;
            con.Your_Last_Name__c = ld.Your_Last_Name__c;
            con.Category__c = ld.Category__c ;
            con.Program__c = ld.Seeking_Admission_in_Grade__c;
            con.Relation__c = ld.Relation__c;
            con.Gender__c = ld.Gender__c;
            con.Date_of_Birth__c = ld.Date_of_Birth__c;
            con.Contact_Status__c = ld.Status;
            con.Lead_ID__c=ld.id;
            con.LastName=ld.LastName;
          
            insert con;          
       
        Test.startTest();

        LeadUpdateBatch obj = new LeadUpdateBatch();
        DataBase.executeBatch(obj); 
            
        Test.stopTest();
      }

}