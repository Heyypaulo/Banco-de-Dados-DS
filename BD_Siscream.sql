#################################################################################
######################### SISTEMA COMERCIAL SISCREAM 1.0 ########################

################################## ALUNOS #######################################
# André Raymundo | Gabriel Henrique | Gabrielly Lorraynne | Paulo Santos        #
# Thallia Michelle | Victor Daniel                                              #
#################################################################################

############################ REQUISITOS FUNCIONAIS ##############################
# Cadastrar Cliente, Cadastrar Funcionário, Vender Produto, Abrir Caixa         #
# Fazer Login, Cadastrar Produto, Lançar gasto, Fechar caixa, Consultar         #
# estoque, Devolver produto, Consultar cliente, Repor estoque, Menu             #
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

############################### INSERTS TESTE ###################################

INSERT INTO tb_produto VALUES (null, 'Picole de creme', 'gr', '2022-08-25',
'Picole',750, 'Jibom Sorvetes', 'Jibom', 0258812213, 25, 1.5, 50, 'Ingredientes:
açucar, leite em pó, leite, água, sabor artificial, gordura vegetal,
amido de milho. Contem gluten. Contem sacarose' );

INSERT INTO tb_produto VALUES (null, 'Picole de fruta', 'gr', '2022-08-25',
'Picole', 550,'Jibom Sorvetes', 'Jibom', 02514125, 25, 1, 35, 'Ingredientes:
açucar, leite em pó, água, sabor artificial,
amido de milho. Contem gluten. Contem sacarose' );

INSERT INTO tb_produto VALUES (null, 'Caixa de sorvetes 5l', 'lt', '2022-08-25',
'Sorvete', 20,'Tropical sorvetes', 'Tropical', 536412, 15, 55, 20, 'Ingredientes:
açucar, leite em pó, água, sabor artificial,
amido de milho. Contem gluten. Contem sacarose' );

INSERT INTO tb_produto VALUES (null, 'Caixa de sorvetes 10l', 'lt', '2022-08-25',
'Sorvete', 100,'Tropical sorvetes', 'Tropical', 8521412541, 15, 75, 20, 'Ingredientes:
açucar, leite em pó, água, sabor artificial,
amido de milho. Contem gluten. Contem sacarose' );

select * from tb_produto;

############### CADASTRAR UM FUNCIONARIO PELA ORDEM DAS TABELAS #################
################################## FUNCIONARIO 1 #################################

INSERT INTO tb_endereco VALUES (null, 'AV. Dom Augusto', 715, 'Centro', 'Ji-Paraná',
'RO','76900007');

INSERT INTO tb_pessoa_fisica VALUES (null, 'Paulo Santos', 04496532263, 69999742831,
'2003-08-25', 'Paulo252003@hotmail.com','Masculino', 1);

INSERT INTO tb_funcionario VALUES (null, 69800752, 'Gerente', 'Carteira assinada',
'*******', '2019-01-05', '1');

################################## FUNCIONARIO 2 ################################

INSERT INTO tb_endereco VALUES (null, 'AV. 5 de Maio', 1469, 'Centro', 'Ji-Paraná',
'RO','76900709');

INSERT INTO tb_pessoa_fisica VALUES (null, 'Thallia Michelle', 05896325106, 69999752362,
'2003-11-22', 'thalliamichele@gmail.com','Feminino', 2);

INSERT INTO tb_funcionario VALUES (null, 1548756, 'Consultora de Vendas', 'Carteira assinada',
'*******', '2021-08-19', '2');

############################# CONSULTAR FUNCIONARIO #############################

select nome_pfisica Funcionário, email_pfisica email, cargo_func Cargo, 
tipocontrato_func tipocontrato, senha_func senhaAcesso, dataAdmissao_func Admissao 
from tb_pessoa_fisica, tb_funcionario WHERE cod_pfisica_fk= cod_pfisica;

############################ GATILHOS E PROCEDIMENTOS ###########################
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

SET verificar_vendedor= (SELECT nome_pfisica FROM tb_pessoa_fisica WHERE nome_pfisica = vendedor);
SET verificar_estoque= (SELECT estoque_prod FROM tb_produto WHERE cod_prod = CodProds);
SET pegarpreco = (SELECT preco_prod FROM tb_produto WHERE cod_prod= CodProds);
SET PrecoVenda = pegarpreco * quantidade;
SET saldoCaixa= (SELECT saldofinal_caixa FROM tb_Caixa WHERE cod_caixa = (SELECT MAX(cod_caixa) FROM tb_Caixa));

IF (quantidade <= verificar_estoque) THEN
    IF (vendedor = verificar_vendedor) THEN
    
	INSERT INTO tb_venda (cod_venda, valor_venda, data_venda, formaPagamento_venda ) 
    VALUES (null, precoVenda, now(), formapagamento);
    
    INSERT INTO tb_venda_produto (cod_vendaProd, quantidade_prodVenda, cod_prod_fk) 
    VALUES (null, quantidade, codProds);
    
	UPDATE tb_produto SET estoque_prod = estoque_prod - quantidade WHERE CodProds= cod_prod;
    
START TRANSACTION;

	IF NOT EXISTS (SELECT cod_caixa FROM tb_caixa WHERE funcionario_caixa = vendedor) THEN
    
		INSERT INTO tb_caixa (cod_caixa, funcionario_caixa, entradas_caixa, saldofinal_caixa, cod_venda_fk) 
		VALUES (null, vendedor, precoVenda, saldoCaixa, null);
        
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

