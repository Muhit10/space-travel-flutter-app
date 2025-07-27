import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:random_01_space_travel/core/constants.dart';
import 'package:random_01_space_travel/theme/app_theme.dart';

class BookMissionScreen extends StatefulWidget {
  final String planetName;
  
  const BookMissionScreen({super.key, required this.planetName});

  @override
  State<BookMissionScreen> createState() => _BookMissionScreenState();
}

class _BookMissionScreenState extends State<BookMissionScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form values
  String _selectedMissionType = AppConstants.missionTypes.first;
  DateTime _departureDate = DateTime.now().add(const Duration(days: 30));
  int _passengerCount = 1;
  bool _includeSpaceSuit = true;
  bool _includeZeroGravityTraining = false;
  bool _includeAlienLanguageTranslator = false;
  
  // Calculated values
  int get _baseCost => 10000 + (AppConstants.planetNames.indexOf(widget.planetName) * 5000);
  int get _missionTypeCost => AppConstants.missionTypes.indexOf(_selectedMissionType) * 3000;
  int get _passengerCost => _passengerCount * _baseCost;
  int get _extrasCost => (_includeSpaceSuit ? 2000 : 0) + 
                         (_includeZeroGravityTraining ? 5000 : 0) + 
                         (_includeAlienLanguageTranslator ? 3000 : 0);
  int get _totalCost => _passengerCost + _missionTypeCost + _extrasCost;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Trip to ${widget.planetName}'),
        backgroundColor: AppTheme.deepSpace,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.spaceGradient,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            children: [
              // Header image
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: AppConstants.spacingL),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonBlue.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/planet_${AppConstants.planetNames.indexOf(widget.planetName) % 12}.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ).animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.2, end: 0),
              
              // Mission type selection
              _buildSectionTitle('Mission Type'),
              _buildMissionTypeSelector(),
              
              const SizedBox(height: AppConstants.spacingL),
              
              // Departure date
              _buildSectionTitle('Departure Date'),
              _buildDatePicker(),
              
              const SizedBox(height: AppConstants.spacingL),
              
              // Passenger count
              _buildSectionTitle('Number of Passengers'),
              _buildPassengerCounter(),
              
              const SizedBox(height: AppConstants.spacingL),
              
              // Extras
              _buildSectionTitle('Extras'),
              _buildExtrasCheckboxes(),
              
              const SizedBox(height: AppConstants.spacingXL),
              
              // Cost summary
              _buildCostSummary(),
              
              const SizedBox(height: AppConstants.spacingXL),
              
              // Book now button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.neonPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                  ),
                  child: Text(
                    'Book Now',
                    style: AppTheme.buttonText.copyWith(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: Text(
        title,
        style: AppTheme.headingMedium,
      ),
    ).animate()
      .fadeIn(duration: 400.ms)
      .slideX(begin: -0.1, end: 0);
  }
  
  Widget _buildMissionTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.spaceBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppTheme.neonBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: AppConstants.missionTypes.map((type) => 
          RadioListTile<String>(
            title: Text(type, style: AppTheme.bodyLarge),
            subtitle: Text(
              '${type == AppConstants.missionTypes.first ? "Basic" : type == AppConstants.missionTypes.last ? "Premium" : "Standard"} package',
              style: AppTheme.bodySmall,
            ),
            value: type,
            groupValue: _selectedMissionType,
            activeColor: AppTheme.neonPink,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedMissionType = value;
                });
              }
            },
          ),
        ).toList(),
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.spaceBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppTheme.neonBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected date: ${DateFormat('MMMM d, y').format(_departureDate)}',
            style: AppTheme.bodyLarge,
          ),
          const SizedBox(height: AppConstants.spacingM),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Change Date'),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _departureDate,
                  firstDate: DateTime.now().add(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: AppTheme.neonPink,
                          onPrimary: Colors.white,
                          surface: AppTheme.deepSpace,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor: AppTheme.spaceBlue,
                      ),
                      child: child!,
                    );
                  },
                );
                
                if (picked != null && picked != _departureDate) {
                  setState(() {
                    _departureDate = picked;
                  });
                }
              },
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildPassengerCounter() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.spaceBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppTheme.neonBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Passengers',
            style: AppTheme.bodyLarge,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _passengerCount > 1
                    ? () {
                        setState(() {
                          _passengerCount--;
                        });
                      }
                    : null,
                color: AppTheme.neonPink,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                  vertical: AppConstants.spacingS,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.deepSpace,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Text(
                  _passengerCount.toString(),
                  style: AppTheme.headingSmall,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _passengerCount < 10
                    ? () {
                        setState(() {
                          _passengerCount++;
                        });
                      }
                    : null,
                color: AppTheme.neonPink,
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildExtrasCheckboxes() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.spaceBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppTheme.neonBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildCheckboxItem(
            'Space Suit',
            'Custom-fitted space suit for your journey',
            _includeSpaceSuit,
            (value) {
              if (value != null) {
                setState(() {
                  _includeSpaceSuit = value;
                });
              }
            },
            '2,000 credits',
          ),
          const Divider(color: AppTheme.spaceGrey),
          _buildCheckboxItem(
            'Zero Gravity Training',
            'Pre-flight training to prepare for zero gravity',
            _includeZeroGravityTraining,
            (value) {
              if (value != null) {
                setState(() {
                  _includeZeroGravityTraining = value;
                });
              }
            },
            '5,000 credits',
          ),
          const Divider(color: AppTheme.spaceGrey),
          _buildCheckboxItem(
            'Alien Language Translator',
            'Universal translator for potential alien encounters',
            _includeAlienLanguageTranslator,
            (value) {
              if (value != null) {
                setState(() {
                  _includeAlienLanguageTranslator = value;
                });
              }
            },
            '3,000 credits',
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildCheckboxItem(
    String title,
    String subtitle,
    bool value,
    Function(bool?) onChanged,
    String price,
  ) {
    return CheckboxListTile(
      title: Text(title, style: AppTheme.bodyLarge),
      subtitle: Text(subtitle, style: AppTheme.bodySmall),
      secondary: Text(price, style: AppTheme.bodyMedium),
      value: value,
      activeColor: AppTheme.neonPink,
      checkColor: Colors.white,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
  
  Widget _buildCostSummary() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.deepSpace.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: AppTheme.neonPink.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonPink.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Summary',
            style: AppTheme.headingMedium.copyWith(
              color: AppTheme.neonPink,
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          _buildSummaryRow('Base Cost', '${NumberFormat('#,###').format(_baseCost)} credits'),
          _buildSummaryRow('Mission Type', '${NumberFormat('#,###').format(_missionTypeCost)} credits'),
          _buildSummaryRow('Passengers (${_passengerCount}x)', '${NumberFormat('#,###').format(_passengerCost)} credits'),
          _buildSummaryRow('Extras', '${NumberFormat('#,###').format(_extrasCost)} credits'),
          const Divider(color: AppTheme.spaceGrey),
          _buildSummaryRow(
            'Total',
            '${NumberFormat('#,###').format(_totalCost)} credits',
            isTotal: true,
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal ? AppTheme.headingSmall : AppTheme.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? AppTheme.headingSmall.copyWith(color: AppTheme.neonPink)
                : AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  
  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      // Show booking confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.deepSpace,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            side: BorderSide(
              color: AppTheme.neonBlue.withOpacity(0.5),
              width: 2,
            ),
          ),
          title: Text(
            'Booking Confirmed!',
            style: AppTheme.headingMedium.copyWith(
              color: AppTheme.neonPink,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your journey to ${widget.planetName} has been booked!',
                style: AppTheme.bodyLarge,
              ),
              const SizedBox(height: AppConstants.spacingM),
              Text(
                'Mission: $_selectedMissionType',
                style: AppTheme.bodyMedium,
              ),
              Text(
                'Departure: ${DateFormat('MMMM d, y').format(_departureDate)}',
                style: AppTheme.bodyMedium,
              ),
              Text(
                'Passengers: $_passengerCount',
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppConstants.spacingM),
              Text(
                'Total: ${NumberFormat('#,###').format(_totalCost)} credits',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.spacingL),
              Text(
                'A confirmation has been sent to your registered contact. Please arrive at the spaceport 3 hours before departure.',
                style: AppTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // Close dialog
                context.go('/home'); // Return to home screen
              },
              child: Text(
                'Return to Home',
                style: AppTheme.buttonText.copyWith(
                  color: AppTheme.neonBlue,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.neonPink,
              ),
              child: Text(
                'View Booking',
                style: AppTheme.buttonText,
              ),
            ),
          ],
        ),
      );
    }
  }
}