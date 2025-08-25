DROP DATABASE IF EXISTS gerenciador_restaurantes;

CREATE DATABASE gerenciador_restaurantes;
USE gerenciador_restaurantes;

-- tabela cliente
CREATE TABLE IF NOT EXISTS cliente (
    cliente_id INT AUTO_INCREMENT,
    nome_completo VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL, -- para dados do pagamento (simulado)
    PRIMARY KEY (cliente_id)
);

-- tabela enderecos_entrega (lista de enderecos por cliente)
CREATE TABLE IF NOT EXISTS enderecos_entrega (
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
CREATE TABLE IF NOT EXISTS enderecos_restaurante (
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
CREATE TABLE IF NOT EXISTS restaurante (
    id_restaurante INT AUTO_INCREMENT,
    id_endRest INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    tipo_culinaria VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_restaurante),
    FOREIGN KEY (id_endRest) REFERENCES enderecos_restaurante(id_endRest) ON DELETE CASCADE
);

-- tabela horarios_funcionamento_restaurante
CREATE TABLE IF NOT EXISTS horarios_funcionamento_restaurante(
    horario_funcionamento_id INT AUTO_INCREMENT,
    dia_semana ENUM('Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sábado') NOT NULL,
    horario_abertura TIME,
    horario_fechamento TIME,
    id_restaurante INT NOT NULL,
	PRIMARY KEY(horario_funcionamento_id),
    UNIQUE KEY(id_restaurante, dia_semana),
	FOREIGN KEY(id_restaurante) REFERENCES restaurante(id_restaurante) ON DELETE CASCADE
);

-- tabela avaliacoes_restaurante
CREATE TABLE IF NOT EXISTS avaliacoes_restaurante (
    id_avaliacao INT AUTO_INCREMENT,
    id_restaurante INT NOT NULL,
    id_cliente INT NOT NULL,
    nota INT CHECK (nota BETWEEN 0 AND 5),
    feedback VARCHAR(255),
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_avaliacao),
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id_restaurante) ON DELETE CASCADE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(cliente_id) ON DELETE CASCADE
);

-- tabela categoria pratos
CREATE TABLE IF NOT EXISTS categoria_pratos (
    categoria_id INT AUTO_INCREMENT,
    id_restaurante INT NOT NULL,
    nome_categoria VARCHAR(100) NOT NULL,
    PRIMARY KEY (categoria_id),
    UNIQUE KEY (id_restaurante, nome_categoria),
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id_restaurante) ON DELETE CASCADE
);

-- tabela pratos
CREATE TABLE IF NOT EXISTS pratos (
    id_prato INT AUTO_INCREMENT,
    categoria_id INT NOT NULL,
    nome_prato VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10, 2) NOT NULL,
    status_disp BOOLEAN DEFAULT TRUE, -- true = disponivel, false = indisponivel
    PRIMARY KEY (id_prato),
    FOREIGN KEY (categoria_id) REFERENCES categoria_pratos(categoria_id) ON DELETE CASCADE
);

-- tabela pedido
CREATE TABLE IF NOT EXISTS pedido (
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

-- tabela forma_pagamento
CREATE TABLE IF NOT EXISTS forma_pagamento (
    id_forma_pagamento INT AUTO_INCREMENT,
    formaPag ENUM('Cartão', 'Pix', 'Dinheiro') NOT NULL,
    PRIMARY KEY (id_forma_pagamento)
);

-- tabela item_pedido
CREATE TABLE IF NOT EXISTS item_pedido (
    id_pedido INT NOT NULL,
    id_prato INT NOT NULL,
    qtd INT NOT NULL CHECK (qtd > 0),
    preco_item DECIMAL(10, 2) NOT NULL,
    observacoes VARCHAR(255),
    PRIMARY KEY (id_pedido, id_prato),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_prato) REFERENCES pratos(id_prato) ON DELETE RESTRICT
);

-- tabela produtos
CREATE TABLE IF NOT EXISTS produtos(
	produto_id INT AUTO_INCREMENT,
    estoque INT NOT NULL CHECK (estoque >= 0),
    nome_produto VARCHAR(64),
    PRIMARY KEY(produto_id));

-- tabela possui3 (relacao pratos x produtos)
CREATE TABLE IF NOT EXISTS possui3(
	id_prato INT NOT NULL,
    produto_id INT NOT NULL,
    qtd INT NOT NULL CHECK (qtd > 0),
    PRIMARY KEY(id_prato, produto_id),
	FOREIGN KEY (id_prato) REFERENCES pratos(id_prato) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id) ON DELETE CASCADE
    );
