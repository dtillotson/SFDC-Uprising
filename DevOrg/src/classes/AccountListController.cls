public class AccountListController extends DynamicListController {
    public AccountListController() {
        // call the parent class constructor with a base query
        super('select Id, CreatedDate, Name from Account');
        pageSize = 10;
    }

    // cast the resultset
    public List<Account> getAccounts() {
        // cast returned records into list of Accounts
        return (List<Account>) getRecords();
    }
}