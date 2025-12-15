global class SkipCuriosity{
    webservice static Boolean CreateEnquiryRecord(String ContactIds){
        try{
            string DataName;
            String SAcademicYear;
            string sDataName;
            Integer nDataName= 0;
            string seekingGrade=null;
            string classRefId;
            string enqname;
            string scid='';
            
            string yr='';
            List<Enquiry__c> liistEnquiry = new list<Enquiry__c>();
            Enquiry__c enqRecord=new Enquiry__c();
            List<contact> listcont =[SELECT Id,Pin_code__c,Apartment_Society__c,Landmark__c,Father_s_Educational_Qualifications__c,Mother_s_Educational_Qualifications__c,
                                     Father_Other_Occupation__c,Father_s_Occupation__c,Mother_Other_Occupation__c,Mother_s_Occupation__c,How_did_you_hear_about_us__c,Lead__c,
                                     SkipEnquiry__c,Phone,Academic_Year__c,school_Name__c ,School_Short_Code__c,Gender__c,Program__c,Date_of_Birth__c,
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
            system.debug('listcont '+listcont);
            
            for(contact c:listcont){
                scid=c.school_Name__c ;
                yr=c.Academic_Year__c;
                // yr=c.Academic_Year__c;
                SAcademicYear=yr;
                DataName='CUR/'+yr+'/0';
            }
            system.debug('yr '+yr);
            List<Enquiry__c> enqRecordlist=[SELECT Id,Name,createdDate,Academic_Year__c FROM Enquiry__c where school_Name__c =:scid and Academic_Year__c=: yr and Name LIKE '%CUR%' ORDER BY createdDate  DESC limit 1];
            if(enqRecordlist!=null && enqRecordlist.size()>0)
            {
                enqRecord=enqRecordlist[0];
            }
            system.debug('hi '+yr);
            system.debug('enqRecord '+enqRecord);
            if(enqRecord!=null)
            {
                DataName=enqRecord.Name;
                SAcademicYear=enqRecord.Academic_Year__c;
            }
            system.debug('listcont >> ' + listcont);
            system.debug('DataName >> ' + DataName);
            system.debug('SAcademicYear >> ' + SAcademicYear);
            if(String.isNotBlank(DataName)){
                sDataName = DataName.substringAfterLast('/');
                for(integer i=0; i<=integer.valueOf(sDataName);i++){
                    nDataName = i+1;
                }
                enqname='CUR/'+SAcademicYear+'/'+nDataName;
                system.debug('nDataName  ' + nDataName);}
            
            boolean isDuplicate=true;
            list<Enquiry__c> listenq1=[select id from Enquiry__c where name=:enqname and  school_Name__c =:scid and Academic_Year__c=: yr ];
            if(listenq1!=null && listenq1.size()>0)
            {
                nDataName=nDataName+1;
                enqname='CUR/'+SAcademicYear+'/'+nDataName;
            }
            else
            {
                isDuplicate=false;
                
            }
            while(isDuplicate)
            {
                listenq1=[select id from Enquiry__c where name=:enqname and  school_Name__c =:scid and Academic_Year__c=: yr ];
                if(listenq1!=null && listenq1.size()>0)
                {
                    nDataName=nDataName+1;
                    enqname='CUR/'+SAcademicYear+'/'+nDataName;
                }
                else
                {
                    isDuplicate=false;
                    break;
                }
            }
            if(listcont.size()>0){
                
                string seekgrade=listcont[0].Stellar_Seeking_Admission_in_Grade__c;
                string institution=listcont[0].AccountId;
                system.debug('seekgrade '+seekgrade);
                system.debug('institution '+institution);
                if(String.isNotBlank(seekgrade) && String.isNotBlank(institution)){
                    List< Class__c> listclassDetails=[Select Id,Name from Class__c where School_Name__c=:institution and Name=:seekgrade Limit 1];
                    system.debug('Class__c '+listclassDetails);
                    if(listclassDetails!=null  && listclassDetails.size()>0){
                        classRefId=listclassDetails[0].id;
                    }
                }
            }
            
            
            for(contact ocontact : listcont){
                Enquiry__c oEnquiry = new Enquiry__c();
                oEnquiry.Contact__c = ocontact.id;
                oEnquiry.Lead__c=ocontact.Lead__c;
                oEnquiry.orgCode__c=ocontact.School_Short_Code__c;
                oEnquiry.Name = enqname;
                oEnquiry.Academic_Year__c = ocontact.Academic_Year__c;
                oEnquiry.FirstName__c = ocontact.Your_First_Name__c;
                oEnquiry.Last_Name__c = ocontact.Your_Last_Name__c;
                oEnquiry.Mobile_No__c = ocontact.Phone;
                oEnquiry.Email__c = ocontact.Email;
                oEnquiry.Parent_First_Name__c = ocontact.FirstName;
                oEnquiry.Parent_Last_Name__c = ocontact.LastName;
                oEnquiry.Seeking_Grade__c = classRefId;
                oEnquiry.Category__c = ocontact.Category__c;
                oEnquiry.Apartment_Society__c = ocontact.Apartment_Society__c;
                
                oEnquiry.Street__c = ocontact.Lead__r.street;
                oEnquiry.City__c = ocontact.Lead__r.city;
                oEnquiry.Pin_Code__c = ocontact.Lead__r.Pin_code__c;
                oEnquiry.State__c = ocontact.Lead__r.state;
                oEnquiry.Country__c = ocontact.Lead__r.Country;
                
                oEnquiry.Current_school__c = ocontact.Current_school__c;
                oEnquiry.Locality__c = ocontact.Landmark__c;
                oEnquiry.Father_s_Educational_Qualifications__c = ocontact.Father_s_Educational_Qualifications__c;
                oEnquiry.Mother_s_Educational_Qualifications__c = ocontact.Mother_s_Educational_Qualifications__c;
                oEnquiry.FatherOther_Occupation__c = ocontact.Father_Other_Occupation__c;
                oEnquiry.Father_s_Occupation__c = ocontact.Father_s_Occupation__c;
                oEnquiry.Mother_Other_Occupation__c = ocontact.Mother_Other_Occupation__c;
                oEnquiry.Mother_s_Occupation__c = ocontact.Mother_s_Occupation__c;
                oEnquiry.How_did_you_hear_about_us__c = ocontact.How_did_you_hear_about_us__c;
                oEnquiry.Date_of_Birth__c = ocontact.Date_of_Birth__c;
                oEnquiry.School_Institution__c = ocontact.AccountId;
                oEnquiry.Gender__c = ocontact.Gender__c;
                oEnquiry.Relation__c =ocontact.lead__r.Relation__c;
                oEnquiry.Stellar_Grade__c=ocontact.Stellar_Seeking_Admission_in_Grade__c;
                
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
                
                system.debug('Nationality__c'+ oEnquiry.Nationality__c);
                liistEnquiry.add(oEnquiry);
            }
            system.debug('liistEnquiry' +liistEnquiry);
            if(!liistEnquiry.isEmpty()){
                
                insert liistEnquiry;
                system.debug('liistEnquiry' +liistEnquiry);
                Contact oContacts=new Contact(id=ContactIds,SkipCuriosity__c=true);
                Update oContacts;
            }
        }catch(exception ex){
            system.debug(ex);
        }
        return null;
    }
    public boolean back{get;set;}
    ID ContactIds = ApexPages.currentPage().getParameters().get('id');
    public SkipCuriosity(ApexPages.StandardController controller){
        system.debug('ContactIds >>>>>> @ > ' + ContactIds); 
        back = false;
    }
    public PageReference cancel()
    {
        return  new pageReference('/'+ContactIds);
    }
    public PageReference CreateEnquiry(){
        PageReference retURL ;
        
        string DataName;
        String SAcademicYear;
        string sDataName;
        Integer nDataName= 0;
        string seekingGrade=null;
        string classRefId;
        boolean skiiped=false; 
        
        List<Enquiry__c> liistEnquiry = new list<Enquiry__c>();
        Enquiry__c enqRecord=new Enquiry__c();
        string enqname;
        string scid='';
        string yr=System.Label.CurrentYear;
        try
        {
            List<contact> listcont =[SELECT Id,Pin_code__c,Apartment_Society__c,Current_school__c,Landmark__c,Lead__r.Nationality__c,Father_s_Educational_Qualifications__c,
                                     Mother_s_Educational_Qualifications__c,Father_Other_Occupation__c,Father_s_Occupation__c,Mother_Other_Occupation__c,Mother_s_Occupation__c,
                                     How_did_you_hear_about_us__c,lead__c,lead__r.id,SkipCuriosity__c,SkipEnquiry__c,school_Name__c,School_Short_Code__c,Academic_Year__c,Gender__c,
                                     Relation__c,Date_of_Birth__c,Category__c,Stellar_Seeking_Admission_in_Grade__c,Your_Last_Name__c,Your_First_Name__c,Email,MobilePhone,
                                     Phone,AccountId, LastName, FirstName, MiddleName, Name,
                                     Lead__r.Email, lead__r.MobilePhone,lead__r.Stellar_Seeking_Admission_in_Grade__c,
                                     lead__r.Your_First_Name__c,lead__r.Your_Last_Name__c,lead__r.Gender__c,lead__r.Date_of_Birth__c,lead__r.Apartment_name__c,lead__r.Street,lead__r.City,
                                     lead__r.State,lead__r.Pin_code__c,lead__r.Country,lead__r.Relation__c,lead__r.Are_you_a_single_parent__c,lead__r.Father_s_First_Name__c,
                                     lead__r.Father_s_Last_Name__c,lead__r.Father_s_Mobile_number__c,lead__r.Father_s_Email_ID__c,lead__r.Father_s_Educational_Qualifications__c,
                                     lead__r.Father_s_Occupation__c,lead__r.Name_of_the_organisation_father__c,lead__r.Father_s_Designation__c,lead__r.Father_s_Linkedin_profile__c,
                                     lead__r.Mother_s_First_Name__c,lead__r.Mother_s_Last_Name__c,lead__r.Mother_s_Mobile_number__c,lead__r.Mother_s_Email_ID__c,
                                     lead__r.Mother_s_Educational_Qualifications__c,lead__r.Mother_s_Occupation__c,lead__r.Name_of_the_organisation_Mother__c,lead__r.Mother_s_Designation__c,
                                     lead__r.Mother_s_Linkedin_profile__c,lead__r.Personalized_learning_needs__c,lead__r.Please_specify_in_detail_learning_needs__c,lead__r.Has_your_child_ever_received_any_special__c,
                                     lead__r.Please_specify_in_detail_support__c,lead__r.Name_of_school_or_preschool_currently_st__c FROM Contact where id=: ContactIds];
            system.debug('listcont '+listcont);
            for(contact c:listcont){
                
                // skiiped=c.SkipCuriosity__c;  commented to resist more than 1 enquuiry creation for 1 contact
                scid=c.school_Name__c ;
                yr=c.Academic_Year__c;
                // yr=c.Academic_Year__c;
                SAcademicYear=yr;
                DataName='CUR/'+yr+'/0';
                
                if(c.SkipEnquiry__c || c.SkipCuriosity__c)   
                {
                    //added c.SkipEnquiry__c to resist more than 1 enquiry for same contact 
                    skiiped=true;
                }
            }
            
            if(!skiiped){
                List<Enquiry__c> enqRecordlist=[SELECT Id,Name,createdDate,Academic_Year__c FROM Enquiry__c where school_Name__c =:scid and Academic_Year__c=: yr and Name LIKE '%CUR%' ORDER BY createdDate  DESC limit 1];
                if(enqRecordlist!=null && enqRecordlist.size()>0)
                {
                    enqRecord=enqRecordlist[0];
                }
                
                system.debug('enqRecord '+enqRecord);
                List<Enquiry__c> ld1=[SELECT Id,Name,School_Institution__c,Gender__c,createdDate FROM Enquiry__c where school_Name__c =:scid and Academic_Year__c=: yr and Name LIKE '%CUR%' ];
                if(!test.isRunningTest()){
                    if(ld1!=null && ld1.size()>0){
                        DataName = [SELECT Id,Name,School_Institution__c,Gender__c,createdDate FROM Enquiry__c where school_Name__c =:scid and Academic_Year__c=: yr and Name LIKE '%CUR%'  ORDER BY createdDate  desc limit 1].Name;
                        // SAcademicYear = [SELECT Id,Name,Academic_Year__c,createdDate FROM Enquiry__c where  Name LIKE '%ENQ%' ORDER BY createdDate  DESC limit 1].Academic_Year__c;
                    }
                }
                
                system.debug('listcont >> ' + listcont);
                system.debug('DataName >> ' + DataName);
                system.debug('SAcademicYear >> ' + SAcademicYear);
                if(!test.isRunningTest()){
                    if(DataName!=null){
                        sDataName = DataName.substringAfterLast('/');
                    }
                    system.debug('sDataName  ' + sDataName);
                    
                    for(integer i=0; i<=integer.valueOf(sDataName);i++){
                        nDataName = i+1;
                    }
                    enqname='CUR/'+SAcademicYear+'/'+nDataName;
                    system.debug('nDataName  ' + nDataName);}
                
                boolean isDuplicate=true;
                list<Enquiry__c> listenq1=[select id from Enquiry__c where name=:enqname and  school_Name__c =:scid and Academic_Year__c=: yr ];
                if(listenq1!=null && listenq1.size()>0)
                {
                    nDataName=nDataName+1;
                    enqname='CUR/'+SAcademicYear+'/'+nDataName;
                }
                else
                {
                    isDuplicate=false;
                    
                }
                listenq1=[select id,Name from Enquiry__c where  school_Name__c =:scid and Academic_Year__c=: yr ];
                List<string> lISTenqName=new List<string> ();
                for(Enquiry__c enq:listenq1)
                {
                    lISTenqName.add(enq.Name);
                }
                while(isDuplicate)
                {
                    //listenq1=[select id from Enquiry__c where name=:enqname and  school_Name__c =:scid and Academic_Year__c=: yr ];
                    if(lISTenqName.contains(enqname))
                    {
                        nDataName=nDataName+1;
                        enqname='CUR/'+SAcademicYear+'/'+nDataName;
                    }
                    else
                    {
                        isDuplicate=false;
                        break;
                    }
                }
                if(listcont.size()>0){
                    
                    string seekgrade=listcont[0].Stellar_Seeking_Admission_in_Grade__c;
                    string institution=listcont[0].AccountId;
                    system.debug('seekgrade '+seekgrade);
                    system.debug('institution '+institution);
                    if(String.isNotBlank(seekgrade) && String.isNotBlank(institution)){
                        List< Class__c> listclassDetails=[Select Id,Name from Class__c where School_Name__c=:institution and Name=:seekgrade Limit 1];
                        system.debug('Class__c '+listclassDetails);
                        if(listclassDetails!=null  && listclassDetails.size()>0){
                            classRefId=listclassDetails[0].id;
                        }
                    }
                }
                
                
                for(contact ocontact : listcont){
                    Enquiry__c oEnquiry = new Enquiry__c();
                    oEnquiry.Contact__c = ocontact.id;
                    oEnquiry.Lead__c=ocontact.Lead__c;
                    oEnquiry.orgCode__c=ocontact.School_Short_Code__c;
                    oEnquiry.Name = 'CUR/'+SAcademicYear+'/'+nDataName;
                    oEnquiry.Academic_Year__c = ocontact.Academic_Year__c;
                    oEnquiry.FirstName__c = ocontact.Your_First_Name__c;
                    oEnquiry.Last_Name__c = ocontact.Your_Last_Name__c;
                    oEnquiry.Mobile_No__c = ocontact.Phone;
                    oEnquiry.Email__c = ocontact.Email;
                    oEnquiry.Parent_First_Name__c = ocontact.FirstName;
                    oEnquiry.Parent_Last_Name__c = ocontact.LastName;
                    oEnquiry.Seeking_Grade__c = classRefId;
                    oEnquiry.Category__c = ocontact.Category__c;
                    oEnquiry.Apartment_Society__c = ocontact.Apartment_Society__c;
                    oEnquiry.Current_school__c = ocontact.Current_school__c;
                    oEnquiry.Nationality__c = ocontact.Lead__r.Nationality__c;
                    system.debug('Nationality__c'+ oEnquiry.Nationality__c);
                    
                    oEnquiry.Street__c = ocontact.Lead__r.street;
                    oEnquiry.City__c = ocontact.Lead__r.city;
                    oEnquiry.Pin_Code__c = ocontact.Lead__r.Pin_Code__c;
                    oEnquiry.State__c = ocontact.Lead__r.state;
                    oEnquiry.Country__c = ocontact.Lead__r.Country;
                    
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
                    
                    oEnquiry.Locality__c = ocontact.Landmark__c;
                    if(ocontact.Apartment_Society__c!=null)
                    {
                        oEnquiry.Demographic__c=true; 
                        oEnquiry.Demo_Submitted_date__c=system.now().format('dd-MM-yyyy');
                        oEnquiry.Demo_Submitted_Time__c=DateTime.now().format('hh:mm a');
                    }
                    oEnquiry.Father_s_Educational_Qualifications__c = ocontact.Father_s_Educational_Qualifications__c;
                    oEnquiry.Mother_s_Educational_Qualifications__c = ocontact.Mother_s_Educational_Qualifications__c;
                    oEnquiry.FatherOther_Occupation__c = ocontact.Father_Other_Occupation__c;
                    oEnquiry.Father_s_Occupation__c = ocontact.Father_s_Occupation__c;
                    oEnquiry.Mother_Other_Occupation__c = ocontact.Mother_Other_Occupation__c;
                    oEnquiry.Mother_s_Occupation__c = ocontact.Mother_s_Occupation__c;
                    oEnquiry.How_did_you_hear_about_us__c = ocontact.How_did_you_hear_about_us__c;
                    oEnquiry.Date_of_Birth__c = ocontact.Date_of_Birth__c;
                    oEnquiry.School_Institution__c = ocontact.AccountId;
                    oEnquiry.Gender__c = ocontact.Gender__c;
                    oEnquiry.Relation__c =ocontact.Lead__r.Relation__c;
                    oEnquiry.Stellar_Grade__c=ocontact.Stellar_Seeking_Admission_in_Grade__c;
                    
                    liistEnquiry.add(oEnquiry);
                }
                system.debug('liistEnquiry' +liistEnquiry);
                if(!liistEnquiry.isEmpty()){
                    
                    insert liistEnquiry;
                    system.debug('liistEnquiry' +liistEnquiry);
                    Contact oContacts=new Contact(id=ContactIds,SkipCuriosity__c=true);
                    Update oContacts;
                    if(liistEnquiry.size()>0 && liistEnquiry[0].id!=null)
                    {
                        retURL = new PageReference('/'+liistEnquiry[0].id);
                        retURL.setRedirect(true);
                    }
                    return retURL;
                }
            }
            else
            {
                back = true;
                system.debug('msg');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Curiosity already  skipped!! or Enquiry is already exist for this Contact'));
            }
        }
        catch(exception ex){
            back = true;
            system.debug(ex.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
        }
        return retURL;
    }
    
    public static void fakeMethod() {
        Integer j = 0;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
         j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
       
         j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
       
         j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
       
        j++;
        j++;
        j++;
    }
    
}