// imports
// import getBoatTypes from the BoatDataService => getBoatTypes method';
import { LightningElement, wire, track } from "lwc";
import getBoatTypes from "@salesforce/apex/BoatDataService.getBoatTypes";
//import { subscribe,unsubscribe,createMessageContext,releaseMessageContext,APPLICATION_SCOPE } from 'lightning/messageService';
//import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';

export default class BoatSearchForm extends LightningElement {
    @track selectedBoatTypeId = "";
    @track error = undefined;
    @track searchOptions;
    //selectedBoatTypeId = '';    
    // Private
    //error = undefined;
    // Needs explicit track due to nested data
    //searchOptions;

    // Wire a custom Apex method
      boatTypes({ error, data }) {
      if (data) {
        this.searchOptions = data.map(type => {
          // TODO: complete the logic
        });
        this.searchOptions.unshift({ label: 'All Types', value: '' });
      } else if (error) {
        this.searchOptions = undefined;
        this.error = error;
      }
    }
    
    @wire(getBoatTypes)
    boatTypes({ error, data }) {
    if (data) {
        this.searchOptions = data.map((type) => {
            return {
            label: type.Name,
            value: type.Id
            };
        });
        this.searchOptions.unshift({ label: "All Types", value: "" });
        } else if (error) {
            this.searchOptions = undefined;
            this.error = error;
        }
    }

// Fires event that the search option has changed.
// passes boatTypeId (value of this.selectedBoatTypeId) in the detail
    handleSearchOptionChange(event) {
    // Create the const searchEvent
    // searchEvent must be the new custom event search
        event.preventDefault();
        this.selectedBoatTypeId = event.detail.value;
        const searchEvent = new CustomEvent("search", {
                detail: {
                boatTypeId: this.selectedBoatTypeId
            }
        });
        this.dispatchEvent(searchEvent);
    }
}