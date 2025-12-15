trigger MarketingCloudHistoryTrigger on Marketing_Cloud_History__c (after insert) {
MarketingCloudHistoryhandler.insertMarketingCloudHistory(Trigger.new);
}