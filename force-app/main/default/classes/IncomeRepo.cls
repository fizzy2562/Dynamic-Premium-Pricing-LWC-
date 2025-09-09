public with sharing class IncomeRepo {
    public IncomeRepo() {
    }

    public Map<Id,Income__c> queryIncomesByBudget(Set<Id> recorIds){
        return new Map<Id,Income__c>([SELECT Id, Category__c, Amount__c, Budget__c FROM Income__c WHERE Budget__c in: recorIds]);
    }
}