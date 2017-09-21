global class UPSLocator {

    webservice static void getTrackingDataById (String trackingID, String ShipmentId) {
        system.debug('trackingID =====> '+trackingID);
        system.debug('ShipmentId =====> '+ShipmentId);
        String payload = '{\"UPSSecurity\":{\"UsernameToken\":{\"Username\":\"dtillotson-GM\",\"Password\":\"Coastal2017!\"},\"ServiceAccessToken\":{\"AccessLicenseNumber\":\"8D30E58D1B69187C\"}},\"TrackRequest\":{\"Request\":{\"RequestOption\":\"1\",\"TransactionReference\":{\"CustomerContext\":\"Get Tracking Data\"}},\"InquiryNumber\":\"'+trackingID+'\"}}';
        system.debug('payload =====> '+payload);
        Map<String, Object> results = new Map<String, Object>();
        UPSfaultResponse faults = new UPSfaultResponse();
        boolean goodResponse = false;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        // Testing URL
        //request.setEndpoint('https://wwwcie.ups.com/rest/Track');
        // Production URL
        request.setEndpoint('https://onlinetools.ups.com/rest/Track');
        request.setMethod('POST');
        request.setHeader('content-type','application/json');
        request.setBody(payload);
        HttpResponse response = http.send(request);
        system.debug('response =====> '+response.getBody());

        /*
        //get the list of header names (keys)
        string[] headerkeys = response.getHeaderKeys();
        //create an object to store your header key-value pairs
        Map<string, string> headers = new map<string, string>();
        //iterate through they keys, and populate your map
        for(string s : headerkeys){
            headers.put(s,response.getHeader(s));
            system.debug('header: ' + s + ' value: ' + response.getHeader(s));
        }
        */

        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            system.debug('results ====> '+results);
            Object TrackResponse = results.get('TrackResponse');
            system.debug('TrackResponse ====> '+TrackResponse);
            Object Fault = results.get('Fault');
            system.debug('Fault =====> '+Fault);
            if (TrackResponse != null) goodResponse = true; // We did not receive a "Fault" response
            if (Fault != null) {
                Object FaultObjects = JSON.serialize(results);
                String FOstring = String.valueOf(FaultObjects);
                faults = UPSfaultResponse.parse(FOstring);
                system.debug('Fault error =====> '+faults.Fault.detail.errors.ErrorDetail.PrimaryErrorCode.Description);

                // Update shipment record
                Shipment__c currShipment = new Shipment__c();
                currShipment.Id = ShipmentId;
                currShipment.UPS_Last_Updated__c = System.Now();
                currShipment.UPS_Error__c = faults.Fault.detail.errors.ErrorDetail.PrimaryErrorCode.Description;
                update currShipment;
            }
        }

        // If the request is successful, parse the JSON response.
        if (goodResponse) {
            Object TrackResponse = results.get('TrackResponse');
            Object TrackResponseObjects = JSON.serialize(TrackResponse);
            String TROstring = String.valueOf(TrackResponseObjects);
            Map<String, Object> results2 = (Map<String, Object>) JSON.deserializeUntyped(TROstring);
            system.debug('results2 ====> '+results2);
            Object Shipment = results2.get('Shipment');
            system.debug('Shipment Object ====> '+Shipment);
            Object ShipmentObjects = JSON.serialize(Shipment);
            String SOstring = String.valueOf(ShipmentObjects);
            system.debug('SOstring ====> '+SOstring);
            Map<String, Object> results3 = (Map<String, Object>) JSON.deserializeUntyped(SOstring);
            system.debug('results3 ====> '+results3);

            Object Package1 = results3.get('Package');
            system.debug('Package1 ====> '+Package1);
            Object Package1Objects = JSON.serialize(Package1);
            system.debug('Package1Objects ====> '+Package1Objects);
            Object Activity1 = results3.get('Activity');
            system.debug('Activity1 ====> '+Activity1);
            Object Activity1Objects = JSON.serialize(Activity1);
            system.debug('Activity1Objects ====> '+Activity1Objects);

            String POstring = '';
            if (String.valueOf(Package1Objects) != 'null') POstring = String.valueOf(Package1Objects);
            if (String.valueOf(Activity1Objects) != 'null') POstring = String.valueOf(Activity1Objects);
            system.debug('POstring ====> '+POstring);

            // Variables used to pull out the field data from the JSON response
            String DateValOrig = '';
            String TimeValOrig = '';
            String currStatus = '';
            String ActObjects = '';
            Integer recordCount = 0;
            Integer recordCount2 = 0;

            // Check to see if this part of the JSON string is an object
            If (POstring.startsWith('{')) {
                system.debug('Package is an object and not an array =====> '+POstring);
                // Build out code to handle getting list of activities
                Map<String, Object> results4 = (Map<String, Object>) JSON.deserializeUntyped(POstring);
                system.debug('results4 ====> '+results4);
                Object Activity = results4.get('Activity');
                system.debug('Activity =====> '+Activity);
                Object ActivityObjects = JSON.serialize(Activity);
                system.debug('ActivityObjects ====> '+ActivityObjects);
                String AOstring = String.valueOf(ActivityObjects);
                system.debug('AOstring ====> '+AOstring);

                // Check to see if this part of the JSON string is an object
                if (AOstring.startsWith('{')) {
                    String response1 = POstring.replace('"Time":','"TimeStr":');
                    String response2 = response1.replace('"Date":','"DateStr":');
                    system.debug('response2 =====> '+response2);
                    UPSactivityResponse currActivity = UPSactivityResponse.parse(response2);
                    system.debug('currActivity =====> '+currActivity);
                    TimeValOrig = currActivity.Activity.TimeStr;
                    DateValOrig = currActivity.activity.DateStr;
                    currStatus = currActivity.activity.Status.Description;
                }
                // Check to see if this part of the JSON string is an array
                If (AOstring.startsWith('[')) {
                    List<Object> acts = (List<Object>)JSON.deserializeUntyped(AOstring);
                    system.debug('acts list =====> '+acts);
                    for (Object act : acts) {
                        // now get attributes for this List.
                        Map<String, Object> actAttributes = (Map<String, Object>)act;
                        // now loop through our List attributes.
                        for (String attributeName : actAttributes.keyset()) {
                            // handle response and list all name / value pairs
                            System.debug('====> ' + attributeName + ' = ' + actAttributes.get(attributeName));
                            if (attributeName == 'Time' && recordCount2 == 0) TimeValOrig = String.valueOf(actAttributes.get(attributeName));
                            if (attributeName == 'Date' && recordCount2 == 0) DateValOrig = String.valueOf(actAttributes.get(attributeName));
                            if (attributeName == 'Status' && recordCount2 == 0) {
                                Object stats = actAttributes.get(attributeName);
                                system.debug('stats =====> '+stats);
                                JSONParser parser = JSON.createParser(JSON.serialize(stats));
                                while (parser.nextToken() != JSONToken.END_OBJECT) {
                                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                                        String text = parser.getText();
                                        if (parser.nextToken() != JSONToken.VALUE_NULL) {
                                            if (text == 'Description') {
                                                currStatus = parser.getText();
                                            }
                                        }
                                    }
                                }
                                System.debug('Current token: ' +parser.getCurrentToken()+' '+parser.getText());
                            }
                            if (DateValOrig !='' && TimeValOrig != '' && currStatus != '') recordCount2++;
                        }
                    }
                }
            }

            // Check to see if this part of the JSON string is an array
            If (POstring.startsWith('[')) {
                system.debug('Package is an array and not an object =====> '+POstring);
                List<Object> pkgs = new List<Object>();
                if (String.valueOf(Package1Objects) != 'null') pkgs = (List<Object>)results3.get('Package');
                if (String.valueOf(Activity1Objects) != 'null') pkgs = (List<Object>)results3.get('Activity');
                system.debug('pkgs size ====> '+pkgs.size());
                // Loop through the array to get the Activity object
                for (Object pkg : pkgs) {
                    // now get attributes for this List.
                    Map<String, Object> pkgAttributes = (Map<String, Object>)pkg;
                    // now loop through our List attributes.
                    for (String attributeName : pkgAttributes.keyset()) {
                        // handle response and list all name / value pairs
                        System.debug('====> ' + attributeName + ' = ' + pkgAttributes.get(attributeName));
                        if (attributeName == 'Activity' && recordCount == 0) {
                            Object actLatest = JSON.serialize(pkgAttributes.get(attributeName));
                            system.debug('actLatest ====> '+actLatest);
                            ActObjects = String.valueOf(actLatest);
                            recordCount++;
                        }
                        if (attributeName == 'Time' && recordCount < 3) TimeValOrig = String.valueOf(pkgAttributes.get(attributeName));
                        if (attributeName == 'Date' && recordCount < 3) DateValOrig = String.valueOf(pkgAttributes.get(attributeName));
                        if (attributeName == 'Description' && recordCount < 3) currStatus = String.valueOf(pkgAttributes.get(attributeName));
                        if (attributeName == 'Time' || attributeName == 'Date' || attributeName == 'Description') recordCount++;
                    }
                }
                system.debug('ActObjects =====> '+ActObjects);
                // Check to see if this part of the JSON string is an object
                if (ActObjects.startsWith('{')) {
                    String response1 = ActObjects.replace('"Time":','"TimeStr":');
                    String response2 = response1.replace('"Date":','"DateStr":');
                    UPSactivityResponse currActivity = UPSactivityResponse.parse(response2);
                    system.debug('currActivity =====> '+currActivity);
                    TimeValOrig = currActivity.Activity.TimeStr;
                    DateValOrig = currActivity.activity.DateStr;
                    currStatus = currActivity.activity.Status.Description;
                }
                // Check to see if this part of the JSON string is an array
                If (ActObjects.startsWith('[')) {
                    List<Object> acts = (List<Object>)JSON.deserializeUntyped(ActObjects);
                    system.debug('acts list =====> '+acts);
                    for (Object act : acts) {
                        // now get attributes for this List.
                        Map<String, Object> actAttributes = (Map<String, Object>)act;
                        // now loop through our List attributes.
                        for (String attributeName : actAttributes.keyset()) {
                            // handle response and list all name / value pairs
                            System.debug('====> ' + attributeName + ' = ' + actAttributes.get(attributeName));
                            if (attributeName == 'Time' && recordCount2 == 0) TimeValOrig = String.valueOf(actAttributes.get(attributeName));
                            if (attributeName == 'Date' && recordCount2 == 0) DateValOrig = String.valueOf(actAttributes.get(attributeName));
                            if (attributeName == 'Status' && recordCount2 == 0) {
                                Object stats = actAttributes.get(attributeName);
                                system.debug('stats =====> '+stats);
                                JSONParser parser = JSON.createParser(JSON.serialize(stats));
                                while (parser.nextToken() != JSONToken.END_OBJECT) {
                                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                                        String text = parser.getText();
                                        if (parser.nextToken() != JSONToken.VALUE_NULL) {
                                            if (text == 'Description') {
                                                currStatus = parser.getText();
                                            }
                                        }
                                    }
                                }
                                System.debug('Current token: ' +parser.getCurrentToken()+' '+parser.getText());
                            }
                            if (DateValOrig !='' && TimeValOrig != '' && currStatus != '') recordCount2++;
                        }
                    }
                }
            }

            /*
            // May not need to do this manual parsing
            JSONParser parser = JSON.createParser(JSON.serialize(Package1));
            system.debug('parser =====> '+parser);

            while (parser.nextToken() != JSONToken.END_OBJECT) {
                System.debug('Current token: ' +parser.getCurrentToken()+' '+parser.getText());
            }
            */
            system.debug('DateValOrig =====>' + DateValOrig);
            system.debug('TimeValOrig =====>' + TimeValOrig);

            System.debug('Received the following Tracking Data:');
            String response1 = response.getBody().replace('"Package":','"Package1":');
            String response2 = response1.replace('"Date":','"DateStr":');
            String response3 = response2.replace('"Time":','"TimeStr":');
            UPSResponse myClass = UPSResponse.parse(response3);
            system.debug('myClass ====> '+myClass);
            system.debug('myClass Shipment ====> '+myClass.TrackResponse.Shipment);
            system.debug('myClass Service ====> '+myClass.TrackResponse.Shipment.Service);

            // Update shipment record
            Shipment__c currShipment = new Shipment__c();
            currShipment.Id = ShipmentId;
            currShipment.UPS_Status__c = currStatus;
            currShipment.UPS_Date__c = DateValOrig.substring(4, 6) +'/'+ DateValOrig.substring(6) +'/'+ DateValOrig.substring(0, 4);
            currShipment.UPS_Time__c = TimeValOrig.substring(0, 2) +':'+ TimeValOrig.substring(2, 4) +':'+ TimeValOrig.substring(4);
            currShipment.UPS_Service__c = myClass.TrackResponse.Shipment.Service.Description;
            currShipment.UPS_Last_Updated__c = System.Now();
            currShipment.UPS_Tracking_Number__c = myClass.TrackResponse.Shipment.InquiryNumber.Value;
            currShipment.UPS_Weight__c = myClass.TrackResponse.Shipment.ShipmentWeight.Weight;
            currShipment.UPS_Unit_of_Measure__c = myClass.TrackResponse.Shipment.ShipmentWeight.UnitOfMeasurement.Code;
            update currShipment;
        }
    }
}