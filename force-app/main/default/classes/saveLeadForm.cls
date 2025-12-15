@RestResource(urlMapping='/saveWebToLead/*')// Lead DashBoard API
global without sharing class saveLeadForm {
    
    @httpPost
    global static void doPost(){
        
        API_log__c api_log = new API_log__c();
        api_log.Name='saveWebToLead';
        List<Object> resultList = new List<Object>();
        Map < String, String > result = new Map < String, String > ();
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        string requestBody = request.requestBody.toString();
        api_log.Request_Body__c = requestBody;
        api_log.Request_Date_and_Time__c = Datetime.now();
        
        try{
            JSON2Apex jsData =  JSON2Apex.parse(request.requestBody.toString().replace('\n',''));
            set<Id> successLeadId = new set<Id>();
            set<string> acedemicYearList = new set<string>();
            set<string> mobileList = new set<string>();
            set<string> schoolList = new set<string>();
            set<string> childNameList = new set<string>();
            set<string> emailList= new set<string>();
            set<string> LeadSource= new set<string>();
            
            List<cls_leadJS2Apex> leadList = jsData.leadList;
            Map<string,string> mapsucesslineIds = new Map<string,string>();
            for(cls_leadJS2Apex lds : leadList){
                mapsucesslineIds.put(lds.Email, lds.Email+'-'+lds.LeadDashBoardId);
                if(string.isNotBlank(lds.acedemicYear)){
                    acedemicYearList.add(lds.acedemicYear);   
                }
                
                if(string.isNotBlank(lds.LeadSource)){
                    LeadSource.add(lds.LeadSource);   
                }
                
                if(string.isNotBlank(lds.schoolCode)){
                    schoolList.add(lds.schoolCode);   
                }
                
                if(string.isNotBlank(lds.Email)){
                    emailList.add(lds.Email);   
                }
                
                if(string.isNotBlank(lds.childFirstName)){
                    childNameList.add(lds.childFirstName);   
                }
                
                if(string.isNotBlank(lds.mobile)){
                    if(lds.mobile.contains('+91')){
                        mobileList.add(lds.Mobile.right(10));  
                    }else{
                        mobileList.add(lds.mobile);   
                    }
                }
            }
            
            //System.debug('mapsucesslineIds' + mapsucesslineIds);
            
            List<Account> accList = new List<Account>();
            accList = [SELECT Id , School_Short_Code__c FROM Account where School_Short_Code__c IN : schoolList];
            
            Map<string,Id> accMap = new Map<string,Id>();
            for(Account ac : accList){
                accMap.put(ac.School_Short_Code__c, ac.Id);
            }
            
            List<Lead> ldList = new List<Lead>();
            system.debug('mobileList'+mobileList);
            system.debug('schoolList'+schoolList);
            system.debug('emailList'+emailList);
            system.debug('acedemicYearList'+acedemicYearList);
            system.debug('childNameList'+childNameList);
            
            ldList = [select Id,OwnerId,Your_First_Name__c,Acadmic_Year__c,School_Short_Code__c,DupMobileNumber__c,email
                      from Lead where  DupMobileNumber__c  IN : mobileList and  School_Short_Code__c IN : schoolList
                      and email IN : emailList and Acadmic_Year__c IN : acedemicYearList and  Your_First_Name__c IN : childNameList];
            
            
            system.debug('existing lead size '+ldList.size());
            /*if(ldList.size() == 0){
ldList = [select Id,OwnerId,Your_First_Name__c,Acadmic_Year__c,School_Short_Code__c,DupMobileNumber__c,email
from Lead where  DupMobileNumber__c  IN : mobileList and  School_Short_Code__c IN : schoolList
and Acadmic_Year__c IN : acedemicYearList];
}*/
            
            
            map<string,lead> LeadMap = new map<string,lead>();
            
            for(Lead l : ldList){
                string key = l.DupMobileNumber__c+'-'+l.School_Short_Code__c+'-'+l.Acadmic_Year__c;
                LeadMap.put((key).toLowerCase(),l);
            }
            
            List<Lead_Source__c> leadSourceList = new  List<Lead_Source__c>();
            List<Task> taskList = new  List<Task>();
            
            system.debug('LeadMap'+LeadMap);
            List<Lead> leadList_Update = new  List<Lead>();
            Map<String,List<cls_leadJS2Apex>> sourceKeyChecker =  new Map<String,List<cls_leadJS2Apex>>();
            for(cls_leadJS2Apex lds : leadList) {
                if(accMap.containskey(lds.schoolCode)){
                    string key = (lds.Mobile).right(10)+'-'+lds.schoolCode+'-'+lds.acedemicYear;
                    sourceKeyChecker.put((key).toLowerCase(),new List<cls_leadJS2Apex>{lds});
                    system.debug('key'+key);
                    if(LeadMap.containskey((key).toLowerCase())){
                        system.debug('from inside 2 key '+key);
                        Lead ld = new Lead();
                        ld.Id =  LeadMap.get((key).toLowerCase()).Id;
                        Lead_Source__c ldsrc = new Lead_Source__c();
                        ldsrc.Name = lds.LeadSource;
                        ldsrc.Lead__c = LeadMap.get((key).toLowerCase()).Id;
                        //ldsrc.Id =  LeadMap.get((key).toLowerCase()).Id;
                        ldsrc.Lead_Dashboard_Id__c	 = lds.LeadDashBoardId;
                        
                        
                        
                        //ldsrc.Gender__c = lds.Gender;
                        
                        
                        
                        ldsrc.School_Institution__c = accMap.get(lds.schoolCode); 
                        if(string.isNotBlank(lds.Salutation))
                            ldsrc.Salutation__c =lds.Salutation; 
                        if(string.isNotBlank(lds.Your_first_name))
                            ldsrc.Lead_First_Name__c = lds.Your_first_name;
                        if(string.isNotBlank(lds.childLastName))
                            ldsrc.Lead_Last_Name__c = lds.childLastName;
                        ldsrc.Company__c = 'Universal Education';
                        if(string.isNotBlank(lds.mobile))
                            ldsrc.MobilePhone__c = lds.mobile;
                        if(string.isNotBlank(lds.acedemicYear))
                            ldsrc.Academic_Year__c = lds.acedemicYear;
                        if(string.isNotBlank(lds.DOB))
                            ldsrc.Date_of_Birth__c = date.parse(lds.DOB);
                        if(string.isNotBlank(lds.schoolCode))
                            ldsrc.School_Short_Code__c = lds.schoolCode;
                        if(string.isNotBlank(lds.Email))
                            ldsrc.Email__c =lds.Email;
                        if(string.isNotBlank(lds.childFirstName))
                            ldsrc.Your_First_Name__c = lds.childFirstName;
                        if(string.isNotBlank(lds.childLastName))
                            ldsrc.Your_Last_Name__c =lds.childLastName;
                        
                        if(string.isNotBlank(lds.Apartment_Society))
                            ldsrc.Apartment_Society__c = lds.Apartment_Society;
                        if(string.isNotBlank(lds.Landmark))
                            ldsrc.Landmark__c = lds.Landmark;
                        if(string.isNotBlank(lds.pinCode))
                            ldsrc.PostalCode__c =lds.pinCode;
                        if(string.isNotBlank(lds.fatherEducationalQualifications))
                            ldsrc.Father_s_Educational_Qualifications__c = lds.fatherEducationalQualifications;
                        if(string.isNotBlank(lds.motherEducationalQualifications))
                            ldsrc.Mother_s_Educational_Qualifications__c = lds.motherEducationalQualifications;
                        if(string.isNotBlank(lds.fatherOccupation))
                            ldsrc.Father_s_Occupation__c	 =lds.fatherOccupation;
                        if(string.isNotBlank(lds.motherOccupation))
                            ldsrc.Mother_s_Occupation__c	 = lds.motherOccupation;
                        if(string.isNotBlank(lds.fatherOtherOccupation))
                            ldsrc.Father_Other_Occupation__c = lds.fatherOtherOccupation;
                        if(string.isNotBlank(lds.motherOtherOccupation))
                            ldsrc.Mother_Other_Occupation__c = lds.motherOtherOccupation;
                        if(string.isNotBlank(lds.Grade_Applying_For))
                            ldsrc.Grade_Applying_For__c =lds.Grade_Applying_For;
                        if(string.isNotBlank(lds.howDidYouHearAboutUs))
                            ldsrc.How_did_you_hear_about_us__c =lds.howDidYouHearAboutUs;
                        
                        if(string.isNotBlank(lds.category))
                            ldsrc.Category__c =lds.category;
                        
                        if(string.isNotBlank(lds.gender))
                            ldsrc.Gender__c =lds.gender;
                        
                        if(string.isNotBlank(lds.relation))
                            ldsrc.Relation__c =lds.relation;
                        
                        if(string.isNotBlank(lds.currentschool))
                            ldsrc.Current_school__c =lds.currentschool;
                        
                        if(string.isNotBlank(lds.leadSubmissionURL))
                            ldsrc.Lead_Submission_URL__c =lds.leadSubmissionURL;
                        
                        if(string.isNotBlank(lds.utmAdgroup))
                            ldsrc.utm_adgroup__c =lds.utmAdgroup;
                        if(string.isNotBlank(lds.utmAudience))
                            ldsrc.utm_Audience__c =lds.utmAudience;
                        if(string.isNotBlank(lds.utmCampaign))
                            ldsrc.utm_campaign__c =lds.utmCampaign;
                        if(string.isNotBlank(lds.utmContent))
                            ldsrc.utm_content__c =lds.utmContent;
                        if(string.isNotBlank(lds.utmDevice))
                            ldsrc.utm_device__c =lds.utmDevice;
                        
                        
                        if(string.isNotBlank(lds.utmMatchtype))
                            ldsrc.utm_matchtype__c =lds.utmMatchtype;
                        if(string.isNotBlank(lds.utmMedium))
                            ldsrc.utm_medium__c =lds.utmMedium;
                        if(string.isNotBlank(lds.utmNetwork))
                            ldsrc.utm_network__c =lds.utmNetwork;
                        if(string.isNotBlank(lds.utmPlacement))
                            ldsrc.utm_placement__c =lds.utmPlacement;
                        if(string.isNotBlank(lds.utmSitelink))
                            ldsrc.utm_Sitelink__c =lds.utmSitelink;
                        
                        if(string.isNotBlank(lds.utmSource))
                            ldsrc.utm_source__c =lds.utmSource;
                        if(string.isNotBlank(lds.utmTerm)){
                            ldsrc.utm_term__c =lds.utmTerm;
                        }
                        if(string.isNotBlank(lds.stellarSeekingAdmissionInGrade)){
                            ldsrc.Stellar_Seeking_Admission_in_Grade__c = lds.stellarSeekingAdmissionInGrade;
                        }
                        
                        leadSourceList.add(ldsrc);
                        
                        Task tsk = new Task();
                        tsk.WhoId = LeadMap.get((key).toLowerCase()).Id;
                        tsk.Subject = 'Lead Updated with '+lds.leadSource;
                        tsk.OwnerId = LeadMap.get((key).toLowerCase()).OwnerId;
                        tsk.Status = 'Open';
                        tsk.Priority = 'high';
                        tsk.ActivityDate = date.today();
                        taskList.add(tsk);
                        
                        system.debug('tsk.OwnerId '+tsk.OwnerId );
                        
                        leadList_Update.add(ld);
                    }
                    else{
                        system.debug('from inside 2 key else');
                        Lead ld = new Lead();
                        ld.School_Institution__c	 = accMap.get(lds.schoolCode); 
                        ld.LeadSource = lds.LeadSource;
                        ld.Lead_Dashboard_Id__c	 = lds.LeadDashBoardId; 
                        
                        
                        if(string.isNotBlank(lds.pinCode))
                        ld.Pin_code__c = lds.pinCode;
                         //iflds.Are_you_a_single_parent))
                         
                        ld.Are_you_a_single_parent__c = lds.Are_you_a_single_parent;
                        
                         if(string.isNotBlank(lds.Father_s_First_Name))
                        ld.Father_s_First_Name__c = lds.Father_s_First_Name;
                         if(string.isNotBlank(lds.Mother_s_First_Name))
                        ld.Mother_s_First_Name__c = lds.Mother_s_First_Name;
                        
                         if(string.isNotBlank(lds.Father_s_Last_Name))
                        ld.Father_s_Last_Name__c = lds.Father_s_Last_Name;
                         if(string.isNotBlank(lds.Mother_s_Last_Name))
                         ld.Mother_s_Last_Name__c = lds.Mother_s_Last_Name;
                        
                         if(string.isNotBlank(lds.Father_s_Linkedin_profile))
                        ld.Father_s_Linkedin_profile__c = lds.Father_s_Linkedin_profile;
                        
                         if(string.isNotBlank(lds.Mother_s_Linkedin_profile))
                         ld.Mother_s_Linkedin_profile__c = lds.Mother_s_Linkedin_profile;
                        
                        if(string.isNotBlank(lds.Name_of_the_organisation_father))
                        ld.Name_of_the_organisation_father__c  = lds.Name_of_the_organisation_father;
                         if(string.isNotBlank(lds.Name_of_the_organisation_Mother))
                         ld.Name_of_the_organisation_Mother__c = lds.Name_of_the_organisation_Mother;
                        
                         if(string.isNotBlank(lds.Father_s_Mobile_number))
                        ld.Father_s_Mobile_number__c  = lds.Father_s_Mobile_number;
                         if(string.isNotBlank(lds.Mother_s_Mobile_number))
                         ld.Mother_s_Mobile_number__c = lds.Mother_s_Mobile_number;
                        
                         if(string.isNotBlank(lds.Father_s_Designation))
                        ld.Father_s_Designation__c = lds.Father_s_Designation;
                         if(string.isNotBlank(lds.Mother_s_Designation))
                         ld.Mother_s_Designation__c = lds.Mother_s_Designation;
                        
                         if(string.isNotBlank(lds.Father_s_Email_ID))
                        ld.Father_s_Email_ID__c = lds.Father_s_Email_ID;
                        
                         if(string.isNotBlank(lds.Mother_s_Email_ID))
                         ld.Mother_s_Email_ID__c = lds.Mother_s_Email_ID;
                        
                        //Mother_s_Profession,Fathers_s_Profession,
                        
                        if(string.isNotBlank(lds.Mother_s_Profession))
                        ld.Mother_s_Profession__c	 = lds.Mother_s_Profession;
                        
                         if(string.isNotBlank(lds.Fathers_s_Profession))
                         ld.Fathers_s_Profession__c	 = lds.Fathers_s_Profession;
                        
                        if(string.isNotBlank(lds.Parent_Questions_Or_Info))
                         ld.Parent_Questions_Or_Info__c	 = lds.Parent_Questions_Or_Info;
                        
                        
                        if(string.isNotBlank(lds.Salutation))
                            ld.Salutation =lds.Salutation;
                        if(string.isNotBlank(lds.Your_first_name))
                            ld.FirstName = lds.Your_first_name;
                        if(string.isNotBlank(lds.childLastName))
                            ld.LastName = lds.childLastName;
                        ld.Company = 'Universal Education';
                        if(string.isNotBlank(lds.mobile))
                            ld.MobilePhone = lds.mobile;
                        
                        
                        if(string.isNotBlank(lds.studentMobile)){
                            ld.phone = lds.studentMobile; // for landig page 2 
                        }
                        
                        if(string.isNotBlank(lds.acedemicYear))
                            ld.Acadmic_Year__c = lds.acedemicYear;
                        if(string.isNotBlank(lds.DOB))
                            ld.Date_of_Birth__c = date.parse(lds.DOB);
                        
                        
                        if(string.isNotBlank(lds.schoolCode))
                            ld.School_Short_Code__c = lds.schoolCode;
                        if(string.isNotBlank(lds.Email))
                            ld.Email =lds.Email;
                        if(string.isNotBlank(lds.childFirstName))
                            ld.Your_First_Name__c = lds.childFirstName;
                        if(string.isNotBlank(lds.childLastName))
                            ld.Your_Last_Name__c =lds.childLastName;
                        
                        if(string.isNotBlank(lds.Apartment_Society))
                            ld.Apartment_Society__c = lds.Apartment_Society;
                        if(string.isNotBlank(lds.Landmark))
                            ld.Landmark__c = lds.Landmark;
                        if(string.isNotBlank(lds.pinCode))
                            ld.Pin_code__c =lds.pinCode;
                        if(string.isNotBlank(lds.fatherEducationalQualifications))
                            ld.Father_s_Educational_Qualifications__c = lds.fatherEducationalQualifications;
                        if(string.isNotBlank(lds.motherEducationalQualifications))
                            ld.Mother_s_Educational_Qualifications__c = lds.motherEducationalQualifications;
                        if(string.isNotBlank(lds.fatherOccupation))
                            ld.Father_s_Occupation__c	 =lds.fatherOccupation;
                        if(string.isNotBlank(lds.motherOccupation))
                            ld.Mother_s_Occupation__c	 = lds.motherOccupation;
                        if(string.isNotBlank(lds.fatherOtherOccupation))
                            ld.Father_Other_Occupation__c = lds.fatherOtherOccupation;
                        if(string.isNotBlank(lds.motherOtherOccupation))
                            ld.Mother_Other_Occupation__c = lds.motherOtherOccupation;
                        if(string.isNotBlank(lds.Grade_Applying_For))
                            ld.Seeking_Admission_in_Grade__c =lds.Grade_Applying_For;
                        if(string.isNotBlank(lds.howDidYouHearAboutUs))
                            ld.How_did_you_hear_about_us__c =lds.howDidYouHearAboutUs;
                        
                        if(string.isNotBlank(lds.category))
                            ld.Category__c =lds.category;
                        
                        if(string.isNotBlank(lds.gender))
                            ld.Gender__c =lds.gender;
                        
                        if(string.isNotBlank(lds.relation))
                            ld.Relation__c =lds.relation;
                        
                        if(string.isNotBlank(lds.leadSubmissionURL))
                            ld.Lead_Submission_URL__c =lds.leadSubmissionURL;
                        
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
                        if(string.isNotBlank(lds.utmTerm))
                            ld.utm_term__c =lds.utmTerm;
                        if(string.isNotBlank(lds.stellarSeekingAdmissionInGrade)){
                            ld.Stellar_Seeking_Admission_in_Grade__c = lds.stellarSeekingAdmissionInGrade;
                        }
                        
                        if(string.isNotBlank(lds.currentschool))
                            ld.Current_school__c =lds.currentschool;
                        
                        leadList_Update.add(ld);
                    }
                }else{
                    map<string,string> row = new map<string,string> ();
                    row.put('Status', 'Failed');
                    row.put('Lead Dashbaord Id', lds.LeadDashBoardId);
                    row.put('Message','School Not Found ');
                    resultList.add(row); 
                    
                }
            }
            Schema.DescribeFieldResult dfr = Schema.sObjectType.Lead.fields.Id;
            Schema.sObjectField T = dfr.getSObjectField();
            Database.UpsertResult[] dtList = Database.upsert(leadList_Update, T, false);
            
            //System.debug('dtList' + dtList);
            
            map<Id,Id>leadId = new map<Id,Id>();
            for (Integer i = 0; i < dtList.size();i++) {
                map<string,string> row = new map<string,string> ();
                if(mapsucesslineIds.containskey(leadList[i].Email)){
                    if (dtList[i].isSuccess()) {
                        successLeadId.add(dtList[i].getId());
                        leadId.put(dtList[i].getId(),dtList[i].getId());
                    }else{
                        for(Database.Error err : dtList[i].getErrors()) {
                            row.put('Message', err.getMessage());
                            row.put('Status', string.valueOf(err.getStatusCode())+'-'+mapsucesslineIds.get(leadList[i].Email).substringBefore('-'));
                            //row.put('SF Lead Id',mapsucesslineIds.get(leadList[i].Email).substringBefore('-'));
                            row.put('SF Lead Id','Failed');
                            row.put('Lead Dashboard Id',mapsucesslineIds.get(leadList[i].Email).substringAfter('-'));
                            resultList.add(row); 
                        }
                        
                    }
                    
                }
                
                
            }
            
            //system.debug('from result Story'+JSON.serialize(resultList));
            
            
            List<Lead> ldListTOUpdateSource = [select Id,OwnerId,Your_First_Name__c,Acadmic_Year__c,lead_Id__c , Lead_Dashboard_Id__c , School_Short_Code__c,DupMobileNumber__c,email
                                               from Lead where ID IN: successLeadId];
            
            /*  List<Lead_Source__c> s_leadSourceList = [Select Id, Lead__c ,Name from Lead_Source__c where Lead__c IN: successLeadId and Name IN : LeadSource];
Map<string,Id> m_leadSource= new Map<string,Id> ();
for(Lead_Source__c ls : s_leadSourceList){
m_leadSource.put(ls.Name,ls.Name);
}
*/
            system.debug('from lead source '+ldListTOUpdateSource.size());
            
            for(Lead l : ldListTOUpdateSource){
                string key = l.DupMobileNumber__c+'-'+l.School_Short_Code__c+'-'+l.Acadmic_Year__c;
                key = key.toLowerCase();
                if(sourceKeyChecker.containskey(key)){ 
                    map<string,string> row = new map<string,string> ();
                    row.put('Message', 'Lead Saved Successfully.!!!');
                    row.put('Status', 'Success');
                    row.put('SF Lead Id',l.lead_Id__c);
                    row.put('Id',l.Id);
                    row.put('Lead Dashboard Id',l.Lead_Dashboard_Id__c);
                    resultList.add(row);
                }
                
            }
            
            system.debug('from  new source 1'+leadSourceList.size() +' task '+taskList.size());  
            if(leadSourceList.size() > 0){
                insert leadSourceList;
            }
            
            if(taskList.size() > 0){
                insert taskList;
            }
            
            api_log.Response_Body__c = JSON.serialize(resultList);
            api_log.Response_Date_and_Time__c = Datetime.now();
            api_log.API_Log_Status__c ='Success';
            api_log.Response_Code__c = '200';
            system.debug('resultList'+resultList);
            if(!test.isRunningTest()){
                response.responseBody = Blob.valueOf(JSON.serialize(resultList));
            }
            
            
            response.statusCode = 200;
            response.addHeader('Content-Type', 'application/json');
            
            //}
        }
        catch(exception e){
            system.debug('error'+e);
            result.put('message',e.getMessage());
            result.put('Status', '400');
            result.put('Line', string.valueOf(e.getLineNumber()));
            resultList.add(result);
            system.debug('final exception'+JSON.serialize(resultList));
            api_log.Response_Body__c = JSON.serialize(resultList);
            api_log.Response_Date_and_Time__c = Datetime.now();
            api_log.API_Log_Status__c ='Failure';
            api_log.Exception_Message__c = e.getMessage();
            api_log.Response_Code__c = '400';
            api_log.Exception_Stack_Trace__c = string.valueOf(e.getStackTraceString());
            response.responseBody = Blob.valueOf(JSON.serialize(resultList));
            response.statusCode = 400;
            response.addHeader('Content-Type', 'application/json');
        }
        insert api_log;
    }
    
    public class JSON2Apex{
        public cls_leadJS2Apex [] leadList;
    }
    
    public class cls_leadJS2Apex{
       //public string pinCode; 
        public boolean Are_you_a_single_parent;
        public string Father_s_First_Name ;
        public string Mother_s_First_Name;
        public string Father_s_Last_Name ;
        public string  Mother_s_Last_Name; 
        public string  Father_s_Linkedin_profile ;
        public string  Mother_s_Linkedin_profile ;
        public string Father_s_Mobile_number ;
        public string Mother_s_Email_ID ;
        public string Mother_s_Designation;
        public string Father_s_Email_ID;
        public string Father_s_Designation;
        public string Mother_s_Mobile_number;
        public string Name_of_the_organisation_Mother;
        public string Name_of_the_organisation_father;
        public string Fathers_s_Profession;
        public string Parent_Questions_Or_Info;
        public string Mother_s_Profession;
        
        
        public string Id;
        public string Salutation;
        public string Your_first_name;
        public string Your_Last_name;
        public string Email;
        public string childFirstName;
        public string childLastName;
        public string DOB;
        public string schoolCode;
        public string mobile;
        public string studentMobile;
        public string acedemicYear;
        public string company;
        public string Apartment_Society;
        public string Landmark;
        public string pinCode;
        public string fatherEducationalQualifications;
        public string motherEducationalQualifications;
        public string fatherOccupation;
        public string motherOccupation;
        public string fatherOtherOccupation;
        public string motherOtherOccupation;
        public string howDidYouHearAboutUs;
        public string Grade_Applying_For;
        public string LeadSource;
        public string LeadDashBoardId;
        public string gender;
        public string utmTerm;
        public string utmSource;
        public string Category;
        public string Relation;
        public string leadSubmissionURL;
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
        public string stellarSeekingAdmissionInGrade;
        public string currentschool;
        
    }
    
    public static JSON2Apex parse(string js){
        return (JSON2Apex) (System.JSON.deserialize(js, JSON2Apex.class));
    }
}