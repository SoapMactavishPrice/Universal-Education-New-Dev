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
                SELECT Id, School_Institution__c, Stellar_Seeking_Admission_in_Grade__c, 
                       FirstName, LastName, Your_First_Name__c, Acadmic_Year__c, Email,
                       School_Short_Code__c, OwnerId
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
            String schoolShortCode = leadToUpdate.School_Short_Code__c;
            Boolean shouldUpdateOwner = false;
            
            if (String.isNotBlank(requestData.schoolShortCode)) {
                List<Account> accounts = [
                    SELECT Id, School_Short_Code__c
                    FROM Account 
                    WHERE School_Short_Code__c = :requestData.schoolShortCode 
                    LIMIT 1
                ];
                
                if (accounts.isEmpty()) {
                    respCode = '400';
                    UpdateLeadResponse errorResp = new UpdateLeadResponse();
                    errorResp.Status = 'Failed';
                    errorResp.Error = 'Account not found with the provided schoolShortCode';
                    respBody = JSON.serialize(errorResp);
                    res.statusCode = 400;
                    res.responseBody = Blob.valueOf(respBody);
                    createApiLog('ChatbotUpdateLeadAPI', reqBody, respBody, respCode, 'Account not found', null);
                    return;
                }
                
                leadToUpdate.School_Institution__c = accounts[0].Id;
                schoolShortCode = accounts[0].School_Short_Code__c;
                updatedFields.add('schoolShortCode');
                
                if (requestData.schoolShortCode != leadToUpdate.School_Short_Code__c) {
                    shouldUpdateOwner = true;
                }
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
            
            if (String.isNotBlank(requestData.email)) {
                String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
                Pattern emailPattern = Pattern.compile(emailRegex);
                Matcher emailMatcher = emailPattern.matcher(requestData.email);
                
                if (!emailMatcher.matches()) {
                    respCode = '400';
                    UpdateLeadResponse errorResp = new UpdateLeadResponse();
                    errorResp.Status = 'Failed';
                    errorResp.Error = 'Invalid email format';
                    respBody = JSON.serialize(errorResp);
                    res.statusCode = 400;
                    res.responseBody = Blob.valueOf(respBody);
                    createApiLog('ChatbotUpdateLeadAPI', reqBody, respBody, respCode, 'Invalid email format', null);
                    return;
                }
                
                leadToUpdate.Email = requestData.email;
                updatedFields.add('email');
            }
            
            if (shouldUpdateOwner && String.isNotBlank(schoolShortCode)) {
                Set<String> schoolCodes = new Set<String>();
                schoolCodes.add(schoolShortCode);
                
                Map<String, String> schoolCodeToLeadUserMap = new Map<String, String>();
                for (LeadUser__c leadUser : [
                    SELECT Name, SchoolCode__c 
                    FROM LeadUser__c 
                    WHERE SchoolCode__c IN :schoolCodes
                ]) {
                    schoolCodeToLeadUserMap.put(leadUser.SchoolCode__c, leadUser.Name);
                    System.debug('Matching LeadUser__c found: ' + leadUser.Name + ' for SchoolCode__c: ' + leadUser.SchoolCode__c);
                }
                
                Map<String, Id> userNameToUserIdMap = new Map<String, Id>();
                if (!schoolCodeToLeadUserMap.isEmpty()) {
                    for (User u : [
                        SELECT Id, Name 
                        FROM User 
                        WHERE Name IN :schoolCodeToLeadUserMap.values()
                    ]) {
                        userNameToUserIdMap.put(u.Name, u.Id);
                        System.debug('User found: ' + u.Name + ' with Id: ' + u.Id);
                    }
                }
                
                String leadUserName = schoolCodeToLeadUserMap.get(schoolShortCode);
                if (leadUserName != null) {
                    Id newOwnerId = userNameToUserIdMap.get(leadUserName);
                    if (newOwnerId != null) {
                        leadToUpdate.OwnerId = newOwnerId;
                        updatedFields.add('ownerId');
                        System.debug('Lead ' + leadToUpdate.Id + ' assigned to user: ' + leadUserName);
                    } else {
                        System.debug('No matching User found for LeadUser__c.Name: ' + leadUserName);
                    }
                }
            }
            
            if (!updatedFields.isEmpty()) {
                update leadToUpdate;
            }
            
            UpdateLeadResponse response = new UpdateLeadResponse();
            response.Status = 'Success';
            response.updatedFields = updatedFields;
            response.leadId = leadToUpdate.Id;
            response.schoolShortCode = schoolShortCode;
            
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
    
    private static LeadUserInfo getLeadUserBySchoolCode(String schoolCode) {
        LeadUserInfo info = new LeadUserInfo();
        
        if (String.isBlank(schoolCode)) {
            return info;
        }
        
        try {
            Set<String> schoolCodes = new Set<String>();
            schoolCodes.add(schoolCode);
            
            for (LeadUser__c leadUser : [
                SELECT Name, SchoolCode__c 
                FROM LeadUser__c 
                WHERE SchoolCode__c IN :schoolCodes
            ]) {
                info.leadUserName = leadUser.Name;
                info.schoolCode = leadUser.SchoolCode__c;
            }
        } catch (Exception ex) {
            System.debug('Error fetching LeadUser: ' + ex.getMessage());
        }
        
        return info;
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
        public String email;
    }
    
    global class UpdateLeadResponse {
        public String Status;
        public List<String> updatedFields;
        public String leadId;
        public String schoolShortCode;
        public LeadUserInfo leadUser;
        public String Error;
    }
    
    global class LeadUserInfo {
        public String leadUserName;
        public String schoolCode;
    }
}