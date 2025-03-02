<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">

    <title>Category Management || Clothing</title>
    <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
    <style>
        .fixed-width-btn {
            min-width: 120px; /* Có thể điều chỉnh giá trị này */
            text-align: center;
        }
    </style>
    
</head>

<body>
    <!-- Sidebar -->
    <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

    <!-- Header -->
    <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

    <c:url value="/admin/manage-category" var="paginationUrl">
    <c:param name="action" value="list" />
    <c:if test="${not empty param.status}">
        <c:param name="status" value="${param.status}" /></c:if>
    <c:if test="${not empty param.search}">
        <c:param name="search" value="${param.search}" />
    </c:if>
</c:url>


    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Category Management</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Category List</li>
            </ul>
        </div>

        <!-- Filter Section -->
        <div class="card mb-24">
            <div class="card-body p-24">
                <form action="${pageContext.request.contextPath}/admin/manage-category" method="GET">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <input type="text" class="form-control" name="search" placeholder="Search by category name" 
                                   value="${param.search}">
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" name="status">
                                <option value="">All Status</option>
                                <option value="1" ${param.status == '1' ? 'selected' : ''}>Active</option>
                                <option value="0" ${param.status == '0' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">Filter</button>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/admin/manage-category?action=add" class="btn btn-success w-100">
                                Add New Category
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Category Table -->
        <div class="card">
            <div class="card-body p-24">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Created At</th>
                                <th>Updated At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="category" items="${categories}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>${category.name}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${category.description.length() > 50}">
                                                ${category.description.substring(0, 50)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${category.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge ${category.status == 1 ? 'bg-success' : 'bg-danger'}">
                                            ${category.status == 1 ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td>${category.createdAt}</td>
                                    <td>${category.updatedAt}</td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/manage-category?action=edit&id=${category.categoryId}" 
                                               class="btn btn-sm btn-primary">
                                                <iconify-icon icon="material-symbols:edit"></iconify-icon>
                                            </a>
                                            <c:choose>
                                                <c:when test="${category.status == 1}">
                                                    <button type="button" 
                                                            class="btn btn-sm btn-danger fixed-width-btn"
                                                            onclick="confirmDeactivate('${category.categoryId}')">
                                                        <i class="fas fa-trash-alt"></i> Deactivate
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" 
                                                            class="btn btn-sm btn-success fixed-width-btn"
                                                            onclick="confirmActivate('${category.categoryId}')">
                                                        <i class="fas fa-check"></i> Activate
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
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

    <main>

    </main>

    <!-- JS here -->
    <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var toastMessage = "${sessionScope.toastMessage}";
            var toastType = "${sessionScope.toastType}";
            if (toastMessage) {
                iziToast.show({
                    title: toastType === 'success' ? 'Success' : 'Error',
                    message: toastMessage,
                    position: 'topRight',
                    color: toastType === 'success' ? 'green' : 'red',
                    timeout: 1000,
                    onClosing: function() {
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
    </script>

</body>
</html>

<script>
function confirmDeactivate(categoryId) {
    if (confirm('Are you sure you want to deactivate this category?')) {
        window.location.href = '${pageContext.request.contextPath}/admin/manage-category?action=deactivate&id=' + categoryId;
    }
}

function confirmActivate(categoryId) {
    if (confirm('Are you sure you want to activate this category?')) {
        window.location.href = '${pageContext.request.contextPath}/admin/manage-category?action=activate&id=' + categoryId;
    }
}
</script> 