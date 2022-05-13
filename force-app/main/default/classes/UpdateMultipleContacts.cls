public with sharing class UpdateMultipleContacts {
    //@future (callout=true)
    /* JSON2Apex
	public Boolean allOrNone;
	public List<Records> records;

	public class Attributes {
		public String type;
	}

	public class Records {
		public Attributes attributes;
		public String Id;
		public String Email;
		public String LastName;
		public String FirstName;
		public Boolean Active__c;
	}
    */  
    public static void doUpdateMultipleContacts(String bodyval) {
            //return (UpdateMultipleContacts) System.JSON.deserialize(json, UpdateMultipleContacts.class);

        HttpRequest req = new HttpRequest(); 
        //String bodyval = '{"allOrNone":true,"compositeRequest":[{"method":"POST","url":" /services/data/v53.0/ sobjects/Account", "referenceId":"NewAccount", "body":{"Name":"New-composite Account","Phone":"987654321"}},{"method":"GET", "referenceId":"NewAccountInfo", "url":"/services/data/v53.0/ sobjects/Account/@ {NewAccount.id}"},{"method":"POST","url":" /services/data/v53.0/sobjects/ Contact","referenceId": "newAccountv","body":{"lastname": "@{NewAccountInfo.Name} - @{NewAccountInfo.Phone}", "AccountId": "@{NewAccountInfo.Id}", "Phone": "@{NewAccountInfo. Phone}"}},{"method":"POST","url":"/ services/data/v53.0/sobjects/ Contact", "referenceId":"newAccountv1","body":{"lastname": "@{NewAccountInfo.Name} - @{NewAccountInfo.Phone}", "AccountId": "@{NewAccountInfo.Id}", "Phone": "@{NewAccountInfo.Phone}" }}]}'; 
        /*
        bodyval = '{'+
		'    \"allOrNone\": true,'+
		'    \"records\": ['+
		'        {'+
		'        \"attributes\" : {\"type\" : \"Contact\"},'+
		'        \"Id\": \"0033h000012q1nSAAQ\",'+
		'        \"Email\": \"hamann@casinoroyale.com\",'+
		'        \"LastName\": \"Craig\",'+
		'        \"FirstName\": \"Hamann\",'+
		'        \"Active__c\": false'+
		'        },'+
		'        {'+
		'        \"attributes\" : {\"type\" : \"Contact\"},'+
		'        \"Id\": \"0033h00000qITdlAAG\",'+
		'        \"Email\": \"bnatuka@cometd.com\",'+
		'        \"Active__c\": true'+
		'        }'+
		'    ]  '+
		'}';
        */
        req.setHeader ('Authorization', 'Bearer ' + UserInfo.getSessionID()); 
        req.setHeader('Content-Type', 'application/json'); 
        String domainUrl = URL.getSalesforceBaseUrl().toExternalForm(); 
        
        System.debug ('=====domainUrl: ' + domainUrl); 
        //String domainUrl = 'https://fishingtime-dev-ed.my.salesforce.com';
        req.setEndpoint(domainUrl+ '/services/data/v54.0/composite/sobjects'); 
        req.setMethod('PATCH'); 
        req.setBody(bodyval); 
        Http h = new Http(); 
        try{
            HttpResponse res = h.send(req);
            System.debug(res.getBody());
            if(res.getStatusCode() == 200) {
                // Deserialize the JSON string into collections of primitive data types.
                // and detect error returned if any to inform user
                String resBody = JSON.serialize(res.getBody());
                System.debug('==resBody==' + resBody);
            }    
            if(res.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' + res.getStatusCode() + ' ' + res.getStatus());
            }
            else{
                System.debug('==Error updating one of contacts. Whole request failed and none of contacts get updated as allOrNone is set to true in composite api==');
            }
        }catch(System.CalloutException e){
            System.debug('===Callout error===' + e);
            //System.debug(res.toString());
        }
    }
}    
