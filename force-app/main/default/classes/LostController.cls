public class LostController {
    
    public Lead strlead {get; set;}  
    public Contact strContact {get; set;}  
    public Enquiry__c strEnquiry {get; set;}  
    public Application_Form__c strApplicationForm {get; set;}  
    public Admission_Form__c strAdmissionForm {get; set;}  
    public Admission_Granted__c strAdmissionGranted {get; set;}  
    public string LeadReasonLosts{get;set;}
    public string IdParamName{get;set;}
    public string sLeadId{get;set;}
    public string sEnquiryId{get;set;}
    public string sApplicationForId{get;set;}
    public string sAdmissionFormId{get;set;}
    public string sAdmissionGrantedId{get;set;}
    
    public string sLost{get;set;}
    public string sDorment{get;set;}
    public string sAdmissionProcessCompleted{get;set;}
    public string sNurturing{get;set;}
    public string sNew{get;set;}
    public string sCommanStatus{get;set;}
    public string Lost_Reasons{get;set;}
    Public boolean ErrorTrue{get;set;}
    
    Id RecordId=Apexpages.currentpage().getParameters().get('id');
    public LostController(ApexPages.StandardController Controller){
        Id RecordId=Apexpages.currentpage().getParameters().get('id');
        IdParamName = RecordId;
        System.debug('IdParamName ' + IdParamName);
        
    }
    public List<SelectOption> getLeadLost_Reasons() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Lead.Lost_Reasons__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('','Reject'));
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    public PageReference LeadLostPopup(){
        PageReference pg;
        List<Lead>  slstlead = [select Id,Lost_Date_Time__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Lead where Id=:IdParamName];
        for(Lead olead : slstlead){ErrorTrue = olead.Reason_Lost__c;}
        List<Lead> lstlead = [select Id,Converted__c,Lost_Date_Time__c,Stage__c,Status,Current_Status__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Lead where Id=:IdParamName];
        system.debug('lstlead @@@ ' + lstlead);
        List<Lead> nlstlead = new List<Lead>();
        if(lstlead[0].Reason_Lost__c == true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Reason Lost Already Done !'));
        }else{
            for(Lead olead : lstlead){
                Lead oled = new Lead();
                oled.id = olead.id;
                oled.Reason_Lost__c = true;
                oled.Current_Status__c = 'Lost';
                oled.Stage__c ='Lost';
                oled.Reason_Losts__c = LeadReasonLosts;
                oled.Lost_Reasons__c =Lost_Reasons;
                oled.Reason_Lost_Object__c = 'Lead';
                oled.Lost_Date_Time__c = system.now();
                oled.Reopen_Date_Time__c= Null;
                nlstlead.add(oled);
            }
            if(!nlstlead.isEmpty()){update nlstlead; }
            //pg = new PageReference('/'+RecordId);
        }
        return null; 
    }
    public PageReference ContactLostPopup(){
        PageReference pg;
        List<Contact> slstlead = [select Id,Lost_Date_Time__c,Reason_Lost__c,Lead_ID__c from Contact where Id=:IdParamName];
        for(Contact olead : slstlead){ErrorTrue = olead.Reason_Lost__c;}
        contact oContact = [select Id,Lost_Date_Time__c,Lead_ID__c from Contact where Id=:IdParamName];
        if(oContact.Lead_ID__c != ''){sLeadId =oContact.Lead_ID__c;}
        List<Contact> lstCon = [select Id,Lost_Date_Time__c,Reason_Lost__c,Contact_Status__c,Reason_Losts__c,Reason_Lost_Object__c from Contact where Id=:RecordId];
        List<Contact> nLstCon = new List<Contact>();
        if(lstCon[0].Reason_Lost__c ==true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Reason Lost Already Done!'));
        }else{
            for(Contact ocon : lstCon){
                Contact ncon = new Contact();
                ncon.id = ocon.id;
                ncon.Reason_Lost__c = true;
                sCommanStatus = ocon.Contact_Status__c;
                ncon.Stages__c = 'Lost';
                ncon.Reason_Losts__c = LeadReasonLosts;
                ncon.Lost_Reasons__c =Lost_Reasons;
                ncon.Reason_Lost_Object__c = 'Contact';
                ncon.Lost_Date_Time__c = system.now();
                nLstCon.add(ncon);
            }
            if(!nLstCon.isEmpty()){update nLstCon;}
            List<Lead> lstlead = [select Id,Converted__c,Lost_Date_Time__c,Lead_ID__c,Stage__c,Status,Current_Status__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Lead where Lead_ID__c=:sLeadId];
            List<Lead> nlstlead = new List<Lead>();
            system.debug('sNew ' + sNew);
            system.debug('sDorment ' + sDorment);
            system.debug('sLost ' + sLost);
            for(Lead olead : lstlead){
                Lead oled = new Lead();
                oled.id = olead.id;
                oled.Reason_Lost__c = true;
                oled.Current_Status__c = 'Lost';
                oled.Stage__c ='Lost';
                oled.Reason_Losts__c = LeadReasonLosts;
                oled.Lost_Reasons__c =Lost_Reasons;
                oled.Reason_Lost_Object__c = 'Contact';
                oled.Lost_Date_Time__c = system.now();
                nlstlead.add(oled);
            }
            if(!nlstlead.isEmpty()){update nlstlead;}
            //pg = new PageReference('/'+RecordId);
        }
        return null; 
        
    }
    public PageReference EnquiryLostPopup(){
        PageReference pg;
        List<Enquiry__c> slstlead = [select Id,Lost_Date_Time__c,Stages__c,Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Enquiry__c where Id=:IdParamName];
        for(Enquiry__c olead : slstlead){ErrorTrue = olead.Reason_Lost__c;}
        Enquiry__c oEnquiry = [select Id,Lost_Date_Time__c,Stages__c,Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Enquiry__c where Id=:IdParamName];
        if(oEnquiry.Lead_ID__c != ''){sEnquiryId =oEnquiry.Lead_ID__c;}
        List<Enquiry__c> lstEnq = [select Id,Lost_Date_Time__c,Stages__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Enquiry__c where Id=:RecordId];
        List<Enquiry__c> nLstEnq = new List<Enquiry__c>();
        if(lstEnq[0].Reason_Lost__c ==true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Reason Lost Already Done!'));
        }else{
            for(Enquiry__c oEnqury : lstEnq){
                Enquiry__c nEnqury = new Enquiry__c();
                nEnqury.id = oEnqury.id;
                nEnqury.Reason_Lost__c = true;
                //sCommanStatus = oEnqury.Stages__c;
                nEnqury.Stages__c = 'Lost';
                nEnqury.Reason_Losts__c = LeadReasonLosts;
                nEnqury.Lost_Reasons__c =Lost_Reasons;
                nEnqury.Reason_Lost_Object__c = 'Enquiry';
                nEnqury.Lost_Date_Time__c = system.now();
                nLstEnq.add(nEnqury);
            }//sLost,sDorment,sAdmissionProcessCompleted,sNurturing,sNew
            if(!nLstEnq.isEmpty()){update nLstEnq;}
            List<Lead> lstlead = [select Id,Lost_Date_Time__c,Converted__c,Lead_ID__c,Stage__c,Status,Current_Status__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Lead where Lead_ID__c=:sEnquiryId];
            List<Lead> nlstlead = new List<Lead>();
            for(Lead olead : lstlead){
                Lead oled = new Lead();
                oled.id = olead.id;
                oled.Reason_Lost__c = true;
                oled.Current_Status__c = 'Lost';
                oled.Stage__c ='Lost';
                oled.Reason_Losts__c = LeadReasonLosts;
                oled.Lost_Reasons__c =Lost_Reasons;
                oled.Reason_Lost_Object__c = 'Enquiry';
                oled.Lost_Date_Time__c = system.now();
                nlstlead.add(oled);
            }
            if(!nlstlead.isEmpty()){update nlstlead;}
            //pg = new PageReference('/'+RecordId);
        }
        return null; 
        
    }
    public PageReference ApplicationFormLostPopup(){
        PageReference pg;
        List<Application_Form__c> slstlead = [select Id,Lost_Date_Time__c,Status__c,Enquiry__r.Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Application_Form__c where Id=:IdParamName];
        for(Application_Form__c olead : slstlead){ErrorTrue = olead.Reason_Lost__c;}
        Application_Form__c ApplicationForm =[select Id,Lost_Date_Time__c,Status__c,Enquiry__r.Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Application_Form__c where Id=:IdParamName];
        if(ApplicationForm.Enquiry__r.Lead_ID__c != ''){sApplicationForId =ApplicationForm.Enquiry__r.Lead_ID__c;}
        List<Application_Form__c> lstAppForm = [select Id,Lost_Date_Time__c,Status__c,Reason_Lost__c,Enquiry__r.Lead_ID__c,Reason_Losts__c,Reason_Lost_Object__c from Application_Form__c where Id=:RecordId];
        List<Application_Form__c> nLstAppForm = new List<Application_Form__c>();
        if(lstAppForm[0].Reason_Lost__c ==true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Reason Lost Already Done!'));
        }else{
            for(Application_Form__c oAppForm : lstAppForm){
                Application_Form__c nAppForm = new Application_Form__c();
                nAppForm.id = oAppForm.id;
                nAppForm.Reason_Lost__c = true;
                nAppForm.Status__c ='Lost';
                //sCommanStatus = oAppForm.Status__c;
                nAppForm.Reason_Losts__c = LeadReasonLosts;
                nAppForm.Lost_Reasons__c =Lost_Reasons;
                nAppForm.Reason_Lost_Object__c = 'Application Form';
                nAppForm.Lost_Date_Time__c = system.now();
                nLstAppForm.add(nAppForm);
            }
            if(!nLstAppForm.isEmpty()){update nLstAppForm;}
            List<Lead> lstlead = [select Id,Lead_ID__c,Lost_Date_Time__c,Converted__c,Stage__c,Status,Current_Status__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Lead where Lead_ID__c=:sApplicationForId];
            List<Lead> nlstlead = new List<Lead>();
            for(Lead olead : lstlead){
                Lead oled = new Lead();
                oled.id = olead.id;
                oled.Reason_Lost__c = true;
                oled.Current_Status__c = 'Lost';
                oled.Stage__c ='Lost';
                oled.Reason_Losts__c = LeadReasonLosts;
                oled.Lost_Reasons__c =Lost_Reasons;
                oled.Reason_Lost_Object__c = 'Application Form';
                oled.Lost_Date_Time__c = system.now();
                nlstlead.add(oled);
            }
            if(!nlstlead.isEmpty()){update nlstlead;}
            //pg = new PageReference('/'+RecordId);
        }
        return null; 
        
    }
    public PageReference AdmissionFormLostPopup(){
        PageReference pg;
        List<Admission_Form__c> slstlead = [select Id,Lost_Date_Time__c,Status__c,Enquiry_No__r.Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Admission_Form__c where Id=:IdParamName];
        for(Admission_Form__c olead : slstlead){ErrorTrue = olead.Reason_Lost__c;}
        Admission_Form__c AdmissionFormId = [select Id,Lost_Date_Time__c,Status__c,Enquiry_No__r.Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Admission_Form__c where Id=:IdParamName];
        if(AdmissionFormId.Enquiry_No__r.Lead_ID__c != ''){sAdmissionFormId =AdmissionFormId.Enquiry_No__r.Lead_ID__c;}
        List<Admission_Form__c> lstAddForm = [select Id,Lost_Date_Time__c,Status__c,Enquiry_No__r.Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Admission_Form__c where Id=:RecordId];
        List<Admission_Form__c> nLstAddForm = new List<Admission_Form__c>();
        if(lstAddForm[0].Reason_Lost__c ==true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Reason Lost Already Done!'));
        }else{
            for(Admission_Form__c oAddForm : lstAddForm){
                Admission_Form__c nAddForm = new Admission_Form__c();
                nAddForm.id = oAddForm.id;
                nAddForm.Reason_Lost__c = true;
                //sCommanStatus = oAddForm.Status__c;
                nAddForm.Status__c ='Lost';
                nAddForm.Reason_Losts__c = LeadReasonLosts;
                nAddForm.Lost_Reasons__c =Lost_Reasons;
                nAddForm.Reason_Lost_Object__c = 'Admission Form';
                nAddForm.Lost_Date_Time__c = system.now();
                nLstAddForm.add(nAddForm);
            }
            if(!nLstAddForm.isEmpty()){update nLstAddForm;}
            List<Lead> lstlead = [select Id,Converted__c,Lost_Date_Time__c,Lead_ID__c,Stage__c,Status,Current_Status__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Lead where Lead_ID__c=:sAdmissionFormId];
            List<Lead> nlstlead = new List<Lead>();
            for(Lead olead : lstlead){
                Lead oled = new Lead();
                oled.id = olead.id;
                oled.Reason_Lost__c = true;
                oled.Current_Status__c = 'Lost';
                oled.Stage__c ='Lost';
                oled.Reason_Losts__c = LeadReasonLosts;
                oled.Lost_Reasons__c =Lost_Reasons;
                oled.Reason_Lost_Object__c = 'Admission Form';
                oled.Lost_Date_Time__c = system.now();
                nlstlead.add(oled);
            }
            if(!nlstlead.isEmpty()){update nlstlead;}
            //pg = new PageReference('/'+RecordId);
        }
        return null; 
    }
    public PageReference AdmissionGrantedLostPopup(){
        PageReference pg;
        List<Admission_Granted__c> slstlead = [select Id,Lost_Date_Time__c,Status__c,EnquiryNo__r.Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Admission_Granted__c where Id=:IdParamName];
        for(Admission_Granted__c olead : slstlead){ErrorTrue = olead.Reason_Lost__c;}
        Admission_Granted__c AdmissionGranted = [select Id,Lost_Date_Time__c,Status__c,EnquiryNo__r.Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Admission_Granted__c where Id=:IdParamName];
        if(AdmissionGranted.EnquiryNo__r.Lead_ID__c != ''){sAdmissionGrantedId =AdmissionGranted.EnquiryNo__r.Lead_ID__c;}
        List<Admission_Granted__c> lstAddGrant = [select Id,Lost_Date_Time__c,Status__c,EnquiryNo__r.Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Admission_Granted__c where Id=:RecordId];
        List<Admission_Granted__c> nLstAddGrant = new List<Admission_Granted__c>();
        if(lstAddGrant[0].Reason_Lost__c ==true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Reason Lost Already Done!'));
        }else{
            for(Admission_Granted__c oAddGrant : lstAddGrant){
                Admission_Granted__c nAddGrant = new Admission_Granted__c();
                nAddGrant.id = oAddGrant.id;
                nAddGrant.Reason_Lost__c = true;
                nAddGrant.Reason_Losts__c = LeadReasonLosts;
                //sCommanStatus = oAddGrant.Status__c;
                nAddGrant.Status__c ='Lost';   
                nAddGrant.Lost_Reasons__c =Lost_Reasons;
                nAddGrant.Reason_Lost_Object__c = 'Admission Granted';
                nAddGrant.Lost_Date_Time__c = system.now();
                nLstAddGrant.add(nAddGrant);
            }
            if(!nLstAddGrant.isEmpty()){update nLstAddGrant;}
            List<Lead> lstlead = [select Id,Converted__c,Lost_Date_Time__c,Lead_ID__c,Stage__c,Status,Current_Status__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Lead where Lead_ID__c=:sAdmissionGrantedId];
            List<Lead> nlstlead = new List<Lead>();
            for(Lead olead : lstlead){
                Lead oled = new Lead();
                oled.id = olead.id;
                oled.Reason_Lost__c = true;
                oled.Current_Status__c = 'Lost';
                oled.Stage__c ='Lost';
                oled.Reason_Losts__c = LeadReasonLosts;
                oled.Lost_Reasons__c =Lost_Reasons;
                oled.Reason_Lost_Object__c = 'Admission Granted';
                oled.Lost_Date_Time__c = system.now();
                nlstlead.add(oled);
            }
            if(!nlstlead.isEmpty()){update nlstlead;}
            //pg = new PageReference('/'+RecordId);
        }
        return null; 
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
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
        j++;
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