import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/userProfile/user_profile_model.dart';
import 'UserProfile_vm.dart';

class CreateStudentScreen extends GetView<UserProfileVM> {
  const CreateStudentScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final UserProfile? user = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(user!=null){
        controller.studentIdController.text = user.studentId ?? '';
        controller.studentNameController.text = user.fullName ?? '';
        controller.studentEmailController.text = user.email ?? '';
        controller.phoneNumberController.text = user.phoneNumber ?? '';
        controller.gender.value = user.gender ?? 'Male';
        controller.dateOfBirthController.text = user.dateOfBirth ?? '';
        controller.enrollmentDateController.text =
            user.enrollmentDate?.toIso8601String().split('T').first ?? '';
        controller.passwordController.text = user.password ?? '';


      }
      if (user == null) {
        controller.studentIdController.text = "STU-${DateTime.now().millisecondsSinceEpoch}";
        controller.clearFields();
      }

    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
            user == null
                ? 'Create Student'
                : 'Update Student',
          ),

        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField(
                label: 'Student ID',
                controller: controller.studentIdController,
                validatorMsg: 'Enter Student ID',
              ),
              _buildTextField(
                label: 'Name',
                controller: controller.studentNameController,
                validatorMsg: 'Enter name',
              ),
              _buildTextField(
                label: 'Email',
                controller: controller.studentEmailController,
                validatorMsg: 'Enter email',
                inputType: TextInputType.emailAddress,
                enabled: user?.email == null, // disable if email exists
                customValidator: (value) {
                  if (value == null || value.isEmpty) return 'Enter email';
                  if (!value.contains('@')) return 'Enter valid email';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Phone Number',
                controller: controller.phoneNumberController,
                validatorMsg: 'Enter phone number',
                inputType: TextInputType.phone,
              ),
              Obx(() => DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gender'),
                value: controller.gender.value,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {
                  controller.gender.value = value ?? 'Male';
                },
              )),
              const SizedBox(height: 16),
              _buildDatePickerField(
                context,
                label: 'Date of Birth',
                controller: controller.dateOfBirthController,
              ),
              _buildDatePickerField(
                context,
                label: 'Enrollment Date',
                controller: controller.enrollmentDateController,
              ),
               _buildTextField(
                label: 'Password',
                controller: controller.passwordController,
                validatorMsg: 'Enter password',
                isPassword: true,
                enabled: user== null, // Only enter when creating
                customValidator: (value) {
                  if (user != null &&
                      (value == null || value.isEmpty)) {
                    return null; // No password required on update
                  }
                  if (value == null || value.isEmpty) {
                    return 'Enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              return ElevatedButton.icon(
                icon: controller.isLoading.value
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.save),
                label: Text(
                  controller.isLoading.value
                      ? 'Processing...'
                      : (user == null ? 'Save Student' : 'Update Student'),
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                  if (controller.formKey.currentState!.validate()) {
                    // Start loading immediately
                    controller.isLoading.value = true;

                    // Let UI rebuild before doing heavy work
                      if (user == null) {
                        controller.addUserProfile();
                      } else {
                        controller.updateProfile(user);
                      }

                  }
                },
              );
            }),
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String validatorMsg,
    TextInputType inputType = TextInputType.text,
    bool isPassword = false,
    bool enabled = true,
    String? Function(String?)? customValidator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          filled: !enabled,
          fillColor: !enabled ? Colors.grey.shade200 : null,
        ),
        keyboardType: inputType,
        obscureText: isPassword,
        validator: customValidator ??
                (value) => value == null || value.isEmpty ? validatorMsg : null,
      ),
    );
  }

  Widget _buildDatePickerField(
      BuildContext context, {
        required String label,
        required TextEditingController controller,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? 'Enter $label' : null,
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            controller.text = pickedDate.toIso8601String().split('T').first;
          }
        },
      ),
    );
  }
}
