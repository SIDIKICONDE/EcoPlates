# 🔐 Backend API Specification - Système QR Sécurisé EcoPlates

## 📋 Vue d'ensemble

Cette spécification définit l'API backend pour le système de QR codes sécurisés d'EcoPlates, utilisant TOTP avec rotation automatique et signature HMAC-SHA256.

## 🏗️ Architecture

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│   Client    │◄────────│   Backend   │────────►│   Redis     │
│   Mobile    │         │   API       │         │   Cache     │
└─────────────┘         └─────────────┘         └─────────────┘
       │                       │                        
       │                       ▼                        
       │                ┌─────────────┐                
       └───────────────►│  PostgreSQL │                
                        │   Database  │                
                        └─────────────┘                
```

## 📊 Modèles de données

### OrderSecret
```typescript
interface OrderSecret {
  id: string;              // UUID v4
  orderId: string;         // UUID référence à Order
  merchantId: string;      // UUID référence à Merchant  
  consumerId: string;      // UUID référence à Consumer
  secret: string;          // 256 bits, chiffré AES-256-GCM
  createdAt: Date;
  expiresAt: Date;        // Généralement createdAt + 2h
  revokedAt?: Date;
  lastUsedAt?: Date;
  metadata?: {
    deviceId?: string;
    appVersion?: string;
  };
}
```

### QRValidation
```typescript
interface QRValidation {
  id: string;              // UUID v4
  orderId: string;
  merchantId: string;
  consumerId: string;
  status: 'success' | 'failed';
  failureReason?: string;
  deviceFingerprint: string;
  ipAddress: string;
  timestamp: Date;
  tokenUsed: string;      // Hash du token pour audit
  qrPayload: object;      // Payload décodé pour debug
}
```

## 🚀 Endpoints API

### 1. Génération du secret TOTP

**POST** `/api/v1/orders/:orderId/secret`

#### Request
```json
{
  "deviceId": "550e8400-e29b-41d4-a716-446655440000",
  "appVersion": "1.0.0"
}
```

#### Response (200 OK)
```json
{
  "secretId": "550e8400-e29b-41d4-a716-446655440001",
  "secret": "JBSWY3DPEHPK3PXP...",  // Base32 encoded
  "algorithm": "SHA256",
  "digits": 8,
  "period": 30,
  "createdAt": "2025-01-26T10:30:00Z",
  "expiresAt": "2025-01-26T12:30:00Z"
}
```

#### Erreurs possibles
- `404` - Commande introuvable
- `409` - Secret déjà généré pour cette commande
- `403` - Utilisateur non autorisé

### 2. Validation du QR Code

**POST** `/api/v1/qr/validate`

#### Request
```json
{
  "qrData": "eyJ2IjoiMS4wIiwibWVyY2hhbnRJZCI6IjU1MGU4NDAwLi4.",
  "deviceFingerprint": "android_550e8400...",
  "scanLocation": {
    "lat": 48.8566,
    "lng": 2.3522
  }
}
```

#### Response (200 OK - Succès)
```json
{
  "valid": true,
  "order": {
    "id": "550e8400-e29b-41d4-a716-446655440002",
    "items": [
      {
        "name": "Salade César",
        "quantity": 2,
        "price": 4.50
      }
    ],
    "totalAmount": 9.00,
    "customerName": "Jean Dupont"
  },
  "validationId": "550e8400-e29b-41d4-a716-446655440003"
}
```

#### Response (200 OK - Échec)
```json
{
  "valid": false,
  "error": "EXPIRED_TOKEN",
  "message": "Le QR code a expiré. Demandez au client de le régénérer."
}
```

#### Codes d'erreur
- `INVALID_SIGNATURE` - Signature HMAC invalide
- `EXPIRED_TOKEN` - Token TOTP expiré (hors fenêtre ±30s)
- `ALREADY_USED` - Token déjà utilisé dans cette fenêtre
- `ORDER_NOT_FOUND` - Commande inexistante
- `ORDER_ALREADY_COLLECTED` - Commande déjà récupérée
- `MERCHANT_MISMATCH` - Mauvais commerçant
- `REVOKED_SECRET` - Secret révoqué

### 3. Révocation d'urgence

**POST** `/api/v1/orders/:orderId/revoke`

#### Request
```json
{
  "reason": "device_lost",
  "details": "Téléphone volé signalé par le client"
}
```

#### Response (200 OK)
```json
{
  "orderId": "550e8400-e29b-41d4-a716-446655440002",
  "revokedAt": "2025-01-26T11:00:00Z",
  "newSecretAvailable": true
}
```

### 4. Health Check & Métriques

**GET** `/api/v1/health`

#### Response
```json
{
  "status": "healthy",
  "services": {
    "database": "up",
    "redis": "up",
    "totp": "operational"
  },
  "metrics": {
    "validations_last_5m": 1247,
    "success_rate": 0.996,
    "avg_latency_ms": 127
  }
}
```

## 🔒 Sécurité

### Headers requis
```http
X-API-Key: your-api-key
X-Device-ID: device-uuid
X-App-Version: 1.0.0
```

### Rate Limiting
- `/validate`: 100 req/min par device
- `/secret`: 5 req/min par user
- `/revoke`: 10 req/min global

### Certificate Pinning
Les apps mobiles doivent implémenter le certificate pinning avec les empreintes :
```
SHA256: 4B:22:D5:A6:AE:C9:83:D1:BE:BB:C0:4E:7A:3B:85:F4...
```

## 📈 Métriques & Monitoring

### Métriques Prometheus exposées

```prometheus
# Latence de validation
ecoplates_qr_validation_duration_seconds{quantile="0.95"} 0.180
ecoplates_qr_validation_duration_seconds{quantile="0.99"} 0.250

# Taux de succès
ecoplates_qr_validation_total{status="success"} 12453
ecoplates_qr_validation_total{status="failed"} 47

# Raisons d'échec
ecoplates_qr_validation_failures{reason="expired_token"} 23
ecoplates_qr_validation_failures{reason="invalid_signature"} 12
ecoplates_qr_validation_failures{reason="already_used"} 8
```

### Logs structurés (JSON)

```json
{
  "timestamp": "2025-01-26T10:30:45.123Z",
  "level": "info",
  "service": "qr-validator",
  "traceId": "550e8400-e29b-41d4-a716-446655440004",
  "event": "validation_success",
  "orderId": "550e8400-e29b-41d4-a716-446655440002",
  "merchantId": "550e8400-e29b-41d4-a716-446655440005",
  "latencyMs": 145,
  "tokenAge": 12
}
```

## 🧪 Tests

### Curl exemples

#### Génération de secret
```bash
curl -X POST https://api.ecoplates.com/v1/orders/550e8400/secret \
  -H "X-API-Key: test-key" \
  -H "Content-Type: application/json" \
  -d '{"deviceId": "test-device"}'
```

#### Validation QR
```bash
curl -X POST https://api.ecoplates.com/v1/qr/validate \
  -H "X-API-Key: merchant-key" \
  -H "Content-Type: application/json" \
  -d '{
    "qrData": "eyJ2IjoiMS4wIi...",
    "deviceFingerprint": "merchant-device-123"
  }'
```

## 🔄 Migration & Rollback

### Feature Flag
```json
{
  "qr_security_v2_enabled": true,
  "qr_security_v2_percentage": 100,
  "fallback_to_v1": false
}
```

### Compatibilité descendante
- Les anciens QR codes (v1) restent valides pendant 30 jours
- Double validation v1 et v2 pendant la transition
- Metrics séparées pour tracking adoption

---

*Version 2.0 - Production Ready*