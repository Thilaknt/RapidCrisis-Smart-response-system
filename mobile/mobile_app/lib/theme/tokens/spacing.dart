/// Consistent Spacing & Sizing System
/// Based on 4px base unit for clean, proportional layouts
/// Follows Material Design 3 spacing guidelines

abstract class AppSpacing {
  // ========== BASE UNIT ==========
  /// Base unit for all spacing calculations (4px)
  static const double baseUnit = 4.0;

  // ========== SPACING SCALE ==========
  /// 2px - Minimal/tight spacing
  static const double xs = baseUnit * 0.5;
  
  /// 4px - Extra tight spacing
  static const double xxs = baseUnit * 1.0;
  
  /// 8px - Tight spacing (between inline elements)
  static const double sm = baseUnit * 2.0;
  
  /// 12px - Small spacing
  static const double md = baseUnit * 3.0;
  
  /// 16px - Default/standard spacing (most common)
  static const double lg = baseUnit * 4.0;
  
  /// 20px - Medium-large spacing
  static const double xlg = baseUnit * 5.0;
  
  /// 24px - Large spacing (section padding)
  static const double xl = baseUnit * 6.0;
  
  /// 28px - Extra large spacing
  static const double xxl = baseUnit * 7.0;
  
  /// 32px - 2XL spacing (major sections)
  static const double xxx = baseUnit * 8.0;
  
  /// 40px - 3XL spacing
  static const double xl3 = baseUnit * 10.0;
  
  /// 48px - 4XL spacing (page margins)
  static const double xl4 = baseUnit * 12.0;
  
  /// 56px - 5XL spacing
  static const double xl5 = baseUnit * 14.0;
  
  /// 64px - 6XL spacing (large section spacing)
  static const double xl6 = baseUnit * 16.0;

  // ========== COMMON PATTERNS ==========
  /// Inline element spacing (xs between items)
  static const double inlineSpacing = sm;
  
  /// Form field spacing
  static const double formFieldSpacing = lg;
  
  /// List item padding
  static const double listItemPadding = lg;
  
  /// Card padding
  static const double cardPadding = lg;
  
  /// Dialog padding
  static const double dialogPadding = xl;
  
  /// Section padding
  static const double sectionPadding = xl;
  
  /// Page margin
  static const double pageMargin = lg;
  
  /// Horizontal padding (mobile)
  static const double screenPadding = lg;

  // ========== BORDER RADIUS ==========
  /// No rounding - square corners
  static const double radiusNone = 0.0;
  
  /// Tight rounding - 4px (small elements)
  static const double radiusSm = 4.0;
  
  /// Standard rounding - 8px (most elements)
  static const double radiusMd = 8.0;
  
  /// Large rounding - 12px (cards, inputs)
  static const double radiusLg = 12.0;
  
  /// Extra large rounding - 16px (major containers)
  static const double radiusXl = 16.0;
  
  /// Full rounding - circle (avatars, floating buttons)
  static const double radiusFull = 9999.0;

  // ========== ELEVATION/SHADOWS ==========
  /// No shadow
  static const double elevationNone = 0.0;
  
  /// Subtle shadow - raised slightly
  static const double elevationSm = 1.0;
  
  /// Default shadow - standard elevation
  static const double elevationMd = 4.0;
  
  /// Large shadow - prominent elevation
  static const double elevationLg = 8.0;
  
  /// Extra large shadow - modal/dialog
  static const double elevationXl = 16.0;

  // ========== BUTTON DIMENSIONS ==========
  /// Small button height
  static const double buttonHeightSm = 32.0;
  
  /// Default button height (54pt = accessibility minimum)
  static const double buttonHeightMd = 48.0;
  
  /// Large button height
  static const double buttonHeightLg = 56.0;

  // ========== TOUCH TARGET SIZE ==========
  /// Minimum touch target size (iOS/Android standard)
  static const double touchTargetMin = 48.0;
  
  /// Comfortable touch target
  static const double touchTargetComfort = 56.0;

  // ========== ICON SIZES ==========
  /// Very small icon
  static const double iconXs = 16.0;
  
  /// Small icon
  static const double iconSm = 20.0;
  
  /// Default icon
  static const double iconMd = 24.0;
  
  /// Large icon
  static const double iconLg = 32.0;
  
  /// Extra large icon
  static const double iconXl = 48.0;

  // ========== INPUT FIELD DIMENSIONS ==========
  /// Default input height
  static const double inputHeight = 48.0;
  
  /// Input horizontal padding
  static const double inputPaddingH = lg;
  
  /// Input vertical padding
  static const double inputPaddingV = md;

  // ========== BREAKPOINTS (Responsive) ==========
  /// Mobile breakpoint
  static const double breakpointMobile = 480.0;
  
  /// Tablet breakpoint
  static const double breakpointTablet = 768.0;
  
  /// Desktop breakpoint
  static const double breakpointDesktop = 1024.0;

  // ========== MAX WIDTH ==========
  /// Maximum width for content
  static const double maxWidth = 640.0;
  
  /// Maximum width for wide content
  static const double maxWidthWide = 1000.0;
}
