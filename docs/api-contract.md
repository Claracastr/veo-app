# VEO — Contrato de API REST v0.1.0

## Objetivo
Esta documentação descreve a **API mock** do VEO para aluguel de carros entre pessoas. Os exemplos de request e response servem como acordo entre cliente Flutter e servidor. Não há pagamento, seguro, verificação de documentos ou locação real nesta etapa.

- Base URL desktop/iOS simulator: `http://localhost:8080`
- Android emulator: `http://10.0.2.2:8080`
- Content-Type: `application/json; charset=utf-8`
- Rotas privadas: `Authorization: Bearer demo-token`
- Credenciais da demonstração: `clara@veo.app` / `123456`
- Datas: ISO 8601 `YYYY-MM-DD`; valores: BRL, número com 2 casas na resposta.

## Endpoints

| Método | Rota | Auth | Resposta |
|---|---|---|---|
| GET | `/health` | Não | 200 |
| POST | `/auth/login` | Não | 200 |
| POST | `/auth/logout` | Sim | 204 |
| GET | `/me` | Sim | 200 |
| GET | `/vehicles?search=&city=` | Sim | 200 |
| GET | `/vehicles/:id` | Sim | 200 |
| GET | `/bookings` | Sim | 200 |
| GET | `/bookings/:id` | Sim | 200 |
| POST | `/bookings` | Sim | 201 |
| DELETE | `/bookings/:id` | Sim | 204 |
| POST | `/reset` | Sim | 204 |

## Requisições e respostas

### GET /health
Request sem body.
**200**
```json
{"status":"ok","version":"0.1.0"}
```

### POST /auth/login
**Request**
```json
{"email":"clara@veo.app","password":"123456"}
```
**200**
```json
{"token":"demo-token","user":{"id":"usr_001","name":"Clara Castro","email":"clara@veo.app"}}
```
**401**: `invalid_credentials`.

### POST /auth/logout
Header `Authorization: Bearer demo-token`. **204** sem body. *No mock, token estático não é revogado; apenas simula a rota.*

### GET /me
**200**
```json
{"id":"usr_001","name":"Clara Castro","email":"clara@veo.app"}
```

### GET /vehicles?search=Jeep
**200**
```json
{"items":[{"id":"car_001","brand":"Jeep","model":"Renegade","year":"2023","city":"Palmas, TO","transmission":"Automático","fuel":"Flex","seats":5,"dailyPrice":219,"rating":4.9,"available":true,"description":"SUV confortável, perfeito para viagens.","imageUrl":"https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=1000"}],"total":1}
```
Query opcional: `search` faz busca textual por marca, modelo, cidade e transmissão; `city` filtra por cidade.

### GET /vehicles/car_001
**200**: objeto do veículo mostrado acima, sem wrapper `items`. **404**: `not_found`.

### GET /bookings
**200**
```json
{"items":[],"total":0}
```

### POST /bookings
**Request**
```json
{"vehicleId":"car_001","startDate":"2026-12-15","endDate":"2026-12-17"}
```
**201** (exemplo assumindo veículo livre e data futura no momento da execução)
```json
{"id":"book_001","vehicleId":"car_001","startDate":"2026-12-15","endDate":"2026-12-17","status":"pending","total":657}
```
Regra de cálculo: dias **inclusivos** = diferença entre datas + 1; `total = dias × dailyPrice`. Status inicial `pending` (solicitação ainda não aprovada). **422**: data inválida, data anterior a hoje ou ID inexistente. **409**: período sobreposto a reserva não cancelada.

### GET /bookings/book_001
**200**: objeto da reserva criada acima. **404**: `not_found`.

### DELETE /bookings/book_001
**204** sem body: marca reserva como `cancelled`; não apaga histórico. **404**: `not_found`.

### POST /reset
**204** sem body: apaga apenas reservas na memória. Endpoint exclusivo do ambiente acadêmico.

## Modelo padronizado de erro
```json
{"error":{"code":"validation","message":"Dados inválidos","fields":{"startDate":"Data inválida"}}}
```

| HTTP | code | Uso |
|---|---|---|
| 400 | bad_request | JSON não parseável |
| 401 | invalid_credentials | Credenciais incorretas |
| 401 | unauthorized | Token ausente/inválido |
| 401 | token_expired | Falha simulada, header X-Fail |
| 404 | not_found | Recurso/rota não existe |
| 409 | conflict | Reserva em período ocupado |
| 422 | validation | Campo não atende à regra |
| 500 | internal | Erro interno ou falha simulada |

## Como testar com cURL
```bash
curl http://localhost:8080/health
curl -X POST http://localhost:8080/auth/login -H 'Content-Type: application/json' -d '{"email":"clara@veo.app","password":"123456"}'
curl http://localhost:8080/vehicles -H 'Authorization: Bearer demo-token'
curl -X POST http://localhost:8080/bookings -H 'Authorization: Bearer demo-token' -H 'Content-Type: application/json' -d '{"vehicleId":"car_001","startDate":"2026-12-15","endDate":"2026-12-17"}'
```

## Observações técnicas
Mock em memória: dados reiniciam quando servidor reinicia; token demonstrativo é fixo; CORS liberado apenas para desenvolvimento; não há banco, criptografia, autenticação de produção nem pagamento.
