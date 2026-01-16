import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Resim paketi

import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../models/event_model.dart';
import 'qr_scan_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Seçili olan etkinliğin ID'si
  int? _selectedEventId;

  @override
  void initState() {
    super.initState();
    // Ekran açılır açılmaz verileri çek
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
    });
  }

  // Tarih Formatlayıcı
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Etkinlikler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Çıkış Yap',
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          // A) Yükleniyor
          if (eventProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          }
          // B) Hata
          if (eventProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    eventProvider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => eventProvider.fetchEvents(),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }
          // C) Liste Boş
          if (eventProvider.events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz etkinlik bulunmuyor.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            );
          }
          // D) Dolu Liste
          return RefreshIndicator(
            onRefresh: () => eventProvider.fetchEvents(),
            color: theme.primaryColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: eventProvider.events.length,
              itemBuilder: (context, index) {
                final event = eventProvider.events[index];
                return _buildEventCard(event, theme);
              },
            ),
          );
        },
      ),

      // 3. QR OKUT BUTONU
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Etkinlik seçilmemişse uyarı ver
          if (_selectedEventId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lütfen işlem yapmak için bir etkinlik seçin.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          // Seçiliyse QR ekranına git (Seçili event ID'yi buraya parametre geçebiliriz ileride)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QrScanScreen(eventId: _selectedEventId!),
            ),
          );
        },
        // Seçim yapılmadıysa buton gri (pasif) görünür
        backgroundColor: _selectedEventId == null
            ? Colors.grey
            : theme.primaryColor,
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        label: const Text(
          'QR Okut',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // KART TASARIMI
  Widget _buildEventCard(EventModel event, ThemeData theme) {
    final bool isSelected = _selectedEventId == event.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Zaten seçiliyse kaldır, değilse seç
          if (_selectedEventId == event.id) {
            _selectedEventId = null;
          } else {
            _selectedEventId = event.id;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          // Seçiliyse kalın renkli çerçeve, değilse şeffaf/ince
          border: isSelected
              ? Border.all(color: theme.primaryColor, width: 2.5)
              : Border.all(color: Colors.transparent, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // RESİM BÖLÜMÜ (Ayrı fonksiyona alındı)
              _buildEventImage(event, theme),

              const SizedBox(width: 16),

              // BİLGİ BÖLÜMÜ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tarih
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 14,
                          color: theme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(event.eventDate),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Başlık
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Açıklama
                    Text(
                      event.description.isNotEmpty
                          ? event.description
                          : 'Açıklama bulunmuyor.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              // Seçim İkonu (Tik)
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check_circle, color: theme.primaryColor),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // RESİM YÜKLEME MANTIĞI (Production Ready)
  Widget _buildEventImage(EventModel event, ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 90,
        width: 90,
        child: event.imageUrl != null && event.imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: event.imageUrl!,
                fit: BoxFit.cover,
                // Resim yüklenirken dönen çark
                placeholder: (context, url) => Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.primaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
                // Resim hatasında (404 vb.) placeholder göster
                errorWidget: (context, url, error) => _buildPlaceholder(theme),
              )
            : _buildPlaceholder(theme), // URL yoksa placeholder
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withOpacity(0.8),
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.event_available, color: Colors.white, size: 32),
      ),
    );
  }
}
