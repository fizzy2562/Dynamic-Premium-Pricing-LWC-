public class BudgetService {
    private static ExpenseRepo expenseRepo {
        get{
            if(expenseRepo == null){
                expenseRepo = new ExpenseRepo();
            }
            return expenseRepo;
        }
        set;
    }

    private static IncomeRepo incomeRepo {
        get{
            if(incomeRepo == null){
                incomeRepo = new IncomeRepo();
            }
            return incomeRepo;
        }
        set;
    }

    public static List<Budget__c> generateBudgetListToUpdate(Map<Id,sObject> genericObjectMap){
        Map<Id,Decimal> budgetTotalMap = new Map<Id,Decimal>(populateBudgetTotalMap(genericObjectMap));
        String type = objectType(genericObjectMap);
        List<Budget__c> budgetList = new List<Budget__c>();
        for(Id budgetId : budgetTotalMap.keySet()){
            Budget__c budget = new Budget__c();
            budget.id = budgetId;
            if(type == 'Expense'){
                budget.Total_Expenses__c = budgetTotalMap.get(budgetId);
            }else if (type == 'Income'){
                budget.Total_Income__c = budgetTotalMap.get(budgetId);
            }
            budgetList.add(budget);
        }
        return budgetList;
    }

    public static List<Budget__c> generateBudgetListToUpdateAfterDelete(Set<Id> budgetIds){
        Map<Id,Map<String,Decimal>> budgetTotalMap = new Map<Id,Map<String,Decimal>>();
        for(Id budgetId : budgetIds){
            Map<String,Decimal> totalMap = new Map<String,Decimal>{
                'Expense' => 0.00,
                'Income' => 0.00
            };
            if(!budgetTotalMap.containsKey(budgetId)){
                budgetTotalMap.put(budgetId,totalMap);
            }
        }

        Map<Id,Income__c> incomeMap = new Map<Id,Income__c>(incomeRepo.queryIncomesByBudget(budgetIds));
        Map<Id,Expense__c> expenseMap = new Map<Id,Expense__c>(expenseRepo.queryExpensesByBudget(budgetIds));
        Map<Id,Budget__c> budgetMap = new Map<Id,Budget__c>();

        for(Income__c income:incomeMap.values()){
            Id key = income.Budget__c;
            Decimal total = budgetTotalMap.get(key).get('Income')+income.Amount__c;
            budgetTotalMap.get(key).put('Income',total);
        }

        for(Expense__c expense:expenseMap.values()){
            Id key = expense.Budget__c;
            Decimal total = budgetTotalMap.get(key).get('Expense')+expense.Amount__c;
            budgetTotalMap.get(key).put('Expense',total);
        }

        List<Budget__c> budgetList = new List<Budget__c>();
        for (Id key : budgetTotalMap.keySet()) {
            Budget__c budget = new Budget__c(
                Id = key,
                Total_Expenses__c = budgetTotalMap.get(key).get('Expense'),
                Total_Income__c = budgetTotalMap.get(key).get('Income')
            );
            budgetList.add(budget);
        }

        return budgetList;
    }

    private static Map<Id,Decimal> populateBudgetTotalMap(Map<Id,sObject> genericObjectMap){
        Map<Id,Decimal> budgetTotalMap = new Map<Id,Decimal>();
        String type = objectType(genericObjectMap);
        
        if(type == 'Expense'){
            budgetTotalMap.putAll(ExpenseService.totalExpenseAmountByBudget((Map<Id,Expense__c>)genericObjectMap));
        }else if(type == 'Income'){
            budgetTotalMap.putAll(IncomeService.totalIncomeAmountByBudget((Map<Id,Income__c>) genericObjectMap));
        }
        return budgetTotalMap;
    }

    private static String objectType (Map<Id,sObject> genericObjectMap){
        if(genericObjectMap.getSObjectType() == Expense__c.sObjectType ){
            return 'Expense';
        }else if(genericObjectMap.getSObjectType() == Income__c.sObjectType){
            return 'Income';
        }
        return '';
    }
}