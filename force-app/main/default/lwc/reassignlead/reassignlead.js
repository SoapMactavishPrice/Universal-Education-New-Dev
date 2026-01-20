import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation'; 
import { NavigationMixin } from 'lightning/navigation'; 
import getSchoolOptionslist from '@salesforce/apex/reassignLeadController.getSchoolOptionslist';
import saveLead from '@salesforce/apex/reassignLeadController.saveLead';
import getLeadDetails from '@salesforce/apex/reassignLeadController.getLeadDetails'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Reassignlead extends NavigationMixin(LightningElement) {
    @track schoolOptions = [];
    @track selectedSchool;
    @track leadRecordId;
    @track leadRecord;
    @track showCard = true;

    // Wire to fetch the current page reference and extract the record ID
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference && currentPageReference.state && currentPageReference.state.recordId) {
            this.leadRecordId = currentPageReference.state.recordId;
            console.log('Current Lead Record ID:', this.leadRecordId);
        }
    }

    // Wire to fetch Lead record details
    @wire(getLeadDetails, { leadId: '$leadRecordId' })
    wiredLead({ error, data }) {
        if (data) {
            this.leadRecord = data;
            console.log('Fetched Lead Record:', this.leadRecord);
            // Fetch school options, excluding the current school
            this.fetchSchoolOptions(this.leadRecordId);
            // Set the selected school to the current school assigned to the lead
            this.selectedSchool = this.leadRecord.School_Institution__c;
        } else if (error) {
            console.error('Error fetching Lead record:', error);
        }
    }

    // Fetch school options excluding the current selected school
    fetchSchoolOptions(leadId) {
        getSchoolOptionslist({ leadId })
            .then((result) => {
                this.schoolOptions = result.map(option => ({
                    label: option.label,
                    value: option.value
                }));
            })
            .catch((error) => {
                console.error('Error fetching schools:', error);
            });
    }

    // Handle school selection change
    handleSchoolChange(event) {
        this.selectedSchool = event.target.value;
        console.log('selectedSchool', this.selectedSchool);
    }

    handleCancel() {
        this.showCard = false;
    }

    // Handle save and check for Current Location
    handleSave() {
        if (!this.selectedSchool) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Please select a school.',
                variant: 'error',
            }));
            return;
        }

        if (!this.leadRecord || !this.leadRecord.Current_Location__c) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Please add a Current Location to the lead before changing the school.',
                variant: 'error',
            }));
            return;
        }

        saveLead({ leadId: this.leadRecordId, accountId: this.selectedSchool })
            .then((result) => {
                console.log('saveLead result:', result);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Lead transferred successfully',
                    variant: 'success',
                }));

                // Navigate to the current Lead's record page using the leadRecordId
                this[NavigationMixin.Navigate]( {
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.leadRecordId,
                        objectApiName: 'Lead',
                        actionName: 'view',
                    },
                });

                // Optionally refresh the page after saving the record
                setTimeout(() => {
                    window.location.reload();
                }, 1000); // Delay to ensure that the page navigation happens first
            })
            .catch((error) => {
                let errorMessage = 'An error occurred while saving the lead.';
                if (error && error.body && error.body.message) {
                    errorMessage = error.body.message;
                } else if (error && error.message) {
                    errorMessage = error.message;
                }

                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: errorMessage,
                    variant: 'error',
                }));
            });
    }
}



// import { LightningElement, wire, track } from 'lwc';

// import { CurrentPageReference } from 'lightning/navigation'; // Import to access the current page reference
// import { NavigationMixin } from 'lightning/navigation'; 
// import getSchoolOptionslist from '@salesforce/apex/reassignLeadController.getSchoolOptionslist';
// import saveLead from '@salesforce/apex/reassignLeadController.saveLead';
// import getLeadDetails from '@salesforce/apex/reassignLeadController.getLeadDetails'; // Apex to fetch lead
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import { RefreshEvent } from 'lightning/refresh';
// const DELAY = 300;

// export default class Reassignlead extends NavigationMixin(LightningElement) {
//     schoolOptions = [];
//     @track selectedSchool;
//     @track leadRecordId;
//     @track message; 
//     @track isError = false; 
//     leadRecord; // Holds the fetched Lead record
//     @track showCard = true;

//     // Wire to fetch the current page reference and extract the record ID
//     @wire(CurrentPageReference)
//     getStateParameters(currentPageReference) {
//         if (currentPageReference && currentPageReference.state && currentPageReference.state.recordId) {
//             this.leadRecordId = currentPageReference.state.recordId;
//             console.log('Current Lead Record ID:', this.leadRecordId);
//         }
//     }

//     // Wire to fetch Lead record details
//     @wire(getLeadDetails, { leadId: '$leadRecordId' })
//     wiredLead({ error, data }) {
//         if (data) {
//             this.leadRecord = data; // Assign the fetched lead record
//             console.log('Fetched Lead Record:', this.leadRecord);
//         } else if (error) {
//             console.error('Error fetching Lead record:', error);
//         }
//     }

//     // Wire to fetch school options
//     @wire(getSchoolOptionslist)
//     wiredSchools({ error, data }) {
//         if (data) {
//             // Map the Apex data to the expected format for lightning-combobox
//             this.schoolOptions = data.map(option => ({
//                 label: option.label,
//                 value: option.value
//             }));
//         } else if (error) {
//             console.error('Error fetching schools:', error);
//         }
//     }

//     // Handle school selection change
//     handleSchoolChange(event) {
//         this.selectedSchool = event.target.value;
//         console.log('selectedSchool', this.selectedSchool);
//     }
//     handleCancel() {
//         this.showCard = false; // Set to false to hide the card
//     }
//     // Handle save and check for Current Location
//     handleSave() {
//         if (!this.selectedSchool) {
//             this.dispatchEvent(new ShowToastEvent({
//                 title: 'Error',
//                 message: 'Please select a school.',
//                 variant: 'error',
//             }));
//             return; // Exit the function if no school is selected
//         }

//         // Check if the Current Location field is blank
//         if (!this.leadRecord || !this.leadRecord.Current_Location__c) {
//             this.dispatchEvent(new ShowToastEvent({
//                 title: 'Error',
//                 message: 'Please add a Current Location to the lead before changing the school.',
//                 variant: 'error',
//             }));
//             return; // Exit the function if Current Location is blank
//         }

//         // Proceed with saving the lead if Current Location is valid
//         saveLead({ leadId: this.leadRecordId, accountId: this.selectedSchool })
//             .then((result) => {
//                 console.log('saveLead result:', result);
//                 this.dispatchEvent(new ShowToastEvent({
//                     title: 'Success',
//                     message: 'Lead transferred successfully',
//                     variant: 'success',
//                 }));

//                 // Navigate to the Lead List View
//                 this[NavigationMixin.Navigate]({
//                     type: 'standard__objectPage',
//                     attributes: {
//                         objectApiName: 'Lead',
//                         actionName: 'list',
//                     },
//                 });
//             })
//             .catch((error) => {
//                 let errorMessage = 'An error occurred while saving the lead.';
//                 if (error && error.body && error.body.message) {
//                     errorMessage = error.body.message;
//                 } else if (error && error.message) {
//                     errorMessage = error.message;
//                 }
            
//                 this.dispatchEvent(new ShowToastEvent({
//                     title: 'Error',
//                     message: errorMessage,
//                     variant: 'error',
//                 }));
//             });
            
//     }
// }