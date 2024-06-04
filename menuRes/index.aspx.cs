using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Web.UI;

namespace menuRes
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCarousel();
            }
        }

        private void BindCarousel()
        {
            string connectionString = "DataBase=menucomida;DataSource=localhost;user=root;Port=3306";
            string query = "SELECT id, nombre, imagen FROM restaurante";
            List<string> carouselItems = new List<string>();

            using (MySqlConnection connection = new MySqlConnection(connectionString))
            {
                MySqlCommand command = new MySqlCommand(query, connection);
                connection.Open();

                using (MySqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        int id = Convert.ToInt32(reader["id"]);
                        string nombre = reader["nombre"].ToString();
                        byte[] imagenBytes = (byte[])reader["imagen"];

                        string imagenBase64 = Convert.ToBase64String(imagenBytes);
                        string imagenSrc = $"data:image/jpeg;base64,{imagenBase64}";

                        string h1 = $"<h1 id='nombre{id}'>{nombre}</h1>";
                        string button = $"<a class='btn btn-carrito' href='MenuRes.aspx?id={id}'>Ir a menú</a>";
                        string image = $"<img src='{imagenSrc}' alt='{nombre}'>";

                        string contentDiv = $"<div>{h1}{button}</div>";
                        string carouselItem = $"<div class='carousel-item'><div class='carousel-content'>{contentDiv}</div>{image}</div>";
                        carouselItems.Add(carouselItem);
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

                        LiteralControl menuitem = new LiteralControl($"<a href='MenuRes.aspx?id={id}'><div class='menu-item'>{nombre}</div></a>");
                        menu.Controls.Add(menuitem);
                    }
                }
            }
            litCarousel.Text = string.Join("", carouselItems);
            }
    }
}