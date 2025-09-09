import { LightningElement, track } from 'lwc';

export default class AppRuleBuilder extends LightningElement {
    @track selectedObject;
    @track criteriaField;
    @track criteriaOperator;
    @track criteriaValue;
    @track selectedAction;
    @track actionField;
    @track actionValue;

    // Sample options for objects, operators, and actions
    objectOptions = [
        { label: 'Account', value: 'Account' },
        { label: 'Contact', value: 'Contact' },
        { label: 'Opportunity', value: 'Opportunity' },
    ];

    operatorOptions = [
        { label: 'Equals', value: 'equals' },
        { label: 'Not Equals', value: 'notEquals' },
        { label: 'Greater Than', value: 'greaterThan' },
        { label: 'Less Than', value: 'lessThan' },
    ];

    actionOptions = [
        { label: 'Field Update', value: 'fieldUpdate' },
        { label: 'Create Task', value: 'createTask' },
        { label: 'Send Email', value: 'sendEmail' },
    ];

    handleObjectChange(event) {
        this.selectedObject = event.target.value;
    }

    handleFieldChange(event) {
        this.criteriaField = event.target.value;
    }

    handleOperatorChange(event) {
        this.criteriaOperator = event.target.value;
    }

    handleValueChange(event) {
        this.criteriaValue = event.target.value;
    }

    handleActionChange(event) {
        this.selectedAction = event.target.value;
    }

    handleActionFieldChange(event) {
        this.actionField = event.target.value;
    }

    handleActionValueChange(event) {
        this.actionValue = event.target.value;
    }

    generateCode() {
        // This is where you would generate code based on the user input.
        // For example, you could generate an Apex trigger or Flow XML.

        const code = `
        // Sample generated code
        if (${this.selectedObject}.${this.criteriaField} ${this.getOperatorSymbol(this.criteriaOperator)} ${this.criteriaValue}) {
            ${this.generateActionCode(this.selectedAction, this.actionField, this.actionValue)}
        }`;

        console.log(code);
        alert(code);
    }

    getOperatorSymbol(operator) {
        const operators = {
            equals: '==',
            notEquals: '!=',
            greaterThan: '>',
            lessThan: '<'
        };
        return operators[operator] || '==';
    }

    generateActionCode(action, field, value) {
        let actionCode = '';
        switch (action) {
            case 'fieldUpdate':
                actionCode = `${field} = ${value};`;
                break;
            case 'createTask':
                actionCode = `// Task creation code here for ${field} with value ${value}`;
                break;
            case 'sendEmail':
                actionCode = `// Email sending code here for ${field} with value ${value}`;
                break;
            default:
                actionCode = '// Default action code';
        }
        return actionCode;
    }
}