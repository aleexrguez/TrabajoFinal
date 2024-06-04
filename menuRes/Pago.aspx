<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Pago.aspx.cs" Inherits="menuRes.Pago" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Hugo 0.84.0">
    <title>Checkout</title>
    <link rel="shortcut icon" href="Fotos/Index/logoSolo.png" />
    <link rel="canonical" href="https://getbootstrap.com/docs/5.0/examples/sign-in/">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-*******" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link href="Estilos/boostrap1.css" rel="stylesheet">
    <link rel="stylesheet" href="Estilos/estiloPago.css"/>

</head>
<body>
    <!------------------------------------------------------------------------------- NAVBAR -------------------------------------------------------------------------->

            <div class="navbar transparent">
                <div class="navbar-left">
                      <button type="button" class="btn-atras" data-toggle="modal" data-target="#confirmModal"></button>
                      <span class="principal">SR COMPANY</span>
                </div>
                <div class="nav-nombre">
              <asp:Literal ID="nombreRestauranteLiteral" runat="server"></asp:Literal>
            </div>

          </div>
            <div style="padding-top: 60px;"></div>

        <form runat="server">
            <!------------------------------------------------------------------------------- MODAL DE VOLVER -------------------------------------------------------------------------->

            <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">¿Te vas 😥?</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                ¿Está seguro de que desea salir? Perderás todos los datos de la compra
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-cancelarModal" data-dismiss="modal">Cancelar</button>
                                <asp:Button ID="btnConfirmarEliminar" runat="server" CssClass="btn btn-eliminarDefinitivo" Text="Confirmar" OnClick="btnConfirmarEliminar_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            <!------------------------------------------------------------------------------- METODO DE PAGO -------------------------------------------------------------------------->

                    <div class="container d-flex justify-content-center mt-5 mb-5">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <span class="principal">Método de pago</span>
                            <div class="card">
                                <div class="accordion" id="accordionExample">
                                    <div class="card">
                                        <div class="card-header p-0">
                                            <h2 class="mb-0">
                                                <div class="btn btn-block text-left p-3 rounded-0" id="btn-princi" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                                    <div class="d-flex align-items-center justify-content-between">
                                                        <span>Tarjeta de Crédito</span>
                                                        <div class="icons">
                                                            <img src="https://i.imgur.com/2ISgYja.png" width="30">
                                                            <img src="https://i.imgur.com/W1vtnOV.png" width="30">
                                                            <img src="https://i.imgur.com/35tC99g.png" width="30">
                                                            <img src="https://i.imgur.com/2ISgYja.png" width="30">
                                                        </div>
                                                    </div>
                                                </div>
                                            </h2>
                                        </div>
                                        <div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#accordionExample">
                                            <div class="card-body payment-card-body">
                                                <span class="font-weight-normal card-text">Número de tarjeta</span>
                                                <div class="input">
                                                    <i class="fa fa-credit-card"></i>
                                                    <asp:TextBox ID="numTar" runat="server" placeholder="0000 0000 0000 0000" MaxLength="16"></asp:TextBox>
                                                </div>
                                                <div class="row mt-3 mb-3">
                                                    <div class="col-md-6">
                                                        <span class="font-weight-normal card-text">Dia de expiración</span>
                                                        <div class="input">
                                                            <i class="fa fa-calendar"></i>
                                                            <asp:TextBox ID="expira" runat="server" placeholder="MM/YY" MaxLength="5"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <span class="font-weight-normal card-text">CVC/CVV</span>
                                                        <div class="input">
                                                            <i class="fa fa-lock"></i>
                                                            <asp:TextBox ID="cvv" runat="server" placeholder="000" MaxLength="3"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <asp:Label ID="Error" runat="server" Text="" Visible="false" ForeColor="Red"></asp:Label>
                                                </div>
                                                <span class="text-muted certificate-text"><i class="fa fa-lock"></i> Tu transaccion es seguro con el certificado SSL </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <span class="principal">Resumen</span>
                            <div class="card">
                                <div class="d-flex justify-content-between p-3">
                                    <div class="d-flex flex-column">
                                        <asp:Literal ID="litResultado" runat="server"></asp:Literal>
                                    </div>
                                </div>
                                <asp:Button Cssclass="bt1" runat="server" Text="Comprar" OnClick="RedirectAfterPayment" />
                            </div>
                            <div class="p-3"></div>
                        </div>
                    </div>
                </div>
            </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    <script src="JS/checkout.js"></script>
    <script>
        function formatExpirationDate(event) {
            const input = event.target;
            const value = input.value.replace(/\D/g, ''); 

            if (event.inputType === 'deleteContentBackward') {
                if (value.length <= 2) {
                    input.value = value;
                } else {
                    input.value = value.slice(0, 2) + '/' + value.slice(2, 4);
                }
            } else {
                if (value.length >= 2) {
                    input.value = value.slice(0, 2) + '/' + value.slice(2, 4);
                } else {
                    input.value = value;
                }
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            const expirationInput = document.getElementById('expira');
            expirationInput.addEventListener('input', formatExpirationDate);
        });
    </script>
</body>
</html>
