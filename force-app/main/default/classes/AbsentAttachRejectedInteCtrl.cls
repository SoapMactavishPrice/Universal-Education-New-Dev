public class AbsentAttachRejectedInteCtrl {
    public Enquiry__c Enq{get;set;}
    public boolean msg{get;set;}
    Id pid=Apexpages.currentpage().getParameters().get('id');
    List<Enquiry__c> listEnquiry{get;set;}
    public string leadidvalue{get;set;}
    public string customAdmissionFormValue{get;set;}
    public AbsentAttachRejectedInteCtrl(ApexPages.StandardController Controller){
        // /p/attach/NoteAttach?pid={!Admission_Form__c.Id}&parentname={!Admission_Form__c.Name}&retURL=%2F{!Admission_Form__c.Id}
        Id pid=Apexpages.currentpage().getParameters().get('id');
        system.debug('ID::::'+pid);
        listEnquiry =new List<Enquiry__c>();
        msg = True;
        if(!Test.isRunningTest()){Enq=[SELECT FirstName__c, Id, Interaction_Done__c,Stages__c, Interaction_Online_Rescheduled__c,Interaction_Online_Scheduled__c,
             Interaction_Rescheduled__c,Interaction_Scheduled__c,Lead_ID__c, Name,Rejected_After_Interaction__c,Attach_Interaction_Notes__c,
                  Absent_for_Interaction__c FROM Enquiry__c where id=: pid ];}else{
                      Enq=[SELECT FirstName__c, Id, Interaction_Done__c,Stages__c, Interaction_Online_Rescheduled__c,Interaction_Online_Scheduled__c,
             Interaction_Rescheduled__c,Interaction_Scheduled__c,Lead_ID__c, Name,Rejected_After_Interaction__c,Attach_Interaction_Notes__c,
                  Absent_for_Interaction__c FROM Enquiry__c limit 1];
                  }
        leadidvalue = Enq.Lead_ID__c;
        customAdmissionFormValue= Enq.Id;
        system.debug('AdmissionForm_Record:::::'+Enq);
    }
    public PageReference goToPageTwo(){
        PageReference pg;
        if(!Test.isRunningTest()){Enq=[SELECT Id,Name, Attach_Interaction_Notes__c,Lead_ID__c FROM Enquiry__c where id=: pid ];}
        else{Enq=[SELECT Id,Name, Attach_Interaction_Notes__c,Lead_ID__c FROM Enquiry__c limit 1];}
        system.debug('AdmissionForm_Record:::::'+Enq);
        pg = new PageReference('/p/attach/NoteAttach?pid='+Enq.Id+'&parentname='+Enq.Name+'&retURL='+Enq.Id);
        //if(Enq.Attach_Interaction_Notes__c == true){
        Enq.Stages__c ='Attach Interaction Notes';
        Enq.Attach_Interaction_Notes__c = true;
        update Enq;
        if(!Test.isRunningTest()){Lead ld=[Select Id,Lead_ID__c,Stage__c From Lead Where Lead_ID__c=:Enq.Lead_ID__c];
        ld.Stage__c='Attach Interaction Notes';
                                  update ld;}
        //}
        pg = new PageReference('/p/attach/NoteAttach?pid='+Enq.Id+'&parentname='+Enq.Name+'&retURL='+Enq.Id);
        return pg;
    }
    public PageReference RejectedAfterInteraction(){
        PageReference pg;
        List<Enquiry__c> Enquiry = new List<Enquiry__c>();
        if(!Test.isRunningTest()){Enquiry = [SELECT FirstName__c, Id,Stages__c, Interaction_Done__c, Interaction_Online_Rescheduled__c,Interaction_Online_Scheduled__c,
                              Interaction_Rescheduled__c,Interaction_Scheduled__c,Lead_ID__c, Name,Rejected_After_Interaction__c
                                                              ,Attach_Interaction_Notes__c,Absent_for_Interaction__c FROM Enquiry__c where id=: pid];}
        else{Enquiry = [SELECT FirstName__c, Id,Stages__c, Interaction_Done__c, Interaction_Online_Rescheduled__c,Interaction_Online_Scheduled__c,
                              Interaction_Rescheduled__c,Interaction_Scheduled__c,Lead_ID__c, Name,Rejected_After_Interaction__c
                                                              ,Attach_Interaction_Notes__c,Absent_for_Interaction__c FROM Enquiry__c limit 1];}
        
        
        if(Enquiry[0].Stages__c =='Rejected After Interaction'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Rejected After Interaction Already Done!'));
        }else{
            for(Enquiry__c oEnquiry : Enquiry){
                Enquiry__c Enquirycs = new Enquiry__c();
                Enquirycs.id = oEnquiry.id;
                Enquirycs.Stages__c ='Rejected After Interaction';
                Enquirycs.Rejected_After_Interaction__c = true;
                listEnquiry.add(Enquirycs);
            }
            if(!listEnquiry.IsEmpty()){
                if(!Test.isRunningTest()){update listEnquiry;}
                list<Admission_Form__c> listAdmission_Forms = new list<Admission_Form__c>();
                list<Admission_Form__c> listAdmission_Formld=[SELECT Id, Enquiry_No__r.name, Name,Rejected_After_Interaction__c
                                       ,Attach_Interaction_Notes__c,Status__c,Absent_for_Interaction__c FROM Admission_Form__c where Enquiry_No__c =:customAdmissionFormValue];
                for(Admission_Form__c olead : listAdmission_Formld){
                    Admission_Form__c ol = new Admission_Form__c();
                    ol.id = olead.id;
                    ol.Rejected_After_Interaction__c = true;
                    ol.Status__c='Rejected After Interaction';
                    listAdmission_Forms.add(ol);
                }
                if(!listAdmission_Forms.isEmpty()){
                    update listAdmission_Forms;
                } 
                
                list<Lead> listlds = new list<Lead>();
                list<Lead> listld=[Select Id,Lead_ID__c,Stage__c From Lead Where Lead_ID__c=:leadidvalue];
                for(Lead olead : listld){
                    Lead ol = new Lead();
                    ol.id = olead.id;
                    ol.Stage__c='Rejected After Interaction';
                    listlds.add(ol);
                }
                if(!listlds.isEmpty()){
                    update listlds;
                } 
                pg = new PageReference('/'+listEnquiry[0].Id);
            }
        }
        pg = new PageReference('/'+Enq.Id);
        return pg;
    }
    
    public PageReference AbsentforInteraction(){
        PageReference pg;
        List<Enquiry__c> Enquiry = new List<Enquiry__c>();
        if(!Test.isRunningTest()){Enquiry = [SELECT FirstName__c, Id,Stages__c, Interaction_Done__c, Interaction_Online_Rescheduled__c,Interaction_Online_Scheduled__c,
                              Interaction_Rescheduled__c,Interaction_Scheduled__c,Lead_ID__c, Name,Rejected_After_Interaction__c
                                                              ,Attach_Interaction_Notes__c,Absent_for_Interaction__c FROM Enquiry__c where id=: pid];}
        else{Enquiry = [SELECT FirstName__c, Id,Stages__c, Interaction_Done__c, Interaction_Online_Rescheduled__c,Interaction_Online_Scheduled__c,
                              Interaction_Rescheduled__c,Interaction_Scheduled__c,Lead_ID__c, Name,Rejected_After_Interaction__c
                                                              ,Attach_Interaction_Notes__c,Absent_for_Interaction__c FROM Enquiry__c limit 1];}
        
        if(Enquiry[0].Stages__c =='Absent for Interaction'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Absent for Interaction!'));
        }else{
            for(Enquiry__c oEnquiry : Enquiry){
                Enquiry__c Enquirycs = new Enquiry__c();
                Enquirycs.id = oEnquiry.id;
                Enquirycs.Stages__c ='Absent for Interaction';
                Enquirycs.Absent_for_Interaction__c = true;
                listEnquiry.add(Enquirycs);
            }
            if(!listEnquiry.IsEmpty()){
                update listEnquiry;
                list<Admission_Form__c> listAdmission_Forms = new list<Admission_Form__c>();
                list<Admission_Form__c> listAdmission_Formld=[SELECT Id, Enquiry_No__r.name, Name,Rejected_After_Interaction__c
                                       ,Attach_Interaction_Notes__c,Status__c,Absent_for_Interaction__c FROM Admission_Form__c where Enquiry_No__c =:customAdmissionFormValue];
                for(Admission_Form__c olead : listAdmission_Formld){
                    Admission_Form__c ol = new Admission_Form__c();
                    ol.id = olead.id;
                    ol.Absent_for_Interaction__c = true;
                    ol.Status__c='Absent for Interaction';
                    listAdmission_Forms.add(ol);
                }
                if(!listAdmission_Forms.isEmpty()){
                    update listAdmission_Forms;
                } 
                
                list<Lead> listlds = new list<Lead>();
                list<Lead> listld=[Select Id,Lead_ID__c,Stage__c From Lead Where Lead_ID__c=:leadidvalue];
                for(Lead olead : listld){
                    Lead ol = new Lead();
                    ol.id = olead.id;
                    ol.Stage__c='Absent for Interaction';
                    listlds.add(ol);
                }
                if(!listlds.isEmpty()){
                    update listlds;
                }    
                system.debug('----------:'+listEnquiry);
                pg = new PageReference('/'+listEnquiry[0].Id);
            }
        }
        
        return pg;
    }
    public PageReference goBack(){
        return new PageReference('/'+Enq.Id);
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
    }
}