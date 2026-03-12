public without sharing class AssignLeadOwnerLevelSwapQueueable implements Queueable {
    private final List<String> schoolCodes;
    private final Map<Id, Id> leadIdToAssignedOwnerId;

    public AssignLeadOwnerLevelSwapQueueable(List<String> schoolCodes, Map<Id, Id> leadIdToAssignedOwnerId) {
        this.schoolCodes = schoolCodes == null ? new List<String>() : new List<String>(schoolCodes);
        this.leadIdToAssignedOwnerId = leadIdToAssignedOwnerId == null
            ? new Map<Id, Id>()
            : new Map<Id, Id>(leadIdToAssignedOwnerId);
    }

    public void execute(QueueableContext context) {
        if (schoolCodes.isEmpty()) {
            return;
        }

        Set<String> normalizedSchoolCodes = new Set<String>();
        for (String schoolCode : schoolCodes) {
            String normalizedSchoolCode = normalizeSchoolCode(schoolCode);
            if (String.isNotBlank(normalizedSchoolCode)) {
                normalizedSchoolCodes.add(normalizedSchoolCode);
            }
        }

        if (normalizedSchoolCodes.isEmpty()) {
            return;
        }

        Map<String, LeadUser__c> schoolCodeToLevelOneLeadUser = new Map<String, LeadUser__c>();
        Map<String, LeadUser__c> schoolCodeToLevelTwoLeadUser = new Map<String, LeadUser__c>();
        for (LeadUser__c leadUser : [
            SELECT Id, SchoolCode__c, Level__c, Name
            FROM LeadUser__c
            WHERE SchoolCode__c IN :normalizedSchoolCodes
        ]) {
            String schoolCode = normalizeSchoolCode(leadUser.SchoolCode__c);
            if (String.isBlank(schoolCode)) {
                continue;
            }

            if (leadUser.Level__c == 1 && !schoolCodeToLevelOneLeadUser.containsKey(schoolCode)) {
                schoolCodeToLevelOneLeadUser.put(schoolCode, leadUser);
            } else if (leadUser.Level__c == 2 && !schoolCodeToLevelTwoLeadUser.containsKey(schoolCode)) {
                schoolCodeToLevelTwoLeadUser.put(schoolCode, leadUser);
            }
        }

        List<LeadUser__c> leadUsersToUpdate = new List<LeadUser__c>();
        for (String schoolCode : normalizedSchoolCodes) {
            LeadUser__c levelOneLeadUser = schoolCodeToLevelOneLeadUser.get(schoolCode);
            System.debug('Level 1 Lead User for School Code ' + schoolCode + ': ' + levelOneLeadUser.Name);
            LeadUser__c levelTwoLeadUser = schoolCodeToLevelTwoLeadUser.get(schoolCode);
            System.debug('Level 2 Lead User for School Code ' + schoolCode + ': ' + levelTwoLeadUser.Name);
            if (levelOneLeadUser == null || levelTwoLeadUser == null) {
                continue;
            }

            levelOneLeadUser.Level__c = 2;
            levelTwoLeadUser.Level__c = 1;
            leadUsersToUpdate.add(levelOneLeadUser);
            leadUsersToUpdate.add(levelTwoLeadUser);
        }

        if (!leadUsersToUpdate.isEmpty()) {
            update leadUsersToUpdate;
            List<LeadUser__c> leadUsersAfterUpdate = [
                SELECT Id, SchoolCode__c, Level__c, Name
                FROM LeadUser__c
                WHERE Id IN :leadUsersToUpdate
            ];
            for (LeadUser__c leadUser : leadUsersAfterUpdate) {
                System.debug('Lead User Details After Update - Name: ' + leadUser.Name + ', SchoolCode: ' + leadUser.SchoolCode__c + ', Level: ' + leadUser.Level__c);
            }
        }

        if (leadIdToAssignedOwnerId.isEmpty()) {
            return;
        }

        List<Lead> leadsToUpdate = new List<Lead>();
        for (Lead leadRecord : [
            SELECT Id, OwnerId
            FROM Lead
            WHERE Id IN :leadIdToAssignedOwnerId.keySet()
        ]) {
            Id ownerId = leadIdToAssignedOwnerId.get(leadRecord.Id);
            if (ownerId != null && leadRecord.OwnerId != ownerId) {
                leadsToUpdate.add(new Lead(
                    Id = leadRecord.Id,
                    OwnerId = ownerId
                ));
            }
        }

        if (!leadsToUpdate.isEmpty()) {
            Boolean previousSkipTriggerValue = RecursiveTriggerHandler.skipTrigger;
            try {
                RecursiveTriggerHandler.skipTrigger = true;
                update leadsToUpdate;
            } finally {
                RecursiveTriggerHandler.skipTrigger = previousSkipTriggerValue;
            }
        }
    }

    private static String normalizeSchoolCode(String schoolCode) {
        return String.isBlank(schoolCode) ? null : schoolCode.toUpperCase().replaceAll('\\s+', '');
    }
}
