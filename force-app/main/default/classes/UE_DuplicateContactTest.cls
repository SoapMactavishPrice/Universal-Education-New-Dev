@isTest
public class UE_DuplicateContactTest {
    
    Static testmethod void duplicateContact(){
        
        Contact con = new Contact();
        con.FirstName='test';
        con.LastName='test';
        con.Phone = '1245789';
        con.MobilePhone='+911254879630';
        con.SecondaryMobileNo__c='+915125487964';
        insert con;
    }

}