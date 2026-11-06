const {test,after} = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const os = require('node:os');
const fs = require('node:fs');
const path = require('node:path');
const testDir = fs.mkdtempSync(path.join(os.tmpdir(), 'veo-test-'));
process.env.VEO_DATA_FILE = path.join(testDir, 'bookings.json');
const {app} = require('./server');
const server = http.createServer(app);
let port;
test('iniciar servidor', async () => {await new Promise(resolve=>server.listen(0,resolve));port=server.address().port;});
const call = async (path,options={}) => fetch(`http://localhost:${port}${path}`,options);
test('GET /health',async()=>{const r=await call('/health');assert.equal(r.status,200);assert.equal((await r.json()).status,'ok');});
test('login inválido',async()=>{const r=await call('/auth/login',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({email:'no',password:'no'})});assert.equal(r.status,401);});
test('autorização obrigatória',async()=>{assert.equal((await call('/vehicles')).status,401);});
test('buscar carros',async()=>{const r=await call('/vehicles?search=Jeep',{headers:{Authorization:'Bearer demo-token'}});assert.equal(r.status,200);assert.equal((await r.json()).items.length,2);});
test('reservar e bloquear conflito',async()=>{const start=new Date(Date.now()+86400000*5).toISOString().slice(0,10);const end=new Date(Date.now()+86400000*7).toISOString().slice(0,10);const options={method:'POST',headers:{Authorization:'Bearer demo-token','Content-Type':'application/json'},body:JSON.stringify({vehicleId:'car_001',startDate:start,endDate:end})};assert.equal((await call('/bookings',options)).status,201);assert.equal((await call('/bookings',options)).status,409);});
test('falha simulada',async()=>{assert.equal((await call('/vehicles',{headers:{Authorization:'Bearer demo-token','X-Fail':'server'}})).status,500);});
after(()=>{server.close();fs.rmSync(testDir,{recursive:true,force:true});});

test('listar reservas com autenticação', async () => {
 const r = await call('/bookings',{headers:{Authorization:'Bearer demo-token'}});
 assert.equal(r.status,200);
 assert.ok(Array.isArray((await r.json()).items));
});
test('rejeitar dados inválidos', async () => {
 const r = await call('/bookings',{method:'POST',headers:{Authorization:'Bearer demo-token','Content-Type':'application/json'},body:JSON.stringify({vehicleId:'inexistente',startDate:'invalid',endDate:'invalid'})});
 assert.equal(r.status,422);
 assert.equal((await r.json()).error.code,'validation');
});
test('GET /vehicles/:id e 404', async () => {
 const headers={Authorization:'Bearer demo-token'};
 assert.equal((await call('/vehicles/car_001',{headers})).status,200);
 assert.equal((await call('/vehicles/car_999',{headers})).status,404);
});

test('catálogo contém novas cidades', async () => {
 const r = await call('/vehicles?search=Curitiba',{headers:{Authorization:'Bearer demo-token'}});
 assert.equal(r.status,200);
 assert.equal((await r.json()).items.length,2);
});
test('reserva vinculada à conta e salva em arquivo', async () => {
 const start=new Date(Date.now()+86400000*40).toISOString().slice(0,10);
 const r=await call('/bookings',{method:'POST',headers:{Authorization:'Bearer demo-token','Content-Type':'application/json'},body:JSON.stringify({vehicleId:'car_005',startDate:start,endDate:start})});
 assert.equal(r.status,201);
 const item=await r.json();
 assert.equal(item.userId,'usr_001');
 assert.ok(JSON.parse(fs.readFileSync(process.env.VEO_DATA_FILE,'utf8')).some(b=>b.id===item.id));
 const listed=await call('/bookings',{headers:{Authorization:'Bearer demo-token'}});
 assert.ok((await listed.json()).items.some(b=>b.id===item.id));
});

test('proprietário publica, pausa e reativa anúncio persistente', async () => {
 const headers={Authorization:'Bearer demo-token','Content-Type':'application/json'};
 const payload={brand:'Honda',model:'Fit',year:'2020',city:'Palmas, TO',transmission:'Automático',fuel:'Flex',seats:5,dailyPrice:185,description:'Veículo de demonstração.',photoUrls:['https://example.com/fit.jpg']};
 const create=await call('/my-listings',{method:'POST',headers,body:JSON.stringify(payload)});
 assert.equal(create.status,201);
 const item=await create.json();assert.equal(item.ownerId,'usr_001');
 assert.ok(JSON.parse(fs.readFileSync(path.join(testDir,'listings.json'),'utf8')).some(v=>v.id===item.id));
 const mine=await call('/my-listings',{headers});assert.ok((await mine.json()).items.some(v=>v.id===item.id));
 const catalog=await call('/vehicles?search=Fit',{headers});assert.ok((await catalog.json()).items.some(v=>v.id===item.id));
 const pause=await call(`/my-listings/${item.id}`,{method:'PATCH',headers,body:JSON.stringify({status:'paused'})});assert.equal(pause.status,200);
 const hidden=await call('/vehicles?search=Fit',{headers});assert.ok(!(await hidden.json()).items.some(v=>v.id===item.id));
 const resume=await call(`/my-listings/${item.id}`,{method:'PATCH',headers,body:JSON.stringify({status:'active'})});assert.equal(resume.status,200);
 const shown=await call('/vehicles?search=Fit',{headers});assert.ok((await shown.json()).items.some(v=>v.id===item.id));
});

test('cadastro inválido é rejeitado',async()=>{
 const r=await call('/my-listings',{method:'POST',headers:{Authorization:'Bearer demo-token','Content-Type':'application/json'},body:JSON.stringify({brand:'',seats:0,dailyPrice:-1,photoUrls:['http://inseguro']})});
 assert.equal(r.status,422);
});

test('cancelamento remove conflito de datas',async()=>{
 const headers={Authorization:'Bearer demo-token','Content-Type':'application/json'};
 const start=new Date(Date.now()+86400000*90).toISOString().slice(0,10);
 const body=JSON.stringify({vehicleId:'car_006',startDate:start,endDate:start});
 const first=await call('/bookings',{method:'POST',headers,body});assert.equal(first.status,201);const item=await first.json();
 assert.equal((await call(`/bookings/${item.id}`,{method:'DELETE',headers})).status,204);
 const second=await call('/bookings',{method:'POST',headers,body});assert.equal(second.status,201);
});
