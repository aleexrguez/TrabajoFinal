using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;

namespace menuRes
{
    public partial class MenuRes : System.Web.UI.Page
    {
        protected string rutaImagen;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int restauranteId = Convert.ToInt32(Request.QueryString["id"]);
                CargarProductos(restauranteId);
                var restauranteInfo = CargarNombre(restauranteId);
                nombreRestauranteLiteral.Text = restauranteInfo.Item1;
                rutaImagen = restauranteInfo.Item2;
                restauranteIdHiddenField.Value = restauranteId.ToString();
            }
        }

        MySqlConnection conexion = new MySqlConnection("Database=menucomida;Data Source=localhost;User=root;Port=3306");
        static MySqlDataReader datareader;

        public Tuple<string, string> CargarNombre(int restauranteId)
        {
            string connectionString = "DataBase=menucomida;DataSource=localhost;user=root;Port=3306";
            string nombreRestaurante = string.Empty;
            string rutaImagen = string.Empty;

            using (MySqlConnection connection = new MySqlConnection("Database=menucomida;Data Source=localhost;User=root;Port=3306"))
            {
                connection.Open();

                string query = "SELECT nombre, imagen FROM restaurante WHERE id = @RestauranteId";
                MySqlCommand command = new MySqlCommand(query, connection);
                command.Parameters.AddWithValue("@RestauranteId", restauranteId);

                using (MySqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        nombreRestaurante = reader["nombre"].ToString();

                        byte[] imagenBytes = (byte[])reader["imagen"];
                        string imagenBase64 = Convert.ToBase64String(imagenBytes);
                        rutaImagen = $"data:image/png;base64,{imagenBase64}";
                    }
                }
            }
            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                MySqlCommand command = new MySqlCommand("SELECT id, nombre FROM restaurante", connection);
                connection.Open();

                using (MySqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        int id = Convert.ToInt32(reader["id"]);
                        string nombre = reader["nombre"].ToString();

                        LiteralControl menuitem = new LiteralControl($"<a href='MenuRes.aspx?id={id}' class='{(nombre == nombreRestaurante ? "active" : "")}'><div class='menu-item'>{nombre}</div></a>");

                        menu.Controls.Add(menuitem);
                    }
                }
            }
            return new Tuple<string, string>(nombreRestaurante, rutaImagen);
        }
        private void CargarProductos(int restauranteId)
        {
            string connectionString = "Database=menucomida;DataSource=localhost;User=root;Port=3306";
            DataTable dtProductos = new DataTable();

            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                connection.Open();
                string query = "SELECT * FROM producto WHERE id_restaurante = @RestauranteId";
                MySqlCommand command = new MySqlCommand(query, connection);
                command.Parameters.AddWithValue("@RestauranteId", restauranteId);

                using (MySqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string nombre = reader["Nombre"].ToString();
                        string descripcion = reader["Descripcion"].ToString();
                        decimal precio = Convert.ToDecimal(reader["precio"]);
                        byte[] imagenBytes = (byte[])reader["imagen"];

                        // Convertir el arreglo de bytes en una cadena base64
                        string imagenBase64 = Convert.ToBase64String(imagenBytes);

                        // Construir la URL de la imagen para su uso en la etiqueta img
                        string imagenSrc = $"data:image/jpeg;base64,{imagenBase64}";

                        string agregarAlCarritoBtn = $@"
                    <a href='#' class='btn btn-carrito addToCartBtn' 
                        data-product-name='{nombre}' data-product-price='{precio}'>
                        Agregar al carrito
                    </a>";

                        // Creamos la estructura HTML de la tarjeta
                        string cardHtml = $@"
                    <div class='col-md-4'>
                        <div class='card'>
                            <img src='{imagenSrc}' class='card-img-top' alt='Producto' />
                            <div class='card-body-overlay'>
                                <h5 class='card-title'>{nombre}</h5>
                                <p class='card-text'>{descripcion}</p>
                                {agregarAlCarritoBtn}
                            </div>
                        </div>
                    </div>";

                        // Agregamos la tarjeta al Literal
                        litTarjetas.Text += cardHtml;
                    }
                }
            }
        }

    }
}