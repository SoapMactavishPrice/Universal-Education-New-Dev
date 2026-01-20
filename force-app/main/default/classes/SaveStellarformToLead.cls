@RestResource(urlMapping='/saveStellarForm/*')
global with sharing class SaveStellarformToLead {
    @httpPost
    global static void doPost(){
        API_log__c api_log = new API_log__c();
        api_log.Name='saveStellarForm';
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response; 
        String reqDataAsString = request.requestBody.toString();
        api_log.Request_Body__c = reqDataAsString;
        api_log.Request_Date_and_Time__c = Datetime.now();
        Map < String, String > result = new Map < String, String > ();
        try{
            JSON2Apex leadData = JSON2Apex.parse(request.requestBody.toString().replace('\n', ''));
            List<Account> acc = new List<Account>();
            acc = [SELECT Id FROM Account where School_Short_Code__c=:leadData.school];
            
            Lead ld  = new Lead();
            ld.FirstName = leadData.firstName;
            ld.LastName = leadData.lastName;
            ld.Company = 'Universal Education';
            ld.Referrer_First_Name__c	 = leadData.referrerFirstName;
            ld.Referrer_Last_Name__c	 = leadData.referrerLastName;
            ld.MobilePhone	 = leadData.phoneNumber;
            ld.School_Short_Code__c = leadData.school;
            ld.Reason_for_Recommendation__c	 = leadData.reasonforrecommendation;
            ld.parent_Questions_Or_Info__c = leadData.parentQuestionsOrInfo;
            if(acc.size()>0){
                ld.School_Institution__c	 = acc[0].Id; 
            }
            ld.Acadmic_Year__c	 = leadData.AcademicYear;
            ld.Referrer_Contact_No__c = leadData.referrertContactNumber;
            ld.LeadSource = leadData.leadSource;
            
            ld.Email  = leadData.email;
            ld.MobilePhone  = leadData.phoneNumber;
            ld.Stellar_Seeking_Admission_in_Grade__c = leadData.programme;
            ld.Your_First_Name__c = leadData.LearnerFirstName;
            ld.Your_Last_Name__c = leadData.LearnerLastName;
            ld.Gender__c = leadData.Gender;
            ld.Date_of_Birth__c = leadData.DateofBirth;
            ld.Nationality__c = leadData.Nationality;
            ld.Apartment_name__c = leadData.Apartmentname;
            ld.Street = leadData.streetAreaLandmark;
            ld.City = leadData.City;
            ld.State = leadData.State;
            ld.Pin_code__c = leadData.Pincode;
            ld.Country = leadData.country;
            /*if(leadData.Areyouasingleparent == true){
                ld.Are_you_a_single_parent__c ='Yes';
            }else{
                ld.Are_you_a_single_parent__c ='No';
            }*/
            ld.Relation__c = leadData.relationWithChild;
            ld.Are_you_a_single_parent__c = leadData.Areyouasingleparent;
            ld.Father_s_First_Name__c = leadData.FatherFirstName;
            ld.Father_s_Last_Name__c = leadData.FatherLastName;
            ld.Father_s_Mobile_number__c = leadData.fatherPhoneNumber;
            ld.Father_s_Email_ID__c = leadData.fatherEmail;
            ld.Father_s_Educational_Qualifications__c = leadData.FatherEducationalqualification;
            ld.Father_s_Occupation__c = leadData.fatherProfession;
            ld.Name_of_the_organisation_father__c = leadData.fatherOrganisation;
            ld.Father_s_Designation__c = leadData.FatherDesignation;
            ld.Father_s_Linkedin_profile__c = leadData.fatherLinkedin;
            ld.Mother_s_First_Name__c = leadData.MotherFirstName;
            ld.Mother_s_Last_Name__c = leadData.MotherLastName;
            ld.Mother_s_Mobile_number__c = leadData.motherPhoneNumber;
            ld.Mother_s_Email_ID__c = leadData.motherEmail;
            ld.Mother_s_Educational_Qualifications__c = leadData.motherEducationalQualification;
            ld.Mother_s_Occupation__c = leadData.motherProfession;
            ld.Name_of_the_organisation_Mother__c = leadData.motherOrganisation;
            ld.Mother_s_Designation__c = leadData.motherDesignation;
            ld.Mother_s_Linkedin_profile__c = leadData.motherLinkedin;
            ld.Personalized_learning_needs__c = leadData.LearningNeeds;
            ld.Please_specify_in_detail_learning_needs__c = leadData.pleaseSpecifyInDetailLearningNeeds;
            ld.Has_your_child_ever_received_any_special__c = leadData.disability;
            ld.Please_specify_in_detail_support__c = leadData.pleaseSpecifyInDetail;
            ld.Name_of_school_or_preschool_currently_st__c = leadData.schoolOrPreschoolName;
            //.Disablity__c = leadData.Hasyourchildeverreceivedanyspecialspport;
             if(string.isNotBlank(leadData.utm_adgroup))
                ld.utm_adgroup__c =leadData.utm_adgroup;
            if(string.isNotBlank(leadData.utm_Audience))
                ld.utm_Audience__c =leadData.utm_Audience;
            if(string.isNotBlank(leadData.utm_campaign))
                ld.utm_campaign__c =leadData.utm_campaign;
            if(string.isNotBlank(leadData.utm_content))
                ld.utm_content__c =leadData.utm_content;
            if(string.isNotBlank(leadData.utm_device))
                ld.utm_device__c =leadData.utm_device;
            
            
            if(string.isNotBlank(leadData.utm_matchtype))
                ld.utm_matchtype__c =leadData.utm_matchtype;
            if(string.isNotBlank(leadData.utm_medium))
                ld.utm_medium__c =leadData.utm_medium;
            if(string.isNotBlank(leadData.utm_network))
                ld.utm_network__c =leadData.utm_network;
            if(string.isNotBlank(leadData.utm_placement))
                ld.utm_placement__c =leadData.utm_placement;
            if(string.isNotBlank(leadData.utm_Sitelink))
                ld.utm_Sitelink__c =leadData.utm_Sitelink;
            
            if(string.isNotBlank(leadData.utm_source))
                ld.utm_source__c =leadData.utm_source;
            if(string.isNotBlank(leadData.utm_term)){
                ld.utm_term__c =leadData.utm_term;
            }
            insert ld;
            
            result.put('Message', 'Lead Inserted Successfully.!!!');
            result.put('Status', 'Success');
            api_log.Response_Body__c = JSON.serialize(result);
            api_log.Response_Date_and_Time__c = Datetime.now();
            api_log.API_Log_Status__c ='Success';
            api_log.Response_Code__c = '200';
            response.responseBody = Blob.valueOf(JSON.serialize(result));
            
            response.statusCode = 200;
            response.addHeader('Content-Type', 'application/json');
            
            
        }catch(exception e){
            result.put('message',e.getMessage());
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
        
        public string firstName;//Last Name
        public string lastName;
        public string mobile;//Mobile
        public string referrerFirstName;// Referrer Name	
        public string referrerLastName;//
        public string referrertContactNumber; // Referrer Contact No
        public string reasonforrecommendation;//Reason for Recommendation
        public string school;//School/Institution
        public string AcademicYear;//Academic Year
        public string leadSource;//Lead Source 
        // new fields 
        public string   email;
        public string   phoneNumber;
        public string   Stellarcampusapplyingfor;
        public string   programme;
        public string   LearnerFirstName;
        public string   LearnerLastName;
        public string   Gender;
        public Date   DateofBirth;
        public string   Nationality;
        public string   Apartmentname;
        public string   streetAreaLandmark;
        public string   State;
        public string   City;
        public string   Pincode;
        public string   Country;
        public Boolean  Areyouasingleparent;
        public string   fatherFirstName;
        public string   FatherLastName;
        public string   fatherPhoneNumber;
        public string   fatherEmail;
        public string   fatherEducationalQualification;
        public string   FatherProfession;
        public string   fatherOrganisation;
        public string   FatherDesignation;
        public string   fatherLinkedin;
        public string   MotherFirstName;
        public string   MotherLastName;
        public string   motherPhoneNumber;
        public string   motherEmail;
        public string   MotherEducationalqualification;
        public string   motherProfession;
        public string   motherOrganisation;
        public string   MotherDesignation;
        public string   motherLinkedin;
        public string  LearningNeeds;
        public string  Hasyourchildeverreceivedanyspecialspport;
        public string pleaseSpecifyInDetail;
        public string pleaseSpecifyInDetailLearningNeeds;
        public string relationWithChild;
        public string schoolOrPreschoolName;
        public string disability;
        public string utm_term;
        public string utm_source;
        public string utm_Audience;
        public string utm_campaign;
        public string utm_content;
        public string utm_device;
        public string utm_matchtype;
        public string utm_medium;
        public string utm_network;
        public string utm_Sitelink;
        public string utm_placement;
        public string utm_adgroup;
        public string parentQuestionsOrInfo;
        
    }
    
    public static JSON2Apex parse(String json){
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    }
    
    
    
}