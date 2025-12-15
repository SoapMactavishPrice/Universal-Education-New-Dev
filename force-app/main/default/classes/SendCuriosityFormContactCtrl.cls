public class SendCuriosityFormContactCtrl {
    public Contact enqConatct{get;set;}
    public boolean back{get;set;}
    public Boolean showMYExpirelink{ get; set; }
    public Boolean showMYPage{ get; set; }
    public string SeekingGrade{ get; set; }       
    public string LeadID{ get; set; }
    public DateTime strApplicationSubmittedOn{get;set;}
    //public  String linkdate = ApexPages.currentPage().getParameters().get('linkdate');
    public List<Application_Form__c> lstApplication_Form{get;set;}
    public List<lead> lstlead{get;set;}
    public List<Lead> lstleads{get;set;}
    Id pid=Apexpages.currentpage().getParameters().get('id');
    
    public SendCuriosityFormContactCtrl(ApexPages.StandardController Controller)     
    {
        back = false;
    }
    public PageReference send()
    {
        PageReference page;
        try{
            enqConatct =[SELECT Id, AccountId, LastName,Format_Date__c, FirstName, MiddleName, Name, Email, Title, Lead_ID__c, Meet_Done_On__c, On_Hold__c, Meeting_Done__c, Re_Scheduled_Campus_Visit__c, Curiosity_Link__c, Interested__c, Stages__c, Campus_Visit_Done__c, Campus_Visit_Scheduled__c, Video_Call_Done__c, Video_Call_Scheduled__c, Video_Call_Scheduled_On__c, Stellar_Seeking_Admission_in_Grade__c, School_Short_Code__c, Curiosity_Submitted__c, Curiosity_Send_Date__c, Curiosity_Link_Sent__c, Curiosity_Form_Link__c, Enquiry_Submitted__c, Enquiry_Link_Sent__c, Contact_ID__c, Type__c, Description FROM Contact where id=:pid];
            LeadID =  enqConatct.Lead_ID__c;
            lstleads = new List<Lead>();
            system.debug('Query_ENQUIRY:::'+enqConatct.Stages__c);
            lstApplication_Form=new List<Application_Form__c>();
            lstlead=new List<lead>();
            lstApplication_Form =[SELECT Id, Name, SystemModstamp FROM Application_Form__c where Name =:SeekingGrade];
            for(Application_Form__c AFL : lstApplication_Form){
                strApplicationSubmittedOn = AFL.SystemModstamp;
            }
            lstlead = [select id,Lead_ID__c,Stage__c from lead where Lead_ID__c=:LeadID];
            if(enqConatct.Stages__c == 'Application submitted'){
                back = true;
                system.debug('INSIDE IF Stage::'+enqConatct.Stages__c);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Curiosity form Already Recieved !!'));
            }if(enqConatct.Stages__c == 'Application Rejected'){
                system.debug('INSIDE IF Stage::'+enqConatct.Stages__c);
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Curiosity form Already Recieved !!'));
            }
            if(enqConatct.Stages__c == 'Application Link Sent'  ){
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Curiosity Form already sent on registered Email ID.'));
            }
            if(enqConatct.Email == null){
                system.debug('INSIDE IF Stage::'+enqConatct.Email);
                back = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Email ID is not present!!'));
            }
            if(enqConatct.Email != null){
                system.debug('##inside enqConatct##');
                if(enqConatct.Curiosity_Link_Sent__c != null){
                    Send_CuriosityFormLink_SingleEmail.SendEmailNotification(pid);
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Curiosity form Already Recieved !!'));
                }
                page = new pageReference('/'+enqConatct.Id);
            }
       }catch(exception exp){
            system.debug('ERROR:::'+exp.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Something went wrong please try again!'));
        }
        return page;
    }
    public PageReference cancel()
    {
        return  new pageReference('/'+enqConatct.Id);
    }
}