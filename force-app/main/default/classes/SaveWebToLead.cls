@RestResource(urlMapping='/saveReferrerForm/*')
global with sharing class SaveWebToLead {
    
    @httpPost
    global static void doPost(){
       API_log__c api_log = new API_log__c();
       api_log.Name='saveReferrerForm';
        
       RestRequest request = RestContext.request;
       RestResponse response = RestContext.response; 
       String reqDataAsString = request.requestBody.toString();
       api_log.Request_Body__c = reqDataAsString;
       api_log.Request_Date_and_Time__c = Datetime.now();
       Map < String, String > result = new Map < String, String > ();
        try{
            JSON2Apex leadData = JSON2Apex.parse(request.requestBody.toString().replace('\n', ''));
            List<Account> acc = new List<Account>();
            acc = [SELECT Id FROM Account where School_Short_Code__c=:leadData.school];
            
            Lead ld  = new Lead();
            ld.FirstName = leadData.firstName;
            ld.LastName = leadData.lastName;
            ld.Company = 'Universal Education';
            ld.Referrer_First_Name__c	 = leadData.referrerFirstName;
            ld.Referrer_Last_Name__c	 = leadData.referrerLastName;
            ld.MobilePhone	 = leadData.mobile;
            ld.School_Short_Code__c = leadData.school;
            ld.Reason_for_Recommendation__c	 = leadData.reasonforrecommendation;
            if(acc.size()>0){
               ld.School_Institution__c	 = acc[0].Id; 
            }
            ld.Acadmic_Year__c	 = leadData.acedemicYear;
            ld.Referrer_Contact_No__c = leadData.referrertContactNumber;
            ld.LeadSource = leadData.leadSource;
            insert ld;
            
            result.put('Message', 'Lead Inserted Successfully.!!!');
            result.put('Status', 'Success');
            api_log.Response_Body__c = JSON.serialize(result);
            api_log.Response_Date_and_Time__c = Datetime.now();
            api_log.API_Log_Status__c ='Success';
            api_log.Response_Code__c = '200';
                response.responseBody = Blob.valueOf(JSON.serialize(result));
            
                response.statusCode = 200;
                response.addHeader('Content-Type', 'application/json');
            
            
        }catch(exception e){
            result.put('message',e.getMessage());
            result.put('Status', '400');
            //result.put('line', string.valueOf(e.getLineNumber()));
            api_log.Response_Body__c = JSON.serialize(result);
            api_log.Response_Date_and_Time__c = Datetime.now();
            api_log.API_Log_Status__c ='Failure';
            api_log.Exception_Message__c = e.getMessage();
            api_log.Response_Code__c = '400';
            api_log.Exception_Stack_Trace__c = string.valueOf(e.getStackTraceString());
            response.responseBody = Blob.valueOf(JSON.serialize(result));
            response.statusCode = 400;
            response.addHeader('Content-Type', 'application/json');
            
        }
        
        insert api_log;
    }
    
    public class JSON2Apex{
        public string firstName;//Last Name
        public string lastName;
        public string mobile;//Mobile
        public string referrerFirstName;// Referrer Name	
        public string referrerLastName;//
        public string referrertContactNumber; // Referrer Contact No
        public string reasonforrecommendation;//Reason for Recommendation
        public string school;//School/Institution
        public string acedemicYear;//Academic Year
        public string leadSource;//Lead Source
        
    }
    
    public static JSON2Apex parse(String json){
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    }
    
}