public class TriggerHandlerFactory {
/* To instantiate the actual implementation of specific TriggerHandler */
    
	public static TriggerHandler createTriggerHandler(Schema.SObjectType sObjType){ 
        TriggerHandler handler; 
        if(sObjType == Contact.sObjectType){ 
            handler = new ContactTriggerHandler(); 
        } if (handler == null){ 
            throw new TriggerException('No Trigger Handler registered for Object Type: ' + sObjType); 
        } return handler;
    } 
    public class TriggerException extends Exception {
        
    }

}