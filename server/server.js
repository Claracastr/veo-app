const http = require('node:http');
const { URL } = require('node:url');
const fs = require('node:fs');
const pathModule = require('node:path');
const cars = require('./vehicles.json');
const dataFile = process.env.VEO_DATA_FILE || pathModule.join(__dirname, 'data', 'bookings.json');
const listingFile = process.env.VEO_LISTINGS_FILE || pathModule.join(pathModule.dirname(dataFile), 'listings.json');
function readListings() {try{return JSON.parse(fs.readFileSync(listingFile,'utf8'));}catch(e){if(e.code==='ENOENT')return [];throw e;}}
const listings=readListings();
function persistListings(){fs.mkdirSync(pathModule.dirname(listingFile),{recursive:true});const tmp=listingFile+'.tmp';fs.writeFileSync(tmp,JSON.stringify(listings,null,2));fs.renameSync(tmp,listingFile);}
function allCars(){return cars.concat(listings.filter(v=>v.status==='active').map(v=>({...v,available:true,rating:0})));}

function readBookings() {
 try { return JSON.parse(fs.readFileSync(dataFile, 'utf8')); }
 catch (error) { if (error.code === 'ENOENT') return []; throw error; }
}
const bookings = readBookings();
function persistBookings() {
 fs.mkdirSync(pathModule.dirname(dataFile), {recursive:true});
 const temp = dataFile + '.tmp';
 fs.writeFileSync(temp, JSON.stringify(bookings, null, 2));
 fs.renameSync(temp, dataFile);
}
const users = [{id:'usr_001',name:'Clara Castro',email:'clara@veo.app'}];
const send = (res,status,body) => {res.writeHead(status,{'Content-Type':'application/json; charset=utf-8','Access-Control-Allow-Origin':'*','Access-Control-Allow-Headers':'Content-Type,Authorization,X-Fail','Access-Control-Allow-Methods':'GET,POST,PUT,PATCH,DELETE,OPTIONS'});res.end(status===204?'':JSON.stringify(body));};
const err = (res,status,code,message,fields) => send(res,status,{error:{code,message,...(fields?{fields}:{})}});
const read = async req => {let input='';for await(const chunk of req){input+=chunk;if(input.length>100000)throw Error('Request too large');}return input?JSON.parse(input):{};};
const date = s => typeof s==='string' && /^\d{4}-\d{2}-\d{2}$/.test(s) && !Number.isNaN(Date.parse(s)) && new Date(s).toISOString().slice(0,10)===s;
function app(req,res){run(req,res).catch(e=>err(res,e instanceof SyntaxError?400:500,e instanceof SyntaxError?'bad_request':'internal',e.message));}
async function run(req,res){
 if(req.method==='OPTIONS')return send(res,204);
 const url=new URL(req.url,'http://localhost');const path=url.pathname;
 if(req.headers['x-fail']==='server')return err(res,500,'internal','Falha simulada');
 if(path==='/health'&&req.method==='GET')return send(res,200,{status:'ok',version:'0.1.0'});
 if(path==='/auth/login'&&req.method==='POST'){const b=await read(req);if(b.email==='clara@veo.app'&&b.password==='123456')return send(res,200,{token:'demo-token',user:users[0]});return err(res,401,'invalid_credentials','Credenciais inválidas');}
 if(req.headers.authorization!=='Bearer demo-token')return err(res,401,'unauthorized','Informe um token válido');
 if(req.headers['x-fail']==='expired')return err(res,401,'token_expired','Sessão expirada');
 if(path==='/auth/logout'&&req.method==='POST')return send(res,204);
 if(path==='/me'&&req.method==='GET')return send(res,200,users[0]);
 if(path==='/vehicles'&&req.method==='GET'){const q=(url.searchParams.get('search')||'').toLowerCase();let filtered=allCars().filter(c=>(c.brand+' '+c.model+' '+c.city+' '+c.transmission).toLowerCase().includes(q));if(url.searchParams.has('city'))filtered=filtered.filter(c=>c.city.toLowerCase().includes(url.searchParams.get('city').toLowerCase()));return send(res,200,{items:filtered,total:filtered.length});}
 const carMatch=path.match(/^\/vehicles\/([a-zA-Z0-9_]+)$/);
 if(carMatch&&req.method==='GET'){const c=allCars().find(x=>x.id===carMatch[1]);return c?send(res,200,c):err(res,404,'not_found','Veículo não encontrado');}
 if(path==='/my-listings'&&req.method==='GET'){const own=listings.filter(v=>v.ownerId===users[0].id);return send(res,200,{items:own,total:own.length});}
 if(path==='/my-listings'&&req.method==='POST'){
  const b=await read(req);const fields={};
  for(const k of ['brand','model','year','city','transmission','fuel','description'])if(typeof b[k]!=='string'||!b[k].trim())fields[k]='Campo obrigatório';
  if(!Number.isInteger(Number(b.seats))||Number(b.seats)<2||Number(b.seats)>8)fields.seats='Lugares inválidos';
  if(!Number.isFinite(Number(b.dailyPrice))||Number(b.dailyPrice)<=0||Number(b.dailyPrice)>10000)fields.dailyPrice='Diária inválida';
  const year=Number(b.year);if(!Number.isInteger(year)||year<1980||year>new Date().getFullYear()+1)fields.year='Ano inválido';
  const photos=b.photoUrls||[];if(!Array.isArray(photos)||photos.length>3||photos.some(v=>typeof v!=='string'||!v.startsWith('https://')))fields.photoUrls='Fotos devem ser URLs HTTPS (máximo 3)';
  if(Object.keys(fields).length)return err(res,422,'validation','Revise os dados do anúncio',fields);
  const listing={id:'owner_'+Date.now()+'_'+Math.floor(Math.random()*100000),ownerId:users[0].id,brand:b.brand.trim(),model:b.model.trim(),year:String(b.year),city:b.city.trim(),transmission:b.transmission.trim(),fuel:b.fuel.trim(),description:b.description.trim(),imageUrl:photos[0]||'',photoUrls:photos,seats:Number(b.seats),dailyPrice:Number(b.dailyPrice),status:'active'};
  listings.push(listing);persistListings();return send(res,201,listing);
 }
 const listingMatch=path.match(/^\/my-listings\/(owner_[a-zA-Z0-9_]+)$/);
 if(listingMatch&&req.method==='PATCH'){
  const item=listings.find(v=>v.id===listingMatch[1]&&v.ownerId===users[0].id);if(!item)return err(res,404,'not_found','Anúncio não encontrado');
  const b=await read(req);if(!['active','paused'].includes(b.status))return err(res,422,'validation','Status inválido');
  item.status=b.status;persistListings();return send(res,200,item);
 }
 if(path==='/bookings'&&req.method==='GET'){const own=bookings.filter(b=>b.userId===users[0].id);return send(res,200,{items:own,total:own.length});}
 if(path==='/bookings'&&req.method==='POST'){
  const b=await read(req);const fields={};const car=allCars().find(x=>x.id===b.vehicleId);
  if(!car)fields.vehicleId='Veículo inexistente';if(!date(b.startDate))fields.startDate='Data inválida';if(!date(b.endDate))fields.endDate='Data inválida';
  if(Object.keys(fields).length)return err(res,422,'validation','Dados inválidos',fields);
  const start=Date.parse(b.startDate),end=Date.parse(b.endDate),today=Date.parse(new Date().toISOString().slice(0,10));
  if(start<today||end<start)return err(res,422,'validation','Período inválido',{dates:'Retirada deve ser hoje ou futura; devolução >= retirada'});
  if(bookings.some(x=>x.vehicleId===b.vehicleId&&x.status!=='cancelled'&&b.startDate<=x.endDate&&b.endDate>=x.startDate))return err(res,409,'conflict','Veículo indisponível nessas datas');
  const days=Math.round((end-start)/86400000)+1;const booking={id:'book_'+String(Date.now())+'_'+String(Math.floor(Math.random()*100000)),userId:users[0].id,vehicleId:b.vehicleId,startDate:b.startDate,endDate:b.endDate,status:'pending',total:Number((days*car.dailyPrice).toFixed(2))};bookings.push(booking);persistBookings();return send(res,201,booking);
 }
 const bookingMatch=path.match(/^\/bookings\/(book_[a-zA-Z0-9_]+)$/);
 if(bookingMatch&&req.method==='GET'){const b=bookings.find(x=>x.id===bookingMatch[1]&&x.userId===users[0].id);return b?send(res,200,b):err(res,404,'not_found','Reserva não encontrada');}
 if(bookingMatch&&req.method==='DELETE'){const b=bookings.find(x=>x.id===bookingMatch[1]&&x.userId===users[0].id);if(!b)return err(res,404,'not_found','Reserva não encontrada');b.status='cancelled';persistBookings();return send(res,204);}
 if(path==='/reset'&&req.method==='POST'){bookings.length=0;persistBookings();listings.length=0;persistListings();return send(res,204);}
 return err(res,404,'not_found','Rota não encontrada');
}
if(require.main===module){const port=Number(process.env.PORT||8080);http.createServer(app).listen(port,()=>console.log('VEO mock API: http://localhost:'+port));}
module.exports={app,cars,bookings,listings};
