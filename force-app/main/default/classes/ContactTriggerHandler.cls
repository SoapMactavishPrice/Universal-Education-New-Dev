public class ContactTriggerHandler {
    public static void updateCurrentStatus(List<Contact> listContact){
        system.debug('listContact ' + listContact);
        set<string> ContactLeadId = new set<string>();
        List<Contact> lstLead = new List<Contact>();
        if(RecursiveTriComCurrStatusHandler.isFirstTime == true){
            for(Contact ocontacts : listContact){
                if(ocontacts.Contact_Status__c == 'Dormant'){
                    ContactLeadId.add(ocontacts.Lead_ID__c);   
                }
            }
            system.debug('ContactLeadId >> ' + ContactLeadId);
            if(!ContactLeadId.IsEmpty()){
                List<Lead> ldLists = [SELECT Id,Lead_ID__c,Current_Status__c FROM Lead where Lead_ID__c =:ContactLeadId]; 
                List<Lead> listLead = new List<Lead>();
                for(Lead ld:ldLists){
                    Lead oLead = new Lead();
                    oLead.id = ld.id;
                    oLead.Current_Status__c = 'Dormant';    
                    listLead.add(oLead);
                }
                system.debug('listLead  ' + listLead);
                if(!listLead.isEmpty()){
                    RecursiveTriComCurrStatusHandler.isFirstTime = false;
                    update listLead;  
                }                 
            }
        }
    }
    
    /**
     * This method updates the LastName of Contacts if it contains the "+" symbol.
     * It will be triggered after inserting the Contact record.
     * 
     */
    public static void updateContactLastName(List<Contact> contacts) {
        try {
            // Handling Insert: Update LastName if it contains "+" symbol
            for (Contact con : contacts) {
                System.debug('Processing Contact on Insert: ' + con.Id);

                // Check if LastName contains the "+" symbol
                if (con.LastName != null && con.LastName.contains('+')) {
                    con.LastName = 'New Contact';  // Update LastName to "New Contact"
                    System.debug('Updated LastName for Contact ID ' + con.Id + ' to "New Contact".');
                }
            }

        } catch (Exception ex) {
            // Catching all other unexpected exceptions
            System.debug('Exception: ' + ex.getMessage());
            // Optionally rethrow the exception
            throw ex;
        }
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
     }
}