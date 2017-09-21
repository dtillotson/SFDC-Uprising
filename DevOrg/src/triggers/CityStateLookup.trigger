trigger CityStateLookup on Lead (before insert, before update) {

    // COLLECT lead zip codes
    Set<String> zipCodes = new Set<String>();
    for (Lead lead : Trigger.new) {
        if (lead.PostalCode != null && 
            (Trigger.isInsert || (lead.PostalCode != Trigger.oldMap.get(lead.Id).PostalCode))) {
                // add postalcode to keyset
                zipCodes.add(lead.PostalCode);
        }
    }

    if (!zipCodes.isEmpty()) {
        Map<String, Zip_Code__c> cacheMap = new Map<String, Zip_Code__c>();

        // QUERY related cities and states by zip code
        for (Zip_Code__c zip : [ 
                                // add SOQL for Zip Code query
                                SELECT Id, Name, City__c, State__c
                                FROM Zip_Code__c
                                WHERE Name IN :zipCodes
                               ]) {
            // CACHE city and state by zip
            if (zip != null) {
                // cache zip code, city and state
                cacheMap.put(zip.Name, zip);
            }
        }

        // LOOKUP city and state by zip 
        for (Lead lead : Trigger.new) {
            // use the postal code to get the zip details 
            Zip_Code__c zip = cacheMap.get(lead.PostalCode);
            if (zip != null) {
                // assign city and state
                lead.City = zip.City__c;
                lead.State = zip.State__c;
            }
        }
    }

}