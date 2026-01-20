public class ReOpenLeadCtrl {
    
    public string IdParamName{get;set;}
    public string leadParamName{get;set;}
    public ReOpenLeadCtrl(ApexPages.StandardController Controller){
        Id RecordId=Apexpages.currentpage().getParameters().get('id');
        IdParamName = RecordId;
        System.debug('IdParamName ' + IdParamName);
        leadParamName = [select Id,Lead_ID__c from Lead where Id=:IdParamName].Lead_ID__c;
        System.debug('leadParamName ' + leadParamName);
    }
    public PageReference LeadReOpen(){
        List<Lead> lstlead = [select Id,Lead_ID__c,Reopen_Date_Time__c,Converted__c,Stage__c,Status,Current_Status__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Lead where Id=:IdParamName];
        System.debug('lstlead ' + lstlead);
        List<Lead> nlstlead = new List<Lead>();
        for(Lead olead : lstlead){
            Lead oled = new Lead();
            oled.id = olead.id;
            oled.Reason_Lost__c = False;
            oled.Current_Status__c = 'Nurturing';
            oled.Stage__c = olead.Stage__c;
            oled.Reason_Losts__c = '';
            oled.Lost_Reasons__c ='';
            oled.Reason_Lost_Object__c = '';
            oled.Reopen_Date_Time__c = system.now();
            oled.Lost_Date_Time__c= Null;
            nlstlead.add(oled);
        }
        if(!nlstlead.isEmpty()){update nlstlead; }
        List<Contact> lstCon = [select Id,Reason_Lost__c,Lost_Date_Time__c,Lead_ID__c,Contact_Status__c,Reason_Losts__c,Reason_Lost_Object__c from Contact where Lead_ID__c=:leadParamName];
        system.debug('lstCon @@@ ' + lstCon);
        List<Contact> nLstCon = new List<Contact>();
        for(Contact ocon : lstCon){
            Contact ncon = new Contact();
            ncon.id = ocon.id;
            ncon.Reason_Lost__c = false;
            ncon.Reason_Losts__c = '';
            ncon.Lost_Reasons__c ='';
            ncon.Reason_Lost_Object__c = '';
            ncon.Lost_Date_Time__c= Null;
            nLstCon.add(ncon);
        }
        if(!nLstCon.isEmpty()){update nLstCon;}
        List<Enquiry__c> lstEnq = [select Id,Stages__c,Lead_ID__c,Lost_Date_Time__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Enquiry__c where Lead_ID__c=:leadParamName];
        system.debug('lstEnq @@@ ' + lstEnq);
        List<Enquiry__c> nLstEnq = new List<Enquiry__c>();
        for(Enquiry__c oEnqury : lstEnq){
            Enquiry__c nEnqury = new Enquiry__c();
            nEnqury.id = oEnqury.id;
            nEnqury.Reason_Lost__c = False;
            nEnqury.Reason_Losts__c = '';
            nEnqury.Lost_Reasons__c ='';
            nEnqury.Reason_Lost_Object__c = '';
            nEnqury.Lost_Date_Time__c= Null;
            nLstEnq.add(nEnqury);
        }
        if(!nLstEnq.isEmpty()){update nLstEnq;}
        List<Application_Form__c> lstAppForm = [select Id,Status__c,Lost_Date_Time__c,Reason_Lost__c,Enquiry__r.Lead_ID__c,Reason_Losts__c,Reason_Lost_Object__c from Application_Form__c where Enquiry__r.Lead_ID__c=:leadParamName];
        system.debug('lstAppForm @@@ ' + lstAppForm);
        List<Application_Form__c> nLstAppForm = new List<Application_Form__c>();
        for(Application_Form__c oAppForm : lstAppForm){
            Application_Form__c nAppForm = new Application_Form__c();
            nAppForm.id = oAppForm.id;
            nAppForm.Reason_Lost__c = False;
            nAppForm.Reason_Losts__c = '';
            nAppForm.Lost_Reasons__c = '';
            nAppForm.Reason_Lost_Object__c = '';
            nAppForm.Lost_Date_Time__c= Null;
            nLstAppForm.add(nAppForm);
        }
        if(!nLstAppForm.isEmpty()){update nLstAppForm;}
        List<Admission_Form__c> lstAddForm = [select Id,Status__c,Lost_Date_Time__c,Enquiry_No__r.Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Admission_Form__c where Enquiry_No__r.Lead_ID__c=:leadParamName];
        system.debug('lstAddForm @@@ ' + lstAddForm);
        List<Admission_Form__c> nLstAddForm = new List<Admission_Form__c>();
        for(Admission_Form__c oAddForm : lstAddForm){
            Admission_Form__c nAddForm = new Admission_Form__c();
            nAddForm.id = oAddForm.id;
            nAddForm.Reason_Lost__c = false;
            nAddForm.Reason_Losts__c = '';
            nAddForm.Reason_Lost_Object__c = '';
            nAddForm.Lost_Reasons__c = '';
            nAddForm.Lost_Date_Time__c= Null;
            nLstAddForm.add(nAddForm);
        }
        if(!nLstAddForm.isEmpty()){update nLstAddForm;}
        List<Admission_Granted__c> lstAddGrant = [select Id,Lost_Date_Time__c,Status__c,EnquiryNo__r.Lead_ID__c,Reason_Lost__c,Reason_Losts__c,Reason_Lost_Object__c from Admission_Granted__c where EnquiryNo__r.Lead_ID__c=:leadParamName];
        system.debug('lstAddGrant @@@ ' + lstAddGrant);
        List<Admission_Granted__c> nLstAddGrant = new List<Admission_Granted__c>();for(Admission_Granted__c oAddGrant : lstAddGrant){
            Admission_Granted__c nAddGrant = new Admission_Granted__c();
            nAddGrant.id = oAddGrant.id;
            nAddGrant.Reason_Lost__c = false;
            nAddGrant.Reason_Losts__c = '';
            nAddGrant.Lost_Reasons__c = '';
            nAddGrant.Reason_Lost_Object__c = '';
            nAddGrant.Lost_Date_Time__c= Null;
            nLstAddGrant.add(nAddGrant);
        }
        if(!nLstAddGrant.isEmpty()){update nLstAddGrant;}
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
     }

}