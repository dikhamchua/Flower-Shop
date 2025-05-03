<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Coupons || Plantmore</title>
        <meta name="description" content="">
        <meta name="robots" content="noindex, follow">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Place favicon.ico in the root directory -->
        <link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
        <!--All Css Here-->
        <jsp:include page="../common/home/common-css.jsp"></jsp:include>
        <style>
            .coupon-card {
                border: 2px dashed #80b435;
                padding: 20px;
                margin-bottom: 30px;
                border-radius: 8px;
                background-color: #fff;
                transition: all 0.3s ease;
            }
            
            .coupon-card:hover {
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                transform: translateY(-2px);
            }
            
            .coupon-header {
                border-bottom: 1px solid #eee;
                padding-bottom: 15px;
                margin-bottom: 15px;
            }
            
            .coupon-code {
                font-size: 24px;
                font-weight: bold;
                color: #80b435;
                letter-spacing: 2px;
            }
            
            .coupon-description {
                color: #666;
                margin: 10px 0;
                min-height: 60px;
            }
            
            .coupon-details {
                display: flex;
                justify-content: space-between;
                margin-top: 15px;
                font-size: 14px;
                color: #888;
            }
            
            .coupon-value {
                font-size: 20px;
                color: #e83e8c;
                font-weight: bold;
            }
            
            .coupon-dates {
                font-size: 12px;
                color: #999;
                margin-top: 10px;
            }
            
            .coupon-usage {
                background-color: #f8f9fa;
                padding: 8px;
                border-radius: 4px;
                margin-top: 10px;
                font-size: 13px;
            }
            
            .coupon-search {
                margin-bottom: 30px;
            }
            
            .coupon-search .form-control {
                border-radius: 4px 0 0 4px;
                height: 45px;
            }
            
            .coupon-search .btn {
                border-radius: 0 4px 4px 0;
                background-color: #80b435;
                color: white;
                border-color: #80b435;
            }
            
            .coupon-search .btn:hover {
                background-color: #6a9a2d;
                border-color: #6a9a2d;
            }
            
            .pagination {
                margin-top: 30px;
                justify-content: center;
            }
            
            .pagination .page-link {
                color: #80b435;
            }
            
            .pagination .page-item.active .page-link {
                background-color: #80b435;
                border-color: #80b435;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <!--Header Area Start-->
            <jsp:include page="/view/common/home/header.jsp"></jsp:include>
            <!--Header Area End-->
            
            <!--Breadcrumb Start-->
            <div class="breadcrumb-tow mb-120">
                <div class="container">
                    <div class="row">
                        <div class="col-12">
                            <div class="breadcrumb-title">
                                <h1>Coupons</h1>
                            </div>
                            <div class="breadcrumb-content breadcrumb-content-tow">
                                <ul>
                                    <li><a href="home">Home</a></li>
                                    <li class="active">Coupons</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Breadcrumb End-->
            
            <!--Coupon Area Start-->
            <div class="coupon-area white-bg pt-0 pb-0 mb-70">
                <div class="container">
                    <div class="row">
                        <div class="col-12">
                            <!-- Search form -->
                            <div class="coupon-search">
                                <form action="coupon" method="get">
                                    <div class="input-group">
                                        <input type="text" class="form-control" name="search" value="${searchCode}" placeholder="Search coupons by code or description...">
                                        <div class="input-group-append">
                                            <button class="btn btn-outline-secondary" type="submit">Search</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            
                            <c:if test="${empty coupons}">
                                <div class="alert alert-info">No coupons available at the moment.</div>
                            </c:if>
                            
                            <div class="row">
                                <c:forEach var="coupon" items="${coupons}">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="coupon-card">
                                            <div class="coupon-header">
                                                <div class="coupon-code">${coupon.code}</div>
                                            </div>
                                            <div class="coupon-description">${coupon.description}</div>
                                            <div class="coupon-value">
                                                <c:choose>
                                                    <c:when test="${coupon.discountType == 'percentage'}">                                                        
                                                        ${coupon.discountValue}% OFF
                                                    </c:when>
                                                    <c:otherwise>
                                                        $<fmt:formatNumber value="${coupon.discountValue}" pattern="#,##0.00"/> OFF
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="coupon-details">
                                                <div>Min Purchase: $<fmt:formatNumber value="${coupon.minPurchase}" pattern="#,##0.00"/></div>
                                                <c:if test="${not empty coupon.maxDiscount}">
                                                    <div>Max Discount: $<fmt:formatNumber value="${coupon.maxDiscount}" pattern="#,##0.00"/></div>
                                                </c:if>
                                            </div>
                                            <!-- Add this inside the coupon-card div, after coupon-dates -->
                                            <div class="coupon-dates">
                                                Valid from: <fmt:formatDate value="${coupon.startDate}" pattern="MMM dd, yyyy"/> -
                                                <fmt:formatDate value="${coupon.endDate}" pattern="MMM dd, yyyy"/>
                                                
                                                <!-- Add remaining time indicator -->
                                                <c:set var="now" value="<%= new java.util.Date() %>"/>
                                                <c:set var="remainingDays" value="${((coupon.endDate.time - now.time) / (1000*60*60*24))}"/>
                                                <div class="remaining-time ${remainingDays <= 7 ? 'urgent' : ''}">
                                                    <c:choose>
                                                        <c:when test="${remainingDays > 1}">
                                                            <span>Expires in ${Math.round(remainingDays)} days</span>
                                                        </c:when>
                                                        <c:when test="${remainingDays > 0}">
                                                            <span>Expires in less than a day</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span>Expired</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            
                                            <!-- Add this to your existing style section -->
                                            <style>
                                                .remaining-time {
                                                    margin-top: 5px;
                                                    font-size: 12px;
                                                    color: #666;
                                                }
                                                
                                                .remaining-time.urgent span {
                                                    color: #dc3545;
                                                    font-weight: bold;
                                                }
                                            </style>
                                            <div class="coupon-usage">
                                                <c:if test="${not empty coupon.usageLimit}">
                                                    Used ${coupon.usageCount} times out of ${coupon.usageLimit}
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <div class="row">
                                    <div class="col-12">
                                        <ul class="pagination">
                                            <c:if test="${currentPage > 1}">
                                                <li class="page-item">
                                                    <a class="page-link" href="coupon?page=${currentPage - 1}${searchCode != null ? '&search='.concat(searchCode) : ''}">
                                                        <i class="fa fa-angle-left"></i> Previous
                                                    </a>
                                                </li>
                                            </c:if>
                                            
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="coupon?page=${i}${searchCode != null ? '&search='.concat(searchCode) : ''}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalPages}">
                                                <li class="page-item">
                                                    <a class="page-link" href="coupon?page=${currentPage + 1}${searchCode != null ? '&search='.concat(searchCode) : ''}">
                                                        Next <i class="fa fa-angle-right"></i>
                                                    </a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
            <!--Coupon Area End-->
            
            <!--Footer Area Start-->
            <jsp:include page="/view/common/home/footer.jsp"></jsp:include>
            <!--Footer Area End-->
        </div>
        <!--All Js Here-->
        <jsp:include page="/view/common/home/common-js.jsp"></jsp:include>
    </body>
</html>