@isTest
public class CountLeadsOnAccountTest {
    @isTest public static void CountLeadsOnAcc(){
        
        Account a1=new Account();
        a1.Name='name';
        a1.Total_number_of_Contacts__c=10;
        a1.Total_No_of_Enquiry_Form_Recived__c=9;
        a1.Total_No_of_Application_Form_Received__c=11;
       // a1.ShippingAddress='ShippingAddress';
        a1.School_Email__c='abc@gmail.com';
       // a1.BillingAddress='BillingAddress';
        a1.Type='Partner';
        insert a1;
        
        Lead l1=new Lead();
        l1.LastName='lst';
        l1.School_Institution__c=a1.Id;
        l1.Company='vs';
        insert l1;
        l1.Company='suman';
		update l1;        
        
    }
}