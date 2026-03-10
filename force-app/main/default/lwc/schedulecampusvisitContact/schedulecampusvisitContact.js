import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContactName from '@salesforce/apex/SheduleCampusController_LWC.getContactName';
import getSubjectPicklistValues from '@salesforce/apex/SheduleCampusController_LWC.getSubjectPicklistValues';
import getLeadUser from '@salesforce/apex/SheduleCampusController_LWC.getLeadUser';
import createEvent from '@salesforce/apex/SheduleCampusController_LWC.createEvent';
import { CurrentPageReference } from 'lightning/navigation';

export default class ScheduleCampusVisit extends NavigationMixin(LightningElement) {
    @api recordId;
    schoolShortCode;
    campusVisitScheduled;
    isLoading = false;
    contactName;
    schoolName;
    schoolId;
    subjectOptions = [];
    userOptions = [];
    selectedSubject = '';
    showEventInformation = true;

    eventRecord = {
        Subject: '',
        StartDateTime: '',
        EndDateTime: '',
        Description: '',
        OwnerId: ''
    };

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if (!this.recordId) {
            this.recordId = currentPageReference?.state?.recordId || currentPageReference?.state?.c__recordId;
        }
        if (this.recordId) {
            this.fetchContactName();
        }
    }

    connectedCallback() {
        this.fetchSubjectPicklistValues();
        if (this.recordId) {
            this.fetchContactName();
        }
    }

    fetchContactName() {
        getContactName({ contactId: this.recordId })
            .then(result => {
                this.contactName = result.ContactName;
                this.schoolName = result.SchoolName;
                this.schoolId = result.SchoolId;
                this.schoolShortCode = result.SchoolShortCode;

                if (result.CampusVisitScheduled) {
                    this.showEventInformation = false;
                    this.showToast('Error', 'Scheduled Campus Visit already booked.', 'error');
                } else {
                    this.showEventInformation = true;
                    this.fetchLeadUser();
                }
            })
            .catch(error => {
                this.showToast('Error', 'Failed to fetch contact info.', 'error');
                this.showEventInformation = false;
            });
    }

    fetchSubjectPicklistValues() {
        getSubjectPicklistValues()
            .then(result => {
                this.subjectOptions = result.map(value => ({ label: value, value: value }));
            })
            .catch(() => {
                this.showToast('Error', 'Failed to fetch picklist values.', 'error');
            });
    }

    fetchLeadUser() {
        if (!this.schoolShortCode) {
            return;
        }

        getLeadUser({ schoolShortCode: this.schoolShortCode })
            .then(result => {
                this.userOptions = result.map(user => ({ label: user.Name, value: user.Id }));
            })
            .catch(() => {
                this.showToast('Error', 'Failed to fetch users.', 'error');
            });
    }

    handleInputChange(event) {
        const fieldName = event.target.name;
        const fieldValue = event.target.value;
        this.eventRecord = { ...this.eventRecord, [fieldName]: fieldValue };
    }

    handleSubjectSelect(event) {
        this.selectedSubject = event.detail.value;
        this.eventRecord.Subject = this.selectedSubject;
    }

    handleUserSelect(event) {
        this.eventRecord.OwnerId = event.detail.value;
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

    get cancelLabel() {
        return this.showEventInformation ? 'Cancel' : 'Back';
    }

    handleSubmit() {
        if (!this.showEventInformation) {
            this.showToast('Error', 'Scheduled Campus Visit already booked.', 'error');
            return;
        }

        if (
            !this.eventRecord.Subject ||
            !this.eventRecord.StartDateTime ||
            !this.eventRecord.EndDateTime ||
            !this.eventRecord.OwnerId
        ) {
            this.showToast('Error', 'All fields are required.', 'error');
            return;
        }

        if (!this.validateEventDates()) {
            return;
        }

        this.isLoading = true;

        createEvent({
            subject: this.eventRecord.Subject,
            startDateTime: this.eventRecord.StartDateTime,
            endDateTime: this.eventRecord.EndDateTime,
            description: this.eventRecord.Description,
            contactId: this.recordId,
            accountId: this.schoolId,
            ownerId: this.eventRecord.OwnerId,
        })
            .then(result => {
                this.showToast('Success', result, 'success');
                this.resetForm();
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.recordId,
                        objectApiName: 'Contact',
                        actionName: 'view'
                    }
                });
            })
            .catch(error => {
                const message = error?.body?.message || 'Unable to schedule campus visit.';
                this.showToast('Error', message, 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    resetForm() {
        this.eventRecord = { Subject: '', StartDateTime: '', EndDateTime: '', Description: '', OwnerId: '' };
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(event);
    }

    validateEventDates() {
        const { StartDateTime, EndDateTime } = this.eventRecord;

        if (!StartDateTime || !EndDateTime) {
            this.showToast('Error', 'Both Start and End dates are required.', 'error');
            return false;
        }

        const today = new Date();
        today.setHours(0, 0, 0, 0);

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

        return true;
    }
}
