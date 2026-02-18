public class UpdateLeadOwnerQueueable implements Queueable {

    private Task t;

    public UpdateLeadOwnerQueueable(Task task) {
        this.t = task;
    }

    public void execute(QueueableContext context) {

        if (t == null) {
            return;
        }

        if (new List<String>{'Missed','NA','None','Done','Customer Missed','NO_ANSWER','User Disconnected','Unanswered','NOT ANSWERED', 'Fail', null}.contains(t.Call_Status__c)) {

            Lead leadForNotify = [
                SELECT Id, OwnerId
                FROM Lead
                WHERE Id = :t.WhoId
                LIMIT 1
            ];

            CustomNotificationType notificationType = [
                SELECT Id
                FROM CustomNotificationType
                WHERE DeveloperName = 'Missed_Call_Notification'
                LIMIT 1
            ];

            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle('Missed Call');
            notification.setBody('Missed call from a customer, please follow up.');
            notification.setNotificationTypeId(notificationType.Id);
            notification.setSenderId(UserInfo.getUserId());
            notification.setTargetId(t.Id);

            Set<String> recipients = new Set<String>{ String.valueOf(leadForNotify.OwnerId) };
            notification.send(recipients);

            return;
        }

        if (t.WhoId == null || 
            !String.valueOf(t.WhoId).startsWith('00Q') ||
            t.Subject == null || 
            !t.Subject.startsWith('CTI')) {
            return;
        }

        List<Task> relatedTasks = [
            SELECT Id
            FROM Task
            WHERE WhoId = :t.WhoId
            AND Subject LIKE 'CTI%'
            AND Call_Status__c NOT IN ('Missed','NA','None','Done','Customer Missed','NO_ANSWER','User Disconnected','Unanswered','NOT ANSWERED', 'Fail', null)
        ];

        if (relatedTasks.size() > 1) {
            return;
        }

        Lead leadToUpdate = [
            SELECT Id, OwnerId
            FROM Lead
            WHERE Id = :t.WhoId
            LIMIT 1
        ];

        if (leadToUpdate.OwnerId != t.OwnerId) {
            leadToUpdate.OwnerId = t.OwnerId;
            update leadToUpdate;
        }
    }
}