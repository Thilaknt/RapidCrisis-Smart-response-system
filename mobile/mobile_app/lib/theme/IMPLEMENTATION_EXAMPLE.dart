/// IMPLEMENTATION EXAMPLE - Copy this to your main.dart

import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const RapidResponseApp());
}

class RapidResponseApp extends StatelessWidget {
  const RapidResponseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapid Response System',
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme, // Enable when dark theme is ready
      themeMode: ThemeMode.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapid Response System'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Example: Display content
              const Text('Active Responses'),
              const SizedBox(height: 16),
              
              // Example: Status card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Response #2341'),
                      SizedBox(height: 8),
                      Text('Emergency dispatch in progress'),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Example: Action buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Respond'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ========== QUICK REFERENCE ==========

COLORS
import 'package:your_app/theme/tokens/colors.dart';

AppColors.primary              // Blue 600
AppColors.error                // Red
AppColors.warning              // Amber
AppColors.success              // Green
AppColors.textPrimary          // Dark gray
AppColors.textSecondary        // Medium gray
AppColors.background           // White


TYPOGRAPHY
import 'package:your_app/theme/tokens/typography.dart';

AppTypography.displayLarge
AppTypography.headlineMedium
AppTypography.body
AppTypography.caption
AppTypography.buttonText


SPACING
import 'package:your_app/theme/tokens/spacing.dart';

AppSpacing.sm    // 8px
AppSpacing.md    // 12px
AppSpacing.lg    // 16px (most common)
AppSpacing.xl    // 24px

AppSpacing.radiusMd        // 8px
AppSpacing.radiusLg        // 12px
AppSpacing.buttonHeightMd  // 48px


COMPONENTS
import 'package:your_app/theme/components/app_components.dart';

StatusBadge.success('Running')
StatusBadge.warning('Pending')
StatusBadge.error('Failed')
StatusBadge.critical('Active')

AlertCard(
  title: 'Alert Title',
  message: 'Alert message',
  type: AlertType.critical,
)

StatTile(
  label: 'Responses',
  value: '42',
  unit: 'active',
)

SkeletonLoader()
EmptyState(icon: Icon(...), title: '...', message: '...')


FORMS
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'your@email.com',
  ),
)


THEME ACCESS
// Access theme colors in custom widgets
Theme.of(context).colorScheme.primary
Theme.of(context).textTheme.bodyMedium
Theme.of(context).inputDecorationTheme


BEST PRACTICES
✓ Use theme colors, not hardcoded colors
✓ Use AppSpacing constants for all padding/margin
✓ Use AppTypography styles for all text
✓ Use pre-built components (StatusBadge, AlertCard, etc)
✓ Consistent spacing and alignment
✓ Test on multiple screen sizes
✓ Follow WCAG AA contrast guidelines
*/
