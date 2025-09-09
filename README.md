# Premium Appointments & Dynamic Pricing (LWC + Apex)

Two Lightning Web Components backed by Apex controllers and two lightweight custom objects that let you manage premium appointments and dynamic pricing feature flags per scope (Business Unit, Territory, Account, Channel).

## Components

### 1. Premium Appointment Controller
- **API Name**: `premiumAppointmentController`
- **Purpose**: Control premium appointment availability
- **Design**: Blue-purple gradient with modern glassmorphism effects
- **Toggles**: Business Unit, Territory, Account, Channel

### 2. Dynamic Pricing Controller
- **API Name**: `dynamicPricingController`
- **Purpose**: Control dynamic pricing strategies
- **Design**: Red-orange gradient with warm color scheme
- **Toggles**: Business Unit, Territory, Account, Channel

## Features

✨ **Modern Design**
- Gradient backgrounds with glassmorphism effects
- Smooth animations and hover effects  
- Responsive grid layout
- Color-coded toggle cards

🔧 **Functional**
- Real-time toggle state management
- Apex backend integration
- Error handling with user feedback
- Loading states and spinners

📱 **Responsive**
- Mobile-friendly design
- Adaptive grid layouts
- Touch-friendly controls

## Project Structure
```
salesforce-lwc-components/
├── force-app/
│   └── main/
│       └── default/
│           ├── lwc/
│           │   ├── premiumAppointmentController/
│           │   │   ├── premiumAppointmentController.html
│           │   │   ├── premiumAppointmentController.js
│           │   │   ├── premiumAppointmentController.css
│           │   │   └── premiumAppointmentController.js-meta.xml
│           │   └── dynamicPricingController/
│           │       ├── dynamicPricingController.html
│           │       ├── dynamicPricingController.js
│           │       ├── dynamicPricingController.css
│           │       └── dynamicPricingController.js-meta.xml
│           ├── classes/
│           │   ├── PremiumAppointmentController.cls
│           │   ├── PremiumAppointmentController.cls-meta.xml
│           │   ├── DynamicPricingController.cls
│           │   └── DynamicPricingController.cls-meta.xml
│           └── objects/
│               ├── Premium_Appointment_Setting__c/
│               └── Dynamic_Pricing_Setting__c/
├── README.md
└── sfdx-project.json
```

## Install & Deploy

- Prereqs: Salesforce CLI (`sf`), a default org or alias, and permissions to deploy metadata.
- Clone and deploy:
  - `git clone https://github.com/fizzy2562/Dynamic-Premium-Pricing-LWC-.git`
  - `cd Dynamic-Premium-Pricing-LWC-`
  - `sf org login web --alias MyDevOrg --set-default --instance-url https://login.salesforce.com`
  - `sf project deploy start --target-org MyDevOrg --source-dir force-app --test-level NoTestRun`

Objects and fields are included; you do NOT need to create audit-style custom fields. Each object contains only:
- `Setting_Type__c` (Text)
- `Is_Enabled__c` (Checkbox)

## Usage

Add to any Lightning page via App Builder and optionally set initial toggle states:

```html
<c-premium-appointment-controller 
    bu-enabled="true"
    territory-enabled="false"
    account-enabled="false"
    channel-enabled="true">
</c-premium-appointment-controller>

<c-dynamic-pricing-controller 
    bu-enabled="false"
    territory-enabled="true"
    account-enabled="true"
    channel-enabled="false">
</c-dynamic-pricing-controller>
```

### Pricing Control Room app
- App Launcher → Pricing Control Room
- Tabs: Dynamic Pricing Settings and Premium Appointment Settings
- To place both LWCs on the app’s Home page: Home → Gear → Edit Page → drag `dynamicPricingController` and `premiumAppointmentController` onto the canvas → Save.

## Events

Both components dispatch `togglechange` events when toggles are modified:

```javascript
// Event detail structure
{
    type: 'businessUnit',     // Toggle type that changed
    enabled: true,            // New state
    allStates: {              // All current states
        businessUnit: true,
        territory: false,
        account: false,
        channel: true
    }
}
```

## Customization

- Modify CSS variables in the component CSS files
- Adjust colors, gradients, and animations
- Extend Apex controllers for additional business logic
- Add new toggle types by updating the component logic

## API Methods

### Premium Appointment Controller
- `updatePremiumAppointmentSetting(String settingType, Boolean isEnabled)`
- `getPremiumAppointmentSettings()` - Returns Map<String, Boolean>
- `isPremiumAppointmentEnabled(String settingType)`
- `bulkUpdatePremiumAppointmentSettings(Map<String, Boolean> settingsMap)`

### Dynamic Pricing Controller
- `updateDynamicPricingSetting(String settingType, Boolean isEnabled)`
- `getDynamicPricingSettings()` - Returns Map<String, Boolean>
- `isDynamicPricingEnabled(String settingType)`
- `getDynamicPriceMultiplier(String settingType, String recordId)`
- `bulkUpdateDynamicPricingSettings(Map<String, Boolean> settingsMap)`

## Seed Data (optional)

Insert default records for both objects so toggles have initial values:

- Anonymous Apex (file provided): `scripts/seed.apex`
- Run: `sf apex run -o <alias> -f scripts/seed.apex`

Creates records for: `businessUnit`, `territory`, `account`, `channel` with `Is_Enabled__c=false`.

## Troubleshooting

- OAuth port in use (1717): free the port or set `oauthLocalPort` in `sfdx-project.json`; or use `sfdx force:auth:web:login -p 1719`.
- LWC targets: supported targets are App, Home, Record, and Community Page. Avoid deprecated `lightning__TabPage`.
- “NothingToDeploy”: use `--ignore-conflicts` or run from the project root.
- After deploy, custom fields can take a moment to appear in SOQL; if queries fail, retry after ~1–2 minutes.

## License

Open source - feel free to modify and extend for your needs!
