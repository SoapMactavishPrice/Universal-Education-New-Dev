@isTest
public class CountContactOnAccountTest {
    @isTest public static void CountConta(){
         Account a1=new Account();
        a1.Name='name';
        a1.Total_number_of_Contacts__c=10;
        a1.Total_No_of_Enquiry_Form_Recived__c=9;
        a1.Total_No_of_Application_Form_Received__c=11;
        a1.School_Email__c='abc@gmail.com';
        a1.Type='Partner';
        insert a1;
        
        Contact c1=new Contact();
        c1.TestLastName__c='biswa';
        c1.LastName='biswa';
        c1.AccountId=a1.Id;
        c1.Email='biswajit@gmaiul.com';
        insert c1;
        c1.Email='biswa@gmail.com';
        update c1;
    }
}