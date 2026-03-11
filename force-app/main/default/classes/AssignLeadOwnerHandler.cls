public without sharing class AssignLeadOwnerHandler {
    public static void assignOwners(List<Lead> newLeads, Map<Id, Lead> oldMap) {
        RecursiveTriggerHandler.skipTrigger = true;
        if (newLeads == null || newLeads.isEmpty()) {
            return;
        }

        Boolean isUpdate = oldMap != null;
        List<Lead> leadsToProcess = new List<Lead>();
        Set<Id> schoolInstitutionIds = new Set<Id>();

        for (Lead leadRecord : newLeads) {
            if (leadRecord.Company == 'Ozonetel Lead' || leadRecord.School_Institution__c == null) {
                continue;
            }

            if (isUpdate) {
                Lead oldLead = oldMap.get(leadRecord.Id);
                if (oldLead != null && leadRecord.School_Institution__c == oldLead.School_Institution__c) {
                    continue;
                }
            }

            leadsToProcess.add(leadRecord);
            schoolInstitutionIds.add(leadRecord.School_Institution__c);
        }

        if (schoolInstitutionIds.isEmpty()) {
            return;
        }

        Map<Id, String> institutionToSchoolCode = new Map<Id, String>();
        Set<String> schoolCodes = new Set<String>();
        for (Account schoolAccount : [
            SELECT Id, School_Short_Code__c
            FROM Account
            WHERE Id IN :schoolInstitutionIds
        ]) {
            String schoolCode = normalizeSchoolCode(schoolAccount.School_Short_Code__c);
            if (String.isNotBlank(schoolCode)) {
                institutionToSchoolCode.put(schoolAccount.Id, schoolCode);
                schoolCodes.add(schoolCode);
            }
        }

        if (schoolCodes.isEmpty()) {
            return;
        }

        Map<String, String> schoolCodeToLeadUserName = new Map<String, String>();
        for (LeadUser__c leadUser : [
            SELECT Name, SchoolCode__c, Level__c
            FROM LeadUser__c
            WHERE SchoolCode__c IN :schoolCodes
            AND Level__c = 1
        ]) {
            String schoolCode = normalizeSchoolCode(leadUser.SchoolCode__c);
            if (String.isNotBlank(schoolCode) && !schoolCodeToLeadUserName.containsKey(schoolCode)) {
                schoolCodeToLeadUserName.put(schoolCode, leadUser.Name);
            }
        }

        if (schoolCodeToLeadUserName.isEmpty()) {
            return;
        }

        Map<String, Id> userNameToUserId = new Map<String, Id>();
        for (User userRecord : [
            SELECT Id, Name
            FROM User
            WHERE Name IN :schoolCodeToLeadUserName.values()
        ]) {
            userNameToUserId.put(userRecord.Name, userRecord.Id);
        }

        for (Lead leadRecord : leadsToProcess) {
            String schoolCode = institutionToSchoolCode.get(leadRecord.School_Institution__c);
            if (String.isBlank(schoolCode)) {
                continue;
            }
            String leadUserName = schoolCodeToLeadUserName.get(schoolCode);
            Id ownerId = String.isBlank(leadUserName) ? null : userNameToUserId.get(leadUserName);
            if (ownerId != null) {
                leadRecord.OwnerId = ownerId;
            }
        }
    }

    private static String normalizeSchoolCode(String schoolCode) {
        return String.isBlank(schoolCode) ? null : schoolCode.toUpperCase().replaceAll('\\s+', '');
    }
}
