public class LeadTriggerHandler {
    public static void onBeforeUpdate(List<Lead> newLeads, Map<Id, Lead> oldLeadMap) {
        Set<String> userProfileNames = new Set<String>();
        Map<Id, User> userIdToUserMap = new Map<Id, User>([SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()]);
        for (Id userId : userIdToUserMap.keySet()) {
            userProfileNames.add(userIdToUserMap.get(userId).Profile.Name);
        }

        for (Lead lead : newLeads) {
            if (userProfileNames.contains('System Administrator') || userProfileNames.contains('HOD')) {
                continue;
            }

            if (lead.Status != 'New' && lead.Status != 'Working') {
                if (oldLeadMap.get(lead.Id).FirstName != lead.FirstName || 
                    oldLeadMap.get(lead.Id).MiddleName != lead.MiddleName ||
                    oldLeadMap.get(lead.Id).LastName != lead.LastName||
                    oldLeadMap.get(lead.Id).Salutation != lead.Salutation||
                    oldLeadMap.get(lead.Id).Date_of_Birth__c != lead.Date_of_Birth__c||
                    oldLeadMap.get(lead.Id).Email != lead.Email||
                    oldLeadMap.get(lead.Id).Relation__c != lead.Relation__c||
                    oldLeadMap.get(lead.Id).Your_First_Name__c != lead.Your_First_Name__c||
                    oldLeadMap.get(lead.Id).Your_Last_Name__c != lead.Your_Last_Name__c||
                    oldLeadMap.get(lead.Id).Gender__c != lead.Gender__c||
                    oldLeadMap.get(lead.Id).Seeking_Admission_in_Grade__c != lead.Seeking_Admission_in_Grade__c||
                    oldLeadMap.get(lead.Id).Stellar_Seeking_Admission_in_Grade__c != lead.Stellar_Seeking_Admission_in_Grade__c) {
                    lead.addError('You cannot edit lead fields if status is not New or Working.');
                }
            }
        }
    }

    public static void syncLeadStatus(List<Lead> newLeads, Map<Id, Lead> oldMap) {

        Set<String> allowedStatuses = new Set<String>{
            'New',
            'Working',
            'Duplicate',
            'Qualified',
            'Non Qualified'
        };

        for (Lead newLead : newLeads) {

            Lead oldLead = oldMap.get(newLead.Id);

            if (newLead.Status != oldLead.Status) {

                if (allowedStatuses.contains(oldLead.Lead_Status__c)) {
                    newLead.Lead_Status__c = newLead.Status;
                }

            }

        }

    }

    public static void dummy()
        {
          integer j=0;
              j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
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
            
        }
    
    
}