public class ExpenseService {

    public static Map<Id,Decimal> totalExpenseAmountByBudget(Map<Id,Expense__c> expenseMap){
        Map<Id,Decimal> budgetIdWithTotalExpenseAmountMap = new Map<Id,Decimal>();
        for(Expense__c expense : expenseMap.values()){
            Id key = expense.Budget__c;
            Decimal totalAmount = 0.00;
            if(budgetIdWithTotalExpenseAmountMap.containsKey(key)){
                totalAmount = budgetIdWithTotalExpenseAmountMap.get(key)+expense.Amount__c;
                budgetIdWithTotalExpenseAmountMap.put(key,totalAmount);
            }else{
                budgetIdWithTotalExpenseAmountMap.put(key,expense.Amount__c);
            }    
        }
        return budgetIdWithTotalExpenseAmountMap; 
    }

    public static Set<Id> getbudgetIds(Map<Id,Expense__c> expenseMap){
        Set<Id> setIds = new Set<Id>();
        for (Expense__c expense : expenseMap.values()) {
            Id budgetId = expense.Budget__c;
            if(!setIds.contains(budgetId)){
                setIds.add(budgetId);
            }
        }
        return setIds;
    }
}