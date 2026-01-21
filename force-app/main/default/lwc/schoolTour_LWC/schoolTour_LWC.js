import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
// import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import getEnquiryName from '@salesforce/apex/SchoolTourController_LWC.getEnquiryName';
import getSubjectPicklistValues from '@salesforce/apex/SchoolTourController_LWC.getSubjectPicklistValues';
import getLeadUser from '@salesforce/apex/SchoolTourController_LWC.getLeadUser';
import createEventLWC from '@salesforce/apex/SchoolTourController_LWC.createEventLWC';

export default class SchoolTour_LWC extends NavigationMixin(LightningElement) {

    showEventInformation = true;
    @api recordId;
    @api schoolShortCode;
    @track SchoolTourScheduled;
    @track isLoading = false;
    

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
        if (this.recordId) this.fetchEnquiryName();

        // Correctly logging the value of recordId
        console.error('this.recordId', this.recordId);
    }

    connectedCallback() {
        console.log('connectedCallback called');
        this.fetchSubjectPicklistValues();
        this.fetchEnquiryName();
        this.fetchLeadUser();
        console.error('this.recordid', this.recordId);
        // this.template.addEventListener('close', () => {
        //     console.log('Close event received.');
        // });
            
    }
    fetchEnquiryName() { 
        getEnquiryName({ enquiryId: this.recordId })
            .then(result => {
                console.log('result',JSON.stringify(result));
                
                this.enquiryName = result.EnquiryName;
                this.contactId = result.EnquiryContact;
                this.schoolName = result.SchoolName;
                this.schoolid = result.Schoolid;
                this.schoolShortCode = result.SchoolShortCode;
                this.SchoolTourScheduled = result.SchoolTourScheduled;
                console.log('schoolTourScheduled-->',this.SchoolTourScheduled);
                
                if (result.SchoolTourScheduled) {
                    this.showToast('Error', 'Meet at School already scheduled.', 'error');
                    console.error('this.schoolTourScheduled', this.SchoolTourScheduled);
                } else {
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
                console.log('Lead User:', JSON.stringify(result));
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
        console.log('this.eventRecord', JSON.parse(JSON.stringify(this.eventRecord)));
        if (!this.validateEventDates()) {
            return; // stop execution if dates are invalid
        }
        this.isLoading = true;
        // if (!this.selectedSubject || !this.eventRecord.StartDateTime || !this.eventRecord.EndDateTime) {
        //     this.showToast('Error', 'All fields are required.', 'error');
        //     return;
        // }

        console.error('this.SchoolTourScheduled-->', this.SchoolTourScheduled);
        console.error(' this.selectedSubject.', this.selectedSubject);
        console.error(' this.eventRecord.StartDateTime.', this.eventRecord.StartDateTime);
        console.error('this.eventRecord.Description', this.eventRecord.Description);
        console.error('this.schoolid', this.schoolid);
        console.error('this.contactId', this.contactId);
        console.error('this.schoolShortCode', this.schoolShortCode);
        console.error('this.selectedUserId', this.selectedUserId);
        console.log('this.eventRecord.OwnerId', this.eventRecord.OwnerId);

        createEventLWC({
            enquiryId: this.recordId,
            ownerId: this.eventRecord.OwnerId,
            subject: this.selectedSubject,
            startDateTime: this.eventRecord.StartDateTime,
            endDateTime: this.eventRecord.EndDateTime,
            description: this.eventRecord.Description,
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
                setTimeout(() => {
                    window.location.reload();
                }, 1500)
            })
            .catch(error => {
                this.isLoading = false;
                console.error('Error creating event:', error);
                this.showToast('Error', 'Failed to create event.', 'error');
            });

    }
    handleCancel() {
        // Programmatically close the quick action modal
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId, // Replace with the actual record ID or a dynamic ID
                objectApiName: 'Enquiry__c', // Replace with the correct object API name
                actionName: 'view'
            }
        });
        console.log('Quick action panel closed.');
    }
    
    showToast(title, message, variant) {
        const event = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(event);
    }
    resetForm() {
        this.eventRecord = { Subject: '', StartDateTime: '', EndDateTime: '', Description: '', OwnerId: '' };
    }

    validateEventDates() {
        const { StartDateTime, EndDateTime } = this.eventRecord;

        if (!StartDateTime || !EndDateTime) {
            this.showToast('Error', 'Both Start and End dates are required.', 'error');
            return false;
        }

        const today = new Date();
        today.setHours(0, 0, 0, 0); // ignore time for comparison

        const startDate = new Date(StartDateTime);
        const endDate = new Date(EndDateTime);

        if (startDate < today) {
            this.showToast('Error', 'Start date cannot be in the past.', 'error');
            return false;
        }

        if (endDate < today) {
            this.showToast('Error', 'End date cannot be in the past.', 'error');
            return false;
        }

        if (endDate < startDate) {
            this.showToast('Error', 'End date cannot be before Start date.', 'error');
            return false;
        }

        return true; // dates are valid
    }



}