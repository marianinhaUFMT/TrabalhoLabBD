// bibliotecas necessarias para interface grafica e conexao com bd
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;
import javax.swing.*;

public class GerenciamentoRestaurante {
    
    // detalhes da conexao com o banco de dados
    private static final String URL = "jdbc:mysql://localhost:3306/gerenciador_restaurantes";
    private static final String USUARIO = "root"; // seu usuario do mysql
    private static final String SENHA = "123456"; // sua senha do mysql

    public static void main(String[] args) {
                System.out.println("Iniciando Gerenciador de Restaurantes...");

        try {
            // Carregar o driver JDBC para MySQL
            Class.forName("com.mysql.jdbc.Driver");
            System.out.println("Driver JDBC do MySQL carregado.");

            // Usar try-with-resources para garantir que a conexão e o scanner sejam fechados automaticamente
            try (Connection conexao = DriverManager.getConnection(URL, USUARIO, SENHA);
                 Scanner scanner = new Scanner(System.in)) {

                System.out.println("Conexão com o MySQL estabelecida com sucesso!");

                if (!conexao.isValid(5)) {
                    System.err.println("A conexão não é válida ou expirou. Abortando operações.");
                    return;
                }
            }
            System.out.println("\nRecursos do banco de dados e scanner foram fechados automaticamente.");

        } catch (ClassNotFoundException e) {
            System.err.println("Erro: Driver JDBC do MySQL não encontrado. Verifique o CLASSPATH.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Erro de SQL: " + e.getMessage());
            e.printStackTrace();
        }
    }
}