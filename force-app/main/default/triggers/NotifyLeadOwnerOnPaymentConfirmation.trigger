trigger NotifyLeadOwnerOnPaymentConfirmation on Admission_Granted__c (after update) {

    Set<Id> admissionOwnerIds = new Set<Id>();

    for (Admission_Granted__c admission : Trigger.new) {
        Admission_Granted__c oldAdmission = Trigger.oldMap.get(admission.Id);

        if (!oldAdmission.Payment_Confirmed__c && admission.Payment_Confirmed__c) {
            if (admission.OwnerId != null) {
                admissionOwnerIds.add(admission.OwnerId);
            }
        }
    }

    if (!admissionOwnerIds.isEmpty()) {

        CustomNotificationType notificationType = [
            SELECT Id
            FROM CustomNotificationType
            WHERE DeveloperName = 'Payment_Received_Notification'
            LIMIT 1
        ];

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle('Payment Confirmed');
        notification.setBody('Payment posted, review the updated Admission Granted.');
        notification.setNotificationTypeId(notificationType.Id);
        notification.setSenderId(UserInfo.getUserId());
        notification.setTargetId(Trigger.new[0].Id);

        Set<String> recipientIds = new Set<String>();
        for (Id ownerId : admissionOwnerIds) {
            recipientIds.add(ownerId);
        }

        notification.send(recipientIds);
    }
}