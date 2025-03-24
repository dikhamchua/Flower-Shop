<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>${blog.title} || Plantmore</title>
        <meta name="description" content="${blog.content.substring(0, blog.content.length() > 150 ? 150 : blog.content.length())}...">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>
        
        <!-- Toast CSS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <style>
            .iziToast-wrapper {
                z-index: 99999 !important;
            }
            .iziToast {
                min-width: 300px;
            }
        </style>
    </head>
    <body>
        <!--[if lt IE 8]>
        <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->

        <div class="wrapper">
            <!--Header Area Start-->
            <jsp:include page="/view/common/home/header.jsp"></jsp:include>
            <!--Header Area End-->
            
            <!--Breadcrumb Tow Start-->
            <div class="breadcrumb-tow mb-120">
                <div class="container">
                    <div class="row">
                        <div class="col-12">
                            <div class="breadcrumb-title">
                                <h1>Blog Detail</h1>
                            </div>
                            <div class="breadcrumb-content breadcrumb-content-tow">
                                <ul>
                                    <li><a href="home">Home</a></li>
                                    <li><a href="blog">Blog</a></li>
                                    <li class="active">${blog.title}</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Breadcrumb Tow End-->
            
            <!--Blog Area Start-->
            <div class="blog-area white-bg pt-0 pb-0 mb-70">
                <div class="container">
                    <div class="row">
                        <!--Blog Post Start-->
                        <div class="col-lg-9">
                            <div class="blog_area">
                                <article class="blog_single blog-details">
                                    <header class="entry-header">
                                        <h1 class="entry-title">
                                            ${blog.title}
                                        </h1>
                                        <span class="post-author">
                                            <span class="post-by"> Posted by: </span> Admin </span>
                                        <span class="post-separator">|</span>
                                        <span class="blog-post-date">
                                            <i class="fas fa-calendar-alt"></i>
                                            <fmt:formatDate value="${blog.createdAt}" pattern="MMMM dd, yyyy" />
                                        </span>
                                    </header>
                                    
                                    <div class="postinfo-wrapper">
                                        <div class="post-info">
                                            <div class="entry-summary blog-post-description">
                                                <p>${blog.content}</p>
                                                
<!--                                                <div class="social-sharing mt-30">
                                                    <div class="widget widget_socialsharing_widget">
                                                        <h3 class="widget-title">Share this post</h3>
                                                        <ul class="blog-social-icons">
                                                            <li>
                                                                <a target="_blank" title="Facebook" href="#" class="facebook social-icon">
                                                                    <i class="fa fa-facebook"></i>
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a target="_blank" title="twitter" href="#" class="twitter social-icon">
                                                                    <i class="fa fa-twitter"></i>
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a target="_blank" title="pinterest" href="#" class="pinterest social-icon">
                                                                    <i class="fa fa-pinterest"></i>
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a target="_blank" title="linkedin" href="#" class="linkedin social-icon">
                                                                    <i class="fa fa-linkedin"></i>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>-->
                                            </div>
                                        </div>
                                    </div>
                                </article>
                                
                                <!-- Navigation between posts -->
                                <div class="blog-post-navigation">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="prev-post">
                                                <a href="blog" class="btn btn-outline-secondary">
                                                    <i class="fa fa-angle-left mr-2"></i> Back to Blog List
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--Blog Post End-->
                        
                        <!--Blog Sidebar Start-->
                        <div class="col-lg-3">
                            <div class="blog_sidebar">
                                <div class="row_products_side">
                                    <div class="product_left_sidbar">
                                        <div class="product-filter mb-35">
                                            <h5>Search </h5>
                                            <div class="search__sidbar">
                                                <div class="input_form">
                                                    <form action="blog" method="get">
                                                        <input id="search_input" name="search" placeholder="Search..." class="input_text" type="text">
                                                        <button id="blogsearchsubmit" type="submit" class="button">
                                                            <i class="fa fa-search"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="product-filter mb-35">
                                            <h5>Recent Posts</h5>
                                            <div class="blog_Archives__sidbar">
                                                <ul>
                                                    <c:forEach var="recentBlog" items="${recentBlogs}" end="4">
                                                        <li>
                                                            <a href="blog?action=detail&id=${recentBlog.id}" class="${recentBlog.id == blog.id ? 'active' : ''}">${recentBlog.title}</a>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </div>
                                        
                                        <div class="product-filter mb-35">
                                            <div class="sidebar-banner single-banner">
                                                <div class="banner-img">
                                                    <a href="#"><img src="img/banner/shop-sidebar.jpg" alt=""></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--Blog Sidebar End-->
                    </div>
                </div>
            </div>
            <!--Blog Area End-->
            
            <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
            <!--Footer Area End-->
        </div>

        <!--All Js Here-->
        <jsp:include page="../common/home/common-js.jsp"></jsp:include>
        
        <!-- Toast JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
        
        <script>
            // Toast message display
            var toastMessage = "${sessionScope.toastMessage}";
            var toastType = "${sessionScope.toastType}";
            
            if (toastMessage) {
                iziToast.show({
                    title: toastType === 'success' ? 'Success' : 'Error',
                    message: toastMessage,
                    position: 'topRight',
                    color: toastType === 'success' ? 'green' : 'red',
                    timeout: 5000
                });
                
                // Remove toast attributes from session
                fetch('${pageContext.request.contextPath}/remove-toast', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    }
                }).catch(error => {
                    console.error('Error:', error);
                });
            }
        </script>
    </body>
</html> 