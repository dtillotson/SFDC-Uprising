public class CheckboxExamplesController {
    
    CCheckbox Options {get;set;}

    
    private class CCheckbox {

        public String Label {get; set;}
        public String HTML {get; private set;}
          
        public CCheckbox(String Label, String Value, Boolean IsChecked) {
            this.Label = Label;
            this.HTML = '<input type="checkbox" class="cboxChoice" onClick="saveValues();" id="' + Value + '" ' + (IsChecked ? 'checked' : '') + '/>';
        }
    }
}