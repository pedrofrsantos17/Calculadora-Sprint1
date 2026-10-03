require("dotenv").config({ path: ".env.dev" });
var database = require("./src/database/config");
 
// Descubra com:  SELECT id_sensor, numero_serie, localizacao FROM sensor WHERE fk_empresa = 4; esse comando foi usado para teste
var ID_SENSOR = 4;
 
var temperatura = 20;
var umidade = 75;
 
function variar(valor, min, max, passo) {
    valor += (Math.random() - 0.5) * passo;
    return Math.min(max, Math.max(min, valor));
}
 
function inserirLeitura() {
    temperatura = variar(temperatura, 15, 28, 3);
    umidade = variar(umidade, 55, 95, 8);   // chega a 90 para supor orisco do fungo míldio
 
    var instrucaoSql = `
        INSERT INTO leitura_sensor (fk_sensor, temperatura, umidade)
        VALUES (${ID_SENSOR}, ${temperatura.toFixed(2)}, ${umidade.toFixed(2)});
    `;
 
    database.executar(instrucaoSql)
        .then(function () { console.log(`Inserido -> ${temperatura.toFixed(1)} °C | ${umidade.toFixed(1)} %`); })
        .catch(function (erro) { console.error("Erro ao inserir:", erro.sqlMessage || erro); });
}
 
console.log("Simulador ligado. Ctrl + C para parar.");
setInterval(inserirLeitura, 2000);