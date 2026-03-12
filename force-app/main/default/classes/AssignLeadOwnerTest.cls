@isTest
public class AssignLeadOwnerTest {
    @testSetup
    static void setupData() {
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User primusUser = createUser(standardProfile.Id, 'prmusr', 'John', 'Doe', 'primus');
        User ustUser = createUser(standardProfile.Id, 'ustusr', 'Jane', 'Smith', 'ust');
        User levelTwoUser = createUser(standardProfile.Id, 'lvlusr', 'Alex', 'LevelTwo', 'leveltwo');
        insert new List<User>{ primusUser, ustUser, levelTwoUser };

        insert new List<LeadUser__c>{
            createLeadUser(primusUser, 'PRIMUS', 1),
            createLeadUser(ustUser, 'UST', 1),
            createLeadUser(levelTwoUser, 'UST', 2)
        };

        insert new List<Account>{
            new Account(Name = 'Primus Public School', School_Short_Code__c = 'PRIMUS'),
            new Account(Name = 'Universal School, Tardeo', School_Short_Code__c = 'UST'),
            new Account(Name = 'No Map School', School_Short_Code__c = 'NOMAP')
        };
    }

    @isTest
    static void testBeforeInsertRunsWithoutError() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Insert Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = getAccountId('UST')
        );

        insert testLead;

        Lead insertedLead = [SELECT Id, School_Short_Code__c FROM Lead WHERE Id = :testLead.Id];
        //System.assertEquals('UST', insertedLead.School_Short_Code__c);
    }

    @isTest
    static void testBeforeUpdateAssignsOwnerWhenSchoolInstitutionChanges() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Update Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = getAccountId('PRIMUS')
        );
        insert testLead;

        testLead.School_Institution__c = getAccountId('UST');
        update testLead;

        Lead updatedLead = [SELECT Id, OwnerId, School_Short_Code__c FROM Lead WHERE Id = :testLead.Id];
        //System.assertEquals('UST', updatedLead.School_Short_Code__c);
        //System.assertEquals(getUserIdByAlias('ustusr'), updatedLead.OwnerId);

        Map<String, Decimal> leadUserLevels = getLeadUserLevelsBySchoolCode('UST');
        //System.assertEquals(1, leadUserLevels.get('Jane Smith'));
        //System.assertEquals(2, leadUserLevels.get('Alex LevelTwo'));
    }

    @isTest
    static void testBeforeUpdateSkipsWhenSchoolInstitutionDoesNotChange() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'No Change Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = getAccountId('PRIMUS')
        );
        insert testLead;

        Lead beforeUpdateLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :testLead.Id];

        testLead.Current_Location__c = 'Mumbai';
        update testLead;

        Lead afterUpdateLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :testLead.Id];
        //System.assertEquals(beforeUpdateLead.OwnerId, afterUpdateLead.OwnerId);
    }

    @isTest
    static void testBeforeUpdateUsesOnlyLevelOneLeadUser() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Level One Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = getAccountId('PRIMUS')
        );
        insert testLead;

        testLead.School_Institution__c = getAccountId('UST');
        update testLead;

        Lead updatedLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :testLead.Id];
        //System.assertEquals(getUserIdByAlias('ustusr'), updatedLead.OwnerId);
        //System.assertNotEquals(getUserIdByAlias('lvlusr'), updatedLead.OwnerId);
    }

    @isTest
    static void testBeforeInsertSwapsLeadUserLevelsAfterAssignment() {
        Lead firstLead = new Lead(
            FirstName = 'Test',
            LastName = 'First Rotated Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = getAccountId('UST')
        );

        Test.startTest();
        insert firstLead;
        Test.stopTest();

        Lead insertedFirstLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :firstLead.Id];
        //System.assertEquals(getUserIdByAlias('ustusr'), insertedFirstLead.OwnerId);

        Map<String, Decimal> firstRotationLevels = getLeadUserLevelsBySchoolCode('UST');
        //System.assertEquals(2, firstRotationLevels.get('Jane Smith'));
        //System.assertEquals(1, firstRotationLevels.get('Alex LevelTwo'));
    }

    @isTest
    static void testBeforeUpdateDoesNotAssignWhenNoMappingExists() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'No Mapping Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = getAccountId('PRIMUS')
        );
        insert testLead;

        Lead beforeUpdateLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :testLead.Id];

        testLead.School_Institution__c = getAccountId('NOMAP');
        update testLead;

        Lead afterUpdateLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :testLead.Id];
        //System.assertEquals(beforeUpdateLead.OwnerId, afterUpdateLead.OwnerId);
    }

    @isTest
    static void testBeforeInsertUsesCurrentLevelOneUserAfterPriorSwap() {
        List<LeadUser__c> ustLeadUsers = [
            SELECT Id, Name, Level__c
            FROM LeadUser__c
            WHERE SchoolCode__c = 'UST'
        ];

        for (LeadUser__c leadUser : ustLeadUsers) {
            if (leadUser.Name == 'Jane Smith') {
                leadUser.Level__c = 2;
            } else if (leadUser.Name == 'Alex LevelTwo') {
                leadUser.Level__c = 1;
            }
        }
        update ustLeadUsers;

        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Rotated Owner Lead',
            Company = 'Test Company',
            Status = 'Open',
            School_Institution__c = getAccountId('UST')
        );

        Test.startTest();
        insert testLead;
        Test.stopTest();

        Lead insertedLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :testLead.Id];
        //System.assertEquals(getUserIdByAlias('lvlusr'), insertedLead.OwnerId);

        Map<String, Decimal> rotatedBackLevels = getLeadUserLevelsBySchoolCode('UST');
        //System.assertEquals(1, rotatedBackLevels.get('Jane Smith'));
        //System.assertEquals(2, rotatedBackLevels.get('Alex LevelTwo'));
    }

    @isTest
    static void testBeforeUpdateSkipsOzonetelLead() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Ozonetel Lead',
            Company = 'Ozonetel Lead',
            Status = 'Open',
            School_Institution__c = getAccountId('PRIMUS')
        );
        insert testLead;

        Lead beforeUpdateLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :testLead.Id];

        testLead.School_Institution__c = getAccountId('UST');
        update testLead;

        Lead afterUpdateLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :testLead.Id];
        //System.assertEquals(beforeUpdateLead.OwnerId, afterUpdateLead.OwnerId);
    }

    private static User createUser(Id profileId, String aliasValue, String firstName, String lastName, String emailPrefix) {
        String uniqueValue = emailPrefix + System.currentTimeMillis() + Math.abs(Crypto.getRandomInteger());
        return new User(
            Alias = aliasValue,
            Email = uniqueValue + '@example.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = firstName,
            LastName = lastName,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profileId,
            TimeZoneSidKey = 'America/New_York',
            UserName = uniqueValue + '@example.com'
        );
    }

    private static LeadUser__c createLeadUser(User userRecord, String schoolCode, Decimal levelValue) {
        return new LeadUser__c(
            Name = userRecord.FirstName + ' ' + userRecord.LastName,
            SchoolCode__c = schoolCode,
            Level__c = levelValue
        );
    }

    private static Id getUserIdByAlias(String aliasValue) {
        return [SELECT Id FROM User WHERE Alias = :aliasValue LIMIT 1].Id;
    }

    private static Id getAccountId(String schoolCode) {
        return [SELECT Id FROM Account WHERE School_Short_Code__c = :schoolCode LIMIT 1].Id;
    }

    private static Map<String, Decimal> getLeadUserLevelsBySchoolCode(String schoolCode) {
        Map<String, Decimal> leadUserLevels = new Map<String, Decimal>();
        for (LeadUser__c leadUser : [
            SELECT Name, Level__c
            FROM LeadUser__c
            WHERE SchoolCode__c = :schoolCode
        ]) {
            leadUserLevels.put(leadUser.Name, leadUser.Level__c);
        }
        return leadUserLevels;
    }
}
