using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Xml;
using HtmlAgilityPack;
using MySql.Data.MySqlClient;


namespace menuRes
{
    public partial class Pago : System.Web.UI.Page
    {
        private int restauranteId;
        protected void Page_Load(object sender, EventArgs e)
        {
            int itemCount = (Request.QueryString.Count - 1) / 3;

            string html = "<table class='cart-table'>";
            html += "<thead><tr><th>Nombre</th><th>Precio</th><th>Cantidad</th><th>Subtotal</th></tr></thead>";
            html += "<tbody>";

            decimal totalCompra = 0;

            for (int i = 0; i < itemCount; i++)
            {
                string nombre = Request.QueryString.Get("nombre" + i);
                decimal precio = Convert.ToDecimal(Request.QueryString.Get("precio" + i), System.Globalization.CultureInfo.InvariantCulture);
                int cantidad = Convert.ToInt32(Request.QueryString.Get("cantidad" + i));

                decimal subtotal = precio * cantidad;
                totalCompra += subtotal;

                html += "<tr>";
                html += "<td>" + nombre + "</td>";
                html += "<td>" + precio.ToString("0.00") + "€</td>";
                html += "<td>" + cantidad + "</td>";
                html += "<td>" + subtotal.ToString("0.00") + "€</td>";
                html += "</tr>";
            }

            html += "</tbody>";
            html += "</table>";
            html += "<div class='total-container'>";
            html += "<p>Total de la compra: <span class='total'>" + totalCompra.ToString("0.00") + "€</span></p>";
            html += "</div>";

            litResultado.Text = html;
            
            if (!IsPostBack)
            {
                restauranteId = Convert.ToInt32(Request.QueryString["id"]);
                ViewState["RestauranteId"] = restauranteId;
                var restauranteInfo = CargarNombre(restauranteId);
                if (restauranteInfo != null)
                {
                    nombreRestauranteLiteral.Text = restauranteInfo.Item1;
                }
                else
                {
                    nombreRestauranteLiteral.Text = "Restaurante no encontrado";
                }
              
            }
            else
            {
                restauranteId = (int)ViewState["RestauranteId"];
            }

        }

        protected void btnConfirmarEliminar_Click(object sender, EventArgs e)
        {
            restauranteId = (int)ViewState["RestauranteId"];
            Response.Redirect($"MenuRes.aspx?id={restauranteId}");
        }

        private int itemCount;
        private int ObtenerIdProducto(string nombreProducto)
        {
            int idProducto = -1;
            string query = "SELECT id FROM Producto WHERE nombre = @nombre";
            using (MySqlConnection connection = new MySqlConnection("Database=menucomida;Data Source=localhost;User=root;Port=3306"))
            {
                using (MySqlCommand command = new MySqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@nombre", nombreProducto);
                    connection.Open();
                    idProducto = Convert.ToInt32(command.ExecuteScalar());
                }
            }
            return idProducto;
        }
        public Tuple<string, string> CargarNombre(int restauranteId)
        {
            string connectionString = "Database=menucomida;Data Source=localhost;User=root;Port=3306";
            string nombreRestaurante = string.Empty;
            string rutaImagen = string.Empty;

            try
            {
                using (MySqlConnection connection = new MySqlConnection(connectionString))
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

                            if (!reader.IsDBNull(reader.GetOrdinal("imagen")))
                            {
                                byte[] imagenBytes = (byte[])reader["imagen"];
                                string imagenBase64 = Convert.ToBase64String(imagenBytes);
                                rutaImagen = $"data:image/png;base64,{imagenBase64}";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                nombreRestaurante = "Error al cargar el restaurante: " + ex.Message;
            }

            return new Tuple<string, string>(nombreRestaurante, rutaImagen);
        }




        protected void RedirectAfterPayment(object sender, EventArgs e)
        {

            string cardNumber = numTar.Text.Trim();
            string expiryDate = expira.Text.Trim();
            string cvc = cvv.Text.Trim();

            if (cardNumber.Length != 16 || !cardNumber.All(char.IsDigit))
            {
                Error.Text = "El número de tarjeta debe tener 16 dígitos.";
                Error.Visible = true;
                return;
            }

            if (cvc.Length != 3 || !cvc.All(char.IsDigit))
            {
                Error.Text = "El CVC debe tener 3 números.";
                Error.Visible = true;
                return;
            }

            if (!Regex.IsMatch(expiryDate, @"^(0[1-9]|1[0-2])\/\d{2}$"))
            {
                Error.Text = "El formato de la fecha de expiración debe ser MM/YY.";
                Error.Visible = true;
                return;
            }

            DateTime expiryDateTime;
            if (!DateTime.TryParseExact(expiryDate, "MM/yy", CultureInfo.InvariantCulture, DateTimeStyles.None, out expiryDateTime))
            {
                Error.Text = "El formato de la fecha de expiración es inválido.";
                Error.Visible = true;
                return;
            }

            if (expiryDateTime.Year < 2000)
            {
                expiryDateTime = expiryDateTime.AddYears(100);
            }

            if (expiryDateTime < DateTime.Now)
            {
                Error.Text = "La tarjeta ha expirado.";
                Error.Visible = true;
                return;
            }

            string html = litResultado.Text;
                HtmlDocument doc = new HtmlDocument();
                doc.LoadHtml(html);
                HtmlNode totalNode = doc.DocumentNode.SelectSingleNode("//span[@class='total']");
                decimal totalCompra = 0;
            if (totalNode != null && decimal.TryParse(totalNode.InnerText.Replace("€", "").Trim(), out totalCompra))
            {
                using (MySqlConnection connection = new MySqlConnection("Database=menucomida;Data Source=localhost;User=root;Port=3306"))
                {
                    connection.Open();
                    string insertPedidoQuery = "INSERT INTO Pedido (fecha, total) VALUES (@fecha, @total); SELECT LAST_INSERT_ID();";
                    using (MySqlCommand command = new MySqlCommand(insertPedidoQuery, connection))
                    {
                        command.Parameters.AddWithValue("@fecha", DateTime.Now);
                        command.Parameters.AddWithValue("@total", totalCompra);
                        int pedidoId = Convert.ToInt32(command.ExecuteScalar());

                        int itemCount = (Request.QueryString.Count - 1) / 3;
                        for (int i = 0; i < itemCount; i++)
                        {
                            string nombre = Request.QueryString.Get("nombre" + i);
                            int cantidad = Convert.ToInt32(Request.QueryString.Get("cantidad" + i));
                            int productoId = ObtenerIdProducto(nombre);
                            if (productoId != -1)
                            {
                                string insertProductoQuery = "INSERT INTO pedidos_productos (id_pedido, id_producto, cantidad) VALUES (@id_pedido, @id_producto, @cantidad);";
                                using (MySqlCommand productoCommand = new MySqlCommand(insertProductoQuery, connection))
                                {
                                    productoCommand.Parameters.AddWithValue("@id_pedido", pedidoId);
                                    productoCommand.Parameters.AddWithValue("@id_producto", productoId);
                                    productoCommand.Parameters.AddWithValue("@cantidad", cantidad);
                                    productoCommand.ExecuteNonQuery();
                                }
                            }
                            ClientScript.RegisterStartupScript(this.GetType(), "redirect", $"window.location.href = 'Agradecimiento.aspx?id_pedido={pedidoId}';", true);
                        }
                    }
                }

            }


        }

    }
}