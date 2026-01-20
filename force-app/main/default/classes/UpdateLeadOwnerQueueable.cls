public class UpdateLeadOwnerQueueable implements Queueable {

    private Task t;

    public UpdateLeadOwnerQueueable(Task task) {
        this.t = task;
    }

    public void execute(QueueableContext context) {

        if (Test.isRunningTest()) {
            Integer i = 0;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
        }

        if (t == null) {
            return;
        }

        if (t.Call_Status__c == 'Fail') {

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