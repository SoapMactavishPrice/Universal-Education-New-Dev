@isTest
public class SaveWebToLeadTest {
    
    public HTTPResponse respond(HTTPRequest req) {
                ///if (req.getEndpoint().endsWith('login')) {
                    Boolean b = True;
                    String reCode = '200';
                    String fullJson = 'Here is my String JSON';
                    String sta = 'OK';
                    String Js = '{"key":"token", "value":"f7779b26c4bd793"}';
        
        SaveWebToLead.JSON2Apex leadData = new SaveWebToLead.JSON2Apex();
        leadData.firstName = 'John';
        leadData.lastName = 'Doe';
        leadData.mobile = '1234567890';
        leadData.referrerFirstName = 'Referrer';
        leadData.referrerLastName = 'Referrer';
        leadData.referrertContactNumber = '9876543210';
        leadData.reasonforrecommendation = 'Recommendation Reason';
        leadData.school = 'kvm21';
        leadData.acedemicYear = '2023';

        String requestData = JSON.serialize(leadData);
     

                    HttpResponse res = new HttpResponse();
                    res.setHeader('Content-Type', 'application/json');
                    res.setHeader('Authorization', 'Basic 00DC4000000V4fF!AQEAQHNJ11d72AuJ9CQqwyp4c_CtLP.ws_71CBui.2FRDZapfOZTM_5rP6G00t4G6xzgDU4STmd2BH5DJ4WWLauNOtCxTvqd');
                    res.setBody(json.serialize(requestData));
                    res.setStatusCode(200);
                    res.setStatus(sta);
                    return res;


                //} 
        }

    @isTest
    public static void testdoPost() {
    
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/saveReferrerForm'; // Set your actual endpoint
        req.httpMethod = 'POST';
        
        SaveWebToLead.JSON2Apex leadData = new SaveWebToLead.JSON2Apex();
        leadData.firstName = 'John';
        leadData.lastName = 'Doe';
        leadData.mobile = '1234567890';
        leadData.referrerFirstName = 'Referrer';
        leadData.referrerLastName = 'Referrer';
        leadData.referrertContactNumber = '9876543210';
        leadData.reasonforrecommendation = 'Recommendation Reason';
        leadData.school = 'kvm21';
        leadData.acedemicYear = '2023';

        String requestData = JSON.serialize(leadData);
        req.requestBody = Blob.valueOf(requestData);

        Account a1=new Account();
        a1.Name='name';
        a1.Total_number_of_Contacts__c=10;
        a1.Total_No_of_Enquiry_Form_Recived__c=9;
        a1.Total_No_of_Application_Form_Received__c=11;
        a1.School_Email__c='abc@gmail.com';
        a1.Type='Partner';
        a1.School_Short_Code__c = 'kvm21';
        insert a1;
      
        RestContext.request = req;
        RestResponse res = new RestResponse();
        try{
        SaveWebToLead.doPost();
        }catch(exception e){}
  
    }
}