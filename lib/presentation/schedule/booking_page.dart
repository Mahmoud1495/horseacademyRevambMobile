import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  final String time;
  final String coach;
  final int price;
  final int serviceId;
  final String image; // new image field

  const BookingPage({
    super.key,
    required this.time,
    required this.coach,
    required this.price,
    required this.serviceId,
    required this.image, // added here
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int usersCount = 1;
  String paymentType = "cash";

  // Visa payment controllers
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryMonthController = TextEditingController();
  final TextEditingController expiryYearController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryMonthController.dispose();
    expiryYearController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalPrice = widget.price * usersCount;

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Reservation")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildImage(),
            const SizedBox(height: 16),
            _buildTimeslotCard(),
            const SizedBox(height: 20),
            _buildUsersDropdown(),
            const SizedBox(height: 20),
            _buildPaymentOptions(),
            if (paymentType == "visa") _buildVisaForm(),
            const SizedBox(height: 30),
            _buildTotalPrice(totalPrice),
            const SizedBox(height: 30),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  // ==========================
  // Service Image
  // ==========================
  Widget _buildImage() {
    return widget.image.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        : const SizedBox.shrink();
  }

  // ==========================
  // Timeslot Details Card
  // ==========================
  Widget _buildTimeslotCard() {
    return Card(
      child: ListTile(
        title: Text("Time: ${widget.time}"),
        subtitle: Text("Coach: ${widget.coach}"),
        trailing: Text("${widget.price} EGP"),
      ),
    );
  }

  // ==========================
  // Users Count Dropdown
  // ==========================
  Widget _buildUsersDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Number of Trainees:", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButton<int>(
          value: usersCount,
          items: List.generate(10, (i) => i + 1)
              .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
              .toList(),
          onChanged: (value) => setState(() => usersCount = value!),
        ),
      ],
    );
  }

  // ==========================
  // Payment Type Options
  // ==========================
  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Payment Method:", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        RadioListTile(
          value: "cash",
          groupValue: paymentType,
          onChanged: (value) => setState(() => paymentType = value!),
          title: const Text("Cash on Delivery"),
        ),
        RadioListTile(
          value: "visa",
          groupValue: paymentType,
          onChanged: (value) => setState(() => paymentType = value!),
          title: const Text("Visa / MasterCard"),
        ),
      ],
    );
  }

  // ==========================
  // Visa Payment Form
  // ==========================
  Widget _buildVisaForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Card Number"),
        TextField(
          controller: cardNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "XXXX XXXX XXXX XXXX"),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: expiryMonthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Expiry Month"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: expiryYearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Expiry Year"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: cvvController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "CVV"),
        ),
      ],
    );
  }

  // ==========================
  // Total Price Display
  // ==========================
  Widget _buildTotalPrice(int totalPrice) {
    return Text(
      "Total: $totalPrice EGP",
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      textAlign: TextAlign.end,
    );
  }

  // ==========================
  // Confirm Button
  // ==========================
  Widget _buildConfirmButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.deepPurple,
      ),
      onPressed: _confirmBooking,
      child: const Text(
        "Confirm Booking",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  // ==========================
  // Booking Logic
  // ==========================
  void _confirmBooking() {
    if (paymentType == "visa") {
      if (cardNumberController.text.isEmpty ||
          expiryMonthController.text.isEmpty ||
          expiryYearController.text.isEmpty ||
          cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all Visa fields")),
        );
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Completed Successfully")),
    );
  }
}
