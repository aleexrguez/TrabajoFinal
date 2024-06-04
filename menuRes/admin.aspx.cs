using System;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.IO;
using System.Web.UI;

namespace menuRes
{
    public partial class admin : System.Web.UI.Page
    {
        protected void btnAtras_Click(object sender, EventArgs e)
        {
            Response.Redirect("login.aspx");
        }

        MySqlConnection conexion = new MySqlConnection("Database=menucomida;Data Source=localhost;User=root;Port=3306");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarRestaurantes();
                MostrarMensajeInicial();
            }
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Page.Validate("Agregar");
            if (fileImagen.HasFile)
            {
                if (fileImagen.PostedFile.ContentType.ToLower() == "image/png" && fileImagen.PostedFile.ContentLength <= 1024 * 1024)
                {
                    MemoryStream ms = new MemoryStream(fileImagen.FileBytes);
                    byte[] imagen = ms.ToArray();

                    int idRestaurante = Convert.ToInt32(ddlRestaurantes.SelectedValue);

                    InsertarProducto(txtNombre.Text, Convert.ToDecimal(txtPrecio.Text), txtDescripcion.Text, imagen, idRestaurante);

                    LimpiarFormulario();
                    CargarProductosPorRestaurante(idRestaurante);

                    mvAdminMenu.ActiveViewIndex = 1;
                    string script = "showToast('Producto agregado ✅');";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "showToast", script, true);

                }
                else
                {
                    Literal1.Text = "<script>alert('Seleccione un archivo con extensión .png y tamaño máximo de 1 MB.');</script>";
                }
            }
        }

        private void InsertarProducto(string nombre, decimal precio, string descripcion, byte[] imagen, int idRestaurante)
        {
            using (MySqlCommand cmd = new MySqlCommand("INSERT INTO Producto (nombre, precio, descripcion, imagen, id_restaurante) VALUES (@nombre, @precio, @descripcion, @imagen, @idRestaurante)", conexion))
            {
                cmd.Parameters.AddWithValue("@nombre", nombre);
                cmd.Parameters.AddWithValue("@precio", precio);
                cmd.Parameters.AddWithValue("@descripcion", descripcion);
                cmd.Parameters.AddWithValue("@imagen", imagen);
                cmd.Parameters.AddWithValue("@idRestaurante", idRestaurante);
                conexion.Open();
                cmd.ExecuteNonQuery();
                conexion.Close();
            }
        }

        protected void gvProductos_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
        {
            gvProductos.EditIndex = e.NewEditIndex;
            int idProducto = Convert.ToInt32(gvProductos.DataKeys[e.NewEditIndex].Value);
            int idRestaurante = ObtenerIdRestauranteProducto(idProducto);
            CargarProductosPorRestaurante(idRestaurante);
        }

        protected void gvProductos_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(gvProductos.DataKeys[e.RowIndex].Value);
            int idRestaurante = ObtenerIdRestauranteProducto(id);

            TextBox txtNombreEdit = (TextBox)gvProductos.Rows[e.RowIndex].FindControl("txtNombreEdit");
            TextBox txtPrecioEdit = (TextBox)gvProductos.Rows[e.RowIndex].FindControl("txtPrecioEdit");
            TextBox txtDescripcionEdit = (TextBox)gvProductos.Rows[e.RowIndex].FindControl("txtDescripcionEdit");
            FileUpload fileEditarImagen = (FileUpload)gvProductos.Rows[e.RowIndex].FindControl("fileEditarImagen");
            HiddenField hfImagenActual = (HiddenField)gvProductos.Rows[e.RowIndex].FindControl("hfImagenActualEdit");

            if (txtNombreEdit != null && txtPrecioEdit != null && txtDescripcionEdit != null && fileEditarImagen != null && hfImagenActual != null)
            {
                if (fileEditarImagen.HasFile)
                {
                    if (fileEditarImagen.PostedFile.ContentType.ToLower() == "image/png" && fileEditarImagen.PostedFile.ContentLength <= 1024 * 1024)
                    {
                        byte[] nuevaImagen = null;

                        using (MemoryStream ms = new MemoryStream(fileEditarImagen.FileBytes))
                        {
                            nuevaImagen = ms.ToArray();
                        }

                        using (MySqlCommand cmd = new MySqlCommand("UPDATE Producto SET nombre = @nombre, precio = @precio, descripcion = @descripcion, imagen = @imagen WHERE id = @id", conexion))
                        {
                            cmd.Parameters.AddWithValue("@nombre", txtNombreEdit.Text);
                            cmd.Parameters.AddWithValue("@precio", Convert.ToDecimal(txtPrecioEdit.Text));
                            cmd.Parameters.AddWithValue("@descripcion", txtDescripcionEdit.Text);
                            cmd.Parameters.AddWithValue("@imagen", nuevaImagen);
                            cmd.Parameters.AddWithValue("@id", id);

                            conexion.Open();
                            cmd.ExecuteNonQuery();
                            conexion.Close();
                        }
                    }
                    else
                    {
                        Response.Write("<script>alert('Seleccione un archivo con extensión .png y tamaño máximo de 1 MB.');</script>");
                        return;
                    }
                }
                else
                {
                    using (MySqlCommand cmd = new MySqlCommand("UPDATE Producto SET nombre = @nombre, precio = @precio, descripcion = @descripcion WHERE id = @id", conexion))
                    {
                        cmd.Parameters.AddWithValue("@nombre", txtNombreEdit.Text);
                        cmd.Parameters.AddWithValue("@precio", Convert.ToDecimal(txtPrecioEdit.Text));
                        cmd.Parameters.AddWithValue("@descripcion", txtDescripcionEdit.Text);
                        cmd.Parameters.AddWithValue("@id", id);

                        conexion.Open();
                        cmd.ExecuteNonQuery();
                        conexion.Close();
                    }
                }

                gvProductos.EditIndex = -1;
                CargarProductosPorRestaurante(idRestaurante);

                string script = "showToast('Producto actualizado ✅');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "showToast", script, true);
            }
        }

        protected void btnConfirmarEliminar_Click(object sender, EventArgs e)
        {
            int productId = Convert.ToInt32(hfProductIdToDelete.Value);

            if (productId > 0)
            {
                int idRestaurante = ObtenerIdRestauranteProducto(productId);

                using (MySqlCommand cmdDeletePedidos = new MySqlCommand("DELETE FROM pedidos_productos WHERE id_producto = @id_producto", conexion))
                {
                    cmdDeletePedidos.Parameters.AddWithValue("@id_producto", productId);
                    conexion.Open();
                    cmdDeletePedidos.ExecuteNonQuery();
                    conexion.Close();
                }
                using (MySqlCommand cmdDeleteProducto = new MySqlCommand("DELETE FROM Producto WHERE id = @id", conexion))
                {
                    cmdDeleteProducto.Parameters.AddWithValue("@id", productId);
                    conexion.Open();
                    cmdDeleteProducto.ExecuteNonQuery();
                    conexion.Close();
                }

                CargarProductosPorRestaurante(idRestaurante);

                string script = "showToast('Producto eliminado ❌');";
                ScriptManager.RegisterStartupScript(this, GetType(), "showToast", script, true);
            }
        }


        protected void gvProductos_RowCancelingEdit(object sender, System.Web.UI.WebControls.GridViewCancelEditEventArgs e)
        {
            int idProducto = Convert.ToInt32(gvProductos.DataKeys[e.RowIndex].Values["id"]);
            int idRestaurante = ObtenerIdRestauranteProducto(idProducto);
            gvProductos.EditIndex = -1;
            CargarProductosPorRestaurante(idRestaurante);
        }

        private void LimpiarFormulario()
        {
            txtNombre.Text = "";
            txtPrecio.Text = "";
            txtDescripcion.Text = "";
            fileImagen.Dispose();
        }

        private void CargarRestaurantes()
        {
            try
            {
                using (MySqlCommand cmd = new MySqlCommand("SELECT id, nombre FROM Restaurante", conexion))
                {
                    conexion.Open();
                    using (MySqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlRestaurantes.Items.Clear();
                        ddlRestaurantes.Items.Add(new ListItem("-- Elige un restaurante --", ""));
                        while (reader.Read())
                        {
                            ddlRestaurantes.Items.Add(new ListItem(reader["nombre"].ToString(), reader["id"].ToString()));
                        }
                    }
                    conexion.Close();
                }
            }
            catch (Exception ex)
            {
                Literal1.Text = "Error al cargar los restaurantes: " + ex.Message;
            }
        }

        protected void ddlRestaurantes_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlRestaurantes.SelectedValue))
            {
                int idRestaurante = Convert.ToInt32(ddlRestaurantes.SelectedValue);
                CargarProductosPorRestaurante(idRestaurante);
                CargarPedidosPorRestaurante(idRestaurante);

                mvAdminMenu.ActiveViewIndex = 1;

                divAgregarVacio.Visible = false;
                divAgregar.Visible = true;

                bool tieneProductos = RestauranteTieneProductos(idRestaurante);
                divActualizarVacio.Visible = !tieneProductos;
                divActualizar.Visible = tieneProductos;

                bool tienePedidos = RestauranteTienePedidos(idRestaurante);

                if (tienePedidos)
                {
                    divPedidosVacio.Visible = false;
                    divPedidos.Visible = true;
                }
                else
                {
                    divPedidosVacio.Visible = true;
                    divPedidos.Visible = false;
                }
            }
            else
            {
                divAgregarVacio.Visible = true;
                divAgregar.Visible = false;

                divActualizarVacio.Visible = true;
                divActualizar.Visible = false;

                divPedidosVacio.Visible = true;
                divPedidos.Visible = false;
            }
        }


        private void CargarProductosPorRestaurante(int idRestaurante)
        {
            try
            {
                using (MySqlCommand cmd = new MySqlCommand("SELECT * FROM Producto WHERE id_restaurante = @idRestaurante", conexion))
                {
                    cmd.Parameters.AddWithValue("@idRestaurante", idRestaurante);
                    conexion.Open();
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvProductos.DataSource = dt;
                        gvProductos.DataBind();
                    }
                    conexion.Close();
                }
            }
            catch (Exception ex)
            {
                Literal1.Text = "Error al cargar los productos: " + ex.Message;
            }
        }


        private int ObtenerIdRestauranteProducto(int idProducto)
        {
            int idRestaurante = -1;

            using (MySqlCommand cmd = new MySqlCommand("SELECT id_restaurante FROM Producto WHERE id = @idProducto", conexion))
            {
                cmd.Parameters.AddWithValue("@idProducto", idProducto);
                conexion.Open();
                object result = cmd.ExecuteScalar();
                conexion.Close();

                if (result != null)
                {
                    idRestaurante = Convert.ToInt32(result);
                }
            }

            return idRestaurante;
        }

        private void MostrarMensajeInicial()
        {
            if (string.IsNullOrEmpty(ddlRestaurantes.SelectedValue))
            {
                divAgregarVacio.Visible = true;
                divAgregar.Visible = false;

                divActualizarVacio.Visible = true;
                divActualizar.Visible = false;

                divPedidosVacio.Visible = true;
                divPedidos.Visible = false;
            }
            else
            {
                int idRestaurante = Convert.ToInt32(ddlRestaurantes.SelectedValue);
                bool tieneProductos = RestauranteTieneProductos(idRestaurante);
                bool tienePedidos = RestauranteTienePedidos(idRestaurante);

                divAgregarVacio.Visible = false;
                divAgregar.Visible = true;

                divActualizarVacio.Visible = !tieneProductos;
                divActualizar.Visible = tieneProductos;

                if (tienePedidos)
                {
                    divPedidosVacio.Visible = false;
                    divPedidos.Visible = true;
                }
                else
                {
                    divPedidosVacio.Visible = true;
                    divPedidos.Visible = false;
                }
            }
        }

        private bool RestauranteTieneProductos(int idRestaurante)
        {
            bool tieneProductos = false;

            string query = "SELECT COUNT(*) FROM Producto WHERE id_restaurante = @idRestaurante";

            using (MySqlCommand cmd = new MySqlCommand(query, conexion))
            {
                cmd.Parameters.AddWithValue("@idRestaurante", idRestaurante);

                conexion.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());
                conexion.Close();

                tieneProductos = count > 0;
            }

            return tieneProductos;
        }

        private bool RestauranteTienePedidos(int idRestaurante)
        {
            bool tienePedidos = false;

            string query = "SELECT COUNT(*) FROM pedido p JOIN pedidos_productos pp ON p.id = pp.id_pedido JOIN producto pr ON pp.id_producto = pr.id WHERE pr.id_restaurante = @idRestaurante";

            using (MySqlCommand cmd = new MySqlCommand(query, conexion))
            {
                cmd.Parameters.AddWithValue("@idRestaurante", idRestaurante);

                conexion.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());
                conexion.Close();

                tienePedidos = count > 0;
            }

            return tienePedidos;
        }

        private void CargarPedidosPorRestaurante(int idRestaurante)
        {
            try
            {
                string query = "SELECT p.id AS PedidoID, p.fecha, p.total, GROUP_CONCAT(pr.nombre SEPARATOR ', ') AS Productos " +
                               "FROM pedido p " +
                               "INNER JOIN pedidos_productos pp ON p.id = pp.id_pedido " +
                               "INNER JOIN producto pr ON pp.id_producto = pr.id " +
                               "WHERE pr.id_restaurante = @idRestaurante " +
                               "GROUP BY p.id";

                using (MySqlCommand cmd = new MySqlCommand(query, conexion))
                {
                    cmd.Parameters.AddWithValue("@idRestaurante", idRestaurante);
                    conexion.Open();
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvPedidosPorRestaurante.DataSource = dt;
                        gvPedidosPorRestaurante.DataBind();
                    }
                    conexion.Close();
                }
            }
            catch (Exception ex)
            {
                Literal1.Text = "Error al cargar los pedidos por restaurante: " + ex.Message;
            }
        }


        protected void btnAgregarProductos_Click(object sender, EventArgs e)
        {
            mvAdminMenu.ActiveViewIndex = 0;
        }

        protected void btnVerProductos_Click(object sender, EventArgs e)
        {
            mvAdminMenu.ActiveViewIndex = 1;
        }

        protected void btnPedidosRealizados_Click(object sender, EventArgs e)
        {
            mvAdminMenu.ActiveViewIndex = 2;
        }

        private void MostrarVistaSegunRestaurante()
        {
            if (!string.IsNullOrEmpty(ddlRestaurantes.SelectedValue))
            {
                int idRestaurante = Convert.ToInt32(ddlRestaurantes.SelectedValue);

                if (btnAgregarProductos.CommandArgument == idRestaurante.ToString())
                {
                    mvAdminMenu.ActiveViewIndex = 0;
                }
                else if (btnVerProductos.CommandArgument == idRestaurante.ToString())
                {
                    mvAdminMenu.ActiveViewIndex = 1;
                }
                else if (btnPedidosRealizados.CommandArgument == idRestaurante.ToString())
                {
                    mvAdminMenu.ActiveViewIndex = 2;
                }
                else
                {
                    MostrarMensajeInicial();
                }
            }
            else
            {
                MostrarMensajeInicial();
            }
        }
    }
}
