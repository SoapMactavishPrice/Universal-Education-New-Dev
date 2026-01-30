@RestResource(urlMapping = '/getLeadDetails')
global class getLeadDetailsAPI {

    @HttpGet
    global static void doGet() {

        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        API_log__c api_log = new API_log__c();
        api_log.Name = 'getLeadDetails';
        api_log.Apex_Class_Name__c = 'getLeadDetailsAPI';
        api_log.Request_Date_and_Time__c = Datetime.now();

        String jsonRequestBody = request.requestBody == null ? '' : request.requestBody.toString().replace('\n', '');
        api_log.Request_Body__c = jsonRequestBody;

        try {

            JSON2ApexData jsonObj = JSON2ApexData.parse(jsonRequestBody);

            Map<String, Object> responseDataMap = new Map<String, Object>();

            if (jsonObj == null || String.isBlank(jsonObj.customerNumber) || String.isBlank(jsonObj.DIDNumber)) {
                throw new IllegalArgumentException('customerNumber and DIDNumber cannot be blank');
            }

            List<Account> schoolList = [
                SELECT Id, Name, School_Short_Code__c, Centralized_Calling_Team__c, Skill_Name__c
                FROM Account
                WHERE DID_Number__c = :jsonObj.DIDNumber
                LIMIT 1
            ];

            if (schoolList.isEmpty()) {
                throw new IllegalArgumentException('DIDNumber ' + jsonObj.DIDNumber + ' is not associated to any school');
            }

            String schoolShortCode = schoolList[0].School_Short_Code__c;
            String schoolSkillCode = schoolList[0].Skill_Name__c;

            List<Lead> leadList = [
                SELECT Id, Name, School_Short_Code__c, MobilePhone, Meet_Done__c, Owner.Name, Owner.Email, Owner.Phone
                FROM Lead
                WHERE MobilePhone = :jsonObj.customerNumber
                AND School_Short_Code__c = :schoolShortCode
                AND Company = 'Ozonetel Lead'
                AND Acadmic_Year__c = :getCurrentAcademicYear()
                LIMIT 1
            ];

            if (!leadList.isEmpty()) {

                Lead ld = leadList[0];

                responseDataMap.put('Name', ld.Owner.Name);
                responseDataMap.put('Email', ld.Owner.Email);
                responseDataMap.put('Phone', ld.Owner.Phone);
                responseDataMap.put('Type', 'Existing');
                responseDataMap.put('LeadName', ld.Name);

                if (schoolList[0].Centralized_Calling_Team__c) {
                    if (ld.Meet_Done__c) {
                        responseDataMap.put('SkillName', schoolSkillCode);
                    } else {
                        responseDataMap.put('SkillName', 'Central_Team');
                    }
                } else {
                    responseDataMap.put('SkillName', schoolSkillCode);
                }

            } else {

                responseDataMap.put('Type', 'New');

                if (schoolList[0].Centralized_Calling_Team__c) {
                    responseDataMap.put('SkillName', 'Central_Team');
                } else {
                    responseDataMap.put('SkillName', schoolSkillCode);
                }
            }

            responseDataMap.put('status', 'Success');

            String responseBody = JSON.serialize(responseDataMap);

            response.addHeader('Content-Type', 'application/json');
            response.responseBody = Blob.valueOf(responseBody);
            response.statusCode = 200;

            api_log.Response_Body__c = responseBody;
            api_log.API_Log_Status__c = 'Success';
            api_log.Response_Code__c = '200';

        } catch (Exception e) {

            Map<String, Object> responseDataMap = new Map<String, Object>();
            responseDataMap.put('status', 'Fail');
            responseDataMap.put('message', e.getMessage());
            responseDataMap.put('line', e.getLineNumber());

            String responseBody = JSON.serialize(responseDataMap);

            response.addHeader('Content-Type', 'application/json');
            response.responseBody = Blob.valueOf(responseBody);
            response.statusCode = 400;

            api_log.Response_Body__c = responseBody;
            api_log.API_Log_Status__c = 'Failure';
            api_log.Response_Code__c = '400';
        }

        api_log.Response_Date_and_Time__c = Datetime.now();
        insert api_log;
    }

    global class JSON2ApexData {
        public String customerNumber;
        public String DIDNumber;
    }

    public static JSON2ApexData parse(String json) {
        if (String.isBlank(json)) return null;
        return (JSON2ApexData) System.JSON.deserialize(json, JSON2ApexData.class);
    }

    private static String getCurrentAcademicYear() {
        Integer academicYearStartMonth = 6;

        Date today = Date.today();
        Integer year = today.year();

        Integer startYear = year;
        Integer endYear = startYear + 1;

        return String.valueOf(startYear) + '-' + String.valueOf(endYear);
    }
}
