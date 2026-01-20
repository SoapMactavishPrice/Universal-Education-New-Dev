public class LeadFieldsHandler {

    // Method to handle updates for School_Short_Code__c and School_Institution__c
    public static void updateSchoolFields(List<Lead> leads, Map<Id, Lead> oldLeads) {
        
        // Set to collect the normalized (uppercase, no spaces) School_Short_Code__c values from the leads
        Set<String> schoolShortCodes = new Set<String>();
        Set<Id> schoolInstitutionIds = new Set<Id>();

        // Populate the set with normalized School_Short_Code__c values from leads (for both insert and update)
        for (Lead lead : leads) {
            
            // On insert: Update school short code, basis Location picklist values
            if (Trigger.isInsert) {
                // If School_Short_Code__c is blank on insert, check if School_Institution__c is populated
                if (String.isBlank(lead.School_Short_Code__c) && lead.School_Institution__c != null) {
                    Account institution = [SELECT School_Short_Code__c FROM Account WHERE Id = :lead.School_Institution__c LIMIT 1];
                    if (institution != null && institution.School_Short_Code__c != null) {
                        lead.School_Short_Code__c = institution.School_Short_Code__c;
                        System.debug('Assigned School_Short_Code__c from School_Institution__c on Lead ID: ' + lead.Id);
                    }
                }

                // Location-based short code assignment (if School_Short_Code__c is still blank after checking Institution)
                if (String.isBlank(lead.School_Short_Code__c) && lead.Location__c != null) {
                    if (lead.Location__c == 'Andheri') {
                        lead.School_Short_Code__c = 'STELRA';
                        lead.Company = 'STELLAR';
                    } else if (lead.Location__c == 'Bandra') {
                        lead.School_Short_Code__c = 'STELRB';
                        lead.Company = 'STELLAR';
                    } else if (lead.Location__c == 'Goregaon') {
                        lead.School_Short_Code__c = 'STELRG';
                        lead.Company = 'STELLAR';
                    }
                }
            }

            // Normalize School_Short_Code__c and update
            if (!String.isBlank(lead.School_Short_Code__c)) {
                // Normalize: convert to uppercase and remove spaces
                String normalizedShortCode = lead.School_Short_Code__c.toUpperCase().replaceAll('\\s+', '');
                schoolShortCodes.add(normalizedShortCode);

                // Also update the short code on Lead to be in uppercase
                lead.School_Short_Code__c = normalizedShortCode;
            }

            // Collect the School_Institution__c IDs to fetch related accounts
            if (lead.School_Institution__c != null) {
                schoolInstitutionIds.add(lead.School_Institution__c);
            }
        }

        // Exit early if there are no short codes or institutions to process
        if (schoolShortCodes.isEmpty() && schoolInstitutionIds.isEmpty()) {
            System.debug('No School_Short_Code__c or School_Institution__c found in the provided leads.');
            return;
        }

        // Query Account records based on School_Short_Code__c
        Map<String, Account> shortCodeToAccountMap = new Map<String, Account>();
        try {
            for (Account acc : [
                SELECT Id, School_Short_Code__c 
                FROM Account 
                WHERE School_Short_Code__c IN :schoolShortCodes
            ]) {
                // Normalize: convert to uppercase and remove spaces for comparison
                String normalizedShortCode = acc.School_Short_Code__c.toUpperCase().replaceAll('\\s+', '');
                shortCodeToAccountMap.put(normalizedShortCode, acc);
            }
        } catch (QueryException e) {
            // Handle exception if needed (e.g., log error or rethrow)
            System.debug('Error querying Accounts: ' + e.getMessage());
        }

        // Query Account records based on School_Institution__c for updating School_Short_Code__c
        Map<Id, Account> institutionToAccountMap = new Map<Id, Account>();
        try {
            for (Account acc : [
                SELECT Id, School_Short_Code__c 
                FROM Account 
                WHERE Id IN :schoolInstitutionIds
            ]) {
                institutionToAccountMap.put(acc.Id, acc);
            }
        } catch (QueryException e) {
            // Handle exception if needed
            System.debug('Error querying Accounts by institution: ' + e.getMessage());
        }

        // Loop through the leads to update the fields
        for (Lead lead : leads) {
            // Case 1: On insert or update of School_Institution__c, update School_Short_Code__c
            if (lead.School_Institution__c != null) {
                // Fetch the related Account's School_Short_Code__c
                Account account = institutionToAccountMap.get(lead.School_Institution__c);
                if (account != null && account.School_Short_Code__c != null) {
                    // Update the School_Short_Code__c on Lead
                    lead.School_Short_Code__c = account.School_Short_Code__c;
                    System.debug('Updated Lead with ID: ' + lead.Id + ' with School_Short_Code__c: ' + lead.School_Short_Code__c);
                }
            }

            // Case 2: On insert: Update School_Institution__c based on School_Short_Code__c
            if (Trigger.isInsert && !String.isBlank(lead.School_Short_Code__c)) {
                String normalizedLeadShortCode = lead.School_Short_Code__c.toUpperCase().replaceAll('\\s+', '');
                if (shortCodeToAccountMap.containsKey(normalizedLeadShortCode)) {
                    Account matchingAccount = shortCodeToAccountMap.get(normalizedLeadShortCode);
                    lead.School_Institution__c = matchingAccount.Id;
                    System.debug('Updated Lead with ID: ' + lead.Id + ' with School_Institution__c: ' + lead.School_Institution__c);
                } else {
                    // Skip error if School_Short_Code__c is blank during insert
                    if (String.isBlank(lead.School_Short_Code__c)) {
                        System.debug('Skipping error for blank School_Short_Code__c on Lead ID: ' + lead.Id);
                    } else {
                        // Throw an error if no match is found
                        lead.School_Short_Code__c.addError('No matching school exists for the provided short code "' + lead.School_Short_Code__c + '". ' + 
                                                       'Please ensure the short code is correct, or select a valid school/institution from the available options.');
                        System.debug('No match found for Lead with ID: ' + lead.Id + ' and School_Short_Code__c: ' + lead.School_Short_Code__c);
                    }
                }
            }
        }
    }
}









/*public class LeadFieldsHandler {

    // Method to handle updates for School_Short_Code__c and School_Institution__c
    public static void updateSchoolFields(List<Lead> leads, Map<Id, Lead> oldLeads) {
        
        // Set to collect the normalized (uppercase, no spaces) School_Short_Code__c values from the leads
        Set<String> schoolShortCodes = new Set<String>();
        Set<Id> schoolInstitutionIds = new Set<Id>();

        // Populate the set with normalized School_Short_Code__c values from leads (for both insert and update)
        for (Lead lead : leads) {
            
            // Update school short code, basis Location picklist values

              // Handle Location__c specific logic

            if (lead.Location__c != null) {

                if (lead.Location__c.equalsIgnoreCase('Andheri')) {

                    lead.School_Short_Code__c = 'STELRA';
                    lead.Company = 'STELLAR';

                } else if (lead.Location__c.equalsIgnoreCase('Bandra')) {

                    lead.School_Short_Code__c = 'STELRB';
                    lead.Company = 'STELLAR';

                } else if (lead.Location__c.equalsIgnoreCase('Goregaon')) {

                    lead.School_Short_Code__c = 'STELRG';
                    lead.Company = 'STELLAR';

                }

            }
            if (lead.School_Short_Code__c != null) {
                // Normalize: convert to uppercase and remove spaces
                String normalizedShortCode = lead.School_Short_Code__c.toUpperCase().replaceAll('\\s+', '');
                schoolShortCodes.add(normalizedShortCode);

                // Also update the short code on Lead to be in uppercase
                lead.School_Short_Code__c = normalizedShortCode;
            }

            if (lead.School_Institution__c != null) {
                // Collect the School_Institution__c IDs to fetch related accounts
                schoolInstitutionIds.add(lead.School_Institution__c);
            }
        }

        // Exit early if there are no short codes or institutions to process
        if (schoolShortCodes.isEmpty() && schoolInstitutionIds.isEmpty()) {
            System.debug('No School_Short_Code__c or School_Institution__c found in the provided leads.');
            return;
        }

        // Query Account records for matching normalized School_Short_Code__c
        Map<String, Account> shortCodeToAccountMap = new Map<String, Account>();
        try {
            for (Account acc : [
                SELECT Id, School_Short_Code__c 
                FROM Account 
                WHERE School_Short_Code__c IN :schoolShortCodes
            ]) {
                // Normalize: convert to uppercase and remove spaces for comparison
                String normalizedShortCode = acc.School_Short_Code__c.toUpperCase().replaceAll('\\s+', '');
                shortCodeToAccountMap.put(normalizedShortCode, acc);
            }
        } catch (QueryException e) {
            // Handle exception if needed (e.g., log error or rethrow)
            System.debug('Error querying Accounts: ' + e.getMessage());
        }

        // Query Account records based on School_Institution__c for updating School_Short_Code__c
        Map<Id, Account> institutionToAccountMap = new Map<Id, Account>();
        try {
            for (Account acc : [
                SELECT Id, School_Short_Code__c 
                FROM Account 
                WHERE Id IN :schoolInstitutionIds
            ]) {
                institutionToAccountMap.put(acc.Id, acc);
            }
        } catch (QueryException e) {
            // Handle exception if needed
            System.debug('Error querying Accounts by institution: ' + e.getMessage());
        }

        // Loop through the leads to update the fields
        for (Lead lead : leads) {
            // Case 1: Update School_Institution__c based on School_Short_Code__c
            if (lead.School_Short_Code__c != null) {
                String normalizedLeadShortCode = lead.School_Short_Code__c.toUpperCase().replaceAll('\\s+', '');
                if (shortCodeToAccountMap.containsKey(normalizedLeadShortCode)) {
                    Account matchingAccount = shortCodeToAccountMap.get(normalizedLeadShortCode);
                    lead.School_Institution__c = matchingAccount.Id;
                    System.debug('Updated Lead with ID: ' + lead.Id + ' with School_Institution__c: ' + lead.School_Institution__c);
                } else {
                    // Throw an error if no match is found
                    lead.School_Short_Code__c.addError('No matching school exists for the provided short code "' + lead.School_Short_Code__c + '". ' + 
                                                       'Please ensure the short code is correct, or select a valid school/institution from the available options.');
                    System.debug('No match found for Lead with ID: ' + lead.Id + ' and School_Short_Code__c: ' + lead.School_Short_Code__c);
                }
            }

            // Case 2: Update School_Short_Code__c based on School_Institution__c (Account)
            if (lead.School_Institution__c != null && lead.School_Short_Code__c == null) {
                // Fetch the related Account's School_Short_Code__c
                Account account = institutionToAccountMap.get(lead.School_Institution__c);
                if (account != null && account.School_Short_Code__c != null) {
                    // Update the School_Short_Code__c on Lead
                    lead.School_Short_Code__c = account.School_Short_Code__c;
                    System.debug('Updated Lead with ID: ' + lead.Id + ' with School_Short_Code__c: ' + lead.School_Short_Code__c);
                }
            }
        }
    }
}
*/