@RestResource(urlMapping='/chatbot/create/lead')
global with sharing class ChatbotCreateLeadAPI {
    
    @HttpPost
    global static void createLead() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String reqBody = req.requestBody.toString();
        String respBody = '';
        String respCode = '';
        String message = '';
        Exception exceptionObj = null;
        
        try {
            Map<String, Object> requestMap = (Map<String, Object>) JSON.deserializeUntyped(reqBody);
            String mobileNumber = (String) requestMap.get('MobileNumber');
            
            if (String.isBlank(mobileNumber)) {
                respCode = '400';
                Map<String, String> errorResp = new Map<String, String>{
                    'Status' => 'Failed',
                    'Error' => 'MobileNumber is required'
                };
                respBody = JSON.serialize(errorResp);
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(respBody);
                createApiLog('ChatbotCreateLeadAPI', reqBody, respBody, respCode, 'Missing MobileNumber', null);
                return;
            }
            
            Id qualifiedRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Qualified').getRecordTypeId();
            
            Lead newLead = new Lead();
            newLead.FirstName = 'Chatbot Lead';
            newLead.LastName = mobileNumber;
            newLead.MobilePhone = mobileNumber;
            newLead.Company = 'Chatbot Lead';
            newLead.LeadSource = 'Chatbot';
            newLead.School_Short_Code__c = 'STELRA';
            newLead.RecordTypeId = qualifiedRecordTypeId;
            
            insert newLead;
            
            Map<String, String> response = new Map<String, String>();
            response.put('Status', 'Success');
            response.put('leadId', newLead.Id);
            
            respCode = '201';
            message = 'Lead created successfully';
            respBody = JSON.serialize(response);
            res.statusCode = 201;
            res.responseBody = Blob.valueOf(respBody);
            
        } catch (Exception ex) {
            exceptionObj = ex;
            respCode = '500';
            message = ex.getMessage();
            Map<String, String> errorResp = new Map<String, String>{
                'Status' => 'Failed',
                'Error' => ex.getMessage()
            };
            respBody = JSON.serialize(errorResp);
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(respBody);
        } finally {
            createApiLog('ChatbotCreateLeadAPI', reqBody, respBody, respCode, message, exceptionObj);
        }
    }
    
    private static void createApiLog(String className, String reqBody, String respBody, String respCode, String message, Exception ex) {
        try {
            API_Log__c log = new API_Log__c();
            log.Apex_Class_Name__c = className;
            log.Request_Body__c = reqBody;
            log.Request_Date_and_Time__c = Datetime.now();
            log.Response_Body__c = respBody;
            log.Response_Code__c = respCode;
            log.Response_Date_and_Time__c = Datetime.now();
            log.API_Log_Status__c = (respCode == '200' || respCode == '201') ? 'Success' : 'Failure';
            log.Exception_Message__c = message;
            log.Exception_Stack_Trace__c = (ex != null) ? ex.getStackTraceString() : null;
            insert log;
        }
        catch (Exception ignore) {
        }
    }
}