public class ExpenseRepo {
    public ExpenseRepo() {
    }

    public Map<Id,Expense__c> queryExpensesByBudget(Set<Id> recorIds){
        return new Map<Id,Expense__c>([SELECT Id, Category__c, Amount__c, Budget__c FROM Expense__c WHERE Budget__c in :recorIds]);
    }

}