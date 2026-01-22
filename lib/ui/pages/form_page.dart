import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/ui/pages/home_page.dart';
import 'package:intl/intl.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Form field controllers
  final TextEditingController _periodLengthController = TextEditingController();
  final TextEditingController _cycleLengthController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  
  // Form field values
  DateTime? _lastPeriodDate;
  String _cycleRegularity = 'Regular'; // Default to Regular
  
  // Error messages
  String? _periodLengthError;
  String? _cycleLengthError;
  String? _ageError;
  String? _dateError;
  
  @override
  void dispose() {
    _periodLengthController.dispose();
    _cycleLengthController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime. now().subtract(const Duration(days: 60)),
      lastDate: DateTime. now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xff9A0002), // Blue color for date picker
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _lastPeriodDate = picked;
        _dateError = null; // Clear error when date is selected
      });
    }
  }

  // Validate period length
  void _validatePeriodLength() {
    final value = _periodLengthController. text. trim();
    
    setState(() {
      if (value.isEmpty) {
        _periodLengthError = null;
        return;
      }
      
      final days = int.tryParse(value);
      
      if (days == null) {
        _periodLengthError = 'Please enter a valid number';
      } else if (days < 1 || days > 14) {
        _periodLengthError = 'Period length must be between 1 and 14 days';
      } else {
        _periodLengthError = null;
      }
    });
  }

  // Validate cycle length
  void _validateCycleLength() {
    final value = _cycleLengthController.text.trim();
    
    setState(() {
      if (value.isEmpty) {
        _cycleLengthError = null;
        return;
      }
      
      final days = int.tryParse(value);
      
      if (days == null) {
        _cycleLengthError = 'Please enter a valid number';
      } else if (days < 15 || days > 60) {
        _cycleLengthError = 'Cycle length must be between 15 and 60 days';
      } else {
        _cycleLengthError = null;
      }
    });
  }

  // Validate age
  void _validateAge() {
    final value = _ageController.text.trim();
    
    setState(() {
      if (value.isEmpty) {
        _ageError = null;
        return;
      }
      
      final age = int.tryParse(value);
      
      if (age == null) {
        _ageError = 'Please enter a valid number';
      } else if (age < 10 || age > 100) {
        _ageError = 'Age must be between 10 and 100 years';
      } else {
        _ageError = null;
      }
    });
  }

  void _submitForm() {
    // Validate all fields
    bool hasError = false;
    
    // Check date
    if (_lastPeriodDate == null) {
      setState(() {
        _dateError = 'Please select the first day of your last period';
      });
      hasError = true;
    }
    
    // Check period length
    final periodValue = _periodLengthController. text.trim();
    if (periodValue.isEmpty) {
      setState(() {
        _periodLengthError = 'This field is required';
      });
      hasError = true;
    } else {
      final periodDays = int.tryParse(periodValue);
      if (periodDays == null || periodDays < 1 || periodDays > 14) {
        setState(() {
          _periodLengthError = 'Period length must be between 1 and 14 days';
        });
        hasError = true;
      }
    }
    
    // Check cycle length
    final cycleValue = _cycleLengthController.text.trim();
    if (cycleValue.isEmpty) {
      setState(() {
        _cycleLengthError = 'This field is required';
      });
      hasError = true;
    } else {
      final cycleDays = int.tryParse(cycleValue);
      if (cycleDays == null || cycleDays < 15 || cycleDays > 60) {
        setState(() {
          _cycleLengthError = 'Cycle length must be between 15 and 60 days';
        });
        hasError = true;
      }
    }
    
    // Check age
    final ageValue = _ageController.text.trim();
    if (ageValue.isEmpty) {
      setState(() {
        _ageError = 'This field is required';
      });
      hasError = true;
    } else {
      final age = int.tryParse(ageValue);
      if (age == null || age < 10 || age > 100) {
        setState(() {
          _ageError = 'Age must be between 10 and 100 years';
        });
        hasError = true;
      }
    }
    
    if (hasError) {
      return;
    }

    // All validations passed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Setup completed successfully!'),
        backgroundColor: Color(0xff9A0002),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navigate to home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAE5E4),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child:  Padding(
                padding: const EdgeInsets.all(40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      const Center(
                        child: Text(
                          'Welcome to VOAT! ',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Let\'s set up your profile to get started with tracking',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Question 1: When was the first day of your last period?
                      const Text(
                        'When was the first day of your last period? ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child:  Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical:  16),
                          decoration: BoxDecoration(
                            color: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _dateError != null 
                                  ? Colors.red 
                                  : (_lastPeriodDate == null ?  Colors.transparent : const Color(0xff3396D3)),
                              width: _dateError != null || _lastPeriodDate != null ? 2 : 0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _lastPeriodDate == null
                                    ? 'mm/dd/yyyy'
                                    : DateFormat('MM/dd/yyyy').format(_lastPeriodDate!),
                                style: TextStyle(
                                  fontSize:  16,
                                  color: _lastPeriodDate == null ?  Colors.grey : Colors.black,
                                ),
                              ),
                              const Icon(Icons.calendar_today, color: Color(0xff9A0002), size: 20),
                            ],
                          ),
                        ),
                      ),
                      if (_dateError != null)
                        Padding(
                          padding: const EdgeInsets. only(left: 12, top: 8),
                          child: Text(
                            _dateError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),

                      // Question 2: How long does your period usually last?
                      const Text(
                        'How long does your period usually last?  (1-14 Days)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _periodLengthController,
                        keyboardType: TextInputType. number,
                        onChanged: (value) => _validatePeriodLength(),
                        decoration: InputDecoration(
                          hintText: 'e.g., 5',
                          hintStyle:  const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xffF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:  BorderRadius.circular(12),
                            borderSide: _periodLengthError != null 
                                ? const BorderSide(color: Colors.red, width: 2)
                                :  BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:  BorderSide(
                              color: _periodLengthError != null ?  Colors.red : const Color(0xff9A0002),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      if (_periodLengthError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 8),
                          child: Text(
                            _periodLengthError!,
                            style: const TextStyle(
                              color: Colors. red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const SizedBox(height:  30),

                      // Question 3: What is your average cycle length?
                      const Text(
                        'What is your average cycle length?  (15-60 Days)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight. w600,
                          color:  Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _cycleLengthController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _validateCycleLength(),
                        decoration: InputDecoration(
                          hintText: 'e.g., 28',
                          hintStyle:  const TextStyle(color: Colors. grey),
                          filled: true,
                          fillColor: const Color(0xffF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius. circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: _cycleLengthError != null 
                                ? const BorderSide(color: Colors.red, width: 2)
                                :  BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _cycleLengthError != null ? Colors.red : const Color(0xff9A0002),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      if (_cycleLengthError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 8),
                          child: Text(
                            _cycleLengthError!,
                            style: const TextStyle(
                              color: Colors. red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const SizedBox(height:  30),

                      // Question 4: Are your cycles regular or irregular?
                      const Text(
                        'Are your cycles regular or irregular?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight. w600,
                          color:  Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RadioListTile<String>(
                        title: const Text('Regular'),
                        value: 'Regular',
                        groupValue: _cycleRegularity,
                        activeColor: const Color(0xff9A0002),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            _cycleRegularity = value! ;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Irregular'),
                        value: 'Irregular',
                        groupValue: _cycleRegularity,
                        activeColor: const Color(0xff9A0002),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setState(() {
                            _cycleRegularity = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Question 5: What age are you?
                      const Text(
                        'What age are you?',
                        style:  TextStyle(
                          fontSize:  16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller:  _ageController,
                        keyboardType: TextInputType. number,
                        onChanged:  (value) => _validateAge(),
                        decoration: InputDecoration(
                          hintText:  'e.g., 25',
                          hintStyle:  const TextStyle(color: Colors. grey),
                          filled: true,
                          fillColor: const Color(0xffF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius. circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: _ageError != null 
                                ? const BorderSide(color: Colors.red, width: 2)
                                : BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius. circular(12),
                            borderSide: BorderSide(
                              color: _ageError != null ? Colors.red : const Color(0xff9A0002),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      if (_ageError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 8),
                          child: Text(
                            _ageError!,
                            style: const TextStyle(
                              color: Colors. red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const SizedBox(height:  40),

                      // Submit Button
                      SizedBox(
                        width:  double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff9A0002),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            "Complete Setup",
                            style:  TextStyle(
                              fontSize:  18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}