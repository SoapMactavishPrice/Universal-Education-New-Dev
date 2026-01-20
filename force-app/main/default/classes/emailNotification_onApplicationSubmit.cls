//Purpose : Email Notify when Application is Submitted.
//Currently is not Using and Inactive.


public class emailNotification_onApplicationSubmit {
    
    public static void sendMail( Application_Form__c document) {
         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {address};
        String[] toAddresses = new String[] {document.Email_Address__c};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Subject');
         mail.setHtmlBody('Dear Ms/ Mr.'+document.Student_Name__c+',<br/><br/>Thank you for registering with Universal Education Admission Enquiry System. Your Enquiry Number is'+document.Name+
                          ' <br/><br/>Kindly explore the following links:<br/><br/>Online Admission Process :<a href="https://malad.universalhigh.edu.in/application">(Click Here)</a><br/>Age criteria for admission :<a href="https://malad.universalhigh.edu.in/age-criteria/">(Click Here)</a><br/>Primary & Secondary Brochure Link:<a href="https://drive.google.com/file/d/0B3kGZqzP7_uJNEVPZHYydi05ZkE/view">(Click Here)</a><br/>Pre - Primary Brochure Link:<a href="https://drive.google.com/file/d/0B3kGZqzP7_uJWmJ6amZHWEZ5ZEU/view/"/>(Click Here)</a><br/>Facebook Link :<a href="https://www.facebook.com/pg/UHMalad/about/">(Click Here)</a> '+ +
                          ' <br/><br/>We would be happy to meet you to process your admission application. Kindly get back to us to schedule an appointment with you.</p><br/><br/>Office Timings: Monday to Saturday: 9:00 am to 5:00 pm<br/><br/>Working Saturdays of the month: 1st, 3rd and 5th<br/><br/>The office will remain closed on Bank Holidays.<br/><br/>Thank you again for your enquiry.<br/><br/><b>Best Regards</b><br/>Universal Education <br/> Admission Enquiry System ');
       
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
                                 new Messaging.SingleEmailMessage[] { mail });
        inspectResults(results);
    }
    
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
               	sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());  
                
            }
        }
        
        return sendResult;
    }
}