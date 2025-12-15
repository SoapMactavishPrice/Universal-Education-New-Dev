public with sharing class AdmissionFormSubmissionInvocable {

    @InvocableMethod(label='Submit Stellar Request for Application Submission' description='Send Thankyou email using Stellar Api' category='Application_Form__c')
    public static void stellarSubmission(List<Application_Form__c> applications) {
        for(Application_Form__c appItr : applications){
            String parentFirstName = String.isNotBlank(appItr.Father_First_Name__c) ? appItr.Father_First_Name__c : appItr.Mother_First_Name__c;
            String parentLastName = String.isNotBlank(appItr.Father_Last_Name__c) ? appItr.Father_Last_Name__c : appItr.Mother_Last_Name__c;
            makeCallout(appItr.Email_Address__c, parentFirstName, parentLastName, appItr.First_Name__c, appItr.StudentLast_Name__c, appItr.Name);
        }
    }

    @future(Callout=true)
    public static void makeCallout(
        String email,
        String parentFName, String parentLName,
        String studentFName, String studentLName,
        String appNumber
    ){
        String endpoint = 'https://admission.stellarworldschool.com/leads';
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('status', 'INTERACTION_DONE');
        requestBody.put('stage', 'APPLICATION_SUBMITTED');
        requestBody.put('email', email);
        requestBody.put('data', new Map<String, String>{
            'parentFirstname' => parentFName, 'parentLastname' => parentLName,
            'studentFirstname' => studentFName, 'studentLastname' => studentLName,
            'applicationNo' => appNumber
        });
        StellarAPICallouts.makeCallout(endpoint, StellarAPICallouts.PUT_METHOD, requestBody);

        
    }
}

/*
"API: https://admission.stellarworldschool.com/leads
Method: PUT
Payload:
{
  ""stage"": ""APPLICATION_SUBMITTED"",
  ""status"": ""INTERACTION_DONE"",
  ""email"": ""anam@technogise.com"",
  ""data"": {
    ""parentFirstname"": ""Ayaan"",
    ""parentLastname"": ""Shah"",
    ""studentFirstname"": ""Anam"",
    ""studentLastname"": ""Shah"",
    ""applicationNo"": ""app123456""
  }
}"

*/