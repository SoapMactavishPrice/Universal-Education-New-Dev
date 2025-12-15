@isTest
public class saveLeadFormTest {
    public HTTPResponse respond(HTTPRequest req) {
                
                    String sta = 'OK';
        
        saveLeadForm.cls_leadJS2Apex leadData = new saveLeadForm.cls_leadJS2Apex();
        leadData.Salutation = 'Mr.';
        leadData.Your_first_name = 'John';
        leadData.Your_Last_name = 'Doe';
        leadData.childLastName = 'Doe';
        leadData.Landmark = 'Referrer';
        leadData.fatherEducationalQualifications = 'Graduate';
        leadData.pinCode = '987654';
        leadData.Apartment_Society = 'Recommendation Reason';
        leadData.schoolCode = 'kvm21';
        leadData.acedemicYear = '2022-2023';
        
        leadData.childFirstName = 'Jon';
        leadData.Email = 'Doe@gmail.com';
        leadData.mobile = '+916786786789';
        leadData.LeadSource = 'Website';
        
        
        
        leadData.motherEducationalQualifications = 'Graduate';
        leadData.fatherOccupation = 'Others (please specify)';
        leadData.motherOccupation = 'Others (please specify)';
        leadData.fatherOtherOccupation = 'Doe@gmail.com';
        leadData.motherOtherOccupation = 'Doe@gmail.com';
        leadData.Grade_Applying_For = 'I';
        leadData.howDidYouHearAboutUs = 'Found the ad/website on the internet';
        leadData.category = 'Weekly Boarder';
        leadData.gender = 'Male';
        leadData.relation = 'Father';
        leadData.leadSubmissionURL = 'Doe@gmail.com';
        leadData.utmAdgroup = 'Doe@gmail.com';
        leadData.utmAudience = 'Doe@gmail.com';
        leadData.utmCampaign = 'Doe@gmail.com';
        leadData.utmContent = 'Doe@gmail.com';
        leadData.utmDevice = 'Doe@gmail.com';
        leadData.utmMatchtype = 'Doe@gmail.com';
        leadData.utmMedium = 'Doe@gmail.com';
        leadData.utmNetwork = 'Doe@gmail.com';
        
        
        leadData.utmPlacement = 'Doe@gmail.com';
        leadData.utmSitelink = 'Doe@gmail.com';
        leadData.utmSource = 'Doe@gmail.com';
        leadData.utmTerm = 'Doe@gmail.com';
        
        List<saveLeadForm.cls_leadJS2Apex> sds = new List<saveLeadForm.cls_leadJS2Apex>();
        sds.add(leadData);
        saveLeadForm.JSON2Apex json2Apex = new saveLeadForm.JSON2Apex();
		json2Apex.leadList= sds;
        

        String requestData = JSON.serialize(json2Apex);
                    HttpResponse res = new HttpResponse();
                    //res.setHeader('Content-Type', 'application/json');
                    //res.setHeader('Authorization', 'Basic 00DC4000000V4fF!AQEAQHNJ11d72AuJ9CQqwyp4c_CtLP.ws_71CBui.2FRDZapfOZTM_5rP6G00t4G6xzgDU4STmd2BH5DJ4WWLauNOtCxTvqd');
                    res.setBody(json.serialize(requestData));
                    res.setStatusCode(200);
                    res.setStatus(sta);
                    return res;


                //} 
        }
    
     
    
     @isTest
    public static void testdoPost() {
    
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/saveWebToLead'; // Set your actual endpoint
        req.httpMethod = 'POST';
        
        saveLeadForm.cls_leadJS2Apex leadData = new saveLeadForm.cls_leadJS2Apex();
        leadData.Salutation = 'Mr.';
        leadData.Your_first_name = 'John';
        leadData.Your_Last_name = 'Doe';
        leadData.childFirstName = 'Jon';
        leadData.childLastName = 'Doe';
        leadData.Email = 'Doe@gmail.com';
        
        
        leadData.mobile = '+916786786789';
        leadData.Landmark = 'Referrer';
        leadData.fatherEducationalQualifications = 'Graduate';
        leadData.pinCode = '987654';
        leadData.Apartment_Society = 'Recommendation Reason';
        leadData.schoolCode = 'kvm21';
        leadData.acedemicYear = '2023-2024';
        leadData.motherEducationalQualifications = 'Graduate';
        leadData.fatherOccupation = 'Others (please specify)';
        leadData.motherOccupation = 'Others (please specify)';
        leadData.fatherOtherOccupation = 'Doe@gmail.com';
        leadData.motherOtherOccupation = 'Doe@gmail.com';
        leadData.Grade_Applying_For = 'I';
        leadData.howDidYouHearAboutUs = 'Found the ad/website on the internet';
        leadData.category = 'Weekly Boarder';
        leadData.gender = 'Male';
        leadData.relation = 'Father';
        leadData.leadSubmissionURL = 'Doe@gmail.com';
        leadData.utmAdgroup = 'Doe@gmail.com';
        leadData.utmAudience = 'Doe@gmail.com';
        leadData.utmCampaign = 'Doe@gmail.com';
        leadData.utmContent = 'Doe@gmail.com';
        leadData.utmDevice = 'Doe@gmail.com';
        leadData.utmMatchtype = 'Doe@gmail.com';
        leadData.utmMedium = 'Doe@gmail.com';
        leadData.utmNetwork = 'Doe@gmail.com';
        
        
        leadData.utmPlacement = 'Doe@gmail.com';
        leadData.utmSitelink = 'Doe@gmail.com';
        leadData.utmSource = 'Doe@gmail.com';
        leadData.utmTerm = 'Doe@gmail.com';
         leadData.LeadSource = 'Website';
        
        
        
        saveLeadForm.cls_leadJS2Apex leadData1 = new saveLeadForm.cls_leadJS2Apex();
        leadData1.Salutation = 'Mr.';
        leadData1.Your_first_name = 'John';
        leadData1.Your_Last_name = 'Doe';
        leadData1.childFirstName = 'Jon';
        leadData1.childLastName = 'Doe';
        leadData1.Email = 'Doe@gmail.com';
        leadData1.LeadSource = 'Website';
        
        leadData1.mobile = '+916786786789';
        leadData1.Landmark = 'Referrer';
        leadData1.fatherEducationalQualifications = 'Graduate';
        leadData1.pinCode = '987654';
        leadData1.Apartment_Society = 'Recommendation Reason';
        leadData1.schoolCode = 'kvm21';
        leadData1.acedemicYear = '2023-2024';
        leadData1.motherEducationalQualifications = 'Graduate';
        leadData1.fatherOccupation = 'Others (please specify)';
        leadData1.motherOccupation = 'Others (please specify)';
        leadData1.fatherOtherOccupation = 'Doe@gmail.com';
        leadData1.motherOtherOccupation = 'Doe@gmail.com';
        leadData1.Grade_Applying_For = 'I';
        leadData1.howDidYouHearAboutUs = 'Found the ad/website on the internet';
        leadData1.category = 'Weekly Boarder';
        leadData1.gender = 'Male';
        leadData1.relation = 'Father';
        leadData1.leadSubmissionURL = 'Doe@gmail.com';
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
       
        
        List<saveLeadForm.cls_leadJS2Apex> sds = new List<saveLeadForm.cls_leadJS2Apex>();
        sds.add(leadData);
        sds.add(leadData1);
        saveLeadForm.JSON2Apex json2Apex = new saveLeadForm.JSON2Apex();
		json2Apex.leadList= sds;
        
        String requestData = JSON.serialize(json2Apex);
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
        saveLeadForm.doPost();
        }catch(exception e){}
  
    }
    
    
     @isTest
    public static void testdoPost2() {
    
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/saveWebToLead'; // Set your actual endpoint
        req.httpMethod = 'POST';
        
        saveLeadForm.cls_leadJS2Apex leadData = new saveLeadForm.cls_leadJS2Apex();
        leadData.Salutation = 'Mr.';
        leadData.Your_first_name = 'John';
        leadData.Your_Last_name = 'Doe';
        leadData.childFirstName = 'Jon';
        leadData.childLastName = 'Doe';
        leadData.Email = 'Doe@gmail.com';
        
        leadData.mobile = '+916786786789';
        leadData.Landmark = 'Referrer';
        leadData.fatherEducationalQualifications = 'Graduate';
        leadData.pinCode = '987654';
        leadData.Apartment_Society = 'Recommendation Reason';
        leadData.schoolCode = 'kvm21';
        leadData.acedemicYear = '2023-2024';
        leadData.motherEducationalQualifications = 'Graduate';
        leadData.fatherOccupation = 'Others (please specify)';
        leadData.motherOccupation = 'Others (please specify)';
        leadData.fatherOtherOccupation = 'Doe@gmail.com';
        leadData.motherOtherOccupation = 'Doe@gmail.com';
        leadData.Grade_Applying_For = 'I';
        leadData.howDidYouHearAboutUs = 'Found the ad/website on the internet';
        leadData.category = 'Weekly Boarder';
        leadData.gender = 'Male';
        leadData.relation = 'Father';
        leadData.leadSubmissionURL = 'Doe@gmail.com';
        leadData.utmAdgroup = 'Doe@gmail.com';
        leadData.utmAudience = 'Doe@gmail.com';
        leadData.utmCampaign = 'Doe@gmail.com';
        leadData.utmContent = 'Doe@gmail.com';
        leadData.utmDevice = 'Doe@gmail.com';
        leadData.utmMatchtype = 'Doe@gmail.com';
        leadData.utmMedium = 'Doe@gmail.com';
        leadData.utmNetwork = 'Doe@gmail.com';
        
        
        leadData.utmPlacement = 'Doe@gmail.com';
        leadData.utmSitelink = 'Doe@gmail.com';
        leadData.utmSource = 'Doe@gmail.com';
        leadData.utmTerm = 'Doe@gmail.com';
         leadData.LeadSource = 'Website';
        
        
        
        saveLeadForm.cls_leadJS2Apex leadData1 = new saveLeadForm.cls_leadJS2Apex();
        leadData1.Salutation = 'Mr.';
        leadData1.Your_first_name = 'John';
        leadData1.Your_Last_name = 'Doe';
        leadData1.childFirstName = 'Jon';
        leadData1.childLastName = 'Doe';
        leadData1.Email = 'Doe@gmail.com';
        leadData1.LeadSource = 'Website';
        
        leadData1.mobile = '+916786786789';
        leadData1.Landmark = 'Referrer';
        leadData1.fatherEducationalQualifications = 'Graduate';
        leadData1.pinCode = '987654';
        leadData1.Apartment_Society = 'Recommendation Reason';
        leadData1.schoolCode = 'kvm21';
        leadData1.acedemicYear = '2023-2024';
        leadData1.motherEducationalQualifications = 'Graduate';
        leadData1.fatherOccupation = 'Others (please specify)';
        leadData1.motherOccupation = 'Others (please specify)';
        leadData1.fatherOtherOccupation = 'Doe@gmail.com';
        leadData1.motherOtherOccupation = 'Doe@gmail.com';
        leadData1.Grade_Applying_For = 'I';
        leadData1.howDidYouHearAboutUs = 'Found the ad/website on the internet';
        leadData1.category = 'Weekly Boarder';
        leadData1.gender = 'Male';
        leadData1.relation = 'Father';
        leadData1.leadSubmissionURL = 'Doe@gmail.com';
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
        
        
        List<saveLeadForm.cls_leadJS2Apex> sds = new List<saveLeadForm.cls_leadJS2Apex>();
        sds.add(leadData);
        sds.add(leadData1);
        saveLeadForm.JSON2Apex json2Apex = new saveLeadForm.JSON2Apex();
		json2Apex.leadList= sds;
        
        String requestData = JSON.serialize(json2Apex);
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
        
      
        lead ld = new lead();
        ld.LastName='Doe';
        ld.School_Short_Code__c = 'kvm21';
        ld.MobilePhone = '6786786789';
        ld.Acadmic_Year__c = '2023-2024';
        ld.Company = 'UE';
        ld.Your_First_Name__c = 'Jon';
        ld.Email = 'Doe@gmail.com';
        insert ld;
        
      
        RestContext.request = req;
        RestResponse res = new RestResponse();
        try{
        saveLeadForm.doPost();
        }catch(exception e){}
  
    }
}