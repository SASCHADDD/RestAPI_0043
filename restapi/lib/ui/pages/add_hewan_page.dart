import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi/logic/bloc/Hewan/hewan_bloc.dart';
import 'package:restapi/logic/bloc/Hewan/hewan_event.dart';
import 'package:restapi/logic/bloc/Hewan/hewan_state.dart';

class AddHewanPage extends StatefulWidget {
  const AddHewanPage({super.key});

  @override
  State<AddHewanPage> createState() => _AddHewanPageState();
}

class _AddHewanPageState extends State<AddHewanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jenisController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _hargaController = TextEditingController();
  String _selectedStatus = 'tersedia';

  final List<String> _jenisOptions = ['Sapi', 'Kambing', 'Ayam', 'Domba', 'Babi', 'Lainnya'];

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _tanggalController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1A237E)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama': _namaController.text.trim(),
        'jenis': _jenisController.text.trim(),
        'tanggal_lahir': _tanggalController.text.trim(),
        'harga': int.tryParse(_hargaController.text.trim()) ?? 0,
        'status': _selectedStatus,
      };
      context.read<HewanBloc>().add(CreateHewan(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HewanBloc, HewanState>(
      listener: (context, state) {
        if (state is HewanCreatedSuccess) {
          Navigator.pop(context);
        } else if (state is HewanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Tambah Hewan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A237E), Color(0xFFAD1457)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildGlassField(
                            controller: _namaController,
                            hint: "Nama Hewan",
                            icon: Icons.pets,
                            validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                          ),
                          const SizedBox(height: 16),
                          _buildGlassDropdown(),
                          const SizedBox(height: 16),
                          _buildGlassField(
                            controller: _tanggalController,
                            hint: "Tanggal Lahir (YYYY-MM-DD)",
                            icon: Icons.calendar_today,
                            readOnly: true,
                            onTap: _pickDate,
                            validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                          ),
                          const SizedBox(height: 16),
                          _buildGlassField(
                            controller: _hargaController,
                            hint: "Harga (Rp)",
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                          ),
                          const SizedBox(height: 24),
                          _buildStatusToggle(),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _onSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text("Simpan Hewan", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
        ),
      ),
    );
  }

  Widget _buildGlassField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          errorStyle: const TextStyle(color: Colors.yellowAccent),
        ),
      ),
    );
  }

  Widget _buildGlassDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.indigo.shade900,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(border: InputBorder.none, hintText: "Pilih Jenis", hintStyle: TextStyle(color: Colors.white54), prefixIcon: Icon(Icons.category, color: Colors.white70)),
        items: _jenisOptions.map((j) => DropdownMenuItem(value: j, child: Text(j))).toList(),
        onChanged: (v) => setState(() => _jenisController.text = v ?? ''),
        validator: (v) => v == null ? "Pilih jenis" : null,
      ),
    );
  }

  Widget _buildStatusToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['tersedia', 'terjual'].map((s) {
        final isSelected = _selectedStatus == s;
        return GestureDetector(
          onTap: () => setState(() => _selectedStatus = s),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(s.toUpperCase(), style: TextStyle(color: isSelected ? Colors.white : Colors.white60, fontWeight: FontWeight.bold)),
          ),
        );
      }).toList(),
    );
  }
}