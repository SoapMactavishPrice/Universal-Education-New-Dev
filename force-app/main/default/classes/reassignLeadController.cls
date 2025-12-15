public class reassignLeadController {

    // Modified method to exclude the currently selected School_Institution__c (Account lookup on Lead)
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getSchoolOptionslist(String leadId) {
        List<Map<String, String>> options = new List<Map<String, String>>();

        try {
            // Fetch the School_Institution__c value from the Lead record using the leadId
            Lead leadRecord = [SELECT School_Institution__c FROM Lead WHERE Id = :leadId LIMIT 1];
            String excludedSchoolId = leadRecord.School_Institution__c;

            // Debugging - check the current selected school ID
            System.debug('Excluded School ID: ' + excludedSchoolId);

            // Fetch the list of Account records (schools), excluding the current School_Institution__c (if available)
            List<Account> schoolList;
            if (String.isEmpty(excludedSchoolId)) {
                // If there's no school currently assigned, fetch all records
                schoolList = [SELECT Id, Name FROM Account WHERE Name != NULL ORDER BY Name ASC];
            } else {
                // Exclude the currently selected school from the list
                schoolList = [SELECT Id, Name 
                              FROM Account 
                              WHERE Name != NULL 
                                AND Id != :excludedSchoolId 
                              ORDER BY Name ASC];
            }

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
        } catch (Exception e) {
            // Log the error and return an empty list if there's an issue
            System.debug('Error in getSchoolOptionslist: ' + e.getMessage());
            throw new AuraHandledException('Error fetching school options. Please try again.');
        }

        // Return the list of options
        return options;
    }

    // Fetch lead details based on lead ID
    @AuraEnabled(cacheable=true)
    public static Lead getLeadDetails(String leadId) {
        try {
            return [SELECT Current_Location__c, School_Institution__c 
                    FROM Lead WHERE Id = :leadId LIMIT 1];
        } catch (Exception e) {
            System.debug('Error in getLeadDetails: ' + e.getMessage());
            throw new AuraHandledException('Error fetching lead details. Please try again.');
        }
    }

    // Save the selected school for the lead and update its status
    @AuraEnabled
    public static String saveLead(String leadId, String accountId) {
        try {
            // Fetch the lead record
            Lead leadRecord = [SELECT Id, School_Institution__c, Current_Location__c, Status 
                               FROM Lead WHERE Id = :leadId];

            // Validate if Current Location is populated
            if (String.isBlank(leadRecord.Current_Location__c)) {
                throw new AuraHandledException('Please add Current Location before changing the school.');
            }

            // Update the lead record with the new school and status
            leadRecord.School_Institution__c = accountId;
            leadRecord.Status = 'New';
            update leadRecord;

            // Return success message
            return 'Lead transferred successfully';
        } catch (Exception e) {
            // Log the error and throw an exception if something goes wrong
            System.debug('Error in saveLead: ' + e.getMessage());
            throw new AuraHandledException('Error saving lead. Please try again.');
        }
    }
}

/*
public class reassignLeadController{
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getSchoolOptionslist() {
        List<Map<String, String>> options = new List<Map<String, String>>();
        
        // Fetch the list of Account records (schools)
        List<Account> schoolList = [SELECT Id, Name FROM Account WHERE Name != NULL ORDER BY Name ASC];
        
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
    return [SELECT  Current_Location__c 
            FROM Lead WHERE Id = :leadId LIMIT 1];
}

    @AuraEnabled
    public static String saveLead(String leadId, String accountId) {
        try {
            System.debug('lead'+leadId);
            System.debug('accountId'+accountId);
            Lead leadRecord = [SELECT Id, School_Institution__c, Current_Location__c, Status 
                               FROM Lead WHERE Id = :leadId];
       //     if (String.isBlank(leadRecord.Current_Location__c)) {
         //       throw new AuraHandledException('Please add Current Location');
         //   }
            // Reset School_Short_Code__c to null
         //   leadRecord.School_Short_Code__c = null;
            
            leadRecord.School_Institution__c = accountId;
            leadRecord.Status = 'New';
            update leadRecord;
            return 'Lead transferred successfully';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}*/