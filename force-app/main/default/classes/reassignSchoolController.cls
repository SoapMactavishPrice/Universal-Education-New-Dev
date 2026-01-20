public class reassignSchoolController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getSchoolOptionslist() {
        List<Map<String, String>> options = new List<Map<String, String>>();
        
        // Fetch the list of Account records (schools)
        List<Account> schoolList = [SELECT Id, Name FROM Account WHERE Name != NULL];
        
        // Add the default "Select" option to the list
        Map<String, String> defaultOption = new Map<String, String>();
        defaultOption.put('label', 'Select School/Institution');
        defaultOption.put('value', '');
        options.add(defaultOption);
        
        // Loop through the school records and add them to the options list
        for (Account school : schoolList) {
            Map<String, String> schoolOption = new Map<String, String>();
            schoolOption.put('label', school.Name);
            schoolOption.put('value', school.Id);
            options.add(schoolOption);
        }

        // Return the list of options
        return options;
    }
    @AuraEnabled(cacheable=true)
public static Lead getLeadDetails(String leadId) {
    return [SELECT Id, School_Institution__c, Current_Location__c, Status 
            FROM Lead WHERE Id = :leadId LIMIT 1];
}

    @AuraEnabled
    public static String saveLead(String leadId, String accountId) {
        try {
            System.debug('lead'+leadId);
            System.debug('accountId'+accountId);
            Lead leadRecord = [SELECT Id, School_Institution__c, Current_Location__c, Status 
                               FROM Lead WHERE Id = :leadId];
          /*  if (String.isBlank(leadRecord.Current_Location__c)) {
                throw new AuraHandledException('Please add Current Location');
            }*/
            leadRecord.School_Institution__c = accountId;
            leadRecord.Status = 'New';
            update leadRecord;
            return 'Lead transferred successfully';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}