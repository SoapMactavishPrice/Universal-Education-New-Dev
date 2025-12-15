import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import reSchedule_getContactName from '@salesforce/apex/SheduleCampusController_LWC.reSchedule_getContactName';
import getSubjectPicklistValues from '@salesforce/apex/SheduleCampusController_LWC.getSubjectPicklistValues';
import getLeadUser from '@salesforce/apex/SheduleCampusController_LWC.getLeadUser';
import schoolTourRescheduled from '@salesforce/apex/SheduleCampusController_LWC.schoolTourRescheduled';
import { CurrentPageReference } from 'lightning/navigation';

export default class ReschedulecampusvisitContact extends NavigationMixin(LightningElement) {

    @api recordId;
    @api schoolShortCode;
    @api CampusvisitScheduled;
    @api Campusvisitre_Scheduled;
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
        if (this.recordId) this.fetchContactName();
    }

    connectedCallback() {
        console.log('connectedCallback called');
        this.fetchSubjectPicklistValues();
        this.fetchContactName();
        this.fetchLeadUser();
            
    }

    fetchContactName() { 
        reSchedule_getContactName({ contactId: this.recordId })
            .then(result => {
                this.contactName = result.ContactName;
                this.schoolName = result.SchoolName;
                this.schoolid = result.Schoolid;
                this.schoolShortCode = result.SchoolShortCode;
                console.log('this.schoolShortCode:', this.schoolShortCode);

                console.log('result',JSON.stringify(result));
                
                
    
                if (!result.CampusvisitScheduled) {
                    this.showToast('Error', 'Please Schedule Campus visit First', 'error');
                    this.CampusvisitScheduled = result.CampusvisitScheduled;
                    console.log('this.CampusvisitScheduled', this.CampusvisitScheduled);
                }
                if (result.Campusvisitre_Scheduled) {
                    this.showToast('Error', 'Campus visit is already re-scheduled.', 'error');
                    this.Campusvisitre_Scheduled = result.Campusvisitre_Scheduled;
                    console.log('this.Campusvisitre_Scheduled', this.Campusvisitre_Scheduled);
                } else {
                    // Call fetchLeadUser only after schoolShortCode is set
                    this.CampusvisitScheduled = result.CampusvisitScheduled;
                    this.Campusvisitre_Scheduled = result.Campusvisitre_Scheduled;
                    console.log('this.CampusvisitScheduled', this.CampusvisitScheduled);
                    console.log('this.Campusvisitre_Scheduled', this.Campusvisitre_Scheduled);
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

    handleSubmit() {
        if (!this.selectedSubject || !this.eventRecord.StartDateTime || !this.eventRecord.EndDateTime) {
            this.showToast('Error', 'All fields are required.', 'error');
            return;
        }

        // Start loading (show spinner)
        this.isLoading = true;
      
        console.error(' this.selectedSubject.', this.selectedSubject);
        console.error(' this.eventRecord.StartDateTime.', this.eventRecord.StartDateTime);
        console.error('this.eventRecord.Description', this.eventRecord.Description);
        console.error('this.schoolid', this.schoolid);
        console.error('this.recordId', this.recordId);
        console.error('this.schoolShortCode', this.schoolShortCode);
        console.error('this.selectedUserId', this.selectedUserId);
        console.log('CampusvisitScheduled', this.CampusvisitScheduled);
        console.log('Campusvisitre_Scheduled', this.Campusvisitre_Scheduled);
       
        schoolTourRescheduled({
            startDateTime: this.eventRecord.StartDateTime,
            endDateTime: this.eventRecord.EndDateTime,
            contactId: this.recordId,
            accountId: this.schoolid,
            ownerId: this.eventRecord.OwnerId
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
            })
            .catch(error => {
                console.error('Error creating event:', error);
                this.showToast('Error', error.body.message, 'error');
            })
            .finally(() => {
                // Stop loading (hide spinner)
                this.isLoading = false;
            });;
    }

    resetForm() {
        this.eventRecord = { Subject: '', StartDateTime: '', EndDateTime: '', Description: '', OwnerId: '' };
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(event);
    }
}