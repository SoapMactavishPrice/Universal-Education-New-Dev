@isTest
public class SaveWebSiteForm_Test {

    public HTTPResponse respond(HTTPRequest req) {
                
                    String sta = 'OK';
        
        
        SaveWebSiteForm.JSON2Apex leadData1 = new SaveWebSiteForm.JSON2Apex();
        leadData1.Salutation = 'Mr.';
        leadData1.Your_first_name = 'John';
        leadData1.childFirstName = 'Jon';
        leadData1.childLastName = 'Doe';
        leadData1.Email = 'Doe@gmail.com';
        
        leadData1.mobile = '+916786786789';
        leadData1.schoolCode = 'kvm21';
        leadData1.acedemicYear = '2023-2024';
        
        leadData1.Grade_Applying_For = 'I';
        leadData1.relation = 'Father';
        leadData1.utmAdgroup = 'Doe@gmail.com';
        leadData1.utmAudience = 'Doe@gmail.com';
        leadData1.utmCampaign = 'Doe@gmail.com';
        leadData1.utmContent = 'Doe@gmail.com';
        leadData1.utmDevice = 'Doe@gmail.com';
        leadData1.utmMatchtype = 'Doe@gmail.com';
        leadData1.utmMedium = 'Doe@gmail.com';
        leadData1.utmNetwork = 'Doe@gmail.com';
        
        
        leadData1.utmPlacement = 'Doe@gmail.com';
        leadData1.utmSitelink = 'Doe@gmail.com';
        leadData1.utmSource = 'Doe@gmail.com';
        leadData1.utmTerm = 'Doe@gmail.com';
        
        
       
        SaveWebSiteForm.JSON2Apex json2Apex = new SaveWebSiteForm.JSON2Apex();
		 
        //String requestData = JSON.serialize(json2Apex);
        //req.requestBody = Blob.valueOf(requestData);

        

        String requestData = JSON.serialize(json2Apex);
                    HttpResponse res = new HttpResponse();
                                res.setBody(json.serialize(leadData1));
                    res.setStatusCode(200);
                    res.setStatus(sta);
                    return res;


                //} 
        }
    
     
    
     @isTest
    public static void testdoPost() {
    
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/saveWebSiteForm'; // Set your actual endpoint
        req.httpMethod = 'POST';
        
        
        SaveWebSiteForm.JSON2Apex leadData1 = new SaveWebSiteForm.JSON2Apex();
        leadData1.Salutation = 'Mr.';
        leadData1.Your_first_name = 'John';
        leadData1.childFirstName = 'Jon';
        leadData1.childLastName = 'Doe';
        leadData1.Email = 'Doe@gmail.com';
        
        leadData1.mobile = '+916786786789';
        leadData1.schoolCode = 'kvm21';
        leadData1.acedemicYear = '2023-2024';
        
        leadData1.Grade_Applying_For = 'I';
        leadData1.relation = 'Father';
        leadData1.utmAdgroup = 'Doe@gmail.com';
        leadData1.utmAudience = 'Doe@gmail.com';
        leadData1.utmCampaign = 'Doe@gmail.com';
        leadData1.utmContent = 'Doe@gmail.com';
        leadData1.utmDevice = 'Doe@gmail.com';
        leadData1.utmMatchtype = 'Doe@gmail.com';
        leadData1.utmMedium = 'Doe@gmail.com';
        leadData1.utmNetwork = 'Doe@gmail.com';
        
        
        leadData1.utmPlacement = 'Doe@gmail.com';
        leadData1.utmSitelink = 'Doe@gmail.com';
        leadData1.utmSource = 'Doe@gmail.com';
        leadData1.utmTerm = 'Doe@gmail.com';
        
        
       
		 
        String requestData = JSON.serialize(leadData1);
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
        SaveWebSiteForm.doPost();
        }catch(exception e){}
  
    }
   
}