package local.santiago.cines;



import org.postgresql.util.PGobject;

import java.sql.*;


public class Main {
    public static void main(String[] args) {
        System.out.println("Santiago Galván - proyecto Cines");

        try (Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/bdcines",
                "app_cines", "app")) {
            imprimirEntradas(connection);
            int idCine = insertarCine(connection, "bbb", "xprovincia", "xciudad", "xdireccion");
            System.out.printf("id nuevo cine: " + idCine);
        } catch (SQLException e) {
            System.out.println(e.getErrorCode() + ":" + e.getMessage());
        }
    }

    private static void imprimirEntradas(Connection connection) throws SQLException {
        final String SQL = """
                    select *,
                          (cine_direccion).provincia as provincia,
                          (cine_direccion).ciudad as ciudad,
                          (cine_direccion).direccion as direccion
                    from entradas_ex""";
        try (Statement st = connection.createStatement()) {
            ResultSet rst = st.executeQuery(SQL);
            while (rst.next()) {
                int cine_id = rst.getInt("cine_id");
                String cine = rst.getString("cine");
                String pelicula = rst.getString("pelicula");

                System.out.println(cine_id + ":" + cine + ":" + pelicula);

                System.out.print("asientos: ");
                Array array = rst.getArray("asientos");
                Integer[] asientos = (Integer[]) array.getArray();

                for (Integer asiento: asientos) {
                    System.out.print(asiento + "-");
                }
                System.out.println();

                Timestamp fecha_compra = rst.getTimestamp("fecha_compra");
                System.out.println("fecha compra: " + fecha_compra);

                System.out.println(rst.getString("provincia")+"-"+rst.getString("ciudad")+"-"+rst.getString("direccion"));
            }
        }
    }

    private static int insertarCine(Connection connection, String nombre, String provincia,
                                    String ciudad, String direccion) throws SQLException {
     /*   String SQL = """
                insert into cines (nombre, direccion)
                values (?, (?, ?, ?))""";
*/
        String SQL = """
                insert into cines (nombre, direccion.provincia, direccion.ciudad, direccion.direccion)
                values (?, ?, ?, ?)""";

        try (PreparedStatement st = connection.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {

            st.setString(1, nombre);
            st.setString(2, provincia);
            st.setString(3, ciudad);
            st.setString(4, direccion);

            st.executeUpdate();

            try (ResultSet rst = st.getGeneratedKeys()) {
                rst.next();
                return rst.getInt(1);
            }
        }
    }
}
