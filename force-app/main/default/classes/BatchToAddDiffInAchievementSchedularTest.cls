@isTest
public class BatchToAddDiffInAchievementSchedularTest {

    @isTest
    static void testSchedulerExecution() {
        // Create an instance of the schedulable class
        BatchToAddDiffInAchievementSchedular schedular = new BatchToAddDiffInAchievementSchedular();

        // Schedule the job to run once
        String jobId = System.schedule(
            'TestBatchJob',
            '0 0 1 * * ?', // This cron means: 1 AM every day
            schedular
        );

        // Verify job is scheduled
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('0 0 1 * * ?', ct.CronExpression);

        // Let’s also simulate running it directly to test the batch logic
        Test.startTest();
        schedular.execute(null);
        Test.stopTest();

        // Optionally, verify the batch job was enqueued if your batch supports checking
        // (This requires implementation of logic inside BatchToAddDiffInAchievement)
    }
}