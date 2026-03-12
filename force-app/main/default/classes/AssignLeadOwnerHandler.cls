public without sharing class AssignLeadOwnerHandler {
    public static void assignOwners(List<Lead> newLeads, Map<Id, Lead> oldMap) {
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

        Map<String, LeadUser__c> schoolCodeToLevelOneLeadUser = new Map<String, LeadUser__c>();
        Map<String, LeadUser__c> schoolCodeToLevelTwoLeadUser = new Map<String, LeadUser__c>();
        Set<String> leadUserNames = new Set<String>();
        for (LeadUser__c leadUser : [
            SELECT Id, Name, SchoolCode__c, Level__c
            FROM LeadUser__c
            WHERE SchoolCode__c IN :schoolCodes
        ]) {
            String schoolCode = normalizeSchoolCode(leadUser.SchoolCode__c);
            if (String.isBlank(schoolCode)) {
                continue;
            }

            if (leadUser.Level__c == 1 && !schoolCodeToLevelOneLeadUser.containsKey(schoolCode)) {
                schoolCodeToLevelOneLeadUser.put(schoolCode, leadUser);
                leadUserNames.add(leadUser.Name);
            } else if (leadUser.Level__c == 2 && !schoolCodeToLevelTwoLeadUser.containsKey(schoolCode)) {
                schoolCodeToLevelTwoLeadUser.put(schoolCode, leadUser);
            }
        }

        if (leadUserNames.isEmpty()) {
            return;
        }

        Map<String, Id> userNameToUserId = new Map<String, Id>();
        for (User userRecord : [
            SELECT Id, Name
            FROM User
            WHERE Name IN :leadUserNames
        ]) {
            userNameToUserId.put(userRecord.Name, userRecord.Id);
        }

        List<Lead> leadsToUpdate = new List<Lead>();
        Set<String> schoolCodesToSwap = new Set<String>();
        Map<Id, Id> leadIdToAssignedOwnerId = new Map<Id, Id>();
        for (Lead leadRecord : leadsToProcess) {
            String schoolCode = institutionToSchoolCode.get(leadRecord.School_Institution__c);
            if (String.isBlank(schoolCode)) {
                continue;
            }

            LeadUser__c levelOneLeadUser = schoolCodeToLevelOneLeadUser.get(schoolCode);
            LeadUser__c levelTwoLeadUser = schoolCodeToLevelTwoLeadUser.get(schoolCode);
            if (levelOneLeadUser == null || levelTwoLeadUser == null) {
                continue;
            }

            Id ownerId = userNameToUserId.get(levelOneLeadUser.Name);
            if (ownerId == null) {
                continue;
            }

            if (!isUpdate) {
                schoolCodesToSwap.add(schoolCode);
                leadIdToAssignedOwnerId.put(leadRecord.Id, ownerId);
            }
        }

        if (isUpdate || schoolCodesToSwap.isEmpty()) {
            return;
        }

        System.enqueueJob(new AssignLeadOwnerLevelSwapQueueable(
            new List<String>(schoolCodesToSwap),
            new Map<Id, Id>(leadIdToAssignedOwnerId)
        ));
    }

    private static String normalizeSchoolCode(String schoolCode) {
        return String.isBlank(schoolCode) ? null : schoolCode.toUpperCase().replaceAll('\\s+', '');
    }
}
