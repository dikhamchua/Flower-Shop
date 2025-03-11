<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Shop || Plantmore</title>
        <meta name="description" content="">
        <meta name="robots" content="noindex, follow" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>

        <style>
            .pagination li.disabled a {
                pointer-events: none;
                opacity: 0.5;
                cursor: not-allowed;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <!--Header Area Start-->
            <jsp:include page="/view/common/home/header.jsp"></jsp:include>
            <!--Header Area End-->
            <!--Shop Area Start-->
            <div class="shop-area mb-70">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-3 order-2 order-lg-1">
                            <jsp:include page="/view/common/home/sidebar.jsp"></jsp:include>
                        </div>
                        <div class="col-lg-9 order-1 order-lg-2">
                            <div class="shop-layout">
                                <!--Breadcrumb One Start-->
                                <div class="breadcrumb-one mb-120">
                                    <div class="breadcrumb-img">
                                        <img src="${pageContext.request.contextPath}/assets/img/page-banner/shop-banner-1.jpg" alt="">
                                    </div>
                                    <div class="breadcrumb-content">
                                        <ul>
                                            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                                            <li class="active">Shop</li>
                                        </ul>
                                    </div>
                                </div>
                                <!--Breadcrumb One End-->
                                <!--Grid & List View Start-->
                                <div class="shop-topbar-wrapper d-md-flex justify-content-md-between align-items-center">
                                    <div class="grid-list-option">
                                        <ul class="nav">
                                            <li>
                                                <a class="active" data-bs-toggle="tab" href="#grid"><i class="fa fa-th-large"></i></a>
                                            </li>
                                            <li>
                                                <a data-bs-toggle="tab" href="#list"><i class="fa fa-th-list"></i></a>
                                            </li>
                                        </ul>
                                    </div>
                                    <!--Toolbar Short Area Start-->
                                    <div class="toolbar-short-area d-md-flex align-items-center">
                                        <div class="toolbar-shorter">
                                            <label>Sort By:</label>
                                            <select class="orderby">
                                                <option value="default" ${param.sort == null || param.sort == 'default' ? 'selected' : ''}>Default sorting</option>
                                                <option value="name_asc" ${param.sort == 'name_asc' ? 'selected' : ''}>Name, A to Z</option>
                                                <option value="name_desc" ${param.sort == 'name_desc' ? 'selected' : ''}>Name, Z to A</option>
                                                <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Price, low to high</option>
                                                <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Price, high to low</option>
                                                <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Newest first</option>
                                            </select>
                                        </div>
                                        <c:set var="endResult" value="${currentPage*productsPerPage}" />
                                        <c:if test="${endResult > totalProducts}">
                                            <c:set var="endResult" value="${totalProducts}" />
                                        </c:if>
                                        <p class="show-product">Showing ${(currentPage-1)*productsPerPage + 1} to ${endResult} of ${totalProducts} results</p>
                                    </div>
                                    <!--Toolbar Short Area End-->
                                </div>
                                <!--Grid & List View End-->
                                <!--Shop Product Start-->
                                <div class="shop-product">
                                    <div id="myTabContent-2" class="tab-content">
                                        <div id="grid" class="tab-pane fade show active">
                                            <div class="product-grid-view">
                                                <div class="row">
                                                    <c:forEach items="${products}" var="product">
                                                        <div class="col-md-4">
                                                            <!--Single Product Start-->
                                                            <div class="single-product mb-25">
                                                                <div class="product-img img-full">
                                                                    <a href="${pageContext.request.contextPath}/home?action=product-details&id=${product.productId}">
                                                                        <img src="${product.image}" alt="${product.productName}">
                                                                    </a>
                                                                     <div class="product-action">
                                                                        <ul>
                                                                            <li><a href="${pageContext.request.contextPath}/home?action=product-details&id=${product.productId}" title="Quick view"><i class="fa fa-eye"></i></a></li>
                                                                            <li><a href="#" class="add-to-wishlist" data-product-id="${product.productId}" title="Wishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                            <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                        </ul>
                                                                    </div>
                                                                </div>
                                                                <div class="product-content">
                                                                    <h2><a href="${pageContext.request.contextPath}/home?action=product-details&id=${product.productId}">${product.productName}</a></h2>
                                                                    <div class="product-price">
                                                                        <div class="price-box">
                                                                            <span class="regular-price">$${product.price}</span>
                                                                        </div>
                                                                        <div class="add-to-cart">
                                                                            <a href="#" class="add-to-cart-btn" data-product-id="${product.productId}">Add To Cart</a>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <!--Single Product End-->
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="list" class="tab-pane fade">
                                            <div class="product-list-view">
                                                <c:forEach items="${products}" var="product">
                                                    <!--Single List Product Start-->
                                                    <div class="product-list-item mb-40">
                                                        <div class="row">
                                                            <div class="col-md-4">
                                                                <div class="list-product-img img-full">
                                                                    <a href="${pageContext.request.contextPath}/home?action=product-details&id=${product.productId}">
                                                                        <img src="${product.image}" alt="${product.productName}">
                                                                    </a>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-8">
                                                                <div class="product-content shop-list">
                                                                    <h2><a href="${pageContext.request.contextPath}/home?action=product-details&id=${product.productId}">${product.productName}</a></h2>
                                                                    <div class="product-price">
                                                                        <div class="price-box">
                                                                            <span class="regular-price">$${product.price}</span>
                                                                        </div>
                                                                    </div>
                                                                    <div class="product-desc">
                                                                        <p>${product.description}</p>
                                                                    </div>
                                                                    <div class="product-action-shop">
                                                                        <a class="add-to-cart-btn" href="#" data-product-id="${product.productId}">Add to cart</a>
                                                                        <ul>
                                                                            <li><a href="#" class="add-to-wishlist" data-product-id="${product.productId}" title="Wishlist"><i class="fa fa-heart-o"></i></a></li>
                                                                            <li><a href="#" title="Compare"><i class="fa fa-refresh"></i></a></li>
                                                                        </ul>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!--Single List Product End-->
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!--Shop Product End-->
                                
                                <!-- Pagination Start -->
                                <div class="product-pagination">
                                    <ul>
                                        <%-- First button --%>
                                        <li class="${currentPage == 1 ? 'disabled' : ''}">
                                            <c:url var="firstUrl" value="/home">
                                                <c:param name="page" value="1"/>
                                                <c:param name="search" value="${param.search}"/>
                                                <c:param name="sort" value="${param.sort}"/>
                                                <c:param name="categories" value="${param.categories}"/>
                                                <c:param name="minPrice" value="${param.minPrice}"/>
                                                <c:param name="maxPrice" value="${param.maxPrice}"/>
                                            </c:url>
                                            <a href="${firstUrl}"><i class="fa fa-angle-double-left"></i></a>
                                        </li>

                                        <%-- Page numbers --%>
                                        <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                            <li class="${i == currentPage ? 'active' : ''}">
                                                <a href="javascript:void(0)" onclick="goToPage(${i})">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <%-- Last button --%>
                                        <li class="${currentPage == totalPages ? 'disabled' : ''}">
                                            <c:url var="lastUrl" value="/home">
                                                <c:param name="page" value="${totalPages}"/>
                                                <c:param name="search" value="${param.search}"/>
                                                <c:param name="sort" value="${param.sort}"/>
                                                <c:param name="categories" value="${param.categories}"/>
                                                <c:param name="minPrice" value="${param.minPrice}"/>
                                                <c:param name="maxPrice" value="${param.maxPrice}"/>
                                            </c:url>
                                            <a href="${lastUrl}"><i class="fa fa-angle-double-right"></i></a>
                                        </li>
                                    </ul>
                                </div>
                                <!-- Pagination End -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Shop Area End-->
            
            <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
            <!--Footer Area End-->
        </div>
        
        <!-- Quick View Modal -->
        <div class="modal fade" id="open-modal" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="quick-view-content">
                        <!-- Content will be loaded dynamically -->
                        <div class="text-center">
                            <div class="spinner-border" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- All JS Files -->
        <jsp:include page="../common/home/common-js.jsp"></jsp:include>
        
        <!-- Toast container -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 11">
            <div id="cartToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header bg-success text-white">
                    <strong class="me-auto">Thông báo</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body">
                    Sản phẩm đã được thêm vào giỏ hàng
                </div>
            </div>
        </div>
        
        <script>
            // Đợi DOM load xong
            document.addEventListener('DOMContentLoaded', function() {
                // Debug: Kiểm tra xem có tìm thấy element không
                const sortSelect = document.querySelector('.orderby');
                console.log('Sort select element:', sortSelect);

                if (sortSelect) {
                    sortSelect.addEventListener('change', function() {
                        // Debug: Kiểm tra sự kiện change có được kích hoạt
                        console.log('Sort changed to:', this.value);
                        
                        const sortValue = this.value;
                        const urlParams = new URLSearchParams(window.location.search);
                        
                        // Debug: Kiểm tra URL params trước khi thay đổi
                        console.log('Current URL params:', urlParams.toString());
                        
                        urlParams.set('sort', sortValue);
                        urlParams.delete('page');
                        
                        // Debug: Kiểm tra URL params sau khi thay đổi
                        console.log('New URL params:', urlParams.toString());
                        
                        const newUrl = window.location.pathname + '?' + urlParams.toString();
                        console.log('Redirecting to:', newUrl);
                        
                        window.location.href = newUrl;
                    });
                } else {
                    console.error('Sort select element not found!');
                }
            });
            
            // Quick view modal handler
            $(document).on('click', '[data-bs-toggle="modal"][title="Quick view"]', function(e) {
                e.preventDefault();
                const productId = $(this).data('product-id');
                
                // Clear previous content and show loading spinner
                $('#quick-view-content').html('<div class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>');
                
                // Load product details via AJAX
                $.ajax({
                    url: '${pageContext.request.contextPath}/quick-view',
                    type: 'GET',
                    data: { id: productId },
                    success: function(response) {
                        $('#quick-view-content').html(response);
                    },
                    error: function() {
                        $('#quick-view-content').html('<div class="alert alert-danger">Error loading product details</div>');
                    }
                });
            });
            
            // Add to cart handler
            $(document).on('click', '.add-to-cart-btn', function(e) {
                e.preventDefault();
                const productId = $(this).data('product-id');
                
                // Kiểm tra đăng nhập trước khi thêm vào giỏ hàng
                <c:if test="${empty sessionScope.account}">
                    // Hiển thị thông báo yêu cầu đăng nhập
                    const toast = new bootstrap.Toast(document.getElementById('cartToast'));
                    $('#cartToast').removeClass('bg-success').addClass('bg-warning');
                    $('#cartToast .toast-body').text('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng');
                    toast.show();
                    
                    // Chuyển hướng đến trang đăng nhập sau 2 giây
                    setTimeout(function() {
                        window.location.href = '${pageContext.request.contextPath}/authen?action=login';
                    }, 2000);
                    return;
                </c:if>
                
                // Nếu đã đăng nhập, tiếp tục thêm vào giỏ hàng
                $.ajax({
                    url: '${pageContext.request.contextPath}/cart',
                    type: 'POST',
                    data: { action: 'add', productId: productId, quantity: 1 },
                    success: function(response) {
                        // Update cart count in header
                        $('.cart-quantity').text(response);
                        
                        // Show toast message
                        const toast = new bootstrap.Toast(document.getElementById('cartToast'));
                        $('#cartToast').removeClass('bg-danger').addClass('bg-success');
                        $('#cartToast .toast-body').text('Sản phẩm đã được thêm vào giỏ hàng');
                        toast.show();
                        
                        // Auto hide toast after 3 seconds
                        setTimeout(function() {
                            toast.hide();
                        }, 3000);
                    },
                    error: function(xhr) {
                        // Show error toast
                        $('#cartToast').removeClass('bg-success').addClass('bg-danger');
                        $('#cartToast .toast-body').text('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng');
                        const toast = new bootstrap.Toast(document.getElementById('cartToast'));
                        toast.show();
                        
                        // Auto hide toast after 3 seconds
                        setTimeout(function() {
                            toast.hide();
                        }, 3000);
                    }
                });
            });
            
            // Add to wishlist handler
            $(document).on('click', '.add-to-wishlist', function(e) {
                e.preventDefault();
                const productId = $(this).data('product-id');
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/wishlist/add',
                    type: 'POST',
                    data: { productId: productId },
                    success: function(response) {
                        showNotification('success', 'Product added to wishlist successfully');
                    },
                    error: function(xhr) {
                        if (xhr.status === 401) {
                            showNotification('error', 'Please login to add products to wishlist');
                        } else {
                            showNotification('error', 'Failed to add product to wishlist');
                        }
                    }
                });
            });
            
            // Helper functions
            function updateCartCount() {
                $.ajax({
                    url: '${pageContext.request.contextPath}/cart/count',
                    type: 'GET',
                    success: function(count) {
                        $('.cart-count').text(count);
                    }
                });
            }
            
            function showNotification(type, message) {
                // Implement your notification system here
                // For example, using toastr or a custom notification
                alert(message);
            }

            // Category Filter
            document.querySelectorAll('.category-filter').forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    const selectedCategories = Array.from(document.querySelectorAll('.category-filter:checked'))
                        .map(cb => cb.value);
                    
                    const urlParams = new URLSearchParams(window.location.search);
                    if (selectedCategories.length > 0) {
                        urlParams.set('categories', selectedCategories.join(','));
                    } else {
                        urlParams.delete('categories');
                    }
                    urlParams.delete('page'); // Reset về page 1
                    
                    window.location.href = window.location.pathname + '?' + urlParams.toString();
                });
            });

            // Price Filter
            document.getElementById('priceFilterForm').addEventListener('submit', function(e) {
                e.preventDefault();
                
                const minPrice = document.getElementById('minPrice').value;
                const maxPrice = document.getElementById('maxPrice').value;
                
                const urlParams = new URLSearchParams(window.location.search);
                urlParams.set('minPrice', minPrice);
                urlParams.set('maxPrice', maxPrice);
                urlParams.delete('page'); // Reset về page 1
                
                window.location.href = window.location.pathname + '?' + urlParams.toString();
            });

            // Search
            document.getElementById('searchForm').addEventListener('submit', function(e) {
                e.preventDefault();
                
                const searchValue = document.getElementById('searchInput').value;
                
                const urlParams = new URLSearchParams(window.location.search);
                if (searchValue) {
                    urlParams.set('search', searchValue);
                } else {
                    urlParams.delete('search');
                }
                urlParams.delete('page');
                
                window.location.href = window.location.pathname + '?' + urlParams.toString();
            });

            // Pagination
            function goToPage(pageNumber) {
                const urlParams = new URLSearchParams(window.location.search);
                urlParams.set('page', pageNumber);
                
                window.location.href = window.location.pathname + '?' + urlParams.toString();
            }
        </script>
    </body>
</html>
