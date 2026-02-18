public class skipEnquiry_LWC {
    
    @AuraEnabled(cacheable=true)
    public static List<Enquiry__c> createcontact(String ContactId){
        
        system.debug('ContactIds  >> ' + ContactId);
        string DataName;
        String SAcademicYear;
        string sDataName='ENQ/2023-2024/16';
        Integer nDataName= 0;
        boolean skiiped=false; 
        string enqname;
        string scid='';
        string yr=System.Label.CurrentYear;
        List<Enquiry__c> liistEnquiry = new list<Enquiry__c>();
        
         List<contact> listcont =[SELECT Id,Lead__c,
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
                                 lead__r.Please_specify_in_detail_support__c,lead__r.Name_of_school_or_preschool_currently_st__c FROM Contact where id=: ContactId];
        for(contact c:listcont){
            scid=c.school_Name__c ;
            yr=c.Academic_Year__c;
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
            if(!test.isRunningTest()){
                if(DataName!=null){
                    sDataName = DataName.substringAfterLast('/');
                }
                system.debug('sDataName  ' + sDataName);
                
                for(integer i=0; i<=integer.valueOf(sDataName);i++){
                    nDataName = i+1;
                }
                enqname='ENQ/'+SAcademicYear+'/'+nDataName;
                system.debug('nDataName  ' + nDataName);}
            
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
                    
                    List <Class__c> cl=[ Select id ,name from Class__c where name =:ocontact.Program__c and School_Name__c=:ocontact.AccountId ];
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
           /* Contact ConId = [select id,SkipCuriosity__c,SkipEnquiry__c from Contact where ID =:ContactId];
            ConId.SkipEnquiry__c = true;
            Update ConId;*/       
    
} return liistEnquiry;
        
}
}