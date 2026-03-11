trigger AssignLeadOwner on Lead (before insert, before update) {
    AssignLeadOwnerHandler.assignOwners(
        Trigger.new,
        Trigger.isUpdate ? Trigger.oldMap : null
    );
}
