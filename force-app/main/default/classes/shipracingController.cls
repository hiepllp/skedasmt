public with sharing class shipracingController {
    @AuraEnabled(cacheable=true)  
    public static List<Boat__c> fetchShipList(){  
    return [SELECT Name,Id, Contact__r.Name, Price__c, Length__c, BoatType__r.Name, Picture__c FROM Boat__c Limit 15];  
    }  
    @AuraEnabled  
    public static void deleteShip(List<Boat__c> boatList){  
    //delete boatList;  
    } 
}