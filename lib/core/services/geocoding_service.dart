import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Service pour le géocodage inversé (coordonnées -> adresse)
class GeocodingService {
  GeocodingService._();
  
  static final GeocodingService instance = GeocodingService._();
  
  // Cache pour éviter les appels répétés
  final Map<String, String> _addressCache = {};
  
  /// Obtient l'adresse à partir des coordonnées
  Future<String?> getAddressFromCoordinates(
    double latitude, 
    double longitude,
  ) async {
    try {
      // Vérifier le cache
      final cacheKey = '$latitude,$longitude';
      if (_addressCache.containsKey(cacheKey)) {
        return _addressCache[cacheKey];
      }
      
      // Utiliser Nominatim (OpenStreetMap) pour le géocodage inversé gratuit
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?format=json'
        '&lat=$latitude'
        '&lon=$longitude'
        '&accept-language=fr'
        '&zoom=14', // Niveau de détail (14 = ville/quartier)
      );
      
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'EcoPlates/1.0', // Requis par Nominatim
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final address = _formatAddress(data);
        
        // Mettre en cache
        _addressCache[cacheKey] = address;
        
        return address;
      } else {
        // Log error: Geocoding failed with status: ${response.statusCode}
        return null;
      }
    } catch (e) {
      // Log error: $e
      return null;
    }
  }
  
  /// Obtient l'adresse à partir de la position actuelle
  Future<String?> getAddressFromCurrentLocation() async {
    try {
      // Vérifier les permissions
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      
      // Obtenir la position actuelle
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      
      return getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      // Log error: $e
      return null;
    }
  }
  
  /// Formate l'adresse à partir des données Nominatim
  String _formatAddress(Map<String, dynamic> data) {
    final address = data['address'] as Map<String, dynamic>?;
    
    if (address == null) {
      return 'Position inconnue';
    }
    
    // Priorité : quartier/ville > municipalité > région
    final parts = <String>[];
    
    // Quartier ou lieu spécifique
    if (address['suburb'] != null) {
      parts.add(address['suburb'] as String);
    } else if (address['neighbourhood'] != null) {
      parts.add(address['neighbourhood'] as String);
    } else if (address['hamlet'] != null) {
      parts.add(address['hamlet'] as String);
    }
    
    // Ville
    if (address['city'] != null) {
      parts.add(address['city'] as String);
    } else if (address['town'] != null) {
      parts.add(address['town'] as String);
    } else if (address['village'] != null) {
      parts.add(address['village'] as String);
    } else if (address['municipality'] != null) {
      parts.add(address['municipality'] as String);
    }
    
    // Si on n'a rien trouvé, utiliser le nom d'affichage court
    if (parts.isEmpty && data['display_name'] != null) {
      final displayName = data['display_name'] as String;
      // Prendre les deux premiers éléments
      final elements = displayName.split(',');
      if (elements.isNotEmpty) {
        parts.add(elements[0].trim());
        if (elements.length > 1) {
          parts.add(elements[1].trim());
        }
      }
    }
    
    // Joindre les parties
    if (parts.isEmpty) {
      return 'Position actuelle';
    } else if (parts.length == 1) {
      return parts[0];
    } else {
      return parts.join(', ');
    }
  }
  
  /// Vide le cache d'adresses
  void clearCache() {
    _addressCache.clear();
  }
}