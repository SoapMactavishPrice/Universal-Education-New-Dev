trigger NotifyLeadOwnerOnApplicationReceived on Application_Form__c (after update) {


    Set<String> applicationOwnerIds = new Set<String>();

    System.debug('Notify Trigger Im here in NotifyLeadOwnerOnApplicationReceived trigger');

    for (Application_Form__c appForm : Trigger.new) {
        Application_Form__c oldAppForm = Trigger.oldMap.get(appForm.Id);

        if (!oldAppForm.Print_Copy_Submitted__c && appForm.Print_Copy_Submitted__c) {
            if (appForm.OwnerId != null) {
                System.debug('Notify Trigger Adding owner Id: ' + appForm.OwnerId);
                applicationOwnerIds.add(appForm.OwnerId);
            }
        }
    }

    if (!applicationOwnerIds.isEmpty()) {

        System.debug('Notify Trigger Preparing to send notification to owners: ' + applicationOwnerIds);

        CustomNotificationType notificationType = [
            SELECT Id
            FROM CustomNotificationType
            WHERE DeveloperName = 'Application_Form_Received_Notification'
            LIMIT 1
        ];

        System.debug('Notify Trigger Notification Type Id: ' + notificationType.Id);

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle('Application Received');
        notification.setBody('Application received – New application submitted.');
        notification.setNotificationTypeId(notificationType.Id);
        notification.setSenderId(UserInfo.getUserId());
        notification.setTargetId(Trigger.new[0].Id);

        notification.send(applicationOwnerIds);
    }
}
