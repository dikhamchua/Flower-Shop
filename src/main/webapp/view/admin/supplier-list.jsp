<%-- 
    Document   : supplier-list
    Created on : Mar 12, 2025, 12:36:12 AM
    Author     : FPTSHOP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <title>Supplier Management</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
        <style>
            .fixed-width-btn {
                min-width: 120px;
                text-align: center;
            }
        </style>
    </head>

    <body>
        <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

        <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

        <c:url value="/admin/manage-supplier" var="paginationUrl">
            <c:param name="action" value="list" />
            <c:if test="${not empty searchFilter}">
                <c:param name="search" value="${searchFilter}" />
            </c:if>
            <c:if test="${not empty statusFilter}">
                <c:param name="status" value="${statusFilter}" />
            </c:if>
        </c:url>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Supplier Management</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Supplier List</li>
                </ul>
            </div>

            <!-- Filter Section -->
            <div class="card mb-24">
                <div class="card-body p-24">
                    <form action="${pageContext.request.contextPath}/admin/manage-supplier" method="GET">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <input type="text" class="form-control" name="search" placeholder="Search by name, email or phone"
                                       value="${searchFilter}">
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" name="status">
                                    <option value="" ${empty statusFilter ? 'selected' : ''}>All Status</option>
                                    <option value="1" ${statusFilter == '1' ? 'selected' : ''}>Active</option>
                                    <option value="0" ${statusFilter == '0' ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <input type="hidden" name="action" value="list">
                                <button type="submit" class="btn btn-primary w-100">Filter</button>
                            </div>
                            <div class="col-md-3 text-end">
                                <a href="${pageContext.request.contextPath}/admin/manage-supplier?action=add" class="btn btn-success">
                                    <i class="bi bi-plus-circle me-2"></i>Add New Supplier
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Supplier List -->
            <div class="card mb-24">
                <div class="card-body p-24">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Phone</th>
                                    <th scope="col">Address</th>
                                    <th scope="col">Status</th>
                                    <th scope="col">Created At</th>
                                    <th scope="col">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${suppliers}" var="supplier">
                                    <tr>
                                        <td>${supplier.supplierId}</td>
                                        <td>${supplier.name}</td>
                                        <td>${supplier.email}</td>
                                        <td>${supplier.phone}</td>
                                        <td>${supplier.address}</td>
                                        <td>
                                            <span class="badge ${supplier.status == 1 ? 'bg-success' : 'bg-danger'}">
                                                ${supplier.status == 1 ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td><fmt:formatDate value="${supplier.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/manage-supplier?action=edit&id=${supplier.supplierId}" 
                                                   class="btn btn-sm btn-primary fixed-width-btn">Edit</a>
                                                
                                                <c:if test="${supplier.status == 1}">
                                                    <button onclick="confirmDeactivate(${supplier.supplierId})" 
                                                            class="btn btn-sm btn-danger fixed-width-btn">Deactivate</button>
                                                </c:if>
                                                <c:if test="${supplier.status == 0}">
                                                    <button onclick="confirmActivate(${supplier.supplierId})" 
                                                            class="btn btn-sm btn-success fixed-width-btn">Activate</button>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <nav class="mt-24">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
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
                        timeout: 1000,
                        onClosing: function () {
                            fetch('${pageContext.request.contextPath}/remove-toast', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                            }).then(response => {
                                if (!response.ok) {
                                    console.error('Failed to remove toast attributes');
                                }
                            }).catch(error => {
                                console.error('Error:', error);
                            });
                        }
                    });
                }
            });

            function confirmDeactivate(supplierId) {
                if (confirm('Are you sure you want to deactivate this supplier?')) {
                    window.location.href = '${pageContext.request.contextPath}/admin/manage-supplier?action=deactivate&id=' + supplierId;
                }
            }

            function confirmActivate(supplierId) {
                if (confirm('Are you sure you want to activate this supplier?')) {
                    window.location.href = '${pageContext.request.contextPath}/admin/manage-supplier?action=activate&id=' + supplierId;
                }
            }
        </script>
    </body>
</html>
