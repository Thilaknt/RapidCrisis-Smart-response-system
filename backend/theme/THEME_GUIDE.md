# Professional Theme System - Complete Guide

## Overview

A clean, accessible, enterprise-grade design system tailored for the **Rapid Response System** mobile and web applications. Built with Material 3 principles and WCAG AA compliance.

---

## Philosophy

**Less is More**: Professional, functional design that gets out of the way and lets content shine. Focused on:
- **Clarity**: Clear information hierarchy
- **Accessibility**: WCAG AA compliant throughout
- **Performance**: Minimal CSS, system fonts
- **Responsiveness**: Mobile-first approach
- **Semantic**: Meaningful colors and spacing

---

## Color Palette

### Neutral Grays (Primary)
Used for text, backgrounds, borders
```
Gray 950: #0F172A  (Primary text)
Gray 900: #1A202C  (High emphasis)
Gray 800: #2D3748  (Body text)
Gray 700: #4A5568  (Secondary body)
Gray 600: #718096  (Placeholder)
...
Gray 100: #FAFBFC (Lightest bg)
White:    #FFFFFF
```

### Primary Blue
Professional, trust-inducing
```
Blue 600: #3B82F6  (Primary actions)
Blue 500: #60A5FA  (Hover)
Blue 100: #EFF6FF  (Light bg)
```

### Semantic Colors
Clear status indication
```
Success:  #10B981  (Operational, resolved)
Warning:  #F59E0B  (Caution, pending)
Error:    #EF4444  (Failed, issue)
Critical: #DC2626  (Emergency, dispatch)
Info:     #0EA5E9  (Notification)
```

---

## Typography

### Font Stack
```
System UI: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial
Code:     'Menlo', 'Monaco', 'Courier New'
```

### Scale
```
Display XL:  36px (App title level)
Display LG:  32px 
Display MD:  28px
Display SM:  24px

Page Title:  28px
Section:     20px
Card Title:  16px

Body LG:     16px (Intro)
Body MD:     14px (Standard)
Body SM:     12px (Secondary)

Caption:     12px (Metadata)
Micro:       11px (Smallest)
```

### Weights
```
Regular:    400
Medium:     500
Semibold:   600
Bold:       700
```

---

## Spacing System

### Base Unit: 4px
```
xs:   2px  (Minimal)
xxs:  4px  (Extra tight)
sm:   8px  (Tight)
md:   12px (Small)
lg:   16px (Standard) ← Most common
xlg:  20px
xl:   24px (Section padding)
xxl:  28px
xxx:  32px
...
xl6:  64px (Large sections)
```

### Common Patterns
```
Form Field Spacing:    16px (lg)
List Item Padding:     16px (lg)
Card Padding:          16px (lg)
Dialog Padding:        24px (xl)
Section Padding:       24px (xl)
Page Margin:           16px (lg)
```

---

## Components

### Buttons
All buttons use 8px border-radius (radiusMd)
```
Primary:   Blue bg, white text, shadow
Secondary: Light gray bg, dark text, border
Outline:   Transparent bg, blue border
Text:      No background, blue text

Heights:
- Small:   32px
- Medium:  48px (default)
- Large:   56px
```

### Cards
```
Background: White
Border:     1px light gray
Radius:     12px (radiusLg)
Padding:    16px (lg)
Shadow:     Subtle (elevationSm)
Hover:      Enhanced shadow
```

### Alerts
```
Success:   Green bg/border/text
Warning:   Amber bg/border/text
Error:     Red bg/border/text
Info:      Cyan bg/border/text
Critical:  Dark red bg/border/text

Format:    4px left border, padding 16px
```

### Badges
```
Background: Color-based (success, warning, etc)
Text:       Inverse color
Padding:    8px 12px
Radius:     8px
Font:       12px semibold
```

### Forms
```
Input Height:    48px
Padding:         16px horizontal
Border:          1px light gray
Radius:          8px
Focus:           Blue border + shadow
Background:      Light gray

Label:           14px medium, dark
Help Text:       12px tertiary
Error Text:      12px red
```

---

## Flutter Usage

### 1. Setup Theme
```dart
import 'package:your_app/theme/app_theme.dart';

MaterialApp(
  title: 'Rapid Response System',
  theme: AppTheme.lightTheme,
  home: const HomePage(),
)
```

### 2. Use Colors
```dart
import 'package:your_app/theme/tokens/colors.dart';

Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.white),
  ),
)
```

### 3. Use Typography
```dart
import 'package:your_app/theme/tokens/typography.dart';

Text('Hello', style: AppTypography.displayLarge)
Text('Body text', style: AppTypography.body)
Text('Small text', style: AppTypography.caption)
```

### 4. Use Spacing
```dart
import 'package:your_app/theme/tokens/spacing.dart';

Padding(
  padding: EdgeInsets.all(AppSpacing.lg), // 16px
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg), // 12px
    ),
  ),
)
```

### 5. Use Components
```dart
import 'package:your_app/theme/components/app_components.dart';

// Status badge
StatusBadge.success('Operational')
StatusBadge.warning('Pending')
StatusBadge.critical('Active Response')

// Alert card
AlertCard(
  title: 'New Alert',
  message: 'Emergency response requested',
  type: AlertType.critical,
)

// Stat tile
StatTile(
  label: 'Responses',
  value: '42',
  unit: 'active',
)
```

---

## Web Usage

### 1. Include CSS
```html
<link rel="stylesheet" href="/theme/professional.css">
```

### 2. Use Semantic HTML
```html
<button class="btn btn-primary">Get Started</button>
<button class="btn btn-secondary">Cancel</button>
<button class="btn btn-outline">Learn More</button>
```

### 3. Status Indicators
```html
<div class="alert alert-success">
  <div class="alert-title">Success</div>
  <p>Operation completed successfully</p>
</div>

<span class="badge badge-critical">ACTIVE</span>
```

### 4. Cards
```html
<div class="card">
  <div class="card-header">
    <h2 class="card-title">Response Requests</h2>
  </div>
  <div class="card-body">
    Content here...
  </div>
</div>
```

### 5. Forms
```html
<div class="form-group">
  <label class="form-label" for="email">Email</label>
  <input 
    id="email"
    type="email" 
    class="form-control" 
    placeholder="your@email.com"
  >
  <div class="form-help">We'll never share your email</div>
</div>
```

### 6. Layout
```html
<div class="container">
  <div class="row">
    <div class="col col-6">50% width</div>
    <div class="col col-6">50% width</div>
  </div>
</div>
```

---

## Responsive Breakpoints

```
Mobile:   < 480px
Tablet:   480px - 768px
Desktop:  > 768px
```

### CSS Media Queries
```css
@media (max-width: 768px) { }
@media (max-width: 480px) { }
```

### Flutter Responsive
```dart
final isMobile = MediaQuery.of(context).size.width < 480;
final isTablet = MediaQuery.of(context).size.width < 768;
```

---

## Accessibility

### WCAG AA Compliance
- All text has minimum 4.5:1 contrast ratio
- Touch targets minimum 48x48px
- Focus visible on all interactive elements
- Semantic HTML and proper color meaning

### Color Meaning
- 🟢 Green = Success, operational
- 🟡 Amber = Warning, pending
- 🔴 Red = Error, critical
- 🔵 Blue = Information, primary action

### Don't Rely on Color Alone
Always include icons, text, or patterns

---

## Best Practices

### Do
✅ Use semantic colors for status
✅ Keep spacing consistent (4px base unit)
✅ Use system fonts for performance
✅ Maintain 4.5:1 contrast ratios
✅ Make touch targets 48px minimum
✅ Use 8px or 12px border-radius
✅ Test on real devices
✅ Keep designs simple and functional

### Don't
❌ Use colors outside the palette
❌ Use inconsistent spacing
❌ Add decorative shadows unnecessarily
❌ Ignore contrast ratios
❌ Make touch targets smaller than 48px
❌ Use custom fonts without good reason
❌ Over-style or over-engineer components
❌ Break the grid/spacing system

---

## File Structure

### Flutter
```
lib/theme/
├── app_theme.dart              # Main Material 3 theme
├── tokens/
│   ├── colors.dart             # Color tokens
│   ├── typography.dart         # Text styles
│   └── spacing.dart            # Spacing scale
└── components/
    └── app_components.dart     # Reusable widgets
```

### Web
```
backend/theme/
└── professional.css            # All CSS
```

---

## Examples

### Flutter: Status Display
```dart
Row(
  children: [
    StatusBadge.critical('Active'),
    SizedBox(width: AppSpacing.lg),
    Text('Emergency Response', style: AppTypography.sectionTitle),
  ],
)
```

### Web: Alert Section
```html
<div class="alert alert-critical">
  <div class="alert-title">Critical Alert</div>
  <p>Emergency dispatch requested for Area 5</p>
</div>
```

### Flutter: Loading State
```dart
SkeletonLoader(
  width: 200,
  height: 100,
  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
)
```

### Web: Response Card
```html
<div class="card">
  <div class="card-header">
    <h3 class="card-title">Response #2341</h3>
    <span class="badge badge-critical">ACTIVE</span>
  </div>
  <div class="card-body">
    <p><strong>Location:</strong> Downtown Station</p>
    <p><strong>Type:</strong> Medical Emergency</p>
  </div>
</div>
```

---

## Customization

### Changing Primary Color
**Flutter:**
```dart
// In app_theme.dart, update ColorScheme
primary: Color(0xFF2563EB), // New blue
```

**Web:**
```css
:root {
  --color-primary: #2563eb;
  --color-blue-600: #2563eb;
}
```

### Adjusting Spacing
Update the base unit in spacing files and all proportions adjust automatically.

---

## Support & Questions

For implementation questions, refer to:
- Flutter files for mobile
- CSS file for web
- Component examples in app_components.dart

Keep the system consistent across all platforms for best user experience.

**Remember:** Consistency builds trust. Users understand systems they can predict.
