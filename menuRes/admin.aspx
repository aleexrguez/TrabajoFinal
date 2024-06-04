<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="menuRes.admin" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Panel de administrador</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" type="image/png" href="Imagenes/iconos/engranaje.png">
    <link rel="stylesheet" href="Estilos/estiloAdmin.css">

<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function () {
        var btnAgregar = document.getElementById('<%= btnAgregar.ClientID %>');
        btnAgregar.addEventListener('click', function (event) {
            var validators = document.querySelectorAll('.text-danger');
            validators.forEach(function (validator) {
                validator.style.display = 'none';
            });

            setTimeout(function () {
                var hasErrors = false;
                validators.forEach(function (validator) {
                    if (validator.innerText.trim() !== '') {
                        validator.style.display = 'block';
                        hasErrors = true;
                    }
                });

                if (hasErrors) {
                    event.preventDefault();
                }
            }, 10);
        });

        var inputs = document.querySelectorAll('.form-control');
        inputs.forEach(function (input) {
            input.addEventListener('input', function () {
                var validator = document.querySelector('.text-danger[for="' + input.id + '"]');
                if (validator && input.value.trim() !== '') {
                    validator.style.display = 'none';
                }
            });
        });
    });

    function showAlert(message) {
        var alertContainer = document.getElementById('alertContainer');
        var alertHTML = `
        <div class="alert alert-danger d-flex align-items-center" role="alert">
            <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Danger:"><use xlink:href="#exclamation-triangle-fill"/></svg>
            <div>${message}</div>
        </div>
    `;
        var alertElement = document.createElement('div');
        alertElement.innerHTML = alertHTML;
        alertContainer.appendChild(alertElement);

        alertElement.classList.add('alert-show');

        setTimeout(function () {
            alertElement.classList.add('alert-hide');
            setTimeout(function () {
                alertContainer.removeChild(alertElement);
            }, 700);
        }, 4000);
    }

    function previewImage() {
        var fileInput = document.getElementById('<%= fileImagen.ClientID %>');
        var file = fileInput.files[0];
        var imagePreview = document.getElementById('imagePreview');
        var previewImg = document.getElementById('previewImg');

        if (file.type !== 'image/png') {
            showAlert('Solo se permiten archivos PNG.');
            fileInput.value = '';
            return;
        }

        if (file.size > 1024 * 1024) {
            showAlert('El tamaño del archivo no puede superar 1 MB.');
            fileInput.value = '';
            return;
        }

        if (file) {
            var reader = new FileReader();
            reader.onload = function (e) {
                previewImg.src = e.target.result;
                imagePreview.classList.remove('hidden');
                document.getElementById('fileUploadContainer').classList.add('hidden');
            };
            reader.readAsDataURL(file);
        }
    }

    function removeImage() {
        var fileUploadContainer = document.getElementById('fileUploadContainer');
        var imagePreview = document.getElementById('imagePreview');

        imagePreview.classList.add('hidden');
        fileUploadContainer.classList.remove('hidden');
        document.getElementById('<%= fileImagen.ClientID %>').value = '';
    }

    function dragOverHandler(event) {
        event.preventDefault();
        var fileUploadContainer = document.getElementById('fileUploadContainer');
        fileUploadContainer.classList.add('dragover');
    }

    function dropHandler(event) {
        event.preventDefault();
        var fileUploadContainer = document.getElementById('fileUploadContainer');
        fileUploadContainer.classList.remove('dragover');
        var files = event.dataTransfer.files;
        handleFiles(files);
    }

    function handleFiles(files) {
            var fileInput = document.getElementById('<%= fileImagen.ClientID %>');
            fileInput.files = files;
            previewImage();
        }

</script>


<script>
    function soloNumeros(e) {
        var charCode = (e.which) ? e.which : e.keyCode;
        var textBoxValue = e.target.value;

        if (charCode != 46 && charCode != 44 && charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }

        if ((charCode == 46 || charCode == 44) && (textBoxValue.match(/[,.]/g) || []).length > 0) {
            return false;
        }

        var decimalSeparatorIndex = textBoxValue.indexOf(".") !== -1 ? textBoxValue.indexOf(".") : textBoxValue.indexOf(",");
        if (decimalSeparatorIndex !== -1) {
            var integerPart = textBoxValue.substring(0, decimalSeparatorIndex);
            if (integerPart.length >= 3) {
                return false;
            }
            var decimalPart = textBoxValue.substring(decimalSeparatorIndex + 1);
            if (decimalPart.length >= 2) {
                return false;
            }
        } else {
            if (textBoxValue.length >= 3) {
                return false;
            }
        }
        return true;
    }

    function showToast(message) {
        var toastTemplate = document.getElementById("toastTemplate");
        var toastContainer = document.getElementById("toastContainer");

        if (toastTemplate && toastContainer) {
            var toastClone = toastTemplate.content.cloneNode(true);
            toastClone.querySelector('.toast-title').innerText = message;
            toastClone.querySelector('.toast-body').innerText = message;

            var toastElement = toastClone.querySelector('.toast');
            toastElement.classList.add('toast-custom-animation');
            toastContainer.appendChild(toastClone);

            $(toastElement).toast('show');

            setTimeout(function () {
                toastElement.classList.remove('toast-custom-animation');
                toastElement.classList.add('toast-custom-animation-hide');

                 
                setTimeout(function () {
                    $(toastElement).toast('dispose');
                    toastContainer.removeChild(toastElement);
                }, 500); 
            }, 4500); 
        }
    }

    function setProductId(productId) {
        console.log(productId);
        document.getElementById('<%= hfProductIdToDelete.ClientID %>').value = productId;
    }

</script>
</head>

<body>
    <form runat="server" id="formProductos" class="container">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
       
        <div class="divTitulo">
            <h2 class="titulo-panel">Admin SR Company</h2>
            <asp:Button runat="server" CssClass="btn-cerrar" onclick="btnAtras_Click" />
        </div>
 
        <asp:Literal ID="Literal1" runat="server"></asp:Literal>

        <div class="form-group">
            <h3>Restaurantes</h3>
            <asp:DropDownList ID="ddlRestaurantes" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlRestaurantes_SelectedIndexChanged">
                <asp:ListItem Text="-- Elige un restaurante --" Value=""></asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="row">
            <div class="col-md-4">
                <asp:Button ID="btnAgregarProductos" runat="server" Text="Agregar Productos" CssClass="btn btn-vista btn-block" OnClick="btnAgregarProductos_Click" CommandArgument="1" />
            </div>
            <div class="col-md-4">
                <asp:Button ID="btnVerProductos" runat="server" Text="Ver Productos" CssClass="btn btn-vista btn-block" OnClick="btnVerProductos_Click" CommandArgument="2" />
            </div>
            <div class="col-md-4">
                <asp:Button ID="btnPedidosRealizados" runat="server" Text="Pedidos Realizados" CssClass="btn btn-vista btn-block" OnClick="btnPedidosRealizados_Click" CommandArgument="3" />
            </div>
        </div>
<br />

<asp:MultiView ID="mvAdminMenu" runat="server" ActiveViewIndex="0">

<!------------------------------------------------------------------------------- VISTA AÑADIR PRODCUTOS -------------------------------------------------------------------------->
    <asp:View ID="viewAgregarProductos" runat="server">

    <div id="divAgregarVacio" runat="server" visible="true">
        <h3>Agregar productos:</h3>
        <div class="elige">
            <img class="iconos" src= 'Imagenes/iconos/agregarProducto.png'/>
            <p>No hay productos<br />Asegúrese de elegir un restaurante</p>
        </div>
    </div>

    <div id="divAgregar" runat="server" visible="false">
        <div class="col-md-6">
            <h3>Agregar productos:</h3>
            <div class="form-group">
                <label for="txtNombre">Nombre:</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Agregar" ControlToValidate="txtNombre" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label for="txtPrecio">Precio:</label>
                <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" onkeypress="return soloNumeros(event)" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Agregar" ControlToValidate="txtPrecio" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegexPrecio" runat="server" ControlToValidate="txtPrecio" ValidationExpression="^\d{1,3}(\,\d{1,2})?$" ErrorMessage="El formato debe ser el correcto (máximo tres enteros y dos decimales)" CssClass="text-danger" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>
            <div class="form-group">
                <label for="txtDescripcion">Descripción:</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Agregar" ControlToValidate="txtDescripcion" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="fileImagen">Imagen:</label>
                <div id="fileUploadContainer" class="file-upload-container" ondrop="dropHandler(event)" ondragover="dragOverHandler(event)">
                    <asp:FileUpload ID="fileImagen" runat="server" accept=".png" CssClass="form-control-file" onchange="previewImage()" />
                </div>
                <div id="imagePreview" class="hidden">
                    <img id="previewImg" />
                    <asp:Button ID="btnRemoveImage" runat="server" CssClass="remove-image" OnClientClick="removeImage(); return false;" />
                </div>
                    <div id="alertContainer"></div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Ponga una imagen" ValidationGroup="Agregar" ControlToValidate="fileImagen" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>
                <asp:Button ID="btnAgregar" runat="server" OnClick="btnAgregar_Click" ValidationGroup="Agregar" CssClass="btn-agregar" />
            </div>
        </div>
    </asp:View>

<!------------------------------------------------------------------------------- VISTA VER PRODUCTOS -------------------------------------------------------------------------->
      <asp:View ID="viewVerProductos" runat="server">

          <div id="divActualizarVacio" runat="server" visible="true">
                <h3>Productos:</h3>
                  <div class="elige">
                    <img class="iconos" src= 'Imagenes/iconos/productosVacio.png'/>
                    <p>No hay productos<br />Asegúrese de elegir un restaurante</p>
                </div>
         </div>

        <div id="divActualizar" runat="server" class="row" visible="false">
            <div class="col-md-12">
                <h3>Productos:</h3>
                <div class="table-responsive">
                <asp:GridView ID="gvProductos" runat="server" CssClass="table " AutoGenerateColumns="False" DataKeyNames="id" OnRowEditing="gvProductos_RowEditing" OnRowUpdating="gvProductos_RowUpdating" OnRowCancelingEdit="gvProductos_RowCancelingEdit">
                    <Columns>
                        <asp:BoundField DataField="nombre" HeaderText="Nombre" ReadOnly="True"/>
                        <asp:BoundField DataField="precio" HeaderText="Precio" ReadOnly="True" />
                        <asp:BoundField DataField="descripcion" HeaderText="Descripción" ReadOnly="True" />
                        <asp:TemplateField HeaderText="Imagen">
                            <ItemTemplate>
                                <asp:Image ID="imgProducto" runat="server" ImageUrl='<%# "data:Image/png;base64," + Convert.ToBase64String((byte[])Eval("imagen")) %>' Height="50px" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <button type="button" class="btn-eliminar" data-toggle="modal" data-target="#confirmModal" onclick="setProductId('<%# Eval("id") %>')"></button>
                                <asp:Button ID="btnEditar" runat="server" CommandName="Edit" CssClass="btn-editar" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtNombreEdit" runat="server" Text='<%# Bind("nombre") %>' CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Actualizar" ControlToValidate="txtNombreEdit" CssClass="text-danger"></asp:RequiredFieldValidator>
                                <asp:TextBox ID="txtPrecioEdit" runat="server" Text='<%# Bind("precio") %>' CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Actualizar" ControlToValidate="txtPrecioEdit" CssClass="text-danger"></asp:RequiredFieldValidator>
                                <asp:TextBox ID="txtDescripcionEdit" runat="server" Text='<%# Bind("descripcion") %>' CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="Rellene este campo" ValidationGroup="Actualizar" ControlToValidate="txtDescripcionEdit" CssClass="text-danger"></asp:RequiredFieldValidator>
                                <asp:FileUpload ID="fileEditarImagen" runat="server" accept=".png" CssClass="form-control-file" />
                                <asp:HiddenField ID="hfImagenActualEdit" runat="server" Value='<%# Convert.ToBase64String((byte[])Eval("imagen")) %>' />
                                <br />
                                <asp:Image ID="imgEditarImagen" runat="server" ImageUrl='<%# "data:Image/png;base64," + Convert.ToBase64String((byte[])Eval("imagen")) %>' Height="50px" />
                                <br /><br />
                                <div class="aceptarCancelar">
                                    <asp:Button ID="btnActualizar" runat="server" CommandName="Update" ValidationGroup="Actualizar" class="btn-actualizar" />
                                    <asp:Button ID="btnCancelar" runat="server" CommandName="Cancel" class="btn-cancelar" />
                                </div>
                            </EditItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
           </div>
             </div>
          <asp:HiddenField ID="hfProductIdToDelete" runat="server" />
    </asp:View>

<!------------------------------------------------------------------------------- VISTA VER PEDIDOS -------------------------------------------------------------------------->
             <asp:View ID="viewPedidosRealizados" runat="server">

                  <div id="divPedidosVacio" runat="server" visible="true">
                       <h3>Pedidos:</h3>
                            <div class="elige">
                    <img class="iconos" src= 'Imagenes/iconos/pedidoVacio.png'/>
                    <p>No hay pedidos<br />Asegúrese de elegir un restaurante</p>
                </div> 
                </div>

            <div id="divPedidos" runat="server" visible="false" class="col-md-12">
                <h3>Pedidos:</h3>
                <asp:GridView ID="gvPedidosPorRestaurante" runat="server" CssClass="table " AutoGenerateColumns="False">
                 <Columns>
                    <asp:BoundField DataField="PedidoID" HeaderText="ID del Pedido" />
                    <asp:BoundField DataField="fecha" HeaderText="Fecha del Pedido" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:TemplateField HeaderText="Productos">
                        <ItemTemplate>
                            <asp:Label ID="lblProductos" runat="server" Text='<%# Eval("Productos") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="total" HeaderText="Total del Pedido" DataFormatString="{0:C}" />
                </Columns>
            </asp:GridView>
            </div>
           </asp:View>
        </asp:MultiView>

<!------------------------------------------------------------------------------- Componentes de BS -------------------------------------------------------------------------->
                <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Confirmar eliminación</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                ¿Está seguro de que desea eliminar este producto?
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-cancelarModal" data-dismiss="modal">Cancelar</button>
                                <asp:Button ID="btnConfirmarEliminar" runat="server" CommandName="ConfirmarEliminar" CssClass="btn btn-eliminarDefinitivo" Text="Eliminar" OnClick="btnConfirmarEliminar_Click" />
                            </div>
                        </div>
                    </div>
                </div>

       <asp:HiddenField ID="HiddenField1" runat="server" />

            <template id="toastTemplate">
                <div class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-delay="5000">
                    <div class="toast-header">
                        <strong class="mr-auto toast-title"></strong>
                        <button type="button" class="ml-2 mb-1 close" data-dismiss="toast" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                <div class="toast-body"></div>
                </div>
            </template>

            <div aria-live="polite" aria-atomic="true" style="position: relative; min-height: 200px;">
                <div id="toastContainer"></div>
            </div>
        </form>
    </body>
</html>

