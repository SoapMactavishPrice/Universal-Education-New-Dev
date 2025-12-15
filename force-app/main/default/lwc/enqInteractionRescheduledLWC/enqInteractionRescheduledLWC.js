import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
// import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import re_schgetEnquiryName from '@salesforce/apex/enqInteractionController_LWC.re_schgetEnquiryName';
import getSubjectPicklistValues from '@salesforce/apex/enqInteractionController_LWC.getSubjectPicklistValues';
import getLeadUser from '@salesforce/apex/enqInteractionController_LWC.getLeadUser';
import createEvent from '@salesforce/apex/enqInteractionController_LWC.interactionOnlineRescheduled';

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
    re_schgetEnquiryName({ enquiryId: this.recordId })
        .then(result => {
            console.log('result re_schgetEnquiryName', JSON.stringify(result));

            this.enquiryName = result.EnquiryName;
            this.contactId = result.EnquiryContact;
            this.schoolName = result.SchoolName;
            this.schoolid = result.Schoolid;
            this.schoolShortCode = result.SchoolShortCode;
            this.schoolTourScheduled = result.SchoolTourScheduled;
            this.re_SchoolTourScheduled = result.SchoolTourre_Scheduled;
            this.interactionRescheduled = result.InteractionRescheduled;  // New field from Apex

            console.log('SchoolTourre_Scheduled-->', this.re_SchoolTourScheduled);
            console.log('InteractionRescheduled-->', this.interactionRescheduled);

            // Check if Interaction has already been scheduled or rescheduled
            if (this.re_SchoolTourScheduled) {
                this.showToast('Error', 'Called For Interaction at School is already scheduled.', 'error');
                console.error('School Tour Interaction already scheduled');
            } else if (this.interactionRescheduled) {
                // Check if Interaction has already been rescheduled
                this.showToast('Error', 'Interaction is already Rescheduled.', 'error');
                console.error('Interaction is already Rescheduled');
            } else {
                this.fetchLeadUser();  // Continue with next logic if neither scheduled nor rescheduled
            }
        })
        .catch(error => {
            console.error('Error fetching contact info:', error);
            this.showToast('Error', 'Failed to fetch contact info.', 'error');
        });
}

    // fetchEnquiryName() { 
    //     re_schgetEnquiryName({ enquiryId: this.recordId })
    //         .then(result => {
    //             console.log('result re_schgetEnquiryName',JSON.stringify(result));
                
    //             this.enquiryName = result.EnquiryName;
    //             this.contactId = result.EnquiryContact;
    //             this.schoolName = result.SchoolName;
    //             this.schoolid = result.Schoolid;
    //             this.schoolShortCode = result.SchoolShortCode;
    //             this.schoolTourScheduled = result.SchoolTourScheduled;
    //             this.re_SchoolTourScheduled = result.SchoolTourre_Scheduled;
    //             console.log('schoolTourre_Scheduled-->',this.re_SchoolTourScheduled);
                
    //             if (result.schoolTourre_Scheduled) {
    //                 this.showToast('Error', 'Called For Interaction at School is already scheduled.', 'error');
    //                 console.error('this.schoolTourre_Scheduled', this.SchoolTourre_Scheduled);
    //             } else {
    //                 this.fetchLeadUser();
    //             }
                
    //         })
    //         .catch(error => {
    //             console.error('Error fetching contact info:', error);
    //             this.showToast('Error', 'Failed to fetch contact info.', 'error');
    //         });
    // }
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
        

        createEvent({
            enquiryId: this.recordId,
            subject: this.selectedSubject,
            startDateTime: this.eventRecord.StartDateTime,
            endDateTime: this.eventRecord.EndDateTime,
            ownerId: this.eventRecord.OwnerId,
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