trigger LeadFieldsTrigger on Lead (before insert, before update) {
    // Check if the trigger is running in the 'before insert' or 'before update' context
    if (Trigger.isBefore) {
        // Call the handler method to update the fields
        LeadFieldsHandler.updateSchoolFields(Trigger.new, Trigger.oldMap);
    }
}



/*trigger LeadFieldsTrigger on Lead (before insert, before update) {

    // Check if the trigger is running in the 'before insert' or 'before update' context
    if (Trigger.isBefore) {
        // Call the handler method to update the fields
        LeadFieldsHandler.updateSchoolFields(Trigger.new, Trigger.oldMap);
    }

} */
/*trigger UpdateSchoolFieldsTrigger on Lead (before update) {

    // Check if the trigger is running in the 'before update' context
    if (Trigger.isBefore && Trigger.isUpdate) {
        // Call the handler method to update the fields
        UpdateSchoolFieldsHandler.updateSchoolFields(Trigger.new, Trigger.oldMap);
    }

}*/







/*
trigger UpdateSchoolShortCodeTrigger on Lead (before insert, before update) {
    // Call the handler method to handle the logic
    UpdateSchoolShortCodeHandler.updateSchoolShortCode(Trigger.new);
}
*/