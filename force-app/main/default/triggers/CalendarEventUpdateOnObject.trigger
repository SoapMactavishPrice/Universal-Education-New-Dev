/**
* Trigger      : CalendarEventUpdateOnObject
* Classes      : CalendarEventUpdateOnObjectCtrl,Test_CalendarEventUpdateOnObjectCtrl
* Devloper     : Raj
* Created Date : 
 */
trigger CalendarEventUpdateOnObject on Event (after insert) {
    Trigger_Switch__mdt Trigger_Switch = Trigger_Switch__mdt.getInstance('Calendar_Event');
    if (Trigger_Switch.IsActive__c == true) {
        CalendarEventUpdateOnObjectCtrl.CalendarEventTriggerAftInsert(Trigger.new,Trigger.isAfter,Trigger.isInsert);
    }
}