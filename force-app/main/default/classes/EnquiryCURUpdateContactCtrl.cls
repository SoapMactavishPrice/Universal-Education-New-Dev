/**
* Trigger      : EnquiryCURUpdateContactTrigger
* Classes      : EnquiryCURUpdateContactCtrl,EnquiryRecursiveTriggerHandler,Test_EnquiryCURUpdateContactCtrl
* Devloper     : Rajesh Kumar
* Created Date : 30/12/2021
*/
public class EnquiryCURUpdateContactCtrl {
    public static void EnquiryCURUTriggerAftInsUpdate(list<Enquiry__c> lstEnquiry,Boolean TriggerisAfter,Boolean TriggerisInsert,Boolean TriggerisUpdate){
        if(TriggerisAfter){
            if(TriggerisInsert || TriggerisUpdate){
                EnquiryCURUinsert(lstEnquiry,TriggerisInsert,TriggerisUpdate);
                //updateCurrentStatus(Trigger.new);
            }  
        }    
    }
    public static void EnquiryCURUinsert(list<Enquiry__c> listEnquirys,Boolean TriggerisInsert,Boolean TriggerisUpdate){
        set<id> ContactId = new set<id>();
        set<string> leadId = new set<string>();
        string submiteddatetime;
        List<Contact> newContact = new List<Contact>();
        List<lead> newlead = new List<lead>();
        if(EnquiryRecursiveTriggerHandler.isFirstTime){
            EnquiryRecursiveTriggerHandler.isFirstTime = false;
            if(!listEnquirys.isEmpty() && (TriggerisInsert || TriggerisUpdate)){
                for(Enquiry__c Disclos:listEnquirys){
                    ContactId.add(Disclos.Contact__c);
                    submiteddatetime=string.valueOf(Disclos.SystemModstamp);
                    leadId.add(Disclos.Lead_ID__c);
                } 
                system.debug(' ContactId' + ContactId);
                if(!ContactId.isEmpty()){
                    List<Contact> listContact = [SELECT Name,Curiosity_Submitted__c, Curiosity_Submitted_Date__c, Id FROM Contact where Id =:ContactId limit 1];
                    if(!listContact.isEmpty()){
                        for(Contact lstContact : listContact){
                            Contact nContact = new Contact();
                            nContact.Id =lstContact.id;
                            nContact.Curiosity_Submitted__c=true;
                            //nContact.Curiosity_Submitted_Date__c=datetime.valueOf(submiteddatetime);
                            newContact.add(nContact);
                        }
                        system.debug('newContact >> ' + newContact);
                        if(!newContact.isEmpty()){
                            update newContact;
                            List<lead> listlead = [SELECT Name,Lead_ID__c,Stage__c,Id FROM lead where Lead_ID__c =:leadId limit 1];
                            system.debug('listlead @@@@@@ #### >> ' + listlead);
                            if(!listlead.isEmpty()){
                                for(lead lstlead : listlead){
                                    lead nlead = new lead();
                                    nlead.Id =lstlead.id;
                                    if(lstlead.Stage__c == 'Rejected After Interaction')
                                    {system.debug('listlead @@@@@@ #### >>');
                                     nlead.Stage__c ='Rejected After Interaction';
                                    }else{system.debug('listlead >>');
                                         nlead.Stage__c ='Curiosity Submitted';
                                        }
                                    newlead.add(nlead);
                                }
                                system.debug('newlead >> ' + newlead);
                                if(!newlead.isEmpty()){
                                    update newlead;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    /*
      public static void updateCurrentStatus(List<Enquiry__c> listEnquiry){
        system.debug('listContact ' + listEnquiry);
        set<string> EnquiryLeadId = new set<string>();
        List<Enquiry__c> lstEnquiry = new List<Enquiry__c>();
        if(RecursiveTriComCurrStatusHandler.isFirstTime == true){
            for(Enquiry__c oEnquiry : listEnquiry){
                if(oEnquiry.Stages__c == 'Dormant'){
                    EnquiryLeadId.add(oEnquiry.Lead_ID__c);   
                }
            }
            system.debug('EnquiryLeadId >> ' + EnquiryLeadId);
            if(!EnquiryLeadId.IsEmpty()){
                List<Lead> ldLists = [SELECT Id,Lead_ID__c,Current_Status__c FROM Lead where Lead_ID__c =:EnquiryLeadId]; 
                List<Lead> listLead = new List<Lead>();
                for(Lead ld:ldLists){
                    Lead oLead = new Lead();
                    oLead.id = ld.id;
                    oLead.Current_Status__c = 'Dormant';    
                    listLead.add(oLead);
                }
                system.debug('listLead  ' + listLead);
                if(!listLead.isEmpty()){
                    EnquiryRecursiveTriggerHandler.isFirstTime = false;
                    RecursiveTriComCurrStatusHandler.isFirstTime = false;
                    update listLead;  
                }                 
            }
        }
    }*/
}