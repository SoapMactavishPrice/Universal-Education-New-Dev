@RestResource(urlMapping='/chatbot/update/lead')
global with sharing class ChatbotUpdateLeadAPI {
    
    @HttpPut
    global static void updateLead() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String reqBody = req.requestBody.toString();
        String respBody = '';
        String respCode = '';
        String message = '';
        Exception exceptionObj = null;
        
        try {
            UpdateLeadRequest requestData = parseHeader(reqBody);
            System.debug('requestData: ' + requestData);
            
            if (String.isBlank(requestData.leadId)) {
                respCode = '400';
                UpdateLeadResponse errorResp = new UpdateLeadResponse();
                errorResp.Status = 'Failed';
                errorResp.Error = 'leadId is required';
                respBody = JSON.serialize(errorResp);
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(respBody);
                createApiLog('ChatbotUpdateLeadAPI', reqBody, respBody, respCode, 'Missing leadId', null);
                return;
            }
            
            List<Lead> leads = [
                SELECT Id, School_Short_Code__c, Stellar_Seeking_Admission_in_Grade__c, 
                       FirstName, LastName, Your_First_Name__c, Acadmic_Year__c
                FROM Lead 
                WHERE Id = :requestData.leadId 
                LIMIT 1
            ];

            System.debug('leads found: ' + leads.size());
            
            if (leads.isEmpty()) {
                respCode = '400';
                UpdateLeadResponse errorResp = new UpdateLeadResponse();
                errorResp.Status = 'Failed';
                errorResp.Error = 'Lead not found with the provided leadId';
                respBody = JSON.serialize(errorResp);
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(respBody);
                createApiLog('ChatbotUpdateLeadAPI', reqBody, respBody, respCode, 'Lead not found', null);
                return;
            }
            
            Lead leadToUpdate = leads[0];
            List<String> updatedFields = new List<String>();
            
            if (String.isNotBlank(requestData.schoolShortCode)) {
                leadToUpdate.School_Short_Code__c = requestData.schoolShortCode;
                updatedFields.add('schoolShortCode');
            }
            
            if (String.isNotBlank(requestData.grade)) {
                leadToUpdate.Stellar_Seeking_Admission_in_Grade__c = requestData.grade;
                updatedFields.add('grade');
            }
            
            if (String.isNotBlank(requestData.firstName)) {
                leadToUpdate.FirstName = requestData.firstName;
                updatedFields.add('firstName');
            }
            
            if (String.isNotBlank(requestData.lastName)) {
                leadToUpdate.LastName = requestData.lastName;
                updatedFields.add('lastName');
            }
            
            if (String.isNotBlank(requestData.childFirstName)) {
                leadToUpdate.Your_First_Name__c = requestData.childFirstName;
                updatedFields.add('childFirstName');
            }
            
            if (String.isNotBlank(requestData.academicYear)) {
                leadToUpdate.Acadmic_Year__c = requestData.academicYear;
                updatedFields.add('academicYear');
            }
            
            if (!updatedFields.isEmpty()) {
                update leadToUpdate;
            }
            
            UpdateLeadResponse response = new UpdateLeadResponse();
            response.Status = 'Success';
            response.updatedFields = updatedFields;
            response.leadId = leadToUpdate.Id;
            
            respCode = '200';
            message = 'Lead updated successfully';
            respBody = JSON.serialize(response);
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(respBody);
            
        } catch (Exception ex) {
            exceptionObj = ex;
            respCode = '500';
            message = ex.getMessage();
            UpdateLeadResponse errorResp = new UpdateLeadResponse();
            errorResp.Status = 'Failed';
            errorResp.Error = ex.getMessage();
            respBody = JSON.serialize(errorResp);
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(respBody);
        } finally {
            createApiLog('ChatbotUpdateLeadAPI', reqBody, respBody, respCode, message, exceptionObj);
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

    private static UpdateLeadRequest parseHeader(string js){
        return (UpdateLeadRequest)system.JSON.deserialize(js,UpdateLeadRequest.class);
    }
    
    global class UpdateLeadRequest {
        public String schoolShortCode;
        public String grade;
        public String firstName;
        public String lastName;
        public String childFirstName;
        public String academicYear;
        public String leadId;
    }
    
    global class UpdateLeadResponse {
        public String Status;
        public List<String> updatedFields;
        public String leadId;
        public String Error;
    }
}