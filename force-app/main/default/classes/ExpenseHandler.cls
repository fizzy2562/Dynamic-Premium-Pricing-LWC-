public class ExpenseHandler {
    private static ExpenseRepo expenseRepo {
        get{
            if(expenseRepo == null){
                expenseRepo = new ExpenseRepo();
            }
            return expenseRepo;
        }
        set;
    }

    private static BudgetRepo budgetRepo {
        get{
            if(budgetRepo ==  null){
                budgetRepo = new BudgetRepo();
            }
            return budgetRepo;
        }
        set;
    }

    public static void afterInsert(Map<Id,Expense__c> newExpenseMap){
        updateBudget(newExpenseMap);
    }
    public static void afterUpdate(Map<Id,Expense__c> newExpenseMap){
        updateBudget(newExpenseMap);
    }
    public static void afterDelete(Map<Id,Expense__c> oldExpenseMap){
        updateBudgetAfterContext(oldExpenseMap);
    }

    private static void updateBudget(Map<Id,Expense__c> expenseMap){
        Set<Id> budgetIds = ExpenseService.getbudgetIds(expenseMap);
        Map<Id,Expense__c> expenseQueryMap = expenseRepo.queryExpensesByBudget(budgetIds);
        List<Budget__c> budgetList = BudgetService.generateBudgetListToUpdate(expenseQueryMap);
        budgetRepo.updateBudgets(budgetList);
    }

    private static void updateBudgetAfterContext(Map<Id,Expense__c> expenseMap){
        Set<Id> budgetIds = ExpenseService.getbudgetIds(expenseMap);
        List<Budget__c> budgetList = BudgetService.generateBudgetListToUpdateAfterDelete(budgetIds);
        budgetRepo.updateBudgets(budgetList);
    }

}