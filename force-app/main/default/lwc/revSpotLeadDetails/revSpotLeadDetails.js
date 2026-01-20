import { LightningElement, api } from 'lwc';

    export default class RevSpotLeadInfo extends LightningElement {
        @api recordId; // Record ID dynamically passed to the component for the Lead object
    }