@RestResource(urlMapping = '/Ozonetel/CreateLead')
global class OzonetelCreateLead_API {
    @HttpPost
    global static void doPost() {
        
        API_log__c api_log = new API_log__c();
        api_log.Name = 'OzonetelCreateLead';
        api_log.Apex_Class_Name__c = 'OzonetelCreateLead_API';
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        String jSONRequestBody = request.requestBody.toString().replace('\n', '');
        
        api_log.Request_Body__c = jSONRequestBody;
        api_log.Request_Date_and_Time__c = Datetime.now();
        
        JSON2ApexData jsonObj = JSON2ApexData.parse(jSONRequestBody);
        system.debug('jsonObj'+jsonObj);
        
        try {
            
            Map<String, Object> responseDataMap = new Map<String, Object>();
            
            if (String.isBlank(jsonObj.LastName) || String.isBlank(jsonObj.Phone)) {
                throw new IllegalArgumentException('LastName , Phone cannot be blank');
            }
            
            recordType recordType = [SELECT Id, Name, DeveloperName,  SobjectType FROM RecordType WHERE DeveloperName = 'Qualified' AND SobjectType = 'Lead'];
            
            List <Account> accList = new List <Account>();
            if (String.isNotBlank(jsonObj.DIDNumber)) {
                accList = [SELECT Id, Name, School_Short_Code__c, DID_Number__c FROM Account WHERE DID_Number__c = :jsonObj.DIDNumber];
            }
            
            
            Lead newLead = new Lead();
            newLead.RecordTypeId = recordType.id;
            newLead.FirstName = jsonObj.FirstName;
            newLead.LastName = jsonObj.LastName;
         //   newLead.Phone = jsonObj.Phone;
            newLead.Email = jsonObj.Email;
            newLead.Company = 'Ozonetel Lead';
            newLead.LeadSource = 'Incoming call';
            
            
            String mobile = jsonObj.Phone.replaceAll('[^0-9]', '');

           
            if (mobile.length() > 10) {
                mobile = mobile.substring(mobile.length() - 10);
            }
           
            newLead.MobilePhone = mobile;

            
            if (accList.size()>0) {
                newLead.School_Institution__c = accList[0].Id;
            }
            
            insert newLead;
            
            responseDataMap.put('status', 'success');
            responseDataMap.put('message', 'Lead Created');
            
            api_log.Response_Body__c = JSON.serialize(responseDataMap);
            api_log.API_Log_Status__c = 'Success';
            api_log.Response_Code__c = '200';
            
            response.addHeader('Content-Type', 'application/json');
            response.responseBody = Blob.valueOf(JSON.serialize(responseDataMap));
            response.statusCode = 200;
            
        } catch (Exception e) {
            Map < String, Object > responseDataMap = new Map < String, Object > ();
            
            responseDataMap.put('status', 'Fail');
            responseDataMap.put('message', e.getMessage());
            // responseDataMap.put('message2', e.getLineNumber());
            response.responseBody = Blob.valueOf(JSON.serialize(responseDataMap));
            response.addHeader('Content-Type', 'application/json');
            response.statusCode = 400;
            system.debug(e.getlineNumber()+'-'+e.getMessage());
            
            api_log.Response_Body__c = e.getlineNumber()+' || '+e.getMessage();
            api_log.API_Log_Status__c = 'Failure';
            api_log.Response_Code__c = '400';
        }
        
        api_log.Response_Date_and_Time__c = Datetime.now();
        insert api_log;
        
    }
    
    public class JSON2ApexData {
        public String FirstName;
        public String LastName;
        public String Phone;
        public String Email;
        public String Company;
        public String SchoolSFCode;
        public String DIDNumber;
    }
    
    public static JSON2ApexData parse(String json) {
        return (JSON2ApexData) System.JSON.deserialize(json, JSON2ApexData.class);
    }
    
}