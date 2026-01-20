public with sharing class AdmissionFormPutOnHoldInvocable{
	@InvocableMethod(callout = true label = 'Admission Form Put On Hold Stellar API' description = 'Admission form put on hold' category = 'Admission_Form__c')
	public static void stellarSubmission(List<Admission_Form__c> admissionForms){
		for (Admission_Form__c adfItr : admissionForms){
			if (StellarAPICallouts.checkIfStellarAPIEnabled(adfItr.School_Short_Code__c) || System.Test.isRunningTest()){
				String parentFirstName = String.isNotBlank(adfItr.FatherFirst_Name__c) ? adfItr.FatherFirst_Name__c : adfItr.motherFirst_Name__c;
				String parentLastName = String.isNotBlank(adfItr.Father_Last_Name__c) ? adfItr.Father_Last_Name__c : adfItr.motherLast_Name__c;
				// Map<String, Object> dataMap = StellarAPICallouts.createBody(
				//     new List<String>{'parentFirstname', 'parentLastname'},
				//     new List<Object>{parentFirstName, parentLastName}
				// );
				// Map<String, Object> requestBody = StellarAPICallouts.createBody(
				//     new List<String>{
				//         'stage', 'status', 'email', 'data'
				//     },
				//     new List<Object>{
				//         'OBSERVATION_REJECTED', 'INTERACTION_DONE', adfItr.Email_Address__c, dataMap
				//     }
				// );
				// StellarAPICallouts.makeCallout('https://admission.stellarworldschool.com/leads', StellarAPICallouts.PUT_METHOD, requestBody);
				String stage = 'ON_HOLD';
				String status = 'INTERACTION_DONE';
				String email = adfItr.Email_Address__c;
				makeCallout(
                    email, 
                    status, stage, 
                    parentFirstName, parentLastName
                );
			}
		}
	}

	@future(Callout = true)
	public static void makeCallout(
        String email, 
        String status, String stage, 
        String parentFName, String parentLName
    ){
		String endpoint = 'https://admission.stellarworldschool.com/leads';
		Map<String, Object> requestBody = new Map<String, Object>();
		requestBody.put('stage', stage);
		requestBody.put('status', status);
		requestBody.put('email', email);
		requestBody.put('data', new Map<String, String>{'parentFirstname' => parentFName, 'parentLastname' => parentLName});
		StellarAPICallouts.makeCallout(endpoint, StellarAPICallouts.PUT_METHOD, requestBody);
	}
}