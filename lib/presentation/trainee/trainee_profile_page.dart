import 'package:flutter/material.dart';
import 'package:horseacademy/data/repo/user_repo.dart';
import '../../data/models/user_model.dart';

class TraineeProfilePage extends StatefulWidget {
  final UserModel user;

  const TraineeProfilePage({super.key, required this.user});

  @override
  State<TraineeProfilePage> createState() => _TraineeProfilePageState();
}

class _TraineeProfilePageState extends State<TraineeProfilePage> {
  late TextEditingController nameArController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController nationalIdController;
  late TextEditingController levelController;

  final _formKey = GlobalKey<FormState>();
  bool isEditing = false; // toggle edit mode

  @override
  void initState() {
    super.initState();
    nameArController = TextEditingController(text: widget.user.nameAr);
    phoneController = TextEditingController(text: widget.user.phoneNumber);
    emailController = TextEditingController(text: widget.user.email);
    nationalIdController = TextEditingController(text: widget.user.nationalId);
    levelController = TextEditingController(
      text: widget.user.traineeLevel?.toString(),
    );
  }

  @override
  void dispose() {
    nameArController.dispose();
    phoneController.dispose();
    emailController.dispose();
    nationalIdController.dispose();
    levelController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = widget.user.copyWith(
        nameAr: nameArController.text,
        phoneNumber: phoneController.text,
        email: emailController.text,
        nationalId: nationalIdController.text,
        traineeLevel: int.parse(levelController.text),
        passwordHash: '1234',
      );

      final UserRepo userRepo = UserRepo();
      final success = await userRepo.updateUser(updatedUser);

      if (success != '') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم تحديث البيانات بنجاح")),
        );
        setState(() {
  isEditing = false;
  widget.user.copyWith(
    nameAr: nameArController.text,
    phoneNumber: phoneController.text,
    email: emailController.text,
    nationalId: nationalIdController.text,
    traineeLevel: int.parse(levelController.text),
  );
});
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text("تم تحديث البيانات بنجاح")),
);
       // Navigator.pop(context, updatedUser); // return updated user
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("حدث خطأ أثناء التحديث")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الملف الشخصي"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: isEditing ? submit : toggleEdit,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: widget.user.photo != null
                      ? NetworkImage(widget.user.photo!)
                      : null,
                  child: widget.user.photo == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
              ),
              const SizedBox(height: 25),

              _buildField("الاسم", nameArController),
              _buildField("رقم الجوال", phoneController,
                  keyboard: TextInputType.phone),
              _buildField("البريد الإلكتروني", emailController,
                  keyboard: TextInputType.emailAddress),
              _buildField("رقم الهوية", nationalIdController),
              _buildField("المستوى", levelController,
                  keyboard: TextInputType.number),

              if (isEditing) const SizedBox(height: 30),
              if (isEditing)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "حفظ التعديلات",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.right,
        keyboardType: keyboard,
        readOnly: !isEditing, // make field read-only if not editing
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: !isEditing,
          fillColor: !isEditing ? Colors.grey[100] : null,
        ),
        validator: (value) {
          if (isEditing && (value == null || value.isEmpty)) {
            return "هذا الحقل مطلوب";
          }
          return null;
        },
      ),
    );
  }
}
