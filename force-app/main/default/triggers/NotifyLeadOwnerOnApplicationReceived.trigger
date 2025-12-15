trigger NotifyLeadOwnerOnApplicationReceived on Application_Form__c (after update) {
    // Collect Lead Owner IDs to notify
    Set<String> leadOwnerIds = new Set<String>();
    System.debug('Trigger execution started. Processing records.');

    // Iterate through each updated Application_Form__c record
    for (Application_Form__c appForm : Trigger.new) {
        // Get the old version of the record
        Application_Form__c oldAppForm = Trigger.oldMap.get(appForm.Id);
        System.debug('Processing Application_Form__c record with Id: ' + appForm.Id);

        // Check if Application_Received__c was changed from false to true
        if (!oldAppForm.Print_Copy_Submitted__c && appForm.Print_Copy_Submitted__c) {
            System.debug('Print_Copy_Submitted__c changed from false to true for record Id: ' + appForm.Id);

            // Retrieve the related Lead record
            if (appForm.Lead__c != null) {
                System.debug('Fetching Lead with Id: ' + appForm.Lead__c);
                Lead relatedLead = [SELECT Id, OwnerId FROM Lead WHERE Id = :appForm.Lead__c LIMIT 1];
                if (relatedLead != null && relatedLead.OwnerId != null) {
                    System.debug('Found Lead Owner with Id: ' + relatedLead.OwnerId);
                    leadOwnerIds.add(relatedLead.OwnerId);
                } else {
                    System.debug('No Lead Owner found for Lead Id: ' + appForm.Lead__c);
                }
            } else {
                System.debug('No Lead associated with Application_Form__c record Id: ' + appForm.Id);
            }
        } else {
            System.debug('Print_Copy_Submitted__c did not change from false to true for record Id: ' + appForm.Id);
        }
    }

    // Send custom notification if there are any Lead Owners to notify
    if (!leadOwnerIds.isEmpty()) {
        System.debug('Lead Owners to notify: ' + leadOwnerIds);
        // Retrieve the Custom Notification Type ID
        CustomNotificationType notificationType = [
            SELECT Id
            FROM CustomNotificationType
            WHERE DeveloperName = 'Application_Form_Received_Notification'
            LIMIT 1
        ];

        if (notificationType != null) {
            System.debug('CustomNotificationType found with Id: ' + notificationType.Id);
            // Create a new custom notification
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle('Application Received');
            notification.setBody('An application has been received for your Lead.');
            notification.setNotificationTypeId(notificationType.Id);
            notification.setSenderId(UserInfo.getUserId());
            // Assuming you want to link to the first Application_Form__c record
            notification.setTargetId(Trigger.new[0].Id);

            // Send the notification to all collected Lead Owners
            notification.send(leadOwnerIds);
            System.debug('Custom notification sent to Lead Owners.');
        } else {
            System.debug('CustomNotificationType with DeveloperName \'pushNotification\' not found.');
        }
    } else {
        System.debug('No Lead Owners to notify.');
    }
    System.debug('Trigger execution completed.');
}