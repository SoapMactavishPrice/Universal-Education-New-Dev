@RestResource(urlMapping='/SaveLandingForm/*')
global with sharing class SaveLandingForm {
    @httpPost
    global static void doPost(){
        API_log__c api_log = new API_log__c();
        api_log.Name='SaveLandingForm';
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response; 
        String reqDataAsString = request.requestBody.toString();
        api_log.Request_Body__c = reqDataAsString;
        api_log.Request_Date_and_Time__c = Datetime.now();
        Map < String, String > result = new Map < String, String > ();
        try{
            JSON2Apex lds = JSON2Apex.parse(request.requestBody.toString().replace('\n', ''));
            System.debug(lds);
            //System.debug('lastName' + leadData.lastName);
            List<Account> acc = new List<Account>();
            acc = [SELECT Id FROM Account where School_Short_Code__c=:lds.schoolCode];
            system.debug('last Name  '+acc.size() );
            Lead ld  = new Lead();
            ld.Acadmic_Year__c	 = lds.acedemicYear;
            if(string.isNotBlank(lds.relation)){
                ld.Relation__c =lds.relation;   // for landig page  1             
            }
            
            if(string.isNotBlank(lds.Salutation))
                ld.Salutation =lds.Salutation;
            
            if(string.isNotBlank(lds.Parent_First_Name)) // Parent first name
                ld.FirstName = lds.Parent_First_Name; 
            
            if(string.isNotblank(lds.Parent_Last_Name)){
                ld.LastName =lds.Parent_Last_Name;//parent last name come from landing page 2
            }else{
                ld.LastName =lds.childLastName;//parent last name come from landing page 1
            }
            
            if(string.isNotBlank(lds.childFirstName))
                ld.Your_First_Name__c = lds.childFirstName; // child first name
            
            if(string.isNotBlank(lds.childLastName))
                ld.Your_Last_Name__c =lds.childLastName; // child last name
            
            if(string.isNotBlank(lds.Grade_Applying_For))
                ld.Seeking_Admission_in_Grade__c =lds.Grade_Applying_For;
            
            ld.Company = 'Universal Education';
            ld.MobilePhone	 = lds.mobile;
            
            if(string.isNotBlank(lds.studentMobile)){
               ld.phone = lds.studentMobile; // for landig page 2 
            }
            
            if(string.isNotBlank(lds.Email))
                ld.Email =lds.Email;
            
            ld.School_Short_Code__c = lds.schoolCode;
            
            if(acc.size()>0){
                system.debug(lds.schoolCode+acc[0].Id);
                ld.School_Institution__c	 = acc[0].Id; 
            }
            
            if(string.isNotBlank(lds.utmAdgroup))
                ld.utm_adgroup__c =lds.utmAdgroup;
            
            if(string.isNotBlank(lds.utmAudience))
                ld.utm_Audience__c =lds.utmAudience;
            
            if(string.isNotBlank(lds.utmCampaign))
                ld.utm_campaign__c =lds.utmCampaign;
            
            if(string.isNotBlank(lds.utmContent))
                ld.utm_content__c =lds.utmContent;
            
            if(string.isNotBlank(lds.utmDevice))
                ld.utm_device__c =lds.utmDevice;
            
            
            if(string.isNotBlank(lds.utmMatchtype))
                ld.utm_matchtype__c =lds.utmMatchtype;
            if(string.isNotBlank(lds.utmMedium))
                ld.utm_medium__c =lds.utmMedium;
            if(string.isNotBlank(lds.utmNetwork))
                ld.utm_network__c =lds.utmNetwork;
            if(string.isNotBlank(lds.utmPlacement))
                ld.utm_placement__c =lds.utmPlacement;
            if(string.isNotBlank(lds.utmSitelink))
                ld.utm_Sitelink__c =lds.utmSitelink;
            
            if(string.isNotBlank(lds.utmSource))
                ld.utm_source__c =lds.utmSource;
            if(string.isNotBlank(lds.utmTerm)){
                ld.utm_term__c =lds.utmTerm;
            }
            insert ld;
            
            result.put('Message', 'LandingPage: Lead Inserted Successfully.!!!');
            result.put('Status', 'Success');
            //result.put('Id', 'school '+ld.School_Institution__c+' - '+ld.Id);
            api_log.Response_Body__c = JSON.serialize(result);
            api_log.Response_Date_and_Time__c = Datetime.now();
            api_log.API_Log_Status__c ='Success';
            api_log.Response_Code__c = '200';
            response.responseBody = Blob.valueOf(JSON.serialize(result));
            
            response.statusCode = 200;
            response.addHeader('Content-Type', 'application/json');
            
            
        }
        catch(exception e){
            result.put('message','Landing Form '+e.getMessage());
            result.put('Status', '400');
            //result.put('line', string.valueOf(e.getLineNumber()));
            api_log.Response_Body__c = JSON.serialize(result);
            api_log.Response_Date_and_Time__c = Datetime.now();
            api_log.API_Log_Status__c ='Failure';
            api_log.Exception_Message__c = e.getMessage();
            api_log.Response_Code__c = '400';
            api_log.Exception_Stack_Trace__c = string.valueOf(e.getStackTraceString());
            response.responseBody = Blob.valueOf(JSON.serialize(result));
            response.statusCode = 400;
            response.addHeader('Content-Type', 'application/json');
            
        }
        
        insert api_log;
    }
    
    public class JSON2Apex{
        public string Salutation;
        public string Parent_First_name;//parent first Name
        public string Parent_Last_name;//parent Last Name
        public string mobile;//Mobile
        public string studentMobile;
        public string childFirstName;//child first Name
        public string childLastName;//child last Name
        public string Email;
        //public string remark;
        public string Grade_Applying_For;
        public string schoolCode;//School/Institution
        public string acedemicYear;//Academic Year
        //public string leadSource;//Lead Source
        public string Relation;
        public string utmTerm;
        public string utmSource;
        public string utmAudience;
        public string utmCampaign;
        public string utmContent;
        public string utmDevice;
        public string utmMatchtype;
        public string utmMedium;
        public string utmNetwork;
        public string utmSitelink;
        public string utmPlacement;
        public string utmAdgroup;
        
    }
    
    public static JSON2Apex parse(String json){
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
        
    }
    
    
    
}