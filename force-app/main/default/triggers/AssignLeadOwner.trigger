trigger AssignLeadOwner on Lead (before insert, before update) {
    // Lead owner assignment now runs from LeadTrigger in after context.
}
