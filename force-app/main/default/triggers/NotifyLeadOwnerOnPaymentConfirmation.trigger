trigger NotifyLeadOwnerOnPaymentConfirmation on Admission_Granted__c (after update) {
    // Collect Lead Owner IDs to notify
    Set<Id> leadOwnerIds = new Set<Id>();

    // Iterate through each updated Admission_Granted__c record
    for (Admission_Granted__c admission : Trigger.new) {
        // Get the old version of the record
        Admission_Granted__c oldAdmission = Trigger.oldMap.get(admission.Id);

        // Check if Payment_Confirmed__c was changed from false to true
        if (!oldAdmission.Payment_Confirmed__c && admission.Payment_Confirmed__c) {
            // Retrieve the related Lead record
            if (admission.Lead__c != null) {
                Lead relatedLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :admission.Lead__c LIMIT 1];
                if (relatedLead != null && relatedLead.OwnerId != null) {
                    leadOwnerIds.add(relatedLead.OwnerId);
                }
            }
        }
    }

    // Send custom notification if there are any Lead Owners to notify
    if (!leadOwnerIds.isEmpty()) {
        // Retrieve the Custom Notification Type ID
        CustomNotificationType notificationType = [
            SELECT Id
            FROM CustomNotificationType
            WHERE DeveloperName = 'Payment_Received_Notification'
            LIMIT 1
        ];

        if (notificationType != null) {
            // Create a new custom notification
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle('Payment Confirmed');
            notification.setBody('A payment has been confirmed for your Lead.');
            notification.setNotificationTypeId(notificationType.Id);
            notification.setSenderId(UserInfo.getUserId());
            // Assuming you want to link to the first Admission_Granted__c record
            notification.setTargetId(Trigger.new[0].Id);

            // Convert Set<Id> to Set<String>
            Set<String> recipientIds = new Set<String>();
            for (Id leadOwnerId : leadOwnerIds) {
                recipientIds.add(leadOwnerId);
            }

            // Send the notification to all collected Lead Owners
            notification.send(recipientIds);
        }
    }
}