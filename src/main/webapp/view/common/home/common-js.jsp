<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--Jquery 3.6.0-->
<script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-migrate-3.3.2.min.js"></script>
<!--Popper-->
<script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
<!--Bootstrap-->
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
<!--Imagesloaded-->
<script src="${pageContext.request.contextPath}/assets/js/imagesloaded.pkgd.min.js"></script> 
<!--Isotope-->
<script src="${pageContext.request.contextPath}/assets/js/isotope.pkgd.min.js"></script>
<!--Waypoints-->
<script src="${pageContext.request.contextPath}/assets/js/waypoints.min.js"></script>
<!--Counterup-->
<script src="${pageContext.request.contextPath}/assets/js/jquery.counterup.min.js"></script>
<!--Carousel-->
<script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
<!--Slick-->
<script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
<!--Meanmenu-->
<script src="${pageContext.request.contextPath}/assets/js/jquery.meanmenu.min.js"></script>
<!--Easyzoom-->
<script src="${pageContext.request.contextPath}/assets/js/easyzoom.min.js"></script>
<!--Nice Select-->
<script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
<!--ScrollUp-->
<script src="${pageContext.request.contextPath}/assets/js/jquery.scrollUp.min.js"></script>
<!--Wow-->
<script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
<!--Venobox-->
<script src="${pageContext.request.contextPath}/assets/js/venobox.min.js"></script>
<!--Jquery Ui-->
<script src="${pageContext.request.contextPath}/assets/js/jquery-ui.js"></script>
<!--Countdown-->
<script src="${pageContext.request.contextPath}/assets/js/jquery.countdown.min.js"></script>
<!--Plugins-->
<script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
<!--Main Js-->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var toastMessage = "${sessionScope.toastMessage}";
        var toastType = "${sessionScope.toastType}";
        if (toastMessage) {
            iziToast.show({
                title: toastType === 'success' ? 'Success' : 'Error',
                message: toastMessage,
                position: 'topRight',
                color: toastType === 'success' ? 'green' : 'red',
                timeout: 2000,
                onClosing: function () {
                    fetch('${pageContext.request.contextPath}/remove-toast', {
                        method: 'POST'
                    });
                }
            });
        }
    });
</script>