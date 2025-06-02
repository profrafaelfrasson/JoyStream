// Configuração global do SweetAlert2 para o tema do site
const joystreamTheme = Swal.mixin({
    customClass: {
        confirmButton: 'swal-confirm-button',
        cancelButton: 'swal-cancel-button',
        title: 'swal-title',
        popup: 'swal-popup'
    },
    buttonsStyling: false
});

// Toast notifications
function alertResult(icon, text) {
    const Toast = Swal.mixin({
        toast: true,
        position: "top-end",
        showConfirmButton: false,
        timer: 4000,
        timerProgressBar: true,
        iconColor: '#f1c40f',
        background: '#1f1f1f',
        color: '#ffffff',
        didOpen: (toast) => {
            toast.onmouseenter = Swal.stopTimer;
            toast.onmouseleave = Swal.resumeTimer;
        },
        customClass: {
            popup: 'animated fadeInRight',
            title: 'swal-toast-title'
        }
    });
    Toast.fire({
        icon: icon,
        title: text
    });
}

// Confirmação de ação
function confirmAction(title, text, confirmText = 'Confirmar', cancelText = 'Cancelar', icon = 'warning') {
    return joystreamTheme.fire({
        title: title,
        text: text,
        icon: icon,
        showCancelButton: true,
        confirmButtonText: confirmText,
        cancelButtonText: cancelText,
        background: '#1f1f1f',
        color: '#ffffff',
        iconColor: '#f1c40f',
        reverseButtons: true
    });
}

// Mensagem de sucesso
function showSuccess(title, text = '') {
    return joystreamTheme.fire({
        icon: 'success',
        title: title,
        text: text,
        background: '#1f1f1f',
        color: '#ffffff',
        iconColor: '#f1c40f',
        timer: 4000,
        showConfirmButton: false
    });
}

// Mensagem de erro
function showError(title, text = '') {
    return joystreamTheme.fire({
        icon: 'error',
        title: title,
        text: text,
        background: '#1f1f1f',
        color: '#ffffff',
        iconColor: '#f1c40f'
    });
}

// Adicionar estilos CSS personalizados
const style = document.createElement('style');
style.textContent = `
    .swal-popup {
        background-color: #1f1f1f !important;
        border: 1px solid #f1c40f;
        border-radius: 10px;
    }

    .swal-title {
        color: #f1c40f !important;
        font-size: 1.5em !important;
    }

    .swal-toast-title {
        color: #ffffff !important;
        font-size: 1.1em !important;
    }

    .swal-confirm-button {
        background: linear-gradient(45deg, #f1c40f, #f39c12) !important;
        color: #000 !important;
        border: none !important;
        padding: 10px 24px !important;
        border-radius: 6px !important;
        font-weight: bold !important;
        margin: 5px !important;
        cursor: pointer !important;
        transition: all 0.3s ease !important;
    }

    .swal-confirm-button:hover {
        transform: translateY(-2px) !important;
        box-shadow: 0 4px 15px rgba(241, 196, 15, 0.4) !important;
    }

    .swal-cancel-button {
        background: transparent !important;
        color: #f1c40f !important;
        border: 1px solid #f1c40f !important;
        padding: 10px 24px !important;
        border-radius: 6px !important;
        font-weight: bold !important;
        margin: 5px !important;
        cursor: pointer !important;
        transition: all 0.3s ease !important;
    }

    .swal-cancel-button:hover {
        background: rgba(241, 196, 15, 0.1) !important;
    }

    @keyframes fadeInRight {
        from {
            opacity: 0;
            transform: translateX(20px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    .animated {
        animation-duration: 0.3s;
        animation-fill-mode: both;
    }

    .fadeInRight {
        animation-name: fadeInRight;
    }
`;
document.head.appendChild(style);