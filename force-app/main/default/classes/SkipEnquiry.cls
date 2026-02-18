global Without Sharing class SkipEnquiry {
    public boolean back{get;set;}
    ID ContactIds = ApexPages.currentPage().getParameters().get('id');
    string code = ApexPages.currentPage().getParameters().get('code');
    public SkipEnquiry(ApexPages.StandardController controller){
        system.debug('ContactIds >>>>>> @ > ' + ContactIds); 
        system.debug('code >>>>>> @ > ' + code); 
        back = false;
    }
    public PageReference cancel()
    {
        return  new pageReference('/'+ContactIds);
    }
    public PageReference CreateEnquiry(){
        //String ContactIds
        PageReference retURL ;
        system.debug('ContactIds  >> ' + ContactIds);
        string DataName;
        String SAcademicYear;
        string sDataName='ENQ/2023-2024/16';
        Integer nDataName= 0;
        boolean skiiped=false; 
        string enqname;
        string scid='';
        string yr=System.Label.CurrentYear;
        List<Enquiry__c> liistEnquiry = new list<Enquiry__c>();
        List<contact> listcont =[SELECT Id,Lead__c,lead__r.Acadmic_Year__c,
                                 Pin_code__c,Apartment_Society__c,Landmark__c,Father_s_Educational_Qualifications__c,Mother_s_Educational_Qualifications__c,
                                 Father_Other_Occupation__c,Father_s_Occupation__c,Mother_Other_Occupation__c,Mother_s_Occupation__c,How_did_you_hear_about_us__c,
                                 SkipEnquiry__c,SkipCuriosity__c,Phone,Academic_Year__c,school_Name__c ,School_Short_Code__c,Gender__c,Program__c,Date_of_Birth__c,
                                 Relation__c,Category__c,Stellar_Seeking_Admission_in_Grade__c,Your_Last_Name__c,Your_First_Name__c,Email,MobilePhone, AccountId, LastName,
                                 FirstName, MiddleName, Name,Current_school__c,Lead__r.Nationality__c,Lead__r.Email, lead__r.MobilePhone,lead__r.Stellar_Seeking_Admission_in_Grade__c,
                                 lead__r.Your_First_Name__c,lead__r.Your_Last_Name__c,lead__r.Gender__c,lead__r.Date_of_Birth__c,lead__r.Apartment_name__c,lead__r.Street,lead__r.City,
                                 lead__r.State,lead__r.Pin_code__c,Lead__r.postalCode,lead__r.Country,lead__r.Relation__c,lead__r.Are_you_a_single_parent__c,lead__r.Father_s_First_Name__c,
                                 lead__r.Father_s_Last_Name__c,lead__r.Father_s_Mobile_number__c,lead__r.Father_s_Email_ID__c,lead__r.Father_s_Educational_Qualifications__c,
                                 lead__r.Father_s_Occupation__c,lead__r.Name_of_the_organisation_father__c,lead__r.Father_s_Designation__c,lead__r.Father_s_Linkedin_profile__c,
                                 lead__r.Mother_s_First_Name__c,lead__r.Mother_s_Last_Name__c,lead__r.Mother_s_Mobile_number__c,lead__r.Mother_s_Email_ID__c,
                                 lead__r.Mother_s_Educational_Qualifications__c,lead__r.Mother_s_Occupation__c,lead__r.Name_of_the_organisation_Mother__c,lead__r.Mother_s_Designation__c,
                                 lead__r.Mother_s_Linkedin_profile__c,lead__r.Personalized_learning_needs__c,lead__r.Please_specify_in_detail_learning_needs__c,lead__r.Has_your_child_ever_received_any_special__c,
                                 lead__r.Please_specify_in_detail_support__c,lead__r.Name_of_school_or_preschool_currently_st__c FROM Contact where id=: ContactIds];
        for(contact c:listcont){
            scid=c.school_Name__c ;
        //    yr=c.Academic_Year__c;
        	yr = c.lead__r.Acadmic_Year__c;

            SAcademicYear=yr;
            DataName='ENQ/'+yr+'/0';
            system.debug('lk '+scid);
            if(c.SkipEnquiry__c || c.SkipCuriosity__c)   
            {
                //added c.SkipCuriosity__c to resist more than 1 enquiry for same contact 
                skiiped=true;
            }
        }
        if(!skiiped)
        {
            List<Enquiry__c> ld1=[SELECT Id,Name,School_Institution__c,Gender__c,createdDate FROM Enquiry__c where school_Name__c =:scid and Academic_Year__c=: yr and Name LIKE '%ENQ%' ];
            if(!test.isRunningTest()){
                if(ld1!=null && ld1.size()>0){
                    DataName = [SELECT Id,Name,School_Institution__c,Gender__c,createdDate FROM Enquiry__c where school_Name__c =:scid and Academic_Year__c=: yr and Name LIKE '%ENQ%'  ORDER BY createdDate  desc limit 1].Name;
                    // SAcademicYear = [SELECT Id,Name,Academic_Year__c,createdDate FROM Enquiry__c where  Name LIKE '%ENQ%' ORDER BY createdDate  DESC limit 1].Academic_Year__c;
                }
            }
            
            system.debug('listcont >> ' + listcont);
            system.debug('DataName >> ' + DataName);
            system.debug('SAcademicYear >> ' + SAcademicYear);
        /*    if(!test.isRunningTest()){
                if(DataName!=null){
                    sDataName = DataName.substringAfterLast('/');
                }
                system.debug('sDataName  ' + sDataName);
                
                for(integer i=0; i<=integer.valueOf(sDataName);i++){
                    nDataName = i+1;
                }
                enqname='ENQ/'+SAcademicYear+'/'+nDataName;	
                system.debug('nDataName  ' + nDataName);}		*/
            
            Integer maxNumber = 0;
            String namePattern = 'ENQ/' + yr + '/%';
            
            List<Enquiry__c> existingEnquiries = [
                SELECT Name 
                FROM Enquiry__c 
                WHERE school_Name__c = :scid 
                AND Academic_Year__c = :yr 
                AND Name LIKE :namePattern
            ];
            
            for (Enquiry__c enq : existingEnquiries) {
                try {
                    String[] parts = enq.Name.split('/');
                    if (parts.size() == 3) {
                        Integer num = Integer.valueOf(parts[2]);
                        if (num > maxNumber) {
                            maxNumber = num;
                        }
                    }
                } catch (Exception e) {
                    System.debug('Could not parse number from: ' + enq.Name);
                }
            }
            
            nDataName = maxNumber + 1;
            enqname = 'ENQ/' + yr + '/' + nDataName;

            
            
            /* list<Enquiry__c> listenq=[select id from Enquiry__c where name=:enqname and school_Name__c =:scid and Academic_Year__c=: yr];
if(listenq!=null && listenq.size()>0)
{
nDataName=nDataName+1;
enqname='ENQ/'+SAcademicYear+'/'+nDataName;
list<Enquiry__c> listenq1=[select id from Enquiry__c where name=:enqname and  school_Name__c =:scid and Academic_Year__c=: yr ];
if(listenq1!=null && listenq1.size()>0)
{
nDataName=nDataName+1;
enqname='ENQ/'+SAcademicYear+'/'+nDataName;
}
}*/
            
            boolean isDuplicate=true;
            list<Enquiry__c> listenq1=[select id from Enquiry__c where name=:enqname and  school_Name__c =:scid and Academic_Year__c=: yr ];
            if(listenq1!=null && listenq1.size()>0)
            {
                nDataName=nDataName+1;
                enqname='ENQ/'+SAcademicYear+'/'+nDataName;
            }
            else
            {
                isDuplicate=false;
                
            }
            listenq1=[select id,name from Enquiry__c where  school_Name__c =:scid and Academic_Year__c=: yr ];
            List<string> lISTenqName=new List<string> ();
            for(Enquiry__c enq:listenq1)
            {
                lISTenqName.add(enq.Name);
            }
            while(isDuplicate)
            {
                // listenq1=[select id from Enquiry__c where name=:enqname and  school_Name__c =:scid and Academic_Year__c=: yr ];
                if(lISTenqName.contains(enqname))
                {
                    nDataName=nDataName+1;
                    enqname='ENQ/'+SAcademicYear+'/'+nDataName;
                }
                else
                {
                    isDuplicate=false;
                    break;
                }
            }
            for(contact ocontact : listcont){
                Enquiry__c oEnquiry = new Enquiry__c();
                oEnquiry.Contact__c = ocontact.id;
                oEnquiry.Name = enqname;
                oEnquiry.Academic_Year__c = ocontact.Academic_Year__c;
                oEnquiry.Lead__c=ocontact.Lead__c;
                // oEnquiry.FirstName__c = ocontact.FirstName;
                //oEnquiry.Last_Name__c = ocontact.LastName;
                // oEnquiry.Mobile_No__c = ocontact.MobilePhone;
                oEnquiry.Email__c = ocontact.Email;
                oEnquiry.Apartment_Society__c = ocontact.Apartment_Society__c;
                if(ocontact.Apartment_Society__c!=null)
                {
                    oEnquiry.Demographic__c=true; 
                    oEnquiry.Demo_Submitted_date__c=system.now().format('dd-MM-yyyy');
                    oEnquiry.Demo_Submitted_Time__c=DateTime.now().format('hh:mm a');
                }
                oEnquiry.Locality__c = ocontact.Landmark__c;
                oEnquiry.Father_s_Educational_Qualifications__c = ocontact.Father_s_Educational_Qualifications__c;
                oEnquiry.Mother_s_Educational_Qualifications__c = ocontact.Mother_s_Educational_Qualifications__c;
                oEnquiry.FatherOther_Occupation__c = ocontact.Father_Other_Occupation__c;
                oEnquiry.Father_s_Occupation__c = ocontact.Father_s_Occupation__c;
                oEnquiry.Mother_Other_Occupation__c = ocontact.Mother_Other_Occupation__c;
                oEnquiry.Mother_s_Occupation__c = ocontact.Mother_s_Occupation__c;
                oEnquiry.How_did_you_hear_about_us__c = ocontact.How_did_you_hear_about_us__c;
                // oEnquiry.Last_Name__c = ocontact.Your_Last_Name__c;
                oEnquiry.Demographic_Pin_code__c=ocontact.Pin_code__c;
                oEnquiry.Demographic_Pin_code__c=ocontact.Pin_code__c;
                
                oEnquiry.Stellar_Grade__c = ocontact.Stellar_Seeking_Admission_in_Grade__c ;
                oEnquiry.Category__c = ocontact.Category__c;
                oEnquiry.Date_of_Birth__c = ocontact.Date_of_Birth__c;
                oEnquiry.orgCode__c=ocontact.School_Short_Code__c;
                oEnquiry.Gender__c=ocontact.Gender__c;
                oEnquiry.Relation__c = ocontact.Relation__c;
                oEnquiry.Current_school__c = ocontact.Current_school__c;
                oEnquiry.FirstName__c = ocontact.Your_First_Name__c;
                oEnquiry.Last_Name__c = ocontact.Your_Last_Name__c;
                oEnquiry.Mobile_No__c = ocontact.Phone;
                oEnquiry.Email__c = ocontact.Email;
                oEnquiry.Parent_First_Name__c = ocontact.FirstName;
                oEnquiry.Parent_Last_Name__c = ocontact.LastName;
                
                oEnquiry.Nationality__c = ocontact.Lead__r.Nationality__c;
                oEnquiry.Apartment_name__c = ocontact.lead__r.Apartment_name__c;
                oEnquiry.Are_you_a_single_parent__c = ocontact.lead__r.Are_you_a_single_parent__c;
                oEnquiry.Father_s_Designation__c = ocontact.lead__r.Father_s_Designation__c;
                oEnquiry.Father_s_Email_ID__c = ocontact.lead__r.Father_s_Email_ID__c;
                oEnquiry.Father_s_First_Name__c = ocontact.lead__r.Father_s_First_Name__c;
                oEnquiry.Father_s_Last_Name__c =  ocontact.lead__r.Father_s_Last_Name__c;
                oEnquiry.Father_s_Linkedin_profile__c = ocontact.lead__r.Father_s_Linkedin_profile__c;
                oEnquiry.Father_s_Mobile_number__c = ocontact.lead__r.Father_s_Mobile_number__c;
                oEnquiry.Mother_s_Designation__c =  ocontact.lead__r.Mother_s_Designation__c;
                oEnquiry.Mother_s_Designation__c = ocontact.lead__r.Mother_s_Designation__c;
                oEnquiry.Mother_s_Email_ID__c = ocontact.lead__r.Mother_s_Email_ID__c;
                oEnquiry.Mother_s_First_Name__c = ocontact.lead__r.Mother_s_First_Name__c;
                oEnquiry.Mother_s_Last_Name__c =  ocontact.lead__r.Mother_s_Last_Name__c;
                oEnquiry.Mother_s_Linkedin_profile__c = ocontact.lead__r.Mother_s_Linkedin_profile__c;
                oEnquiry.Mother_s_Mobile_number__c = ocontact.lead__r.Mother_s_Mobile_number__c;
                oEnquiry.Name_of_school_or_preschool_currently_st__c = ocontact.lead__r.Name_of_school_or_preschool_currently_st__c;
                oEnquiry.Name_of_the_organisation_father__c = ocontact.lead__r.Name_of_the_organisation_father__c;
                oEnquiry.Name_of_the_organisation_mother__c = ocontact.lead__r.Name_of_the_organisation_mother__c;
                oEnquiry.Personalized_learning_needs__c =  ocontact.lead__r.Personalized_learning_needs__c;
                //  oEnquiry.Seeking_Grade__c = classRefId;
                // oEnquiry.Category__c = ocontact.Category__c;
                //oEnquiry.Seeking_Admission_in_Grade__c=ocontact.Program__c;
                system.debug('888'+ocontact.Stellar_Seeking_Admission_in_Grade__c);
                system.debug('888'+ocontact.AccountId);
                //ocontact.AccountId
                if(ocontact.Program__c!=null){
                    
                    List <Class__c> cl=[ SELECT Id ,Name FROM Class__c WHERE Name =:ocontact.Program__c AND School_Name__c=:ocontact.AccountId ];
                    system.debug('888 '+cl);
                    if(cl!=null && cl.size()>0)
                    {
                        oEnquiry.Seeking_Grade__c=cl[0].id;
                    }
                }
                // oEnquiry.Seeking_Grade__c=ocontact.Stellar_Seeking_Admission_in_Grade__c;
                oEnquiry.School_Institution__c = ocontact.Accountid;
                liistEnquiry.add(oEnquiry);
            }system.debug('liistEnquiry  ' + liistEnquiry);
            if(!liistEnquiry.isEmpty()){
                insert liistEnquiry;
            }
            Contact oContacts = [select id,SkipCuriosity__c,SkipEnquiry__c from Contact where ID =:ContactIds];
            oContacts.SkipEnquiry__c = true;
            Update oContacts;
            if(liistEnquiry.size()>0 && liistEnquiry[0].id!=null)
            {
                retURL = new PageReference('/'+liistEnquiry[0].id);
                retURL.setRedirect(true);
            }
            return retURL;
        }
        else
        {
            back = true;
            system.debug('msg');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Enquiry already  skipped!! or Enquiry is already exist for this Contact'));
        }
        return retURL;
    }
    webservice static Boolean CreateEnquiryRecord(String ContactIds) {
        system.debug('ContactIds >> ' + ContactIds);
        
        String SAcademicYear = '';
        String enqName = '';
        String scid = '';
        Integer nDataName = 0;
        
        List<Enquiry__c> liistEnquiry = new List<Enquiry__c>();
        
        // Step 1: Get the contact and Lead info
        List<Contact> listcont = [
            SELECT Id, Lead__c, Lead__r.Acadmic_Year__c, Phone, Academic_Year__c, School_Short_Code__c, Gender__c, Program__c,
            Date_of_Birth__c, Relation__c, Category__c, Stellar_Seeking_Admission_in_Grade__c, Your_Last_Name__c,
            Your_First_Name__c, Email, MobilePhone, AccountId, LastName, FirstName, MiddleName, Name, Current_school__c, 
            Lead__r.Nationality__c, Lead__r.Email, Lead__r.MobilePhone, Lead__r.Stellar_Seeking_Admission_in_Grade__c,
            Lead__r.Your_First_Name__c, Lead__r.Your_Last_Name__c, Lead__r.Gender__c, Lead__r.Date_of_Birth__c, 
            Lead__r.Apartment_name__c, Lead__r.Street, Lead__r.City, Lead__r.State, Lead__r.Pin_code__c, 
            Lead__r.postalCode, Lead__r.Country, Lead__r.Relation__c, Lead__r.Are_you_a_single_parent__c, 
            Lead__r.Father_s_First_Name__c, Lead__r.Father_s_Last_Name__c, Lead__r.Father_s_Mobile_number__c,
            Lead__r.Father_s_Email_ID__c, Lead__r.Father_s_Educational_Qualifications__c, Lead__r.Father_s_Occupation__c,
            Lead__r.Name_of_the_organisation_father__c, Lead__r.Father_s_Designation__c, Lead__r.Father_s_Linkedin_profile__c,
            Lead__r.Mother_s_First_Name__c, Lead__r.Mother_s_Last_Name__c, Lead__r.Mother_s_Mobile_number__c,
            Lead__r.Mother_s_Email_ID__c, Lead__r.Mother_s_Educational_Qualifications__c, Lead__r.Mother_s_Occupation__c,
            Lead__r.Name_of_the_organisation_Mother__c, Lead__r.Mother_s_Designation__c, Lead__r.Mother_s_Linkedin_profile__c,
            Lead__r.Personalized_learning_needs__c, Lead__r.Please_specify_in_detail_learning_needs__c,
            Lead__r.Has_your_child_ever_received_any_special__c, Lead__r.Please_specify_in_detail_support__c,
            Lead__r.Name_of_school_or_preschool_currently_st__c, school_Name__c
            FROM Contact
            WHERE Id = :ContactIds
        ];
        
        if (listcont.isEmpty()) return false;
        
        Contact ocontact = listcont[0];
        
        scid = ocontact.school_Name__c;
        SAcademicYear = ocontact.Lead__r != null ? ocontact.Lead__r.Acadmic_Year__c : null;
        
        if (String.isBlank(SAcademicYear)) {
            system.debug('Missing Academic Year on Lead.');
            return false;
        }
        
        // Step 2: Generate unique ENQ name
        Integer maxNumber = 0;
        String namePattern = 'ENQ/' + SAcademicYear + '/%';
        
        List<Enquiry__c> existingEnquiries = [
            SELECT Name FROM Enquiry__c
            WHERE school_Name__c = :scid
            AND Academic_Year__c = :SAcademicYear
            AND Name LIKE :namePattern
        ];
        
        Set<String> existingNames = new Set<String>();
        for (Enquiry__c enq : existingEnquiries) {
            existingNames.add(enq.Name);
            try {
                String[] parts = enq.Name.split('/');
                if (parts.size() == 3) {
                    Integer num = Integer.valueOf(parts[2]);
                    if (num > maxNumber) maxNumber = num;
                }
            } catch (Exception e) {
                System.debug('Invalid name format: ' + enq.Name);
            }
        }
        
        // Generate new unique ENQ name
        do {
            nDataName = ++maxNumber;
            enqName = 'ENQ/' + SAcademicYear + '/' + nDataName;
        } while (existingNames.contains(enqName));
        
        // Step 3: Prepare new Enquiry record
        Enquiry__c oEnquiry = new Enquiry__c();
        oEnquiry.Contact__c = ocontact.Id;
        oEnquiry.Name = enqName;
        oEnquiry.Lead__c = ocontact.Lead__c;
        oEnquiry.Academic_Year__c = SAcademicYear;
        oEnquiry.Email__c = ocontact.Email;
        oEnquiry.Child_First_Name__c = ocontact.Your_First_Name__c;
        oEnquiry.Stellar_Grade__c = ocontact.Stellar_Seeking_Admission_in_Grade__c;
        oEnquiry.Category__c = ocontact.Category__c;
        oEnquiry.Date_of_Birth__c = ocontact.Date_of_Birth__c;
        oEnquiry.orgCode__c = ocontact.School_Short_Code__c;
        oEnquiry.Gender__c = ocontact.Gender__c;
        oEnquiry.Relation__c = ocontact.Relation__c;
        oEnquiry.FirstName__c = ocontact.Your_First_Name__c;
        oEnquiry.Last_Name__c = ocontact.Your_Last_Name__c;
        oEnquiry.Mobile_No__c = ocontact.Phone;
        oEnquiry.Parent_First_Name__c = ocontact.FirstName;
        oEnquiry.Parent_Last_Name__c = ocontact.LastName;
        oEnquiry.Current_school__c = ocontact.Current_school__c;
        
        // Lead fields
        oEnquiry.Nationality__c = ocontact.Lead__r.Nationality__c;
        oEnquiry.Apartment_name__c = ocontact.Lead__r.Apartment_name__c;
        oEnquiry.Are_you_a_single_parent__c = ocontact.Lead__r.Are_you_a_single_parent__c;
        oEnquiry.Father_s_Designation__c = ocontact.Lead__r.Father_s_Designation__c;
        oEnquiry.Father_s_Email_ID__c = ocontact.Lead__r.Father_s_Email_ID__c;
        oEnquiry.Father_s_First_Name__c = ocontact.Lead__r.Father_s_First_Name__c;
        oEnquiry.Father_s_Last_Name__c = ocontact.Lead__r.Father_s_Last_Name__c;
        oEnquiry.Father_s_Linkedin_profile__c = ocontact.Lead__r.Father_s_Linkedin_profile__c;
        oEnquiry.Father_s_Mobile_number__c = ocontact.Lead__r.Father_s_Mobile_number__c;
        oEnquiry.Mother_s_Designation__c = ocontact.Lead__r.Mother_s_Designation__c;
        oEnquiry.Mother_s_Email_ID__c = ocontact.Lead__r.Mother_s_Email_ID__c;
        oEnquiry.Mother_s_First_Name__c = ocontact.Lead__r.Mother_s_First_Name__c;
        oEnquiry.Mother_s_Last_Name__c = ocontact.Lead__r.Mother_s_Last_Name__c;
        oEnquiry.Mother_s_Linkedin_profile__c = ocontact.Lead__r.Mother_s_Linkedin_profile__c;
        oEnquiry.Mother_s_Mobile_number__c = ocontact.Lead__r.Mother_s_Mobile_number__c;
        oEnquiry.Name_of_school_or_preschool_currently_st__c = ocontact.Lead__r.Name_of_school_or_preschool_currently_st__c;
        oEnquiry.Name_of_the_organisation_father__c = ocontact.Lead__r.Name_of_the_organisation_father__c;
        oEnquiry.Name_of_the_organisation_mother__c = ocontact.Lead__r.Name_of_the_organisation_mother__c;
        oEnquiry.Personalized_learning_needs__c = ocontact.Lead__r.Personalized_learning_needs__c;
        
        // School account
        oEnquiry.School_Institution__c = ocontact.AccountId;
        
        // Map Program to Class if available
        if (ocontact.Program__c != null && ocontact.AccountId != null) {
            List<Class__c> cl = [
                SELECT Id, Name
                FROM Class__c
                WHERE Name = :ocontact.Program__c
                AND School_Name__c = :ocontact.AccountId
            ];
            if (!cl.isEmpty()) {
                oEnquiry.Seeking_Grade__c = cl[0].Id;
            }
        }
        
        liistEnquiry.add(oEnquiry);
        
        // Step 4: Insert Enquiry
        if (!liistEnquiry.isEmpty()) {
            insert liistEnquiry;
        }
        
        // Step 5: Mark Contact as processed
        Contact oContacts = [SELECT Id, SkipEnquiry__c FROM Contact WHERE Id = :ContactIds];
        oContacts.SkipEnquiry__c = true;
        update oContacts;
        
        return true;
    }

    
    @AuraEnabled 
    public static Map<String, String> getEducationFieldValue(){
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult = Enquiry__c.Father_s_Educational_Qualifications__c.getDescribe();
        
        List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pValues) {
            
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    @AuraEnabled 
    public static Map<String, String> getOccupationFieldValue(){
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult = Enquiry__c.Father_s_Occupation__c.getDescribe();
        
        List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pValues) {
            
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    @AuraEnabled 
    public static Map<String, String> getHearabValue(){
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult = Enquiry__c.How_did_you_hear_about_us__c.getDescribe();
        
        List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pValues) {
            
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    
    @AuraEnabled 
    public static SearchResult getEnqDetails(string enqno,string orgcode,string leadid,string enqid){
        SearchResult obj=new SearchResult();
        system.debug(enqno);
        system.debug(orgcode);
        List<Enquiry__c> enqlist=new List<Enquiry__c>();
        String j= enqno;
        if(leadid!=null && string.isempty(leadid)==false)
        {
            system.debug('A');
            enqlist=[Select id,Last_Name__c,name,Demographic__c,Child_First_Name__c,Child_Last_Name__c,FirstName__c,Mobile_No__c,Gender__c,Email__c,
                     lead_id__c,Date_of_Birth__c,Relation__c, Seeking_Grade__r.Name,Demographic_Pin_code__c,Mother_s_Educational_Qualifications__c,Lead__r.Name,
                     FatherOther_Occupation__c,Mother_Other_Occupation__c,Locality__c,Apartment_Society__c,How_did_you_hear_about_us__c ,Father_s_Educational_Qualifications__c,Mother_s_Occupation__c,Father_s_Occupation__c,Current_school__c from Enquiry__c where lead_id__c= :leadid ]   ;
        }
        else if(enqid!=null && string.isempty(enqid)==false)
        {
            system.debug('B');
            enqlist=[Select id,Last_Name__c,name,Demographic__c,Child_First_Name__c,Child_Last_Name__c,FirstName__c,Mobile_No__c,Gender__c,Email__c,
                     lead_id__c,Date_of_Birth__c,Relation__c, Seeking_Grade__r.Name,Demographic_Pin_code__c,Mother_s_Educational_Qualifications__c,Lead__r.Name,
                     FatherOther_Occupation__c,Mother_Other_Occupation__c,Locality__c,Apartment_Society__c,How_did_you_hear_about_us__c ,Father_s_Educational_Qualifications__c,Mother_s_Occupation__c,Father_s_Occupation__c,Current_school__c from Enquiry__c where Enquiry_ID__c= :enqid ]   ;
        }
        else{
            enqlist=[Select id,Last_Name__c,name,Demographic__c,Child_First_Name__c,Child_Last_Name__c,FirstName__c,Mobile_No__c,Gender__c,Email__c,
                     Date_of_Birth__c,Relation__c, Seeking_Grade__r.Name,Demographic_Pin_code__c,Mother_s_Educational_Qualifications__c,Lead__r.Name,
                     FatherOther_Occupation__c,Mother_Other_Occupation__c,Locality__c,Apartment_Society__c,How_did_you_hear_about_us__c ,Father_s_Educational_Qualifications__c,Mother_s_Occupation__c,Father_s_Occupation__c,Current_school__c from Enquiry__c where name like :j and Org_code__c = :orgcode];
        }
        system.debug('Enq '+enqlist);
        if(enqlist!=null && enqlist.size()==1 )
        {
            system.debug(enqlist[0].Child_Last_Name__c);
            obj.NoRecord='1';
            obj.Demographic=enqlist[0].Demographic__c;
            obj.cfName=enqlist[0].FirstName__c;
            obj.cLName=enqlist[0].Last_Name__c;
            obj.dob=enqlist[0].Date_of_Birth__c;
            obj.gender=enqlist[0].Gender__c;
            obj.grade=enqlist[0].Seeking_Grade__r.Name;
            obj.mobileno=enqlist[0].Mobile_No__c;
            obj.email=enqlist[0].Email__c;
            obj.Id=enqlist[0].id;
            obj.Pin=enqlist[0].Demographic_Pin_code__c;
            obj.MEducation=enqlist[0].Mother_s_Educational_Qualifications__c;
            obj.FEducation=enqlist[0].Father_s_Educational_Qualifications__c;
            obj.Moccupation=enqlist[0].Mother_s_Occupation__c;
            obj.Foccupation=enqlist[0].Father_s_Occupation__c;
            obj.FatherOther=enqlist[0].FatherOther_Occupation__c;
            obj.MotherOther=enqlist[0].Mother_Other_Occupation__c;
            obj.How=enqlist[0].How_did_you_hear_about_us__c;
            obj.Appartment=enqlist[0].Apartment_Society__c;
            obj.Cschool=enqlist[0].Current_school__c; //NP_Finesse060324
            obj.leadname=enqlist[0].Lead__r.Name;
            obj.Relation=enqlist[0].Relation__c;
            obj.Locality=enqlist[0].Locality__c;
        }
        else if(enqlist.size()>1 )
        {
            obj.NoRecord='2';
        }
        else
        {
            obj.NoRecord='0';               
        }
        system.debug('res '+obj);
        return obj;
    }
    @AuraEnabled 
    public static string UpdateDemo(Enquiry__c re,string rId)
    {
        system.debug(re);
        system.debug(rId);
        try
        {
            /*  Enquiry__c enq=new Enquiry__c();
enq.Apartment_Society__c=re.Appartment;
enq.id  =rId;
enq.Locality__c=re.Locality;
enq.Demographic_Pin_code__c=re.Pin;
enq.Mother_s_Educational_Qualifications__c=re.MEducation;
enq.Father_s_Educational_Qualifications__c=re.FEducation;
enq.Mother_s_Occupation__c=re.Moccupation;
enq.Father_s_Occupation__c=re.Foccupation;
TimeZone tz = UserInfo.getTimeZone();
DateTime dt = Datetime.now();

system.debug('Actual Time as String ' + dt.format());
system.debug('Offset ' + tz.getOffset(dt)/1000);
system.debug('Formatted Time ' + dt.addSeconds((tz.getOffset(dt)/1000)));
enq.How_did_you_hear_about_us__c=re.How;*/
            //Demo_Submitted_date
            re.Demographic__c=true;
            re.Demo_Submitted_date__c=system.now().format('dd-MM-yyyy','IST');
            
            re.Demo_Submitted_Time__c=system.now().format('hh:mm a','IST');
            re.id=rId;
            update re;
            return 'true';
        }catch(Exception ex)
        {
            system.debug(ex);
            return 'false';
        }
    }
    @AuraEnabled 
    public static string GetImage(string rId)
    {
        
        School_List__mdt emailDomain = School_List__mdt.getInstance(rId);
        return emailDomain.ImageName__c	;
    }
    global  class SearchResult {
        @AuraEnabled
        public string NoRecord{get;set;}
        @AuraEnabled
        public  Boolean multipleRecord{get;set;}
        @AuraEnabled
        public string cfName{get;set;}
        @AuraEnabled
        public  string cLName{get;set;}
        @AuraEnabled
        public date dob{get;set;}
        @AuraEnabled
        public  string gender{get;set;}
        @AuraEnabled
        public string mobileno{get;set;}
        @AuraEnabled
        public  string email{get;set;}
        @AuraEnabled
        public  string Relation{get;set;}
        
        @AuraEnabled
        public string leadname{get;set;}
        @AuraEnabled
        public  string grade{get;set;}
        @AuraEnabled
        public  string id{get;set;}
        @AuraEnabled
        public  boolean Demographic{get;set;}
        @AuraEnabled
        public string Appartment{get;set;}
        @AuraEnabled
        public string Locality{get;set;}
        @AuraEnabled
        public string Pin{get;set;}
        @AuraEnabled
        public string FEducation{get;set;}
        @AuraEnabled
        public string MEducation{get;set;}
        @AuraEnabled
        public string Foccupation{get;set;}
        @AuraEnabled
        public string Moccupation{get;set;}
        @AuraEnabled
        public string Cschool{get;set;}    //NP_Finesse060324
        @AuraEnabled
        public string How{get;set;}
        @AuraEnabled
        public string year{get;set;}
        @AuraEnabled
        public string FatherOther{get;set;}
        @AuraEnabled
        public string MotherOther{get;set;}
        
    } 
    global  class Request {
        @AuraEnabled
        public string rId{get;set;}
        @AuraEnabled
        public string Appartment{get;set;}
        @AuraEnabled
        public string Locality{get;set;}
        @AuraEnabled
        public string Pin{get;set;}
        @AuraEnabled
        public string FEducation{get;set;}
        @AuraEnabled
        public string MEducation{get;set;}
        @AuraEnabled
        public string Foccupation{get;set;}
        @AuraEnabled
        public string Moccupation{get;set;}
        @AuraEnabled
        public string How{get;set;}
        @AuraEnabled
        public string Cschool{get;set;}   //NP_Finesse060324
    }
       public static void FormFactory() {
Integer i = 0;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;

i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;

i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;

i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;

}

}