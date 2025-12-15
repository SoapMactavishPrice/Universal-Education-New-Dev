public with sharing class EnquiryFormSubmissionInvocable {
    
    @InvocableMethod(label='Submit Stellar Request' description='Send Thankyou email using Stellar Api' category='Enquiry__c')
    public static void stellarSubmission(List<Enquiry__c> enquiries) {
        for(Enquiry__c enqItr : enquiries){
            makeCallout(enqItr.Email__c, enqItr.Parent_First_Name__c, enqItr.Parent_Last_Name__c, enqItr.FirstName__c, enqItr.Last_Name__c, enqItr.Name);
        }
    }

    @future(Callout=true)
    public static void makeCallout(
        String email,
        String parentFName, String parentLName,
        String studentFName, String studentLName,
        String enqNumber
    ){
        String endpoint = 'https://admission.stellarworldschool.com/leads';
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('status', 'NEW_ENQUIRY');
        requestBody.put('stage', 'ENQUIRY');
        requestBody.put('email', email);
        requestBody.put('data', new Map<String, String>{
            'parentFirstname' => parentFName, 'parentLastname' => parentLName,
            'studentFirstname' => studentFName, 'studentLastname' => studentLName,
            'enquiryNo' => enqNumber
        });
        StellarAPICallouts.makeCallout(endpoint, StellarAPICallouts.PUT_METHOD, requestBody);

        
    }
}
/* 
"API: https://admission.stellarworldschool.com/leads
Method: PUT
Payload:
{
  ""stage"": ""ENQUIRY"",
  ""status"": ""NEW_ENQUIRY"",
  ""email"": ""anam@technogise.com"",
  ""data"": {
    ""parentFirstname"": ""Ayaan"",
    ""parentLastname"": ""Shah"",
    ""studentFirstname"": ""Anam"",
    ""studentLastname"": ""Shah"",
    ""enquiryNo"": ""ENQ/21-2022/123456""
  }
}"

*/