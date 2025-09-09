Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
Schema.DescribeSObjectResult d = gd.get('Dynamic_Pricing_Setting__c') != null ? gd.get('Dynamic_Pricing_Setting__c').getDescribe() : null;
if (d == null) {
    System.debug('DPSC object not found');
} else {
    System.debug('DPSC Fields: ' + d.fields.getMap().keySet());
}
Schema.DescribeSObjectResult p = gd.get('Premium_Appointment_Setting__c') != null ? gd.get('Premium_Appointment_Setting__c').getDescribe() : null;
if (p == null) {
    System.debug('PASC object not found');
} else {
    System.debug('PASC Fields: ' + p.fields.getMap().keySet());
}
