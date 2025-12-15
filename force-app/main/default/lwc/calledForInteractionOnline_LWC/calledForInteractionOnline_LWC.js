import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContactName from '@salesforce/apex/CalledForInteractionOnlineController_LWC.getContactName';
import getSubjectPicklistValues from '@salesforce/apex/CalledForInteractionOnlineController_LWC.getSubjectPicklistValues';
import getLeadUser from '@salesforce/apex/CalledForInteractionOnlineController_LWC.getLeadUser';
import createEvent from '@salesforce/apex/CalledForInteractionOnlineController_LWC.createEvent';
import { CurrentPageReference } from 'lightning/navigation';


export default class CalledForInteractionOnline_LWC extends NavigationMixin(LightningElement) {

    @api recordId;
    @api schoolShortCode;
    @api interactionSchedule;
    @track isLoading = false;
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
        getContactName({ AdmissioFormId: this.recordId })
            .then(result => {
                console.log('result-->',JSON.stringify(result));
                
                this.admissioformName = result.AdmissioFormName;
                this.contactName = result.ContactName;
                this.schoolName = result.SchoolName;
                this.schoolid = result.Schoolid;
                this.schoolShortCode = result.SchoolShortCode;
                this.interactionSchedule = result.interactionSchedule;
                console.log('this.schoolShortCode:', this.schoolShortCode);
    
                if (result.interactionSchedule) {
                    this.showToast('Error', 'Interaction is already scheduled.', 'error');
                    this.interactionSchedule = result.interactionSchedule;
                    console.error('this.interactionSchedule', this.interactionSchedule);
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
        if (!this.validateEventDates()) {
            return; // stop execution if dates are invalid
        }
        // if (!this.selectedSubject || !this.eventRecord.StartDateTime || !this.eventRecord.EndDateTime) {
        //     this.showToast('Error', 'All fields are required.', 'error');
        //     return;
        // }
        this.isLoading = true;
        console.log('this.interactionSchedule-->', this.interactionSchedule);
        console.log(' this.selectedSubject.', this.selectedSubject);
        console.log(' this.eventRecord.StartDateTime.', this.eventRecord.StartDateTime);
        console.log('this.eventRecord.Description', this.eventRecord.Description);
        console.log('this.schoolid', this.schoolid);
        console.log('this.contactId', this.contactId);
        console.log('this.schoolShortCode', this.schoolShortCode);
        console.log('this.selectedUserId', this.selectedUserId);
        console.log('this.recordId', this.recordId);

        createEvent({
            subject: this.selectedSubject,
            startDateTime: this.eventRecord.StartDateTime,
            endDateTime: this.eventRecord.EndDateTime,
            description: this.eventRecord.Description,
            ownerId: this.eventRecord.OwnerId,
            admissionId: this.recordId,
            school: this.schoolid,
            interactionSchedule : this.interactionSchedule
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
                this.isLoading = false;
                console.error('Error creating event:', error);
                this.showToast('Error', error.body.message, 'error');
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