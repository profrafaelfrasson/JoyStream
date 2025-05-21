$(document).ready(function () {
  function verificarCampos(form) {
    return form.find("input").filter(function () {
      return !this.value || !this.validity.valid;
    });
  }

  $("form").on("keypress", "input", function (e) {
    if (e.which == 13) { // Código da tecla Enter
      e.preventDefault(); // Previne o envio do formulário

      var form = $(this).closest("form");
      var camposInvalidos = verificarCampos(form);

      if (camposInvalidos.length > 0) {
        var campoAtual = $(this);
        var proximoCampo = camposInvalidos.filter(function () {
          return $(this).index() > campoAtual.index();
        }).first();

        if (proximoCampo.length > 0) {
          proximoCampo.focus();
        } else {
          camposInvalidos.first().focus(); // Se não houver próximo, volta ao primeiro inválido
        }
      } else {
        form.submit(); // Todos os campos estão válidos, envia o formulário
      }
    }
  });
});
