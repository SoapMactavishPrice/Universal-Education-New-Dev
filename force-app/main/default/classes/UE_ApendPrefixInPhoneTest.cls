@isTest
public class UE_ApendPrefixInPhoneTest {
    
    static testMethod void UE_ApendPrefixInPhone(){
        
        Contact con = new Contact();
        con.FirstName='test_name';
        con.LastName='test_las_name';
        con.MobilePhone='1234567890';
        con.SecondaryMobileNo__c='1254789630';
        insert con;
     
        
    }

}