// imports
//import { subscribe,unsubscribe,createMessageContext,releaseMessageContext,APPLICATION_SCOPE } from 'lightning/messageService';
//import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';
import { LightningElement, wire, track } from "lwc";
import getBoats from "@salesforce/apex/BoatDataService.getBoats";
import { NavigationMixin } from 'lightning/navigation';

export default class BoatSearch extends NavigationMixin(LightningElement){
    @track isLoading = false;
    
    // Handles loading event
    handleLoading() { 
        this.isLoading = true;
    }
    
    // Handles done loading event
    handleDoneLoading() { 
        this.isLoading = false;
    }
    
    // Handles search boat event
    // This custom event comes from the form
    searchBoats(event) { 
        const boatTypeId = event.detail.boatTypeId;
        this.template.querySelector("c-boat-search-results").searchBoats(boatTypeId);
    }
    
    createNewBoat() { 
    // Go to the Account page
    this[NavigationMixin.Navigate]({

        type: 'standard__objectPage',        
        attributes: {
            objectApiName: 'Boat__c',
            actionName: 'new',
        }
        
        });
    }
}