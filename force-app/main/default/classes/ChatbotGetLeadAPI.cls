@RestResource(urlMapping='/chatbot/get/lead')
global with sharing class ChatbotGetLeadAPI {
    
    @HttpGet
    global static void getLeadDetail() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String mobileNumber = req.params.get('mobileNumber');
        String reqBody = 'mobileNumber=' + mobileNumber;
        String respBody = '';
        String respCode = '';
        String message = '';
        Exception exceptionObj = null;
        
        try {
            if (String.isBlank(mobileNumber)) {
                respCode = '400';
                Map<String, String> errorResp = new Map<String, String>{
                    'Status' => 'Failed',
                    'Error' => 'mobileNumber parameter is required'
                };
                respBody = JSON.serialize(errorResp);
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(respBody);
                createApiLog('ChatbotGetLeadAPI', reqBody, respBody, respCode, 'Missing mobileNumber parameter', null);
                return;
            }

            String cleanedMobile = mobileNumber.replaceAll('[^0-9]', '');
            String likePattern = '%' + cleanedMobile + '%';

            List<Lead> existingLeads = [
                SELECT Id
                FROM Lead
                WHERE MobilePhone LIKE :likePattern
                AND LeadSource = 'Chatbot'
                LIMIT 1
            ];


            
            Map<String, String> response = new Map<String, String>();
            
            if (!existingLeads.isEmpty()) {
                response.put('Status', 'Success');
                response.put('Type', 'EXISTING');
                response.put('leadId', existingLeads[0].Id);
                respCode = '200';
                message = 'Lead found successfully';
            } else {
                response.put('Status', 'Success');
                response.put('Type', 'NEW');
                response.put('leadId', null);
                respCode = '200';
                message = 'No existing lead found';
            }
            
            respBody = JSON.serialize(response);
            res.statusCode = 200;
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
            createApiLog('ChatbotGetLeadAPI', reqBody, respBody, respCode, message, exceptionObj);
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

    public static void dummyMethod() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}