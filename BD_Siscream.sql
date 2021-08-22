#################################################################################
######################### SISTEMA COMERCIAL SISCREAM 1.0 ########################

################################## ALUNOS #######################################
# André Raymundo | Gabriel Henrique | Gabrielly Lorraynne | Paulo Santos        #
# Thallia Michelle | Victor Daniel                                              #
#################################################################################

############################ REQUISITOS FUNCIONAIS ##############################
# Cadastrar Cliente, Cadastrar Funcionário, Vender Produto, Abrir Caixa         #
# Fazer Login, Cadastrar Produto, Lançar gasto, Fechar caixa, Consultar         #
# estoque, Devolver produto, Consultar cliente, Repor estoque             #
#################################################################################

############################## BANCO DE DADOS ###################################

CREATE DATABASE siscream;
USE siscream;

################################# TABELAS #######################################

CREATE TABLE tb_produto (
	cod_prod int not null PRIMARY KEY auto_increment,
	nome_prod varchar (100) not null,
	unidademed_prod varchar (100) not null,
	datavalidade_prod date not null,
	tipo_prod varchar (100) not null,
    estoque_prod int,
	fabricante_prod varchar (100) not null,
	marca_prod varchar (100) not null,
	codbarras_prod varchar (100) not null,
	comissao_prod int not null,
	preco_prod float not null,
	custo_prod float not null,
	descricao_prod varchar (200) not null
);

CREATE TABLE tb_Venda_Produto (
Cod_vendaProd int not null PRIMARY KEY auto_increment,
quantidade_prodVenda int
);

CREATE TABLE tb_pessoa_fisica (
    cod_pfisica int not null PRIMARY KEY auto_increment,
    Nome_pfisica varchar(100) not null,
    CPF_pfisica varchar(11) not null,
    Telefone_pfisica varchar(14),
    DataNascimento date,
    Email_pfisica varchar(100),
    Sexo_pfisica varchar(9) not null
);

CREATE TABLE tb_pessoa_juridica (
    Cod_pjuridica int not null PRIMARY KEY auto_increment,
    NomeFantasia_pjuridica varchar (100) not null,
    CNPJ_pjuridica varchar(20) not null,
    InscricaoMunicipal_pjuridica varchar(20) not null,
    Email_pjuridica varchar(100) not null,
    telefoneFixo_pjuridica varchar (20) not null,
    celular_pjuridica varchar (20) not null
);

CREATE TABLE tb_endereco (
    Cod_end int not null PRIMARY KEY auto_increment,
    Logradouro_end varchar (100) not null, 
    Numero_end varchar(5) not null,
    Bairro_end varchar(15) not null,
    Cidade_end varchar (100) not null, 
    UF_end varchar(2) not null,
    CEP_end varchar (10) not null
);

CREATE TABLE tb_funcionario (
    Cod_func int not null PRIMARY KEY auto_increment,
    rg_func varchar (15) not null,
    cargo_func varchar (20) not null,
    tipoContrato_func varchar (20) not null,
    senha_func varchar (20) not null,
    dataAdmissao_func date not null
);

CREATE TABLE tb_gerente (
    Cod_gerente int not null PRIMARY KEY auto_increment
);

CREATE TABLE tb_proprietario (
    Cod_prop int not null PRIMARY KEY auto_increment
);

CREATE TABLE tb_cliente (
    Cod_cli int not null PRIMARY KEY auto_increment
);

CREATE TABLE tb_venda (
    cod_venda int primary key not null auto_increment,
	valor_venda float,
    formaPagamento_venda varchar(100),
	data_venda date
);

CREATE TABLE tb_caixa (
    cod_caixa int primary key not null auto_increment,
    funcionario_caixa varchar (100),
    periodo_caixa varchar (100),
    senha_caixa varchar (20),
    valorAbertura_caixa double,
	entradas_caixa double,
	saidas_caixa double,
    saldofinal_caixa double
);

CREATE TABLE tb_gasto (
	cod_gas int not null primary key auto_increment,
	Descricao_gas varchar (100) not null,
	valor_gas float not null,
    data_gas date,
	cod_caixa_fk int not null,
	foreign key (cod_caixa_fk) references tb_Caixa (cod_caixa) 
);

######################### ADICIONANDO FKS DE ENDERECO ###########################

ALTER TABLE tb_pessoa_fisica
ADD COLUMN cod_end_fk int,
ADD FOREIGN KEY (cod_end_fk) 
REFERENCES tb_endereco(cod_end);
 
ALTER TABLE tb_pessoa_juridica
ADD COLUMN cod_end_fk int,
ADD FOREIGN KEY (cod_end_fk) 
REFERENCES tb_endereco(cod_end);

###################### ADICIONANDO FKS DE PESSOA FISICA #########################

ALTER TABLE tb_funcionario
ADD COLUMN cod_pfisica_fk int,
ADD FOREIGN KEY (cod_pfisica_fk) 
REFERENCES tb_pessoa_fisica(cod_pfisica);

ALTER TABLE tb_cliente
ADD COLUMN cod_pjuridica_fk int,
ADD FOREIGN KEY (cod_pjuridica_fk) 
REFERENCES tb_pessoa_juridica(cod_pjuridica);

###################### ADICIONANDO FKS DE GERENTE #########################

ALTER TABLE tb_gerente
ADD COLUMN cod_func_fk int,
ADD FOREIGN KEY (cod_func_fk) 
REFERENCES tb_funcionario(Cod_func);

###################### ADICIONANDO FKS DE PROPRIETÁRIO #########################

ALTER TABLE tb_proprietario
ADD COLUMN cod_pjuridica_fk int,
ADD FOREIGN KEY (cod_pjuridica_fk) 
REFERENCES tb_pessoa_juridica(cod_pjuridica);

###################### ADICIONANDO FKS DE PRODUTO VENDA #########################

ALTER TABLE tb_Venda_Produto
ADD COLUMN cod_prod_fk int,
ADD FOREIGN KEY (cod_prod_fk) 
REFERENCES tb_produto(cod_prod);

ALTER TABLE tb_Venda_Produto
ADD COLUMN cod_venda_fk int,
ADD FOREIGN KEY (cod_venda_fk) 
REFERENCES tb_venda(cod_venda);

###################### ADICIONANDO FKS DE CAIXA E VENDA  ########################

ALTER TABLE tb_caixa
ADD COLUMN cod_venda_fk int,
ADD FOREIGN KEY (cod_venda_fk) 
REFERENCES tb_venda(cod_venda);

ALTER TABLE tb_venda
ADD COLUMN cod_caixa_fk int,
ADD FOREIGN KEY (cod_caixa_fk) 
REFERENCES tb_caixa(cod_caixa);

ALTER TABLE tb_venda
ADD COLUMN cod_func_fk int,
ADD FOREIGN KEY (cod_func_fk) 
REFERENCES tb_funcionario(cod_func);

############################ GATILHOS E PROCEDIMENTOS ###########################
############################## CADASTRAR PRODUTO ################################

DELIMITER $$
CREATE PROCEDURE pr_CadastrarProduto (nome varchar(100), unidade varchar (5),
validade date, tipo varchar (20), estoque int, fabricante varchar (20), marca varchar (20), 
codbarras varchar (20), comissao int, preco float, custo float, descricao varchar (200))
BEGIN

	INSERT INTO tb_produto (cod_prod, nome_prod, unidademed_prod, datavalidade_prod, tipo_prod, estoque_prod, 
    fabricante_prod, marca_prod, codbarras_prod, comissao_prod, preco_prod, custo_prod, descricao_prod)
	VALUES (null, nome, unidade, validade, tipo, estoque, fabricante, marca, codbarras, comissao, preco, custo, descricao);

	SELECT 'Produto cadastrado com sucesso' AS Confirmacao;
    
END $$ DELIMITER ;

CALL pr_CadastrarProduto ('Picole de Abacate', 'gr', '2022-08-25',
'Picole',750, 'Jibom Sorvetes', 'Jibom', 0258812213, 25, 1.5, 50, 'Ingredientes:
açucar, leite em pó, leite, água, sabor artificial, gordura vegetal,
amido de milho. Contem gluten. Contem sacarose');

CALL pr_CadastrarProduto ('Picole de Leitininho', 'gr', '2022-08-25',
'Picole',750, 'Jibom Sorvetes', 'Jibom', 0258812213, 25, 1.5, 50, 'Ingredientes:
açucar, leite em pó, leite, água, sabor artificial, gordura vegetal,
amido de milho. Contem gluten. Contem sacarose');

CALL pr_CadastrarProduto ('Picole de Nata', 'gr', '2022-08-25',
'Picole',750, 'Jibom Sorvetes', 'Jibom', 0258812213, 25, 1.5, 50, 'Ingredientes:
açucar, leite em pó, leite, água, sabor artificial, gordura vegetal,
amido de milho. Contem gluten. Contem sacarose');

CALL pr_CadastrarProduto ('Picole de Morango', 'gr', '2022-08-25',
'Picole', 550,'Jibom Sorvetes', 'Jibom', 02514125, 25, 1, 35, 'Ingredientes:
açucar, leite em pó, água, sabor artificial,
amido de milho. Contem gluten. Contem sacarose');

CALL pr_CadastrarProduto ('Picole de Abacaxi', 'gr', '2022-08-25',
'Picole', 550,'Jibom Sorvetes', 'Jibom', 02514125, 25, 1, 35, 'Ingredientes:
açucar, leite em pó, água, sabor artificial,
amido de milho. Contem gluten. Contem sacarose');

CALL pr_CadastrarProduto ('Picole de Limão', 'gr', '2022-08-25',
'Picole', 550,'Jibom Sorvetes', 'Jibom', 02514125, 25, 1, 35, 'Ingredientes:
açucar, leite em pó, água, sabor artificial,
amido de milho. Contem gluten. Contem sacarose');

CALL pr_CadastrarProduto ('Caixa de sorvetes 10l', 'lt', '2022-08-25',
'Sorvete', 100,'Tropical sorvetes', 'Tropical', 8521412541, 15, 75, 20, 
'Ingredientes: açucar, leite em pó, água, sabor artificial,amido de milho.
 Contem gluten. Contem sacarose');

CALL pr_CadastrarProduto ('Caixa de sorvetes 5l', 'lt', '2022-08-25',
'Sorvete', 20,'Tropical sorvetes', 'Tropical', 536412, 15, 55, 20, 'Ingredientes:
açucar, leite em pó, água, sabor artificial,
amido de milho. Contem gluten. Contem sacarose');

CALL pr_CadastrarProduto ('Pote de açai 2L', 'lt', '2022-08-25',
'Açai', 50,'Skimo Ltda', 'skimo', 1243264235, 25, 25, 26, 'Ingredientes:
açucar, leite em pó, , polpa de açai, xarope de guarana, água,
amido de milho. Contem gluten. Contem sacarose');

select * from tb_produto;

############################## CADASTRAR ENDERECO ###############################

DELIMITER $$
CREATE PROCEDURE pr_CadastrarEndereco (logradouro varchar(100), numero varchar (11), bairro varchar (100), 
cidade varchar (100), uf varchar (100), cep varchar(15))
BEGIN

	INSERT INTO tb_endereco (cod_end, logradouro_end, numero_end, bairro_end, cidade_end, uf_end, cep_end)
	VALUES (null, logradouro, numero, bairro, cidade, uf, cep);

	SELECT 'Endereço cadastrado com sucesso' AS Confirmacao;

END $$ DELIMITER ;

CALL pr_CadastrarEndereco ('Rua do Céu', 526, 'Migrantes', 'Ouro-Preto', 'RO', 769000023);
CALL pr_CadastrarEndereco ('AV. 5 de Maio', 1469, 'Centro', 'Ji-Paraná','RO','76900709');
CALL pr_CadastrarEndereco ('AV. Dom Augusto', 715, 'Centro', 'Ji-Paraná','RO','76900007');
CALL pr_CadastrarEndereco ('AV. 7 de setembro', 749, 'Centro', 'Presidente Médici','RO','76900801');

select * from tb_endereco;

############################ CADASTRAR PESSOA FISICA ###########################

DELIMITER $$
CREATE PROCEDURE pr_CadastrarPessoaFisica (nome varchar(100), cpf varchar (11), telefone varchar (100), 
nascimento date, email varchar (100), sexo varchar(15), cod_endereco INT)
BEGIN

	INSERT INTO tb_pessoa_fisica (cod_pfisica, nome_pfisica, cpf_pfisica , telefone_pfisica, DataNascimento, email_pfisica, sexo_pfisica, cod_end_fk)
	VALUES (null, nome, cpf, telefone, nascimento, email, sexo, cod_endereco);

	SELECT 'Pessoa cadastrada com sucesso' AS Confirmacao;

END $$ DELIMITER ;

CALL pr_CadastrarPessoaFisica ('Victor Daniel', '05263259869', 69985142563 ,'2003-05-21', 'victordaniel@gmail.com', 'Masculino', 3);
CALL pr_CadastrarPessoaFisica ('Thallia Michelle', 05896325106, 69999752362,'2003-11-22', 'thalliamichele@gmail.com','Feminino', 2);
CALL pr_CadastrarPessoaFisica ('Paulo Santos', 04496532263, 69999742831,'2003-08-25', 'Paulo252003@hotmail.com','Masculino', 1);

select * from tb_pessoa_fisica;

############################ CADASTRAR PESSOA JURIDICA ###########################

DELIMITER $$
CREATE PROCEDURE pr_CadastrarPessoaJuridica (nome varchar(100), cnpj varchar (20), inscricao varchar (100), 
email varchar (100), telefone varchar(15), celular varchar(15), endereco int)
BEGIN

	INSERT INTO tb_pessoa_Juridica (cod_pjuridica, nomeFantasia_pjuridica, cnpj_pjuridica , inscricaoMunicipal_pjuridica, 
    email_pjuridica, telefonefixo_pjuridica, celular_pjuridica, cod_end_fk) 
    VALUES (null, nome, cnpj, inscricao, email, telefone, celular, endereco);

	SELECT 'Pessoa Juridica cadastrada com sucesso' AS Confirmacao;

END $$ DELIMITER ;

CALL pr_CadastrarPessoaJuridica ('Andre sorvetes', 12589765-0, 4568253, 'SorvetesAndrezinho@gmail.com',694513562, 6999958623263, 4);

select nomefantasia_pjuridica Fantasia, email_pjuridica email, telefonefixo_pjuridica Fone, 
logradouro_end logradouro, uf_end estado, cidade_end cidade 
from tb_pessoa_juridica, tb_endereco WHERE cod_end_fk = cod_end;

############################ CADASTRAR FUNCIONARIO ############################

DELIMITER $$
CREATE PROCEDURE pr_CadastrarFuncionario (rg varchar(100), cargo varchar (100),
tipoContrato varchar (100), senha varchar (20), dataAdmissao date, cod_pfisica_fk INT)
BEGIN

	INSERT INTO tb_funcionario (cod_func, rg_func, cargo_func, tipoContrato_func, senha_func, dataAdmissao_func, cod_pfisica_fk)
	VALUES (null, rg, cargo, tipoContrato, senha, dataAdmissao, cod_pfisica_fk);

	SELECT 'Funcionario cadastrado com sucesso' AS Confirmacao;

END $$ DELIMITER ;

CALL pr_CadastrarFuncionario (15246897, 'Auxiliar de produção', 'Diarista', '******', '2020-05-25', '1');
CALL pr_CadastrarFuncionario (1548756, 'Consultora de Vendas', 'Carteira assinada','*******', '2021-08-19', '2');
CALL pr_CadastrarFuncionario (69800752, 'Gerente', 'Carteira assinada','*******', '2019-01-05', '3');

select nome_pfisica Funcionário, email_pfisica email, cargo_func Cargo, 
tipocontrato_func tipocontrato, senha_func senhaAcesso, dataAdmissao_func Admissao 
from tb_pessoa_fisica, tb_funcionario WHERE cod_pfisica_fk= cod_pfisica;

############################# INSERIR PRODUTO VENDA #############################

DELIMITER $$
CREATE PROCEDURE pr_InserirProdVenda (CodProds INT, quantidade INT)
BEGIN

IF (quantidade <= (SELECT estoque_prod FROM tb_produto WHERE cod_prod = CodProds)) THEN

	INSERT INTO tb_venda_produto (quantidade_prodVenda, cod_prod_fk) VALUES (quantidade, CodProds);
    
		UPDATE tb_produto SET estoque_prod = estoque_prod - quantidade WHERE CodProds= cod_prod;
		SELECT 'Quantidade inserida com sucesso!' AS confirmação;
        
ELSE
	SELECT 'A quantidade deve ser menor ou igual ao estoque do produto!' AS Erro;
    
END IF;
END $$ DELIMITER ;

CALL pr_InserirProdVenda (1,50);

select * from tb_venda_produto;
select * from tb_produto;

################################ REALIZAR VENDA ##################################

DELIMITER $$
CREATE PROCEDURE pr_VenderProduto (CodProds INT, quantidade INT, formapagamento VARCHAR (100), vendedor VARCHAR(100))
BEGIN

DECLARE PrecoVenda FLOAT;
DECLARE pegarpreco FLOAT;
DECLARE verificar_estoque INT;
DECLARE verificar_vendedor VARCHAR(100);
DECLARE saldoCaixa DOUBLE;
DECLARE valorabertura DOUBLE;
DECLARE valorsaida DOUBLE;

SET verificar_vendedor= (SELECT nome_pfisica FROM tb_pessoa_fisica WHERE nome_pfisica = vendedor);
SET verificar_estoque= (SELECT estoque_prod FROM tb_produto WHERE cod_prod = CodProds);
SET pegarpreco = (SELECT preco_prod FROM tb_produto WHERE cod_prod= CodProds);
SET PrecoVenda = pegarpreco * quantidade;
SET valorabertura = (SELECT valorAbertura_caixa FROM tb_caixa WHERE cod_caixa = cod_caixa);
SET valorsaida = (SELECT saidas_caixa FROM tb_caixa WHERE cod_caixa = cod_caixa);
SET saldoCaixa = (SELECT saldofinal_caixa FROM tb_caixa WHERE cod_caixa = (SELECT MAX(cod_caixa) FROM tb_caixa));

IF(valorabertura IS NULL) THEN
	SET valorabertura = 0;
END IF;

IF(valorsaida IS NULL) THEN
	SET valorsaida = 0;
END IF;

IF(saldoCaixa IS NULL) THEN
	SET saldoCaixa = 0;
END IF;

SET saldoCaixa = saldoCaixa + ((valorabertura + PrecoVenda) - valorsaida);


IF (quantidade <= verificar_estoque) THEN
    IF (vendedor = verificar_vendedor) THEN
    
	INSERT INTO tb_venda (cod_venda, valor_venda, data_venda, formaPagamento_venda ) 
    VALUES (null, precoVenda, now(), formapagamento);
    
    INSERT INTO tb_venda_produto (cod_vendaProd, quantidade_prodVenda, cod_prod_fk) 
    VALUES (null, quantidade, codProds);
    
	UPDATE tb_produto SET estoque_prod = estoque_prod - quantidade WHERE CodProds= cod_prod;
    
START TRANSACTION;

	IF NOT EXISTS (SELECT cod_caixa FROM tb_caixa WHERE funcionario_caixa = vendedor) THEN
    
		INSERT INTO tb_caixa (cod_caixa, funcionario_caixa, valorAbertura_caixa, entradas_caixa, saidas_caixa, saldofinal_caixa, cod_venda_fk) 
		VALUES (null, vendedor, valorabertura, precoVenda, valorsaida, saldoCaixa, null);
        
        
    ELSE 
		UPDATE tb_caixa SET entradas_caixa = entradas_caixa + precoVenda WHERE funcionario_caixa= vendedor;

    END IF;
COMMIT;

		SELECT 'Venda realizada com sucesso!' AS confirmação;
    
		ELSE 
		SELECT 'Vendedor informado não está cadastrado na empresa ' AS Erro;
    
    END IF;
ELSE
	SELECT 'A quantidade deve ser menor ou igual ao estoque do produto!' AS Erro;
    
END IF;
END $$ DELIMITER ;

CALL pr_VenderProduto (3,2, 'Cartão de Crédito', 'Thallia Michelle');
CALL pr_VenderProduto (1,10, 'Dinheiro', 'Paulo Santos');

select cod_venda codigo, valor_venda valor, formaPagamento_venda Forma_Pagamento, data_venda from tb_venda;
select cod_caixa codigo, funcionario_caixa funcionario, entradas_caixa entradas from tb_caixa;
select cod_prod codigo, nome_prod Nome, tipo_prod tipo, estoque_prod estoque, codbarras_prod Codigo_barras, preco_prod preço from tb_produto;
select cod_vendaprod codigo, quantidade_prodvenda quantidade, cod_prod_fk codigo_produto from tb_venda_produto;

###################### CADASTRAR CLIENTE ###############################

DELIMITER $$
CREATE PROCEDURE pr_CadastrarCliente (codigo_pjurida int)
BEGIN

	INSERT INTO tb_cliente (cod_pjuridica_fk) Values (codigo_pjurida);
	SELECT 'Cliente cadastrado com sucesso' AS Confirmacao;

END $$ DELIMITER ;

CALL pr_CadastrarCliente (1);
SELECT * FROM tb_cliente;

###################### ABRIR CAIXA ###############################

DELIMITER $$
CREATE PROCEDURE pr_AbrirCaixa (nome VARCHAR(100), periodo VARCHAR(100), senha VARCHAR(20))
BEGIN
	DECLARE valorabertura DOUBLE;
    DECLARE testesenha VARCHAR(20);
    
    SET valorabertura = (SELECT saldofinal_caixa FROM tb_caixa WHERE cod_caixa = (SELECT MAX(cod_caixa) FROM tb_caixa));
    SET testesenha = (SELECT senha_func FROM tb_funcionario WHERE senha = senha_func limit 1);
    
    IF(senha = testesenha) THEN
		INSERT INTO tb_caixa(cod_caixa, funcionario_caixa, periodo_caixa, senha_caixa, valorAbertura_caixa)
		VALUES (null, nome, periodo, senha, valorabertura);
    
		SELECT 'Caixa aberto com sucesso' AS Confirmacao;
    ELSE 
		SELECT 'Senha incorreta, tente novamente' AS Erro_Senha;
    END IF;
	

END $$ DELIMITER ;

CALL pr_AbrirCaixa ('Victor Daniel', 'Matutino', '*******');

select * from tb_caixa;

###################### FECHAR CAIXA ###############################

DELIMITER $$
CREATE PROCEDURE pr_FecharCaixa (cod_caixaaberto int, saida DOUBLE)
BEGIN
    DECLARE valorabertura DOUBLE;
    DECLARE valorfinal DOUBLE;
    DECLARE valorentradas DOUBLE;
    DECLARE valorsaida DOUBLE;
    
    SET valorabertura = (SELECT valorAbertura_caixa FROM tb_caixa WHERE cod_caixa = cod_caixaaberto);
    SET valorentradas = (SELECT entradas_caixa FROM tb_caixa WHERE cod_caixa = cod_caixaaberto);
    SET valorsaida = (SELECT saidas_caixa FROM tb_caixa WHERE cod_caixa = cod_caixaaberto);
    
    IF (valorentradas is null) then
		SET valorentradas = 0;
	END IF;
    
     IF (valorsaida is null) then
		SET valorsaida= 0;
	END IF;
    
    
    SET valorsaida = saida + valorsaida;
    
    SET valorfinal = (valorabertura + valorentradas) - valorsaida;
    
	UPDATE tb_caixa SET saidas_caixa = valorsaida WHERE cod_caixa = cod_caixaaberto;
	UPDATE tb_caixa SET saldofinal_caixa = valorfinal WHERE cod_caixa = cod_caixaaberto;
    UPDATE tb_caixa SET entradas_caixa = valorentradas WHERE cod_caixa = cod_caixaaberto;
    
    SELECT 'Caixa aberto com sucesso' AS Confirmacao;

END $$ DELIMITER ;

CALL pr_FecharCaixa (3, 1);
SELECT * FROM tb_caixa;

###################### FAZER LOGIN ###############################

DELIMITER $$
CREATE PROCEDURE pr_Login (CPF VARCHAR(11), senha VARCHAR (20))
BEGIN
	DECLARE testecpf VARCHAR(11);
    DECLARE testesenha VARCHAR(20);
    
    
    SET testecpf = (SELECT cpf_pfisica FROM tb_pessoa_fisica WHERE CPF = cpf_pfisica );
    SET testesenha = (SELECT senha_func FROM tb_funcionario WHERE senha = senha_func limit 1);
    
    IF(testecpf = CPF) THEN
		IF(testesenha = senha) THEN
			SELECT 'Bem Vindo!!!' AS Confirmacao;
        ELSE
			SELECT 'Senha Incorreta' AS Erro_Senha;
        END IF;
	ELSE
		SELECT 'CPF Incorreto' AS Erro_CPF;
    END IF;
END $$ DELIMITER ;

CALL pr_Login('05263259869', '*******');

###################### LANÇAR GASTOS ###############################

DELIMITER $$
CREATE PROCEDURE pr_Lançar_Gastos (valor DOUBLE, descricao VARCHAR (100), caixa INT)
BEGIN
	DECLARE testecaixa INT;
	DECLARE valorabertura DOUBLE;
    DECLARE valorfinal DOUBLE;
    DECLARE valorentradas DOUBLE;
    DECLARE valorsaida DOUBLE;
    
    SET valorabertura = (SELECT saldofinal_caixa FROM tb_caixa WHERE cod_caixa = (caixa - 1));
    SET valorentradas = (SELECT entradas_caixa FROM tb_caixa WHERE cod_caixa = caixa);
    SET valorsaida = (SELECT saidas_caixa FROM tb_caixa WHERE cod_caixa = caixa);
    SET testecaixa = (SELECT cod_caixa FROM tb_caixa WHERE cod_caixa = caixa);
   
	IF(testecaixa = caixa) THEN
		IF (valorabertura is null) then
			SET valorabertura = 0;
		END IF;
    
		IF (valorentradas is null) then
			SET valorentradas = 0;
		END IF;
    
		IF (valorsaida is null) then
			SET valorsaida= 0;
		END IF;
    
		SET valorsaida = valor + valorsaida;
		SET valorfinal = (valorabertura + valorentradas) - valorsaida;
        
        UPDATE tb_caixa SET saldofinal_caixa = valorfinal WHERE cod_caixa = caixa;
        UPDATE tb_caixa SET saidas_caixa = valorsaida WHERE cod_caixa = caixa;
        UPDATE tb_caixa SET valorAbertura_caixa = valorabertura WHERE cod_caixa = caixa;
        
		INSERT INTO tb_gasto VALUES (null, descricao, valor, now(), caixa);
        
		
        
        SELECT 'Gasto Adicionado' AS Confirmacao;
    ELSE
		SELECT 'Informe um Caixa Aberto' AS Confirmacao;
    END IF;
	
END $$ DELIMITER ;

CALL pr_Lançar_Gastos (10, 'Compra de remaça de Sorvete KiBom', 3);
CALL pr_Lançar_Gastos (5, 'Devolução de produto', 2);
CALL pr_Lançar_Gastos (5, 'Devolução de produto', 1);
select * from tb_gasto;
select * from tb_caixa;