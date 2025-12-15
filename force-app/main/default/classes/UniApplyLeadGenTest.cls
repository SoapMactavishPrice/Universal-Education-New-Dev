@IsTest
private class UniApplyLeadGenTest {

    @TestSetup
    static void setupData() {
        // Create a couple of test Accounts with School_Short_Code__c
        List<Account> accList = new List<Account>{
            new Account(Name = 'Stellar Academy', School_Short_Code__c = 'STLR'),
            new Account(Name = 'Galaxy International', School_Short_Code__c = 'GLXY')
        };
        insert accList;
    }

    @IsTest
    static void test_success_scenario() {
        // Prepare mock request
        List<UniApplyLeadGen.LeadWrapper> wrappers = new List<UniApplyLeadGen.LeadWrapper>();

        UniApplyLeadGen.LeadWrapper lw1 = new UniApplyLeadGen.LeadWrapper();
        lw1.FirstName = 'John';
        lw1.LastName = 'Doe';
        lw1.Email = 'john@school.com';
        lw1.Mobile = '9999999999';
        lw1.State = 'Maharastra';
        lw1.City = 'Mumbai';
        lw1.School = 'STLR';
        lw1.GradeApplyingFor = 'I';
        lw1.StellarSeekingAdmissionInGrade = '1';
        lw1.ProspectID = 'P001';
        wrappers.add(lw1);

        UniApplyLeadGen.LeadWrapper lw2 = new UniApplyLeadGen.LeadWrapper();
        lw2.FirstName = 'Jane';
        lw2.LastName = 'Smith';
        lw2.Email = 'jane@school.com';
        lw2.Mobile = '8888888888';
        lw2.State = 'Maharastra';
        lw2.City = 'Mumbai';
        lw2.School = 'GLXY';
        lw2.GradeApplyingFor = 'II';
        lw2.StellarSeekingAdmissionInGrade = '2';
        lw2.ProspectID = 'P002';
        wrappers.add(lw2);

        String jsonBody = JSON.serialize(wrappers);

        // Mock the REST request and response
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/EduStrokeLeadGen';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        UniApplyLeadGen.insertLeads();
        Test.stopTest();

        // Validate Response
        System.assertEquals(200, res.statusCode, 'Expected status 200');
        UniApplyLeadGen.ApiResponse apiResp = 
            (UniApplyLeadGen.ApiResponse) JSON.deserialize(res.responseBody.toString(), UniApplyLeadGen.ApiResponse.class);

        System.assertEquals(2, apiResp.total, 'Total records mismatch');
        System.assertEquals(2, apiResp.success, 'All records should be successful');
        System.assertEquals(0, apiResp.failed, 'No failed records expected');

        // Validate Leads inserted
        List<Lead> leads = [SELECT Id, Company, LeadSource, Edustroke_Prospect_ID__c FROM Lead];
        System.assertEquals(2, leads.size(), 'Expected 2 leads inserted');
        System.assertEquals('UniApply', leads[0].LeadSource);

        // Validate only one API_Log__c created
        List<API_Log__c> logs = [SELECT Id, API_Log_Status__c, Response_Code__c, Apex_Class_Name__c FROM API_Log__c];
        System.assertEquals(1, logs.size(), 'Expected exactly one API_Log__c');
        System.assertEquals('Success', logs[0].API_Log_Status__c);
    }

    @IsTest
    static void test_partial_failure_invalid_email() {
        // one good record, one with invalid email
        List<UniApplyLeadGen.LeadWrapper> wrappers = new List<UniApplyLeadGen.LeadWrapper>();

        UniApplyLeadGen.LeadWrapper lw1 = new UniApplyLeadGen.LeadWrapper();
        lw1.FirstName = 'John';
        lw1.LastName = 'Doe';
        lw1.Email = 'john@school.com';
        lw1.Mobile = '9999999999';
        lw1.School = 'STLR';
        lw1.ProspectID = 'P010';
        wrappers.add(lw1);

        UniApplyLeadGen.LeadWrapper lw2 = new UniApplyLeadGen.LeadWrapper();
        lw2.FirstName = 'Invalid';
        lw2.LastName = 'Email';
        lw2.Email = 'not-an-email'; // invalid format
        lw2.Mobile = '1111111111';
        lw2.School = 'GLXY';
        lw2.ProspectID = 'P011';
        wrappers.add(lw2);

        String jsonBody = JSON.serialize(wrappers);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/EduStrokeLeadGen';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        UniApplyLeadGen.insertLeads();
        Test.stopTest();

        System.assertEquals(200, res.statusCode, 'Expected 200 for partial success');

        UniApplyLeadGen.ApiResponse apiResp = 
            (UniApplyLeadGen.ApiResponse) JSON.deserialize(res.responseBody.toString(), UniApplyLeadGen.ApiResponse.class);
        System.assertEquals(2, apiResp.total);
        System.assertEquals(1, apiResp.success);
        System.assertEquals(1, apiResp.failed);
        System.assert(apiResp.results.containsKey('P010'));
        System.assert(apiResp.results.containsKey('P011'));

        // One log per transaction
        System.assertEquals(1, [SELECT count() FROM API_Log__c]);
    }

    @IsTest
    static void test_empty_payload() {
        // empty list request
        String jsonBody = '[]';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/UniApplyLeadGen';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        UniApplyLeadGen.insertLeads();
        Test.stopTest();

        System.assertEquals(200, res.statusCode);
        System.assertEquals(1, [SELECT count() FROM API_Log__c], 'Expected single log');
    }

    @IsTest
    static void test_missing_prospectid_error() {
        // missing prospect id triggers exception and log
        List<UniApplyLeadGen.LeadWrapper> wrappers = new List<UniApplyLeadGen.LeadWrapper>();
        UniApplyLeadGen.LeadWrapper lw = new UniApplyLeadGen.LeadWrapper();
        lw.FirstName = 'NoProspect';
        lw.LastName = 'Case';
        lw.Email = 'no@school.com';
        lw.School = 'STLR';
        // no ProspectID
        wrappers.add(lw);

        String jsonBody = JSON.serialize(wrappers);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/EduStrokeLeadGen';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jsonBody);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        UniApplyLeadGen.insertLeads();
        Test.stopTest();

        System.assertEquals(400, res.statusCode, 'Should return 400 for missing ProspectID');
        System.assertEquals(1, [SELECT count() FROM API_Log__c], 'Only one log expected');
        API_Log__c logRec = [SELECT API_Log_Status__c, Exception_Message__c FROM API_Log__c LIMIT 1];
        System.assertEquals('Failure', logRec.API_Log_Status__c);
        System.assert(logRec.Exception_Message__c.contains('Missing ProspectID'));
    }

}