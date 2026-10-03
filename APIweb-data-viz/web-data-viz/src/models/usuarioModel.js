var database = require("../database/config")

function autenticar(email, senha) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de BD está rodando corretamente. \n\n function entrar(): ", email, senha)
 
    var instrucaoSql = `
        SELECT
            id_usuario AS id,
            nome_usuario AS nome,
            email,
            fk_empresa AS empresaId
        FROM usuario
        WHERE email = '${email}' AND senha = '${senha}' AND ativo = 1;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}
 
// Só se a tela de cadastro for usada. Mantenha a assinatura que o seu controller já chama.
function cadastrar(nome, email, senha, fkEmpresa) {
    var instrucaoSql = `
        INSERT INTO usuario (nome_usuario, email, senha, fk_empresa)
        VALUES ('${nome}', '${email}', '${senha}', '${fkEmpresa}');
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}
module.exports = {
    autenticar,
    cadastrar
};