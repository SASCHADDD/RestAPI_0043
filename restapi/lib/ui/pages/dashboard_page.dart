import 'dart:ui';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:restapi/data/repositories/hewan_repository.dart';
import 'package:restapi/logic/bloc/Auth/auth_bloc.dart';
import 'package:restapi/logic/bloc/Auth/auth_event.dart';
import 'package:restapi/logic/bloc/Hewan/hewan_bloc.dart';
import 'package:restapi/logic/bloc/Hewan/hewan_event.dart';
import 'package:restapi/logic/bloc/Hewan/hewan_state.dart';
import 'package:restapi/ui/pages/edit_hewan_page.dart';
import 'package:restapi/ui/pages/add_hewan_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HewanBloc(repository: HewanRepository())..add(FetchHewan()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            "Koleksi Ternak",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Logout',
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A237E), Color(0xFFAD1457)],
                ),
              ),
            ),
            BlocListener<HewanBloc, HewanState>(
              listener: (context, state) {
                if (state is HewanCreatedSuccess) {
                  _showSnackBar(context, "Operasi Berhasil!", Colors.green);
                } else if (state is HewanError) {
                  _showSnackBar(context, state.message, Colors.red);
                }
              },
              child: BlocBuilder<HewanBloc, HewanState>(
                builder: (context, state) {
                  if (state is HewanLoading) {
                    return Center(
                      child: Lottie.asset('assets/loading.json', width: 200),
                    );
                  } else if (state is HewanLoaded) {
                    if (state.hewanList.isEmpty) {
                      return const Center(
                        child: Text(
                          "Belum ada koleksi.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                    return CustomRefreshIndicator(
                      onRefresh: () async {
                        context.read<HewanBloc>().add(FetchHewan());
                        await Future.delayed(const Duration(seconds: 2));
                      },
                      builder: (context, child, controller) {
                        return AnimatedBuilder(
                          animation: controller,
                          builder: (context, _) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                if (!controller.isIdle)
                                  Positioned(
                                    top: 50.0 * controller.value,
                                    child: Lottie.asset(
                                      'assets/loading.json',
                                      height: 80,
                                    ),
                                  ),
                                Transform.translate(
                                  offset: Offset(0, 100.0 * controller.value),
                                  child: child,
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 100, 16, 100),
                        itemCount: state.hewanList.length,
                        itemBuilder: (context, index) {
                          final hewan = state.hewanList[index];
                          return _buildGlassCard(context, hewan);
                        },
                      ),
                    );
                  }
                  return const Center(child: Text("Gagal memuat data."));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (innerContext) => BlocProvider.value(
                    value: context.read<HewanBloc>(),
                    child: const AddHewanPage(),
                  ),
                ),
              );
            },
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context, dynamic hewan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: ListTile(
              onTap: () {
                final bloc = context.read<HewanBloc>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (innerContext) => BlocProvider.value(
                      value: bloc,
                      child: EditHewanPage(hewan: hewan),
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.pets, color: Colors.white),
              ),
              title: Text(
                hewan.nama,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${hewan.jenis} • ${hewan.status}",
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _showDeleteDialog(context, hewan),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic hewan) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.indigo.shade900,
        title: const Text("Hapus Data?", style: TextStyle(color: Colors.white)),
        content: Text(
          "Yakin ingin menghapus ${hewan.nama}?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              context.read<HewanBloc>().add(DeleteHewan(hewan.id));
              Navigator.pop(dialogContext);
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}
