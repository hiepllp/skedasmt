import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/BoatReview__c.Name';
import COMMENT_FIELD from '@salesforce/schema/BoatReview__c.Comment__c';
import RATING_FIELD from '@salesforce/schema/BoatReview__c.Rating__c';
import BOATREVIEW_OBJECT from '@salesforce/schema/BoatReview__c';
import BOAT_FIELD from '@salesforce/schema/BoatReview__c.Boat__c';

const TOAST_TITLE = 'Review Created!';
const TOAST_SUCCESS_VARIANT = 'success';

export default class BoatAddReviewForm extends LightningElement {
    @api boatId;
    @api rating = RATING_FIELD;

    @api
    get recordId() {
        return this.boatId;
    }
    set recordId(value) {
        this.setAttribute('boatId', value);
        this.boatId = value;
    }


    handleRatingChanged(event) {
        this.rating = event.detail.rating;//JSON.parse(JSON.stringify(event.detail)).rating;
    }

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: TOAST_TITLE,
            variant: TOAST_SUCCESS_VARIANT,
        });
        this.dispatchEvent(evt);
        this.dispatchEvent(new CustomEvent('createreview'));
        this.handleReset(event);
    }

    handleReset(event) {
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        const fields = event.detail.fields;
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }
    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Boat__c = this.boatId;
        fields.Rating__c = this.rating;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
}