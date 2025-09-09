public class IncomeService {
    public static Map<Id,Decimal> totalIncomeAmountByBudget(Map<Id,Income__c> incomeMap){
        Map<Id,Decimal> budgetIdWithTotalIncomeAmountMap = new Map<Id,Decimal>();
        for(Income__c income : incomeMap.values()){
            Id key = income.Budget__c;
            Decimal totalAmount = 0.00;
            if(budgetIdWithTotalIncomeAmountMap.containsKey(key)){
                totalAmount = budgetIdWithTotalIncomeAmountMap.get(key)+income.Amount__c;
                budgetIdWithTotalIncomeAmountMap.put(key,totalAmount);
            }else{
                budgetIdWithTotalIncomeAmountMap.put(key,income.Amount__c);
            }    
        }
        return budgetIdWithTotalIncomeAmountMap; 
    }

    public static Set<Id> getbudgetIds(Map<Id,Income__c> incomeMap){
        Set<Id> setIds = new Set<Id>();
        for (Income__c income : incomeMap.values()) {
            Id budgetId = income.Budget__c;
            if(!setIds.contains(budgetId)){
                setIds.add(budgetId);
            }
        }
        return setIds;
    }
}