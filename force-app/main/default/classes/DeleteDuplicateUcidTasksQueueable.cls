public class DeleteDuplicateUcidTasksQueueable implements Queueable {

    private Task t;

    public DeleteDuplicateUcidTasksQueueable(Task task) {
        this.t = task;
    }

    public void execute(QueueableContext context) {

        if (t == null || String.isBlank(t.MonitorUcid__c)) {
            return;
        }

        if (t.WhoId == null || t.WhoId.getSObjectType() != Lead.SObjectType) {
            return;
        }

        List<Task> duplicateTasks = [
            SELECT Id, WhoId
            FROM Task
            WHERE MonitorUcid__c = :t.MonitorUcid__c
            AND Id != :t.Id
            AND WhoId = :t.WhoId
        ];

        List<Task> tasksToDelete = new List<Task>();
        for (Task tsk : duplicateTasks) {
            if (tsk.WhoId != null && String.valueOf(tsk.WhoId).startsWith('00Q')) {
                tasksToDelete.add(tsk);
            }
        }

        if (!tasksToDelete.isEmpty()) {
            delete tasksToDelete;
        }
    }
}