trigger AcitivityTaskCount on Task (after insert, after update) {
    if(trigger.isInsert || Trigger.isUpdate ) {
        Trigger_Switch__mdt Trigger_Switch = Trigger_Switch__mdt.getInstance('AcitivityTaskCountSwitch');
		system.debug(Trigger_Switch.IsActive__c);
        if (Trigger_Switch.IsActive__c == true) {
			system.debug('Inside Handler>>');
            //AcitivityTaskCountHandler.checkobject(Trigger.New);  
            ActivityTasksCountHandler.checkobject(Trigger.New,Trigger.oldMap);   
        }
    }
    
    if(Trigger.isAfter &&(Trigger.isUpdate || Trigger.isInsert)) {
        for(Task tsk : Trigger.new ) {
            system.debug('tsk.TaskSubtype'+tsk.TaskSubtype);
            if(tsk.TaskSubtype != 'Email') {
                system.debug('in '+tsk.TaskSubtype);
                LastModifiedTaskController.checkobject(Trigger.New);  
            } else if(tsk.TaskSubtype == 'Email') {
                system.debug('else'+tsk.TaskSubtype);
                LastModified_EmailMessageHandler.checkobject(Trigger.New);
            }
        }
    }
    
    if(Trigger.isAfter &&( Trigger.isUpdate || Trigger.isInsert)) {
        for(Task tsk : Trigger.New) {
            List<Lead> leads = new List<Lead>();
            
            if(tsk.Call_Status__c == 'Missed') {
                system.debug(tsk.WhoId);
                
                if(string.isNotblank(tsk.WhoId)){
                    system.debug(Schema.Lead.sObjectType);
                    if(tsk.WhoId.getsObjectType() == Schema.Lead.sObjectType) {
                        system.debug('inside last if-->');
                        Lead ld = new Lead();
                        ld.Id = tsk.WhoId;
                        ld.Call_Status__c = tsk.Call_Status__c;
                        leads.add(ld);
                    }
                }
            }
            update leads;
            system.debug('inside last if-->'+leads.size());
        }
    }
    
    
    if (Trigger.isInsert || Trigger.isUpdate) {
        System.debug('Checking for First Activity Date/Time update...');
      
        ActivityTasksCountHandler.setFirstActivityDateTimeOnLead(Trigger.new);
    }
    
     // Only proceed if there are records to process
    if (Trigger.isInsert || Trigger.isUpdate) {
        System.debug('Trigger fired. Number of tasks: ' + Trigger.new.size());
        ActivityTasksCountHandler.handleChatterPostOnTask(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {

        Map<Id, Id> leadOwnerUpdates = new Map<Id, Id>();

        for (Task t : Trigger.new) {
            if (t.Subject != null && t.Subject.startsWith('CTI') && t.WhoId != null) {
                if (t.WhoId.getSObjectType() == Lead.SObjectType) {
                    leadOwnerUpdates.put(t.WhoId, t.OwnerId);
                }
            }
        }

        if (!leadOwnerUpdates.isEmpty()) {
            List<Lead> leadsToUpdate = new List<Lead>();
            for (Id leadId : leadOwnerUpdates.keySet()) {
                leadsToUpdate.add(new Lead(
                    Id = leadId,
                    OwnerId = leadOwnerUpdates.get(leadId)
                ));
            }
            update leadsToUpdate;
        }
    }

    
}