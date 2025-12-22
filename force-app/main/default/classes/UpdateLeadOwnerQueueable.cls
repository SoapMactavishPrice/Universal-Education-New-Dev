public class UpdateLeadOwnerQueueable implements Queueable {

    private Task t;

    public UpdateLeadOwnerQueueable(Task task) {
        this.t = task;
    }

    public void execute(QueueableContext context) {
        // This queueable expects only a single Task Id
        if (t == null) {
            return;
        }

        if (t == null) {
            return;
        }

        // Only process CTI Tasks related to Leads
        if (t.WhoId == null || !String.valueOf(t.WhoId).startsWith('00Q') || 
            t.Subject == null || !t.Subject.startsWith('CTI')) {
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

        // Query the lead and perform owner update if needed
        Lead leadToUpdate = [
            SELECT Id, OwnerId
            FROM Lead
            WHERE Id = :t.WhoId
            LIMIT 1
        ];

        if (leadToUpdate == null) {
            return;
        }

        if (leadToUpdate.OwnerId != t.OwnerId) {
            leadToUpdate.OwnerId = t.OwnerId;
            try {
                update leadToUpdate;
            } catch (Exception e) {
                throw e;
            }
        }
    }
}