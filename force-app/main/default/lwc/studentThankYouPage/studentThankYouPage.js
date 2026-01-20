import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class StudentThankYouPage extends NavigationMixin(LightningElement) {
    @api applicationFormId;
    @api applicationFormName;
    @api enquiryName;

    redirectToVfPage() {
        console.log('ApplicationId', this.applicationFormId);
        const vfPageUrl = '/ApplicationformPDF?id=' + this.applicationFormId; 
        window.open(vfPageUrl, '_blank'); // Open in a new tab
    }

}