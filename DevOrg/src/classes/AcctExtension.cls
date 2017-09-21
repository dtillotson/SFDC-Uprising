public class AcctExtension {
    ApexPages.StandardSetController controller;
    public AcctExtension(ApexPages.StandardSetController controller) {
        this.controller = controller;
    }
    
    public PageReference save() {
        controller.save();
        return Page.AccountsView;
    }
}