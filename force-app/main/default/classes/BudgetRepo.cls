public with sharing class BudgetRepo {
    public BudgetRepo() {
    }

    public void updateBudgets(List<Budget__c> listOfBudgets){
        update listOfBudgets;
    }
}