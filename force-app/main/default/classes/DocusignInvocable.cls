public with sharing class DocusignInvocable {
    @InvocableMethod(label='Docusign Form A sent status' description='Send Docusign sent/signed status to Stellar Api' category='Application_Form__c')
    public static void stellarSubmission(List<Admission_Granted__c> admissionsgranted) {
        for(Admission_Granted__c appItr : admissionsgranted){
            String parentFirstName = String.isNotBlank(appItr.Father_First_Name__c) ? appItr.Father_First_Name__c : appItr.Mother_First_Name__c;
            String parentLastName = String.isNotBlank(appItr.Father_Last_Name__c) ? appItr.Father_Last_Name__c : appItr.Mother_Last_Name__c;

            String email = String.isNotBlank(appItr.Email_Address__c) ? appItr.Email_Address__c : (
                                String.isNotBlank(appItr.father_Email_Id__c) ? appItr.father_Email_Id__c : (
                                    String.isNotBlank(appItr.mother_Email_Id__c) ? appItr.mother_Email_Id__c : (
                                        String.isNotBlank(appItr.guardianEmail_Id__c) ? appItr.guardianEmail_Id__c : appItr.Enquiry_Email__c
                                    )
                                )
                            );
            System.debug('email: '+email);
            String status;
            String stage;
            status = 'INTERACTION_DONE';
            System.debug('Form_A_Sent__c : '+appItr.Form_A_Sent__c+' DocusignStatus__c: '+appItr.DocusignStatus__c);
            if(appItr.Form_A_Sent__c && (String.isBlank(appItr.DocusignStatus__c) || !appItr.DocusignStatus__c.equalsIgnoreCase('Completed'))/*condition for checking if docment is verified.*/){
                /*status = appItr.Status__c;*/ stage = 'DOCUMENT_SENT';
            }else if(String.isNotBlank(appItr.DocusignStatus__c) && appItr.DocusignStatus__c.equalsIgnoreCase('Completed') /*condition for checking if docment is verified.*/){
                stage = 'DOCUMENT_VERIFIED';
            }
            System.debug('status: '+status+' stage: '+stage);
            makeCallout(
                email,
                status, stage,
                parentFirstName, parentLastName
            );
        }
    }

    @future(Callout=true)
    public static void makeCallout(
        String email,
        String status, String stage,
        String parentFName, String parentLName
    ){
        String endpoint = ' https://admission.stellarworldschool.com/salesforce/send-form';
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('formLink', '');
        requestBody.put('formType', 'DOCUSIGN');
        requestBody.put('email', email);
        requestBody.put('data', new Map<String, String>{
            'parentFirstname' => parentFName, 'parentLastname' => parentLName
        });
        StellarAPICallouts.makeCallout(endpoint, StellarAPICallouts.POST_METHOD, requestBody);

        
    }
}
/*
"API: https://admission.stellarworldschool.com/leads
Method: PUT
Payload:
{
  ""stage"": ""DOCUMENT_VERIFIED"",
  ""status"": ""INTERACTION_DONE"",
  ""email"": ""anam@technogise.com"",
  ""data"": {
    ""parentFirstname"": ""Ayaan"",
    ""parentLastname"": ""Shah""
  }
}"

Admission_Granted__c agc = new Admission_Granted__c(
    Id = 'a0M0T000000aeCNUAY',
    Form_A_Sent__c = true,
    DocusignStatus__c = 'Completed',
    Email_Address__c = 'mahesh@bugendaitech.com'
);
update agc;
System.debug('agc: '+agc);
*/