@isTest public class Notification_onApplicationTest {
	
    @isTest public static void testmethod1(){
        
        Application_Form__c app=new Application_Form__c();
        app.Email_Address__c='rumeli@gmail.com';
        emailNotification_onApplicationSubmit.sendMail(app);
        
    }
   
}