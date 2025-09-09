public class IncomeHandler {
    private static IncomeRepo incomeRepo {
        get{
            if(incomeRepo == null){
                incomeRepo = new IncomeRepo();
            }
            return incomeRepo;
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

    public static void afterInsert(Map<Id,Income__c> newIncomeMap){
        updateBudget(newIncomeMap);
    }
    public static void afterUpdate(Map<Id,Income__c> newIncomeMap){
        updateBudget(newIncomeMap);
    }
    public static void afterDelete(Map<Id,Income__c> oldIncomeMap){
        updateBudgetAfterContext(oldIncomeMap);
    }

    private static void updateBudget(Map<Id,Income__c> incomeMap){
        Set<Id> budgetIds = IncomeService.getbudgetIds(incomeMap);
        Map<Id,Income__c> incomeQueryMap = incomeRepo.queryIncomesByBudget(budgetIds);
        List<Budget__c> budgetList = BudgetService.generateBudgetListToUpdate(incomeQueryMap);
        budgetRepo.updateBudgets(budgetList);
    }

    private static void updateBudgetAfterContext(Map<Id,Income__c> incomeMap){
        Set<Id> budgetIds = IncomeService.getbudgetIds(incomeMap);
        List<Budget__c> budgetList = BudgetService.generateBudgetListToUpdateAfterDelete(budgetIds);
        budgetRepo.updateBudgets(budgetList);
    }
}