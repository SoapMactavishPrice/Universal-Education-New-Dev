@RestResource(urlMapping = '/EduStrokeLeadGen')
global with sharing class EdustrokeLeadGen {

    public class LeadWrapper {
        public String FirstName;
        public String LastName;
        public String Email;
        public String Mobile;
        public String AcademicYear;
        public String School;
        public String GradeApplyingFor;
        public String StellarSeekingAdmissionInGrade;
        public String ProspectID;
    }

    public class ProspectResult {
        public Boolean success;
        public String leadId;
        public List<String> errors = new List<String>();
    }

    public class ApiResponse {
        public Integer total;
        public Integer success;
        public Integer failed;
        public Map<String, ProspectResult> results = new Map<String, ProspectResult>();

        public ApiResponse() {
            this.total = 0;
            this.success = 0;
            this.failed = 0;
        }
    }

    private class CustomException extends Exception {}

    @HttpPost
    global static void insertLeads() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        ApiResponse resp = new ApiResponse();
        String requestBody = req.requestBody != null ? req.requestBody.toString() : '';

        try {
            List<LeadWrapper> wrappers = (List<LeadWrapper>) JSON.deserialize(requestBody, List<LeadWrapper>.class);
            resp.total = wrappers.size();

            if (wrappers.isEmpty()) {
                sendResponse(res, resp, 200);
                createApiLog('EdustrokeLeadGen', requestBody, JSON.serialize(resp), '200', 'Success - No records found', null);
                return;
            }

            for (Integer i = 0; i < wrappers.size(); i++) {
                if (String.isBlank(wrappers[i].ProspectID)) {
                    throw new CustomException('Missing ProspectID at index: ' + i);
                }
            }

            Map<String, Account> schoolMap = new Map<String, Account>();
            for(Account a : [SELECT Id, Name, School_Short_Code__c FROM Account WHERE School_Short_Code__c != null]) {
                schoolMap.put(a.School_Short_Code__c, a);
            }

            List<Lead> leadsToInsert = new List<Lead>();
            List<String> prospectIds = new List<String>();

            for (LeadWrapper lw : wrappers) {
                Lead ld = new Lead();
                ld.FirstName = trimToNull(lw.FirstName);
                ld.LastName = trimToNull(lw.LastName);
                ld.Email = trimToNull(lw.Email);

                ld.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Qualified').getRecordTypeId();

                ld.Company = 'Edustroke';
                ld.LeadSource = 'Edustroke';

                String companyVal = trimToNull(lw.School);
                if (companyVal == null) companyVal = 'Unknown';
                ld.Company = companyVal;

                if (!String.isBlank(lw.Mobile)) {
                    ld.MobilePhone = lw.Mobile;
                    ld.Phone = lw.Mobile;
                }

                if (!String.isBlank(lw.AcademicYear)) {
                    ld.put('Acadmic_Year__c', lw.AcademicYear);
                }
                if (!String.isBlank(lw.School) && schoolMap.containsKey(lw.School)) {
                    ld.put('School_Institution__c', schoolMap.get(lw.School).Id);
                }
                if (!String.isBlank(lw.GradeApplyingFor)) {
                    ld.put('Seeking_Admission_in_Grade__c', lw.GradeApplyingFor);
                }
                if (!String.isBlank(lw.StellarSeekingAdmissionInGrade)) {
                    ld.put('Stellar_Seeking_Admission_In_Grade__c', lw.StellarSeekingAdmissionInGrade);
                }
                if (!String.isBlank(lw.ProspectID)) {
                    ld.put('Edustroke_Prospect_ID__c', lw.ProspectID);
                }

                leadsToInsert.add(ld);
                prospectIds.add(lw.ProspectID);
            }
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.DuplicateRuleHeader.allowSave = true;
            dmlOpts.DuplicateRuleHeader.runAsCurrentUser = false;
            Database.SaveResult[] results = Database.insert(leadsToInsert, dmlOpts);

            Integer successCount = 0;
            Integer failCount = 0;

            for (Integer i = 0; i < results.size(); i++) {
                Database.SaveResult sr = results[i];
                String prospectId = prospectIds[i];
                ProspectResult pRes = new ProspectResult();

                if (sr.isSuccess()) {
                    successCount++;
                    pRes.success = true;
                    pRes.leadId = sr.getId();
                }
                else {
                    failCount++;
                    pRes.success = false;
                    for (Database.Error err : sr.getErrors()) {
                        pRes.errors.add((err.getStatusCode() != null ? err.getStatusCode().name() + ': ' : '') + err.getMessage());
                    }
                }

                resp.results.put(prospectId, pRes);
            }

            resp.success = successCount;
            resp.failed = failCount;

            sendResponse(res, resp, 200);

            createApiLog(
                'EdustrokeLeadGen',
                requestBody,
                JSON.serialize(resp),
                '200',
                'Processed ' + successCount + ' success, ' + failCount + ' failed',
                null
            );

        } catch (Exception ex) {
            System.debug(ex.getMessage() + '\n' + ex.getStackTraceString());

            sendResponse(res, resp, 400);

            createApiLog(
                'EdustrokeLeadGen',
                requestBody,
                JSON.serialize(resp),
                '400',
                ex.getMessage(),
                ex
            );
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
            // Do not throw further errors for log failures
        }
    }

    private static void sendResponse(RestResponse res, ApiResponse resp, Integer statusCode) {
        System.debug(resp);
        res.responseBody = Blob.valueOf(JSON.serializePretty(resp));
        res.addHeader('Content-Type', 'application/json');
        res.statusCode = statusCode;
    }

    private static String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return String.isBlank(s) ? null : s;
    }

}