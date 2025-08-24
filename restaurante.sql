DROP DATABASE IF EXISTS gerenciador_restaurantes;

CREATE DATABASE gerenciador_restaurantes;
USE gerenciador_restaurantes;

-- Tabela cliente
CREATE TABLE cliente (
    cliente_id INT AUTO_INCREMENT,
    nome_completo VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL, -- para dados do pagamento (simulado)
    PRIMARY KEY (cliente_id)
);

-- tabela enderecos_entrega (lista de enderecos por cliente)
CREATE TABLE enderecos_entrega (
    endereco_id INT AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    rua VARCHAR(100) NOT NULL,
    num VARCHAR(10) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    PRIMARY KEY (endereco_id),
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id) ON DELETE CASCADE
);

-- tabela enderecos_restaurante (lista de enderecos por restaurante)
CREATE TABLE enderecos_restaurante (
    id_endRest INT AUTO_INCREMENT,
    rua VARCHAR(100) NOT NULL,
    num VARCHAR(10) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_endRest)
);

-- tabela restaurante
CREATE TABLE restaurante (
    id_restaurante INT AUTO_INCREMENT,
    id_endRest INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    tipo_culinaria VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_restaurante),
    FOREIGN KEY (id_endRest) REFERENCES enderecos_restaurante(id_endRest) ON DELETE CASCADE
);

-- Tabela HorariosFuncionamentoRestaurante
CREATE TABLE IF NOT EXISTS HorariosFuncionamentoRestaurante(
    horario_funcionamento_id INT AUTO_INCREMENT,
    dia_semana ENUM('Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sábado') NOT NULL,
    horario_abertura TIME,
    horario_fechamento TIME,
    id_rest INT,
	PRIMARY KEY(horario_funcionamento_id),
    Unique KEY(id_rest, dia_semana),
	FOREIGN KEY(id_rest) REFERENCES Restaurantes(id_rest)
);

-- tabela categoria pratos
CREATE TABLE categoria_pratos (
    categoria_id INT AUTO_INCREMENT,
    id_restaurante INT NOT NULL,
    nome_categoria VARCHAR(100) UNIQUE NOT NULL,
    PRIMARY KEY (categoria_id),
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id_restaurante) ON DELETE CASCADE
);

-- tabela pratos
CREATE TABLE pratos (
    id_prato INT AUTO_INCREMENT,
    categoria_id INT NOT NULL,
    nome_prato VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10, 2) NOT NULL,
    status_disp BOOLEAN DEFAULT TRUE, -- true = disponivel, false = indisponivel
    PRIMARY KEY (id_prato),
    FOREIGN KEY (categoria_id) REFERENCES categoria_pratos(categoria_id) ON DELETE CASCADE,
);

-- tabela pedido
CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_restaurante INT NOT NULL,
    dataHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pedido ENUM('Pendente', 'Em Preparação', 'Em Trânsito', 'Entregue', 'Cancelado') DEFAULT ('Pendente'),
    valor_total DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_pedido),
    FOREIGN KEY (id_cliente) REFERENCES cliente(cliente_id) ON DELETE CASCADE,
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id_restaurante) ON DELETE CASCADE
);

