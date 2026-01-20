import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import re_sch_getContactName from '@salesforce/apex/CalledForInteractionOnlineController_LWC.re_sch_getContactName';
import getSubjectPicklistValues from '@salesforce/apex/CalledForInteractionOnlineController_LWC.getSubjectPicklistValues';
import getLeadUser from '@salesforce/apex/CalledForInteractionOnlineController_LWC.getLeadUser';
import observationRescheduled from '@salesforce/apex/CalledForInteractionOnlineController_LWC.observationRescheduled';
import { CurrentPageReference } from 'lightning/navigation';


export default class CalledForInteractionOnline_LWC extends NavigationMixin(LightningElement) {

    @api recordId;
    @api schoolShortCode;
    @api interactionSchedule;
    @api interactionreSchedule;
    isLoading = false;
    contactName;
    subjectOptions = [];
    userOptions = [];
    selectedSubject = '';
    selectedUserId;
    selectedUserName;
    errorMessage = '';
    showEventInformation = true;
    showBackButton = false;

    eventRecord = {
        Subject: '',
        StartDateTime: '',
        EndDateTime: '',
        Description: '',
        OwnerId: ''
    };

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.recordId = currentPageReference?.state?.recordId;
        //if (this.recordId) this.fetchContactName();
        console.error(' this.recordId:',  this.recordId);
    }

    connectedCallback() {
        console.log('connectedCallback called');
        this.fetchSubjectPicklistValues();
        this.fetchContactName();
        this.fetchLeadUser();
            
    }
    fetchContactName() { 
        re_sch_getContactName({ AdmissioFormId: this.recordId })
            .then(result => {
                console.log('result-->',JSON.stringify(result));
                
                this.admissioformName = result.AdmissioFormName;
                this.contactName = result.ContactName;
                this.schoolName = result.SchoolName;
                this.schoolid = result.Schoolid;
                this.schoolShortCode = result.SchoolShortCode;
                this.interactionSchedule = result.interactionSchedule;
                this.interactionreSchedule = result.interactionre_Schedule;
                console.log('this.schoolShortCode:', this.schoolShortCode);
    
                if (!result.interactionSchedule) {
                    this.showToast('Error', 'Please Schedule Interaction First.', 'error');
                    this.interactionSchedule = result.interactionSchedule;
                    console.error('this.interactionSchedule', this.interactionSchedule);
                }else if (result.interactionre_Schedule) {
                    this.showToast('Error', 'Interaction is already re-scheduled', 'error');
                    this.interactionreSchedule = result.interactionre_Schedule;
                    console.error('this.interactionSchedule', this.interactionreSchedule);
                } else {
                    // Call fetchLeadUser only after schoolShortCode is set
                    this.fetchLeadUser();
                }
            })
            .catch(error => {
                console.error('Error fetching contact info:', error);
                this.showToast('Error', 'Failed to fetch contact info.', 'error');
            });
    }

    fetchSubjectPicklistValues() {
        getSubjectPicklistValues()
            .then(result => {
                this.subjectOptions = result.map(value => ({ label: value, value: value }));
            })
            .catch(error => {
                this.showToast('Error', 'Failed to fetch picklist values.', 'error');
            });
    }
    fetchLeadUser() {
        console.log('fetchLeadUser schoolShortCode:', this.schoolShortCode);
    
        if (!this.schoolShortCode) {
            console.error('School Short Code is undefined or empty.');
            return;
        }
    
        getLeadUser({ schoolShortCode: this.schoolShortCode })
            .then(result => {
                console.log('Lead User:', result);
                this.userOptions = result.map(user => ({ label: user.Name, value: user.Id }));
                console.log('Lead this.userOptions', this.userOptions);
                // Process the result as needed
            })
            .catch(error => {
                console.error('Error fetching lead user:', error);
                // Handle the error
            });
    }

    handleInputChange(event) {
        const fieldName = event.target.name; // Get the name of the field
        const fieldValue = event.target.value; // Get the value entered by the user
    
        // Update the corresponding field in the eventRecord object
        this.eventRecord = { ...this.eventRecord, [fieldName]: fieldValue };
    }
    
    handleSubjectSelect(event) {
        this.selectedSubject = event.detail.value;
        this.eventRecord.Subject = this.selectedSubject;
        console.error(' this.selectedSubject.', this.selectedSubject);
    }

    handleUserSelect(event) {
        this.selectedUserId = event.detail.value;
        const selectedOption = this.userOptions.find(option => option.value === this.selectedUserId);
        this.selectedUserName = selectedOption ? selectedOption.label : null;
        this.eventRecord.OwnerId = this.selectedUserId;
    }

    handleSubmit() {
        // if (!this.selectedSubject || !this.eventRecord.StartDateTime || !this.eventRecord.EndDateTime) {
        //     this.showToast('Error', 'All fields are required.', 'error');
        //     return;
        // }

        console.error('this.interactionSchedule-->', this.interactionSchedule);
        console.error(' this.selectedSubject.', this.selectedSubject);
        console.error(' this.eventRecord.StartDateTime.', this.eventRecord.StartDateTime);
        console.error('this.eventRecord.Description', this.eventRecord.Description);
        console.error('this.schoolid', this.schoolid);
        console.error('this.contactId', this.contactId);
        console.error('this.schoolShortCode', this.schoolShortCode);
        console.error('this.selectedUserId', this.selectedUserId);
        

        observationRescheduled({
            startDateTime: this.eventRecord.StartDateTime,
            endDateTime: this.eventRecord.EndDateTime,
            admissionFormId: this.recordId,
            subject: this.selectedSubject
        })
            .then(result => {
                this.showToast('Success', result, 'success');
                this.resetForm();
                console.error('this.recordid', this.recordId);
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.recordId, // Replace with the actual record ID or a dynamic ID
                        objectApiName: 'Enquiry__c', // Replace with the correct object API name
                        actionName: 'view'
                    }
                });

                setTimeout(()=>{
                    window.location.reload();
                }, 1500);
            })
            .catch(error => {
                console.error('Error creating event:', error);
                this.showToast('Error', 'Failed to create event.', 'error');
            });

    }


    resetForm() {
        this.eventRecord = { Subject: '', StartDateTime: '', EndDateTime: '', Description: '', OwnerId: '' };
    }


    handleCancel() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}